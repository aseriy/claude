"""Shared code for the intent hooks: embedding, intent lookup, templates, state, log, transcript."""
import json
import os
import re
from datetime import datetime, timezone
from pathlib import Path

import psycopg2
import psycopg2.extras
from jinja2 import Environment, StrictUndefined
from openai import OpenAI

BASE = Path(__file__).resolve().parent.parent
LOG_DIR = BASE / "logs"
LOG_FILE = LOG_DIR / "intents.jsonl"
STATE_DIR = BASE / "state"
MAX_LOG_BYTES = 1_000_000

EMBED_MODEL = "text-embedding-3-small"
EMBED_DIM = 1536
MATCH_THRESHOLD = 0.80

_JINJA = Environment(undefined=StrictUndefined, autoescape=False, keep_trailing_newline=False)


class IntentError(Exception):
    pass


# ---------- database ----------

def connect():
    return psycopg2.connect(os.environ["INTENT_DSN"])


def _vec(v):
    return "[" + ",".join(repr(float(x)) for x in v) + "]"


def list_intents(conn):
    """All intent names, in a fixed order so the numbered list is stable."""
    with conn.cursor() as cur:
        cur.execute("SELECT name FROM intent_enum ORDER BY name")
        return [r[0] for r in cur.fetchall()]


def get_intent(conn, name):
    """The full intent_enum row for one intent, as a dict."""
    with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
        cur.execute(
            "SELECT name, decision, proceed, suppress_output, reason, additional_context, "
            "system_message, stop_reason, skills, tools "
            "FROM intent_enum WHERE name = %s",
            (name,),
        )
        row = cur.fetchone()
    if row is None:
        raise IntentError(f"unknown intent: {name!r}")
    return dict(row)


def match(conn, vector):
    """Nearest stored prompt. Returns (intent or None, similarity, stored prompt).
    Intent is None when the table is empty or the best similarity is below the threshold."""
    v = _vec(vector)
    with conn.cursor() as cur:
        cur.execute(
            "SELECT e.name, 1 - (i.prompt_vector <=> %s::VECTOR), i.prompts "
            "FROM intent i JOIN intent_enum e ON e.id = i.intent "
            "ORDER BY i.prompt_vector <-> %s::VECTOR LIMIT 1",
            (v, v),
        )
        row = cur.fetchone()
    if row is None:
        return None, None, None
    name, sim, example = row[0], float(row[1]), row[2]
    return (name if sim >= MATCH_THRESHOLD else None), sim, example


def record(conn, prompt, vector, intent_name):
    """Store a prompt with its user-verified intent. observed_at and calibrate_at default to now()."""
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO intent (prompts, prompt_vector, intent) "
            "SELECT %s, %s::VECTOR, id FROM intent_enum WHERE name = %s",
            (prompt, _vec(vector), intent_name),
        )
        if cur.rowcount != 1:
            conn.rollback()
            raise IntentError(f"unknown intent: {intent_name!r}")
    conn.commit()


# ---------- templates ----------

def render(row, column):
    """Render one template column of an intent row. Returns None if the column is NULL."""
    template = row.get(column)
    if template is None:
        return None
    return _JINJA.from_string(template).render(
        tools=row.get("tools") or [],
        skills=row.get("skills") or [],
    ).strip()


# ---------- embedding ----------

def embed(text):
    client = OpenAI(timeout=10)
    r = client.embeddings.create(model=EMBED_MODEL, input=text, dimensions=EMBED_DIM)
    return r.data[0].embedding


# ---------- state (one file per session) ----------

def _state_path(session_id):
    return STATE_DIR / (re.sub(r"[^\w-]", "_", session_id) + ".json")


def read_state(session_id):
    try:
        return json.loads(_state_path(session_id).read_text())
    except (OSError, ValueError):
        return {}


def write_state(session_id, state):
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    path = _state_path(session_id)
    tmp = path.with_suffix(".tmp")
    tmp.write_text(json.dumps(state))
    tmp.replace(path)


# ---------- log (rotate at 1 MB, never delete) ----------

def log(entry):
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    if LOG_FILE.exists() and LOG_FILE.stat().st_size >= MAX_LOG_BYTES:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
        LOG_FILE.rename(LOG_DIR / f"intents-{stamp}.jsonl")
    rec = {"ts": datetime.now(timezone.utc).isoformat(timespec="seconds"), **entry}
    with LOG_FILE.open("a") as f:
        f.write(json.dumps(rec, ensure_ascii=False) + "\n")


# ---------- transcript ----------
# The user's typed message is a "user" line with string content (or a list of blocks
# with no tool_result) and isMeta not true. Tool results are "user" lines made of
# tool_result blocks. Claude's reply is split across "assistant" lines, one block per
# line. Other line types are ignored.

def _is_user_prompt(entry):
    if entry.get("type") != "user" or entry.get("isMeta") is True:
        return False
    content = (entry.get("message") or {}).get("content")
    if isinstance(content, str):
        return True
    if isinstance(content, list) and content:
        return not any(isinstance(b, dict) and b.get("type") == "tool_result" for b in content)
    return False


def current_turn(transcript_path):
    entries = []
    with open(transcript_path) as f:
        for line in f:
            try:
                entries.append(json.loads(line))
            except ValueError:
                pass
    start = 0
    for i, e in enumerate(entries):
        if _is_user_prompt(e):
            start = i
    return entries[start:]


def turn_activity(turn):
    """Tool names used in the turn, in order, and the last text block Claude wrote."""
    tools, texts = [], []
    for e in turn:
        if e.get("type") != "assistant":
            continue
        for b in (e.get("message") or {}).get("content") or []:
            if not isinstance(b, dict):
                continue
            if b.get("type") == "tool_use":
                tools.append(b.get("name"))
            elif b.get("type") == "text":
                texts.append(b.get("text", ""))
    return tools, (texts[-1] if texts else "")

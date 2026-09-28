#!/home/ubuntu/git/claude/.venv/bin/python3
"""UserPromptSubmit hook: ask the user to confirm the intent of each prompt,
record the confirmed intent, and pass that intent's rendered context to Claude."""
import json
import sys

import intent_lib as lib

WAIT = ('The user must choose the intent of this message before you act. '
        'Reply with exactly one line: "Waiting for your choice." '
        'Do not answer the message. Do not use any tools.')

ANSWER_PREVIOUS = ("The user's last message was only their intent choice. "
                   "Answer the message before it.")


def emit(system_message=None, context=None, block_reason=None, proceed=True, stop_reason=None,
         suppress_output=False):
    out = {}
    if block_reason:
        out["decision"] = "block"
        out["reason"] = block_reason
    if system_message:
        out["systemMessage"] = system_message
    if context:
        out["hookSpecificOutput"] = {"hookEventName": "UserPromptSubmit", "additionalContext": context}
    if not proceed:
        out["continue"] = False
        if stop_reason:
            out["stopReason"] = stop_reason
    if suppress_output:
        out["suppressOutput"] = True
    print(json.dumps(out))
    sys.exit(0)


def menu(options, matched, sim, invalid=False):
    head = "Invalid choice. " if invalid else ""
    if matched:
        head += f"Closest stored prompt matched '{matched}' (similarity {sim:.2f})."
    elif sim is not None:
        head += f"No match above threshold (best similarity {sim:.2f})."
    else:
        head += "No stored prompts yet."
    lines = [head, "Reply with the number of the intent:"]
    for i, name in enumerate(options, 1):
        mark = "  <- match" if name == matched else ""
        lines.append(f"  {i}. {name}{mark}")
    return "\n".join(lines)


def main():
    data = json.load(sys.stdin)
    sid = data.get("session_id", "")
    prompt = data.get("prompt", "")
    base_log = {"session_id": sid, "cwd": data.get("cwd", ""), "prompt": prompt}

    try:
        conn = lib.connect()
        state = lib.read_state(sid)
        pending = state.get("pending")

        # ---- a choice is pending: this message is the user's answer ----
        if pending:
            options = pending["options"]
            text = prompt.strip()
            if not (text.isdigit() and 1 <= int(text) <= len(options)):
                lib.log({**base_log, "event": "invalid_choice", "options": options})
                emit(system_message=menu(options, pending["matched"], pending["sim"], invalid=True),
                     context=WAIT)

            name = options[int(text) - 1]
            lib.record(conn, pending["prompt"], pending["vector"], name)
            row = lib.get_intent(conn, name)
            lib.write_state(sid, {"intent": name})
            lib.log({**base_log, "event": "chosen", "original": pending["prompt"],
                     "matched": pending["matched"], "sim": pending["sim"], "choice": name})

            ctx = lib.render(row, "additional_context")
            emit(system_message=lib.render(row, "system_message"),
                 context=ANSWER_PREVIOUS + (" " + ctx if ctx else ""),
                 proceed=row["proceed"],
                 stop_reason=lib.render(row, "stop_reason"),
                 suppress_output=row["suppress_output"])

        # ---- a new prompt: match it and ask the user to confirm ----
        vector = lib.embed(prompt)
        matched, sim, _example = lib.match(conn, vector)
        options = lib.list_intents(conn)
        lib.write_state(sid, {"pending": {"prompt": prompt, "vector": vector, "options": options,
                                          "matched": matched, "sim": sim}})
        lib.log({**base_log, "event": "asked", "matched": matched, "sim": sim})
        emit(system_message=menu(options, matched, sim), context=WAIT)

    except Exception as e:
        lib.log({**base_log, "event": "error", "error": f"{type(e).__name__}: {e}"})
        emit(block_reason=f"Intent hook error: {type(e).__name__}: {e}")


if __name__ == "__main__":
    main()

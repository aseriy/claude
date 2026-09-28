#!/usr/bin/env bash
# Enforces the 10-contiguous-line budget and the full-file-rewrite ban.
set -euo pipefail

INPUT=$(cat)
TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name')
LIMIT=10

ask() {
  jq -n --arg r "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: $r
    }
  }'
  exit 0
}

case "$TOOL" in
  Edit)
    LINES=$(printf '%s' "$INPUT" | jq -r '(.tool_input.old_string // "") | split("\n") | length')
    [ "$LINES" -gt "$LIMIT" ] && ask "Edit replaces $LINES contiguous lines (budget: $LIMIT). Approval required."
    ;;
  MultiEdit)
    LINES=$(printf '%s' "$INPUT" | jq -r '[(.tool_input.edits // [])[] | (.old_string // "") | split("\n") | length] | max // 0')
    [ "$LINES" -gt "$LIMIT" ] && ask "MultiEdit's largest hunk replaces $LINES contiguous lines (budget: $LIMIT). Approval required."
    ;;
  Write)
    FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
    [ -n "$FILE" ] && [ -f "$FILE" ] && ask "Write targets an existing file ($FILE). Full-file rewrites require approval."
    ;;
esac

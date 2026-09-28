#!/usr/bin/env bash
# Blocks reads and searches inside dependency directories.
set -uo pipefail

INPUT=$(cat)
TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name')

# Trailing boundary is any character that cannot be part of a directory name,
# so "node_modules/", "node_modules ", "node_modules'" and end-of-string all match.
EXCLUDED='(^|/)(\.venv|venv|node_modules|\.tox|site-packages|vendor|target|dist-info)([^[:alnum:]_.-]|$)'

# Commands that explicitly exclude the directory are doing the right thing.
EXEMPT='(-prune|--exclude-dir|:\(exclude\))'

deny() {
  jq -n --arg r "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $r
    }
  }'
  exit 0
}

case "$TOOL" in
  Read|Glob|Grep)
    TARGET=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // .tool_input.pattern // ""')
    if [ -n "$TARGET" ] && printf '%s' "$TARGET" | grep -qE "$EXCLUDED"; then
      deny "Path is inside a dependency directory: $TARGET. Dependency directories are excluded from repository analysis."
    fi
    ;;
  Bash)
    CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
    if printf '%s' "$CMD" | grep -qE '(^|[;&|]\s*)(mv|rename)\s'; then
      deny "Moving or renaming files in a git repository requires 'git mv', which this session cannot run. Do not move or rename the file. Tell the user the exact 'git mv' command to run, and stop."
    fi
    if printf '%s' "$CMD" | grep -qE '\b(find|grep|rg|ls|cat|wc|head|tail)\b' \
       && ! printf '%s' "$CMD" | grep -qE "$EXEMPT" \
       && printf '%s' "$CMD" | grep -qE "$EXCLUDED"; then
      deny "Command references a dependency directory. Exclude it, e.g. find ... -path '*/node_modules' -prune -o ..."
    fi
    ;;
esac

exit 0

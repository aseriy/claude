#!/usr/bin/env bash
input=$(cat)
echo "$(date) fired stop_hook_active=$(jq -r .stop_hook_active <<<"$input")" >> /tmp/stop-hook.log
# Let Claude finish after one forced retry. Without this check, the hook would block every attempt.
[ "$(jq -r '.stop_hook_active' <<<"$input")" = "true" ] && exit 0
t=$(jq -r '.transcript_path' <<<"$input")
used=$(jq -s '
  (map(.type=="user" and ((.message.content|type)=="string")) | rindex(true)) as $i
  | .[($i // 0):]
  | [ .[] | select(.type=="assistant") | .message.content[]?
      | select(.type=="tool_use" and (.name=="WebSearch" or .name=="WebFetch")) ]
  | length' "$t")
if [ "${used:-0}" -eq 0 ]; then
  echo "No WebSearch/WebFetch this turn. Verify your answer with a web search and base it on what you find, not on memory." >&2
  exit 2
fi
exit 0

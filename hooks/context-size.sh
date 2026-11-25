#!/bin/bash
# Tells Claude how full its context is, once it passes 500,000 tokens.
#
# Claude cannot see its own context size. Claude Code passes this script the
# path of the conversation log, and the log records the size of every request.
# The last record that belongs to the main conversation is the current size.
# Below 500,000 this prints nothing.

input=$(cat)
transcript=$(printf '%s' "$input" | /usr/bin/jq -r '.transcript_path // empty' 2>/dev/null)
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

tokens=$(tail -n 400 "$transcript" | /usr/bin/jq -r '
  select(.type == "assistant" and (.isSidechain | not) and .message.usage != null)
  | .message.usage
  | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0) + (.output_tokens // 0))
' 2>/dev/null | tail -n 1)

case "$tokens" in ''|*[!0-9]*) exit 0 ;; esac

thousands=$((tokens / 1000))

if [ "$tokens" -ge 750000 ]; then
  echo "Context size: about ${thousands},000 tokens. This is past 750,000, and you have been close to useless to Ekin since about 600,000. Follow the \"Long conversations\" rule now: unless he is in the middle of a quickfire session, end this reply by telling him so and offering the handover."
elif [ "$tokens" -ge 500000 ]; then
  echo "Context size: about ${thousands},000 tokens. This is past 500,000, and your work has been getting worse since about 300,000. Follow the \"Long conversations\" rule: every now and then, at a natural pause, end a reply with the reminder and the handover offer. Say nothing if he is in the middle of a quickfire session."
fi
exit 0

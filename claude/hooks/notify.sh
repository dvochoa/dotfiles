#!/bin/bash
# Hook for Stop and Notification events — sends a macOS native notification

INPUT=$(cat)
EVENT=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('hook_event_name',''))" 2>/dev/null)
MESSAGE=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('message',''))" 2>/dev/null)

# Skip notification if Terminal.app is already focused
FOCUSED_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
if [ "$FOCUSED_APP" = "Terminal" ]; then
  exit 0
fi

if [ "$EVENT" = "Stop" ]; then
  TITLE="Claude Code — Done"
  BODY="Task finished, your input may be needed"
elif [ -n "$MESSAGE" ]; then
  TITLE="Claude Code — Needs Input"
  BODY="$MESSAGE"
else
  TITLE="Claude Code"
  BODY="Needs your attention"
fi

osascript -e "display notification \"$BODY\" with title \"$TITLE\" sound name \"Ping\""

exit 0

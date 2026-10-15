#!/bin/sh

# The bar decides which items go on which screen when it loads (see the
# VERTICAL / OTHERS detection in sketchybarrc). Reload it whenever the set
# of connected screens changes, e.g. monitors connecting after login.

STATE="${TMPDIR:-/tmp}/sketchybar_displays"
CURRENT="$(sketchybar --query displays | python3 -c 'import json,sys;print(" ".join(sorted("%s:%dx%d" % (d["DirectDisplayID"], d["frame"]["w"], d["frame"]["h"]) for d in json.load(sys.stdin))))')"

if [ "$CURRENT" != "$(cat "$STATE" 2>/dev/null)" ]; then
  echo "$CURRENT" > "$STATE"
  # Skip the reload on the first run after the bar itself loaded
  [ "$SENDER" = "forced" ] || sketchybar --reload
fi

#!/usr/bin/env bash

# Updates every AeroSpace workspace item in one go:
#  - shows each workspace only on the bar of the monitor it lives on
#  - hides empty workspaces (unless it's the one visible on its monitor)
#  - shows the icons of the apps open in each workspace
#  - underlines the visible workspace on each monitor (brightest = focused)

source "$CONFIG_DIR/plugins/icon_map.sh"

# Underline colors: focused workspace, visible on another monitor, hidden
FOCUSED_LINE=0xfff59e0b
VISIBLE_LINE=0x66f59e0b
HIDDEN_LINE=0x00f59e0b
FOCUSED_TEXT=0xffffffff
OTHER_TEXT=0xff8a8a8d
ACTIVE_APPS=0xffeaeaea
INACTIVE_APPS=0x70eaeaea

# AeroSpace numbers monitors in AppKit order; SketchyBar uses its own
# arrangement order. Build a "aerospace_id sketchybar_id" map, matched by
# CoreGraphics display ID. Cached until the display setup changes.
MAP="${TMPDIR:-/tmp}/sketchybar_display_map"
if [ "$SENDER" = "display_change" ] || [ ! -s "$MAP" ]; then
  APPKIT="$(osascript -l JavaScript -e 'ObjC.import("AppKit"); $.NSScreen.screens.js.map((s,i)=>(i+1)+" "+s.deviceDescription.objectForKey("NSScreenNumber").js).join("\n")')"
  SKETCHY="$(sketchybar --query displays | python3 -c 'import json,sys;[print(d["DirectDisplayID"], d["arrangement-id"]) for d in json.load(sys.stdin)]')"
  echo "$APPKIT" | while read -r aid cgid; do
    echo "$SKETCHY" | awk -v a="$aid" -v c="$cgid" '$1 == c {print a, $2}'
  done > "$MAP"
fi

WINDOWS="$(aerospace list-windows --all --format '%{workspace}|%{app-name}')"

args=()
anim=()
while IFS='|' read -r ws monitor visible focused; do
  display="$(awk -v m="$monitor" '$1 == m {print $2}' "$MAP")"

  # Unique app names in this workspace, in window order
  apps="$(echo "$WINDOWS" | awk -F'|' -v w="$ws" '$1 == w && !seen[$2]++ {print $2}')"
  icons=""
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    icons+="$icon_result "
  done <<< "$apps"

  if [ -n "$apps" ] || [ "$visible" = "true" ]; then drawing=on; else drawing=off; fi
  if [ "$focused" = "true" ]; then line=$FOCUSED_LINE; text=$FOCUSED_TEXT
  elif [ "$visible" = "true" ]; then line=$VISIBLE_LINE; text=$OTHER_TEXT
  else line=$HIDDEN_LINE; text=$OTHER_TEXT; fi
  if [ "$visible" = "true" ]; then apps_color=$ACTIVE_APPS; else apps_color=$INACTIVE_APPS; fi

  args+=(--set space."$ws" drawing=$drawing display="${display:-active}"
         label="${icons% }" label.drawing="$([ -n "$icons" ] && echo on || echo off)")
  anim+=(--set space."$ws" background.color=$line icon.color=$text label.color=$apps_color)
done < <(aerospace list-workspaces --all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}|%{workspace-is-visible}|%{workspace-is-focused}')

# One call, no animation, so the highlight switches instantly
sketchybar "${args[@]}" "${anim[@]}"

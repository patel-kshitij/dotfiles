#!/bin/bash

# Runs (via on-window-detected) every time a new window opens.
#   Main monitor (LF27T35): alternate the split direction for each new
#     window: side by side, then below, then beside, ... (spiral/dwindle).
#   DELL (portrait): keep every window stacked vertically.

MAIN='LF27T35'
VERTICAL='DELL'

# Give AeroSpace a moment to place the window (and apply move rules)
sleep 0.15

# The newest window has the highest id
IFS='|' read -r id ws mon layout < <(aerospace list-windows --all \
  --format '%{window-id}|%{workspace}|%{monitor-name}|%{window-parent-container-layout}' \
  | sort -n | tail -1)

count=$(aerospace list-windows --workspace "$ws" --count)

case "$mon" in
  "$VERTICAL"*)
    # Stack top to bottom
    [ "$layout" = "h_tiles" ] && aerospace layout --window-id "$id" vertical
    ;;
  "$MAIN"*)
    # 1-2 windows: plain side by side. From the 3rd on, join the new window
    # with its neighbour so the split direction flips each time.
    [ "$count" -lt 3 ] && exit 0
    case "$layout" in
      h_tiles) aerospace join-with --window-id "$id" left ;;
      v_tiles) aerospace join-with --window-id "$id" up ;;
    esac
    ;;
esac

sketchybar --trigger aerospace_layout_change

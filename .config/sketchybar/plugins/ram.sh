#!/bin/sh

# Used memory = 100 - system-wide free percentage
FREE="$(memory_pressure | awk '/free percentage/ {gsub("%",""); print $NF}')"
USED="$((100 - FREE))"
VAL=$USED

. "$CONFIG_DIR/plugins/colors_usage.sh"
usage_color "$VAL" 70 90   # yellow from 70%, red from 90%

# Graph items take values from 0 to 1. The *_v items (vertical screen)
# have no graph, so they only get the label.
case "$NAME" in
  *_v) sketchybar --set "$NAME" label="${VAL}%" label.color=$LINE; exit 0 ;;
esac
sketchybar --push "$NAME" "$(echo "$USED" | awk '{printf "%.2f", $1/100}')" \
           --set "$NAME" label="${USED}%" graph.color=$LINE graph.fill_color=$FILL

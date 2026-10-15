#!/bin/sh

# Total CPU usage across all cores, as a percentage
CORES="$(sysctl -n hw.logicalcpu)"
CPU="$(ps -A -o %cpu | awk -v n="$CORES" '{s+=$1} END {printf "%.0f", s/n}')"
[ "$CPU" -gt 100 ] && CPU=100
VAL=$CPU

. "$CONFIG_DIR/plugins/colors_usage.sh"
usage_color "$VAL" 50 80   # yellow from 50%, red from 80%

# Graph items take values from 0 to 1. The *_v items (vertical screen)
# have no graph, so they only get the label.
case "$NAME" in
  *_v) sketchybar --set "$NAME" label="${VAL}%" label.color=$LINE; exit 0 ;;
esac
sketchybar --push "$NAME" "$(echo "$CPU" | awk '{printf "%.2f", $1/100}')" \
           --set "$NAME" label="${CPU}%" graph.color=$LINE graph.fill_color=$FILL

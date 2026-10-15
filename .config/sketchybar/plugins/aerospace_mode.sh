#!/bin/sh

# Shows a tag while AeroSpace is in a non-default mode (service, resize)
case "$MODE" in
  ""|main) sketchybar --set "$NAME" drawing=off ;;
  resize)  sketchybar --set "$NAME" drawing=on icon="󰩨" label="RESIZE" ;;
  *)       sketchybar --set "$NAME" drawing=on icon="󰖷" \
                 label="$(echo "$MODE" | tr '[:lower:]' '[:upper:]')" ;;
esac

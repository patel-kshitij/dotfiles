#!/bin/sh

# Shows the layout of the focused workspace's root container
case "$(aerospace list-workspaces --focused --format '%{workspace-root-container-layout}')" in
  h_tiles)     ICON="󰕭" ;;  # side by side
  v_tiles)     ICON="󰕪" ;;  # stacked
  *accordion)  ICON="󰕬" ;;  # accordion
  *)           ICON="󰕭" ;;
esac

sketchybar --set "$NAME" icon="$ICON"

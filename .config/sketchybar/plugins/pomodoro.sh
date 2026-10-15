#!/usr/bin/env bash

# Pomodoro timer
#   left click  -> start / pause
#   right click -> reset
# Runs 25 min of focus, then a 5 min break, then stops.

WORK=$((25 * 60))
BREAK=$((5 * 60))
STATE="${TMPDIR:-/tmp}/sketchybar_pomodoro"

IDLE_COLOR=0xffd4adfc
WORK_COLOR=0xffff6b6b
BREAK_COLOR=0xff7ee787

# State: mode (work|break)  status (idle|running|paused)  value
# value = end time (epoch) while running, seconds left otherwise
[ -f "$STATE" ] && read -r mode status value < "$STATE"
mode=${mode:-work}; status=${status:-idle}; value=${value:-$WORK}
now=$(date +%s)

if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    mode=work; status=idle; value=$WORK
  elif [ "$status" = "running" ]; then
    status=paused; value=$((value - now))
  else
    status=running; value=$((now + value))
  fi
fi

if [ "$status" = "running" ]; then
  left=$((value - now))
  if [ "$left" -le 0 ]; then
    if [ "$mode" = "work" ]; then
      osascript -e 'display notification "Time for a 5 minute break" with title "Pomodoro" sound name "Glass"'
      mode=break; value=$((now + BREAK)); left=$BREAK
    else
      osascript -e 'display notification "Break is over" with title "Pomodoro" sound name "Glass"'
      mode=work; status=idle; value=$WORK; left=$WORK
    fi
  fi
else
  left=$value
fi

echo "$mode $status $value" > "$STATE"

if [ "$status" = "idle" ]; then
  color=$IDLE_COLOR
elif [ "$mode" = "work" ]; then
  color=$WORK_COLOR
else
  color=$BREAK_COLOR
fi
[ "$status" = "paused" ] && suffix=" ⏸" || suffix=""

# Only tick every second while running
[ "$status" = "running" ] && freq=1 || freq=0

sketchybar --set "$NAME" update_freq=$freq icon.color=$color \
           label="$(printf '%02d:%02d' $((left / 60)) $((left % 60)))$suffix"

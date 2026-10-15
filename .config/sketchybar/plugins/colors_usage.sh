#!/bin/sh

# Shared by cpu.sh / ram.sh: pick a color for a usage value.
#   usage_color <value> <yellow_from> <red_from>
# Sets $LINE (solid) and $FILL (transparent) colors.
usage_color() {
  if [ "$1" -ge "$3" ]; then
    LINE=0xffdc2626; FILL=0x40dc2626   # red
  elif [ "$1" -ge "$2" ]; then
    LINE=0xfffbbf24; FILL=0x40fbbf24   # yellow
  else
    LINE=0xff10b981; FILL=0x4010b981   # green
  fi
}

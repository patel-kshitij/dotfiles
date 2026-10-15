#!/bin/sh

# Shared by cpu.sh / ram.sh: pick a color for a usage value.
#   usage_color <value> <yellow_from> <red_from>
# Sets $LINE (solid) and $FILL (transparent) colors.
usage_color() {
  if [ "$1" -ge "$3" ]; then
    LINE=0xffff5555; FILL=0x40ff5555   # red
  elif [ "$1" -ge "$2" ]; then
    LINE=0xfff1fa8c; FILL=0x40f1fa8c   # yellow
  else
    LINE=0xff50fa7b; FILL=0x4050fa7b   # green
  fi
}

#!/usr/bin/env bash

# App name -> Material Design icon from the Nerd Font, as a pair:
#   solid (shown on the active workspace) and outline (all others).
#   __icon_map <app name> <true|false: active>
# Add a line here to give another app its own icon.
function __icon_map() {
  local solid outline
  case "$1" in
    "Safari" | "Safari Technology Preview" | "Google Chrome" | "Chromium" | "Brave Browser" | "Firefox" | "Arc")
      solid="󰆋"; outline="󰆌" ;;  # compass
    "iTerm2" | "Terminal" | "kitty" | "Alacritty" | "WezTerm" | "Ghostty")
      solid="󰆍"; outline="󰞷" ;;  # console box / console prompt
    "Finder")
      solid="󰉋"; outline="󰉖" ;;  # folder
    "Music" | "Spotify")
      solid="󰎇"; outline="󰽴" ;;  # music note
    "Mail" | "Outlook" | "Microsoft Outlook")
      solid="󰇮"; outline="󰇰" ;;  # email
    "Messages" | "Slack" | "Discord")
      solid="󰭹"; outline="󰻞" ;;  # chat
    "WhatsApp" | "Telegram")
      solid="󰍩"; outline="󰍪" ;;  # message
    "Microsoft Teams")
      solid="󰡉"; outline="󰭘" ;;  # people
    "FaceTime" | "zoom.us")
      solid="󰕧"; outline="󰯜" ;;  # video
    "Notes")
      solid="󰎞"; outline="󱇗" ;;  # note
    "Calendar")
      solid="󰃮"; outline="󰭦" ;;  # calendar
    "Code" | "Visual Studio Code" | "PyCharm" | "IntelliJ IDEA" | "MacVim" | "Xcode" | "Script Editor")
      solid="󰈮"; outline="󱀫" ;;  # code file
    "OrbStack" | "Docker" | "Docker Desktop")
      solid="󰆦"; outline="󰆧" ;;  # cube
    "Claude")
      solid="󰫢"; outline="󰫣" ;;  # four-point star
    "System Settings" | "System Preferences")
      solid="󰒓"; outline="󰢻" ;;  # cog
    "Preview" | "Photos")
      solid="󰋩"; outline="󰥶" ;;  # image
    "Activity Monitor")
      solid="󱕍"; outline="󱕎" ;;  # chart
    "App Store")
      solid="󰒚"; outline="󱇕" ;;  # shopping bag
    *)
      solid="󰣆"; outline="󰘔" ;;  # window (any other app)
  esac
  if [ "$2" = "true" ]; then icon_result="$solid"; else icon_result="$outline"; fi
}

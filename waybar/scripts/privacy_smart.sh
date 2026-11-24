#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/waybar_tooltip.sh"

# Check if any player is currently "Playing"
if playerctl -a status 2>/dev/null | grep -q "Playing"; then
  IS_PLAYING=1
else
  IS_PLAYING=0
fi

# Counts active recording streams
MIC=$(pacmd list-source-outputs 2>/dev/null | grep -c "state: RUNNING")
# Counts processes using video devices
CAM=$(fuser /dev/video* 2>/dev/null | wc -w)

if ((MIC > 0 || CAM > 0)); then
  LABEL=""
  ((MIC > 0)) && LABEL+="󰍬 "
  ((CAM > 0)) && LABEL+="󰄀"

  if ((MIC > 0 && CAM > 0)); then
    HERO="Mic + cam"
  elif ((MIC > 0)); then
    HERO="Mic"
  else
    HERO="Cam"
  fi

  if ((IS_PLAYING == 1)); then
    SUB="Music is playing too"
  else
    SUB="Nothing else is playing"
  fi

  TIP=$(tt_join \
    "$(tt_hero "$HERO" "$TT_WARN")" \
    "$(tt_sub "in use")" \
    "$(tt_dot "$TT_WARN")$(tt_sub "$SUB")")

  if ((IS_PLAYING == 1)); then
    # The Dot (Android Style)
    tt_emit "" "dot" "$TIP"
  else
    # The Full Pill
    tt_emit "$LABEL  Active" "full" "$TIP"
  fi
else
  # Hide if nothing is happening
  tt_emit "" "none" "$(tt_join "$(tt_hero "Idle")" "$(tt_sub "Nothing using mic or camera")")"
fi

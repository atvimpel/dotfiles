#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/waybar_tooltip.sh"

STATUS=$(playerctl status 2>/dev/null)
if [ -z "$STATUS" ] || [ "$STATUS" = "No players found" ]; then
  tt_emit "" "stopped" "$(tt_join "$(tt_hero "—")" "$(tt_sub "Nothing playing")")"
  exit 0
fi

TITLE=$(playerctl metadata title 2>/dev/null)
ARTIST=$(playerctl metadata artist 2>/dev/null)
ALBUM=$(playerctl metadata album 2>/dev/null)
POSITION=$(playerctl position 2>/dev/null)
LENGTH=$(playerctl metadata mpris:length 2>/dev/null)

LENGTH_S=$(echo "$LENGTH / 1000000" | bc -l 2>/dev/null)

BAR=$(tt_bar 0)
if [ -n "$POSITION" ] && [ -n "$LENGTH_S" ] && [ "$(echo "$LENGTH_S > 0" | bc -l)" = "1" ]; then
  FRACTION=$(echo "$POSITION / $LENGTH_S" | bc -l)
  FILLED=$(echo "($FRACTION * $TT_BAR_CELLS) / 1" | bc)
  BAR=$(tt_bar "$FILLED")
fi

fmt_time() {
  local s=$(printf "%.0f" "$1")
  printf "%d:%02d" $((s / 60)) $((s % 60))
}

POS_FMT=$(fmt_time "$POSITION")
LEN_FMT=$(fmt_time "$LENGTH_S")

# Scrolling logic
DISPLAY_LEN=12
SPEED=1 # characters per second
TITLE_LEN=${#TITLE}
if [ "$TITLE_LEN" -le "$DISPLAY_LEN" ]; then
  SCROLL_TITLE="$TITLE"
else
  PADDED="${TITLE}   "
  PADDED_LEN=${#PADDED}
  OFFSET=$((($(date +%s) * $SPEED) % PADDED_LEN))
  SCROLL_TITLE="${PADDED:$OFFSET:$DISPLAY_LEN}"
  if [ "${#SCROLL_TITLE}" -lt "$DISPLAY_LEN" ]; then
    SCROLL_TITLE="${SCROLL_TITLE}${PADDED:0:$(($DISPLAY_LEN - ${#SCROLL_TITLE}))}"
  fi
fi

TEXT="<span font_family='Zalando Sans'>$(tt_esc "$SCROLL_TITLE")</span>"

TITLE_LINE="$(tt_sub "${TITLE:-Unknown track}")"
if [ "$STATUS" = "Playing" ]; then
  TITLE_LINE="$(tt_dot "$TT_OK")$TITLE_LINE"
fi

if [ -n "$ALBUM" ]; then
  ARTIST_LINE="$(tt_sub "${ARTIST:-Unknown artist} · $ALBUM")"
else
  ARTIST_LINE="$(tt_sub "${ARTIST:-Unknown artist}")"
fi

TIP=$(tt_join \
  "$(tt_hero "$POS_FMT")" \
  "$(tt_sub "of $LEN_FMT")" \
  "$TITLE_LINE" \
  "$ARTIST_LINE" \
  "$BAR")

tt_emit "$TEXT" "$STATUS" "$TIP"

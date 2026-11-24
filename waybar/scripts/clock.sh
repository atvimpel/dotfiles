#!/bin/bash
# Clock module: time (with faint seconds) + compact date on bar
# Tooltip: big time, weekday and date, then week, uptime and boot in the footer

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/waybar_tooltip.sh"

uptime_human() {
  local s=$1
  local d=$((s / 86400)) h=$(((s % 86400) / 3600)) m=$(((s % 3600) / 60))
  local out=""
  ((d > 0)) && out+="${d}d "
  ((h > 0)) && out+="${h}h "
  out+="${m}m"
  echo "$out"
}

emit() {
  TIME=$(date "+%H:%M")
  SEC=$(date "+%S")
  DATE=$(date "+%a %d" | tr '[:lower:]' '[:upper:]')
  WEEK=$(date "+%V")
  UPTIME=$(uptime_human "$(awk '{printf "%d", $1}' /proc/uptime)")
  BOOT=$(uptime -s | cut -d' ' -f2 | cut -d: -f1,2)

  TIP=$(tt_join \
    "$(tt_hero "$TIME")" \
    "$(tt_sub "$(date '+%A')")" \
    "$(tt_sub "$(date '+%B %d, %Y')")" \
    "$(tt_footer "Week $WEEK" "Up $UPTIME" "Boot $BOOT")")

  printf '{"text":"󰥔  %s<span alpha='"'"'35%%'"'"'>:%s</span> · %s","tooltip":"%s"}\n' \
    "$TIME" "$SEC" "$DATE" "$TIP"
}

emit
while true; do
  sleep 1
  emit
done

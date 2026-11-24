# Shared tooltip look for the waybar bash scripts in this folder. Source it.
# Every tooltip is a card: a big hero value (tinted by state), a label under it,
# faint sublines, an optional bar, then a small faint footer. No rules or borders.
# Bars fill from the left.

TT_BAR_CELLS=10
TT_FOOT_SEP="   ·   "
# Colours from the Material palette in theme.css
TT_OK="#0052dc"
TT_WARN="#675687"
TT_ALERT="#ba1a1a"

tt_esc() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# tt_hero VALUE [COLOR]
tt_hero() {
  local tint=""
  [ -n "$2" ] && tint=" foreground='$2' background='$2' bgalpha='18%'"
  printf "<span size='xx-large' weight='bold'%s>%s</span>" "$tint" "$(tt_esc "$1")"
}

tt_head() { printf "<span size='large' weight='bold'>%s</span>" "$(tt_esc "$1")"; }
tt_sub()  { printf "<span alpha='75%%'>%s</span>" "$(tt_esc "$1")"; }
tt_dot()  { printf "<span foreground='%s'>●</span> " "$1"; }

tt_footer() {
  local out="" item
  for item in "$@"; do
    [ -z "$item" ] && continue
    [ -n "$out" ] && out+="$TT_FOOT_SEP"
    out+="$(tt_esc "$item")"
  done
  [ -n "$out" ] && printf "<span alpha='45%%' size='small'>%s</span>" "$out"
}

tt_bar() {
  local filled=$1 total=${2:-$TT_BAR_CELLS} off="" on="" i
  ((filled < 0)) && filled=0
  ((filled > total)) && filled=$total
  for ((i = filled; i < total; i++)); do off+="━"; done
  for ((i = 0; i < filled; i++)); do on+="━"; done
  if [ -n "$off" ]; then
    printf "<span alpha='25%%'>%s</span>%s" "$off" "$on"
  else
    printf '%s' "$on"
  fi
}

# Joins lines with a literal \n, which is valid inside the JSON string.
tt_join() {
  local out="" line first=1
  for line in "$@"; do
    if ((first)); then first=0; else out+='\n'; fi
    out+="$line"
  done
  printf '%s' "$out"
}

# text must already be JSON-safe; tooltip comes from tt_join.
tt_emit() {
  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$1" "$2" "$3"
}

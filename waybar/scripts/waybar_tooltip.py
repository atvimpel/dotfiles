"""Shared tooltip look for the waybar Python scripts in this folder.

Every tooltip is a card: a big hero value, a label under it, faint sublines,
an optional bar, then a small footer, with no rules or borders. Bars fill from the left.
The hero takes the state colour, and a live dot marks something ongoing.
"""
import html
import json

BAR_CELLS = 10
FOOT_SEP = "   ·   "

# Colours from the Material palette in theme.css
OK = "#0052dc"      # primary: connected, up to date, charging
WARN = "#675687"    # tertiary: attention, pending, in use
ALERT = "#ba1a1a"   # error: low battery, hot, recording


def esc(text):
    return html.escape(str(text), quote=False)


def head(text):
    return f"<span size='large' weight='bold'>{esc(text)}</span>"


def hero(value, color=None):
    tint = f" foreground='{color}' background='{color}' bgalpha='18%'" if color else ""
    return f"<span size='xx-large' weight='bold'{tint}>{esc(value)}</span>"


def sub(text):
    return f"<span alpha='75%'>{esc(text)}</span>"


def dot(color):
    return f"<span foreground='{color}'>●</span> "


def bar(filled, total=BAR_CELLS):
    filled = max(0, min(int(round(filled)), total))
    off = f"<span alpha='25%'>{'━' * (total - filled)}</span>" if filled < total else ""
    return off + "━" * filled


def footer(*items):
    parts = [esc(i) for i in items if i]
    if not parts:
        return ""
    return f"<span alpha='45%' size='small'>{FOOT_SEP.join(parts)}</span>"


def card(hero_value=None, label="", subs=(), color=None, live=None, bar_line=None, foot=None):
    lines = []
    if hero_value is not None:
        lines.append(hero(hero_value, color))
        if label:
            lines.append(sub(label))
    elif label:
        lines.append(head(label))
    for i, s in enumerate(x for x in subs if x):
        line = sub(s)
        if i == 0 and live:
            line = dot(live) + line
        lines.append(line)
    if bar_line is not None:
        lines.append(bar_line)
    if foot:
        lines.append(foot)
    return "\n".join(lines)


def emit(text, cls, tip, alt=None):
    out = {"text": text, "class": cls, "tooltip": tip}
    if alt is not None:
        out["alt"] = alt
    print(json.dumps(out))

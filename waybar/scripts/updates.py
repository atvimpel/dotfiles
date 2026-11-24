#!/usr/bin/env python3
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import waybar_tooltip as wt


def count_lines(cmd):
    try:
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode == 0 and res.stdout.strip():
            return len(res.stdout.strip().splitlines())
    except Exception:
        pass
    return 0


def get_updates():
    # checkupdates uses the pacman sync database without touching the root db
    pacman = count_lines(["checkupdates"])
    # yay -Qu --aur lists upgradable AUR packages
    aur = count_lines(["yay", "-Qu", "--aur"])
    total = pacman + aur

    if total > 0:
        noun = "update" if total == 1 else "updates"
        text = f"󰚰 {total}"
        tip = wt.card(str(total), noun, [f"Official {pacman} · AUR {aur}"], color=wt.WARN)
        cls = "update"
    else:
        text = "󰚰 0"  # always show the badge, even when clean
        tip = wt.card("0", "up to date", ["Nothing to install"], color=wt.OK)
        cls = "updated"

    wt.emit(text, cls, tip, alt=str(total))


if __name__ == "__main__":
    get_updates()

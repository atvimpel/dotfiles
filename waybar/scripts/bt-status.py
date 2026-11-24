#!/usr/bin/env python3
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import waybar_tooltip as wt


def connected_devices():
    out = subprocess.check_output(
        ["bluetoothctl", "devices", "Connected"], stderr=subprocess.DEVNULL, text=True
    )
    names = []
    for line in out.splitlines():
        line = line.strip()
        if not line:
            continue
        parts = line.split()
        # Format: Device 00:11:22:33:44:55 Name
        names.append(" ".join(parts[2:]) if len(parts) >= 3 else line)
    return names


def status():
    try:
        names = connected_devices()
    except Exception:
        try:
            subprocess.run(["systemctl", "is-active", "bluetooth"], check=True, capture_output=True)
        except Exception:
            return "󰂲", "off", wt.card("Off", "Bluetooth", ["Turn it on to connect devices"]), "disabled"
        return "󰂯", "unknown", wt.card("On", "Bluetooth", ["Couldn't read connected devices"]), "idle"

    count = len(names)
    if count == 0:
        return "󰂯", "0", wt.card("0", "no devices connected", ["Bluetooth is on"]), "disconnected"
    noun = "device" if count == 1 else "devices"
    tip = wt.card(str(count), f"{noun} connected", names, color=wt.OK)
    return "󰂱", str(count), tip, "connected"


def main():
    text, alt, tip, cls = status()
    wt.emit(text, cls, tip, alt=alt)


if __name__ == "__main__":
    main()

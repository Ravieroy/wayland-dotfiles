#!/usr/bin/env python3

import subprocess
import time

def read_status():
    """
    Reads the battery percentage using UPower command.
    """
    command = "upower -i $(upower -e | grep BAT) | grep --color=never -E percentage | awk '{print $2}' | sed 's/%//'"
    get_batterydata = subprocess.Popen(["/bin/bash", "-c", command], stdout=subprocess.PIPE)
    return int(get_batterydata.communicate()[0].decode("utf-8").strip())

def read_state():
    """
    Checks if the battery is charging or discharging.
    """
    command = "upower -i $(upower -e | grep BAT) | grep --color=never -E state | awk '{print $2}'"
    get_state = subprocess.Popen(["/bin/bash", "-c", command], stdout=subprocess.PIPE)
    return get_state.communicate()[0].decode("utf-8").strip()

def take_action():
    """
    Monitors battery level and sends notifications at specific thresholds.
    """
    notified = {"below_50": False, "below_20": False, "above_80": False}

    while True:
        charge = read_status()
        state = read_state()  # Get current battery state

        if charge < 20 and state == "discharging":  # Notify only if discharging
            subprocess.Popen(["notify-send", "-u", "critical", "Battery low!", f"Battery at {charge}%", "--expire-time=0"])
            notified = {"below_50": False, "below_20": True, "above_80": False}
            time.sleep(60)  # Continue checking every minute
            continue  # Skip further checks to ensure repeated low battery alerts

        elif charge < 50 and not notified["below_50"]:
            subprocess.Popen(["notify-send", "Battery Warning", f"Battery at {charge}%"])
            notified = {"below_50": True, "below_20": False, "above_80": False}

        elif charge > 80 and not notified["above_80"]:
            subprocess.Popen(["notify-send", "Battery Charged", f"Battery at {charge}%", "--expire-time=0"])
            notified = {"below_50": False, "below_20": False, "above_80": True}

        time.sleep(60)  # Check battery status every 60 seconds

take_action()


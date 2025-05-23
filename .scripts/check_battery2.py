#!/usr/bin/env python3

import subprocess
import time
import os
import fcntl
import logging
from pathlib import Path
import sys

# === Logging Setup ===
log_file = Path.home() / ".check_battery.log"
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# === Lock File to Prevent Multiple Instances ===
lockfile_path = Path("/tmp/check_battery.lock")

try:
    lockfile = open(lockfile_path, "w")
    fcntl.lockf(lockfile, fcntl.LOCK_EX | fcntl.LOCK_NB)
except IOError:
    logging.warning("Another instance of check_battery.py is already running.")
    sys.exit(0)


# === Battery Info Commands ===
def read_status():
    command = "upower -i $(upower -e | grep BAT) | grep -E 'percentage' | awk '{print $2}' | sed 's/%//'"
    try:
        output = subprocess.check_output(["/bin/bash", "-c", command])
        return int(output.decode("utf-8").strip())
    except Exception as e:
        logging.error(f"Failed to read battery status: {e}")
        return -1


def read_state():
    command = "upower -i $(upower -e | grep BAT) | grep -E 'state' | awk '{print $2}'"
    try:
        output = subprocess.check_output(["/bin/bash", "-c", command])
        return output.decode("utf-8").strip()
    except Exception as e:
        logging.error(f"Failed to read battery state: {e}")
        return "unknown"


def notify(title, message, urgency="normal", expire_time="5000"):
    try:
        subprocess.Popen([
            "notify-send", "-u", urgency,
            title, message,
            "--expire-time", expire_time
        ])
        logging.info(f"Sent notification: {title} - {message}")
    except Exception as e:
        logging.error(f"Failed to send notification: {e}")


# === Main Monitoring Loop ===
def take_action():
    notified = {"below_50": False, "below_20": False, "above_80": False}

    while True:
        charge = read_status()
        state = read_state()

        if charge == -1 or state == "unknown":
            time.sleep(60)
            continue

        if charge < 20 and state == "discharging":
            notify("Battery Critical", f"Battery at {
                   charge}%", urgency="critical", expire_time="0")
            notified = {"below_50": False, "below_20": True, "above_80": False}
            time.sleep(60)
            continue

        elif charge < 50 and not notified["below_50"]:
            notify("Battery Warning", f"Battery at {charge}%")
            notified = {"below_50": True, "below_20": False, "above_80": False}

        elif charge > 80 and not notified["above_80"]:
            notify("Battery Charged", f"Battery at {charge}%", expire_time="0")
            notified = {"below_50": False, "below_20": False, "above_80": True}

        time.sleep(60)


# === Start Monitoring ===
if __name__ == "__main__":
    logging.info("Starting battery monitor.")
    take_action()

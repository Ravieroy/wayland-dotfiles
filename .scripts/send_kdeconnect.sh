#!/bin/bash

# Get a list of available devices (Name and ID)
DEVICE_LIST=$(kdeconnect-cli --list-devices | awk -F': ' '{print $1}' | sed 's/- //')

# Check if any devices are available
if [ -z "$DEVICE_LIST" ]; then
    notify-send "KDE Connect" "No devices found!" -u critical
    exit 1
fi

# Let the user select a device using Zenity
DEVICE_NAME=$(echo "$DEVICE_LIST" | zenity --list --title="Select Device" --column="Devices" --height=300 --width=200)

# If no device was selected, exit
if [ -z "$DEVICE_NAME" ]; then
    notify-send "KDE Connect" "No device selected!" -u normal
    exit 1
fi

# Extract the device ID corresponding to the selected device
DEVICE_ID=$(kdeconnect-cli --list-devices | grep "$DEVICE_NAME" | grep -oP "\b[\dA-Fa-f_-]{10,}")

# Select files using a file picker (Zenity)
FILES=$(zenity --file-selection --multiple --separator=" " --title="Select files to send")

# Check if user selected files
if [ -z "$FILES" ]; then
    notify-send "KDE Connect" "No files selected!" -u normal
    exit 1
fi

# Send each file via kdeconnect
for FILE in $FILES; do
    if kdeconnect-cli --share "$FILE" -d "$DEVICE_ID"; then
        notify-send "KDE Connect" "Sent: $(basename "$FILE") to $DEVICE_NAME" -u low
    else
        notify-send "KDE Connect" "Failed to send: $(basename "$FILE") to $DEVICE_NAME" -u critical
    fi
done


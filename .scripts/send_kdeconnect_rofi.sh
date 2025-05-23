#!/bin/bash

# Get a list of available devices
DEVICE_LIST=$(kdeconnect-cli --list-devices | awk -F': ' '{print $1}' | sed 's/- //')

# Check if any devices are available
if [ -z "$DEVICE_LIST" ]; then
    notify-send "KDE Connect" "❌ No devices found!" -u critical
    exit 1
fi

# Use Rofi to select a device (bigger window)
DEVICE_NAME=$(echo "$DEVICE_LIST" | rofi -dmenu -p "📡 Select Device" -theme-str 'window { width: 40%; } listview { lines: 8; }')

# If no device was selected, exit
if [ -z "$DEVICE_NAME" ]; then
    notify-send "KDE Connect" "❌ No device selected!" -u normal
    exit 1
fi

# Extract the device ID
DEVICE_ID=$(kdeconnect-cli --list-devices | grep "$DEVICE_NAME" | grep -oP "\b[\dA-Fa-f_-]{10,}")

# Open Zenity file picker
FILES=$(zenity --file-selection --multiple --separator='\n' --title="📂 Select Files to Send")

# If no files selected, exit
if [ -z "$FILES" ]; then
    notify-send "KDE Connect" "❌ No files selected!" -u normal
    exit 1
fi

# Send each file via KDE Connect
IFS=$'\n'
for FILE in $FILES; do
    if kdeconnect-cli --share "$FILE" -d "$DEVICE_ID"; then
        notify-send "KDE Connect" "✅ Sent: $(basename "$FILE") to $DEVICE_NAME" -u low
    else
        notify-send "KDE Connect" "❌ Failed to send: $(basename "$FILE")" -u critical
    fi
done


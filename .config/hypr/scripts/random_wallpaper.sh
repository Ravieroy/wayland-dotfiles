#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Start swww-daemon if not already running
pgrep -x swww-daemon >/dev/null || swww-daemon &

# Small delay to ensure the daemon is ready
sleep 1

# Load all wallpapers into an array
mapfile -t ALL_WALLPAPERS < <(find "$WALLPAPER_DIR" -type f | shuf)

# Initialize index
INDEX=0
TOTAL=${#ALL_WALLPAPERS[@]}

while true; do
    # Reset and reshuffle when all wallpapers are used
    if [ "$INDEX" -ge "$TOTAL" ]; then
        mapfile -t ALL_WALLPAPERS < <(find "$WALLPAPER_DIR" -type f | shuf)
        INDEX=0
        TOTAL=${#ALL_WALLPAPERS[@]}
    fi

    # Set the current wallpaper
    CURRENT_WALLPAPER="${ALL_WALLPAPERS[$INDEX]}"
    swww img "$CURRENT_WALLPAPER" --transition-type fade --transition-duration 1

    # Move to the next wallpaper
    INDEX=$((INDEX + 1))

    # Wait for 10 minutes
    sleep 600
done


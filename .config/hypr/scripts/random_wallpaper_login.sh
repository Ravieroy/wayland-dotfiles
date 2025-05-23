#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Start swww if not already running
pgrep -x swww >/dev/null || swww init

# Pick a random wallpaper
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set it
swww img "$RANDOM_WALLPAPER" --transition-type any --transition-fps 60


#!/bin/bash

# Kill all existing Waybar instances
killall waybar 2>/dev/null

# Short delay to avoid race conditions
sleep 0.5

# Start the default Waybar instance
waybar &

# Start the second Waybar instance with the left-side config
# waybar -c ~/.config/waybar/config-left.jsonc &


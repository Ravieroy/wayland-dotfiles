#!/usr/bin/env bash
set -euo pipefail

WAYBAR_DIR="$HOME/.config/waybar"

TOP_CONFIG="$WAYBAR_DIR/config.top.jsonc"
TOP_STYLE="$WAYBAR_DIR/style.top.css"

LEFT_CONFIG="$WAYBAR_DIR/config.left.jsonc"
LEFT_STYLE="$WAYBAR_DIR/style.left.css"

ACTIVE_CONFIG="$WAYBAR_DIR/config"
ACTIVE_STYLE="$WAYBAR_DIR/style.css"

choose_layout() {
    # List connected monitor names from hyprctl output.
    monitors="$(hyprctl monitors | awk '/^Monitor / {print $2}')"

    # If any connected monitor is not the laptop panel eDP-1, use top layout.
    if echo "$monitors" | grep -qx "eDP-1" && echo "$monitors" | grep -qvx "eDP-1"; then
        ln -sfn "$TOP_CONFIG" "$ACTIVE_CONFIG"
        ln -sfn "$TOP_STYLE" "$ACTIVE_STYLE"
        echo "Using TOP layout"
    else
        ln -sfn "$LEFT_CONFIG" "$ACTIVE_CONFIG"
        ln -sfn "$LEFT_STYLE" "$ACTIVE_STYLE"
        echo "Using LEFT layout"
    fi
}

restart_waybar() {
    pkill waybar 2>/dev/null || true
    nohup waybar >/dev/null 2>&1 &
}

main() {
    choose_layout
    restart_waybar

    last_state=""
    while true; do
        current_state="$(hyprctl monitors | awk '/^Monitor / {print $2}' | tr '\n' ' ')"
        if [[ "$current_state" != "$last_state" ]]; then
            choose_layout
            restart_waybar
            last_state="$current_state"
        fi
        sleep 3
    done
}

main

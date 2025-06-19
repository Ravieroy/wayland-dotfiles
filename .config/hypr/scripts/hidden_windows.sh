#!/bin/bash

# Get all hidden clients on special workspaces
get_hidden_clients() {
    hyprctl clients -j 2>/dev/null | jq '[.[] | select(.workspace.name | test("^special:"))]'
}

# Count hidden windows
get_hidden_count() {
    get_hidden_clients | jq 'length'
}

# Clean application class name (e.g. org.KDE.Knotes → Knotes)
clean_app_name() {
    local raw="$1"
    echo "${raw##*.}" | sed 's/.*/\u&/'
}

# Handle click: Show wofi menu and focus selected
handle_click() {
    mapfile -t window_data < <(get_hidden_clients | jq -rc '.[] | {class, title, address}')

    if [[ ${#window_data[@]} -eq 0 ]]; then
        notify-send "  Hidden Windows" "No hidden windows"
        exit 0
    fi

    entries=()
    addresses=()

    for json in "${window_data[@]}"; do
        class=$(echo "$json" | jq -r '.class')
        title=$(echo "$json" | jq -r '.title')
        address=$(echo "$json" | jq -r '.address')
        clean_class=$(clean_app_name "$class")
        display="$clean_class: $title"
        entries+=("$display")
        addresses+=("$address")
    done

    # Show wofi menu
    selected=$(printf "%s\n" "${entries[@]}" | wofi --dmenu --prompt="Hidden Windows" --width=500 --height=300)

    # Focus selected
    for i in "${!entries[@]}"; do
        if [[ "${entries[$i]}" == "$selected" ]]; then
            hyprctl dispatch focuswindow address:"${addresses[$i]}"
            break
        fi
    done
}

# Main entry
if [[ "$1" == "--click" ]]; then
    handle_click
    exit 0
fi

# Default output for Waybar
count=$(get_hidden_count)
echo "  $count"


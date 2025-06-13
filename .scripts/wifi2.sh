#!/bin/bash

# Text colors for output
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtrst=$(tput sgr0)

# Check if nmcli is installed
if ! command -v nmcli &>/dev/null; then
    echo "${txtred}ERROR: nmcli command not found. Please install NetworkManager to proceed.${txtrst}"
    exit 1
fi

# Display available WiFi networks
echo "${txtylw}Fetching available WiFi networks...${txtrst}"
wifi_list=$(nmcli -t -f SSID,BSSID dev wifi | awk -F: '{printf "%-3s %-30s %-20s\n", NR, $1, $2}')
if [ -z "$wifi_list" ]; then
    echo "${txtred}No WiFi networks found. Ensure your WiFi is enabled.${txtrst}"
    exit 1
fi

echo
echo "${txtblu}Available WiFi Networks:${txtrst}"
echo "$wifi_list"
echo
echo "${txtylw}Enter 0 to quit the script at any time.${txtrst}"
echo

# Get user's choice
n_lines=$(echo "$wifi_list" | wc -l)
while :; do
    read -p "${txtgrn}Enter your choice (1-$n_lines, or 0 to quit): ${txtrst}" input

    # Quit if user chooses 0
    if [[ "$input" == "0" ]]; then
        echo "${txtcyn}Exiting... Goodbye!${txtrst}"
        exit 0
    fi

    # Validate input
    if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 1 ] && [ "$input" -le "$n_lines" ]; then
        break
    else
        echo "${txtred}Invalid choice. Please enter a number between 1 and $n_lines, or 0 to quit.${txtrst}"
    fi
done

# Extract selected WiFi details
wifi_name=$(echo "$wifi_list" | sed -n "${input}p" | awk '{print $2}')
bssid=$(echo "$wifi_list" | sed -n "${input}p" | awk '{print $3}')

# Connect to the selected WiFi
echo "${txtylw}Connecting to \"$wifi_name\"...${txtrst}"
nmcli d wifi connect "$bssid" --ask
if [ $? -eq 0 ]; then
    echo "${txtgrn}Successfully connected to \"$wifi_name\"!${txtrst}"
else
    echo "${txtred}Failed to connect to \"$wifi_name\". Please check your credentials and try again.${txtrst}"
fi

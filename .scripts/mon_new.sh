#!/bin/bash

# Text colors
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtrst=$(tput sgr0)

# Root check
chk_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "${txtred}ERROR: This script must be run as root!${txtrst}"
        exit 1
    fi
    echo "${txtgrn}Monitoring usage for:${txtrst}"
    dmidecode | grep -A3 '^System Information'
}

# Check power source (AC or battery)
chk_stat() {
    power_status=$(cat /sys/class/power_supply/AC/online 2>/dev/null)
    if [ "$power_status" == "1" ]; then
        echo "${txtylw}You are on AC power.${txtrst}"
    else
        echo "${txtylw}You are on battery power.${txtrst}"
    fi
}

# Prepare necessary files
imp_files() {
    for file in log.txt times.txt; do
        if [ ! -e "$file" ]; then
            echo "${txtylw}$file not found. Creating...${txtrst}"
            touch "$file"
        fi
        if [ ! -w "$file" ]; then
            echo "${txtylw}$file is not writable. Updating permissions...${txtrst}"
            chmod +w "$file"
        fi
    done
}

# Start or stop session
handle_session() {
    echo -e "${txtgrn}Power ON/OFF? ${txtrst}"
    read input
    case "${input,,}" in
        "on")
            time_on=$(date +'%a %d %b %Y %T')
            echo "---------------------------------------------" >>log.txt
            echo "SESSION STARTED" >>log.txt
            battery_status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|percentage")
            echo "Battery: $battery_status" >>log.txt
            echo "Power ON: $time_on" >>log.txt
            echo "$time_on" >times.txt
            ;;
        "off")
            time_off=$(date +'%a %d %b %Y %T')
            battery_status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|percentage")
            echo "Battery: $battery_status" >>log.txt
            echo "Power OFF: $time_off" >>log.txt
            echo "SESSION STOPPED" >>log.txt
            echo "---------------------------------------------" >>log.txt
            echo "$time_off" >>times.txt
            ;;
        *)
            echo "${txtred}Invalid choice. Please enter 'ON' or 'OFF'.${txtrst}"
            exit 1
            ;;
    esac
}

# Calculate session duration
calculate_duration() {
    # Ensure times.txt has two valid times (start and stop)
    if [ ! -s times.txt ]; then
        echo "${txtred}ERROR: times.txt is empty or not properly updated.${txtrst}"
        return
    fi

    start_time=$(sed -n '1p' times.txt)
    stop_time=$(sed -n '2p' times.txt)

    if [ -z "$start_time" ] || [ -z "$stop_time" ]; then
        echo "${txtred}ERROR: Missing start or stop time in times.txt.${txtrst}"
        return
    fi

    start_seconds=$(date --date="$start_time" +%s)
    stop_seconds=$(date --date="$stop_time" +%s)
    duration_minutes=$(( (stop_seconds - start_seconds) / 60 ))

    echo "Session duration: $duration_minutes minutes" >>log.txt
    echo "${txtgrn}Session duration: $duration_minutes minutes${txtrst}"
}

# Main execution
chk_root
chk_stat
imp_files
handle_session
calculate_duration

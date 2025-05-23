#!/bin/bash

# Default thresholds (can be overridden via command-line args)
CRITICAL_THRESHOLD=${1:-3000}
WARNING_THRESHOLD=${2:-4000}
INTERVAL=${3:-10}

# Log file for memory events
LOGFILE="$HOME/memory_check.log"

# Check if 'free' and 'notify-send' are available
if ! command -v free &> /dev/null; then
    echo "The 'free' command is not found. Exiting."
    exit 1
fi

if ! command -v notify-send &> /dev/null; then
    echo "The 'notify-send' command is not found. Notifications will not be sent."
    notify_send_available=0
else
    notify_send_available=1
fi

while true; do
    # Fetch memory details in one call
    read total free cached available < <(free -m | awk '/^Mem:/ {print $2, $4, $6, $7}')

    # Calculate memory usage percentage
    used=$(($total - $available))
    full_percent=$(echo "scale=0; $used * 100 / $total" | bc)

    # Display memory usage message
    message="Free: $free MB, Cached: $cached MB, Available: $available MB"

    # Notify based on thresholds
    if [ "$available" -lt "$CRITICAL_THRESHOLD" ]; then
        if [ $notify_send_available -eq 1 ]; then
            notify-send -u critical -t 2000 "Critical Memory Limit Reached!" "$message (Usage: $full_percent%)"
        fi
        echo "$(date): CRITICAL - $message (Usage: $full_percent%)" >> $LOGFILE
    elif [ "$available" -lt "$WARNING_THRESHOLD" ]; then
        if [ $notify_send_available -eq 1 ]; then
            notify-send -u normal -t 1000 "WARNING: Memory is running out!" "$message (Usage: $full_percent%)"
        fi
        echo "$(date): WARNING - $message (Usage: $full_percent%)" >> $LOGFILE
    fi

    # Sleep for the specified interval
    sleep $INTERVAL
done


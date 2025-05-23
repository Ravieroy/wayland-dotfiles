#!/bin/bash

# Default thresholds (can be overridden via command-line args)
CRITICAL_THRESHOLD=${1:-3000}
WARNING_THRESHOLD=${2:-4000}
INTERVAL=${3:-10}

# Log file for memory events
LOGFILE=~/memory_check.log

# Check if free and notify-send are available
if ! command -v free &> /dev/null; then
    echo "free command not found. Exiting."
    exit 1
fi

if ! command -v notify-send &> /dev/null; then
    echo "notify-send command not found. Notifications will not be sent."
    notify_send_available=0
else
    notify_send_available=1
fi

while true; do
    # Fetch memory details in one call
    read total free cached available < <(free -m | awk '/^Mem:/ {print $2, $4, $6, $7}')

    # Display memory usage message
    message="Free: $free MB, Cached: $cached MB, Available: $available MB"

    # Memory usage percentage
    full_percent=$(echo "scale=0; ($total - $available) * 100 / $total" | bc)

    # Notify based on thresholds
    if [ "$available" -lt "$CRITICAL_THRESHOLD" ]; then
        if [ $notify_send_available -eq 1 ]; then
            notify-send -u critical -t 4000 "Critical Memory Limit Reached! $full_percent% Full" "$message"
        fi
        echo "$(date): CRITICAL - $message" >> $LOGFILE
    elif [ "$available" -lt "$WARNING_THRESHOLD" ]; then
        if [ $notify_send_available -eq 1 ]; then
            notify-send -u normal -t 2000 "WARNING: Memory is running out! $full_percent% Full" "$message"
        fi
        echo "$(date): WARNING - $message" >> $LOGFILE
    fi

    # Sleep for the specified interval
    sleep $INTERVAL
done


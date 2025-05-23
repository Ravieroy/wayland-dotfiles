#!/bin/bash

# This script checks if a file is executable.
# Usage: ./check_executable.sh fileName

# Function to display usage
display_usage() {
    echo "Error: Wrong usage"
    echo "Usage: $0 fileName"
    exit 1
}

# Check if a filename is provided
if [ $# -eq 0 ]; then
    display_usage
fi

# Check if the file exists and determine if it is executable
check_file() {
    local file="$1"

    if [ -e "$file" ]; then
        if [ -x "$file" ]; then
            echo "\"$file\" is an executable."
        else
            echo "\"$file\" is not an executable."
        fi
    else
        echo "\"$file\" not found."
    fi
}

# Call the function with the provided filename
check_file "$1"


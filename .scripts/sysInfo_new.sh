#!/bin/bash

# Comprehensive System Information Script
# Maintains full functionality and readability from the original version.
# Created by Ravi Roy (https://github.com/ravieroy)

# Colors
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)

# For terminal width alignment
COLUMNS=$(tput cols)

# Center alignment function
center() {
    local width=$((COLUMNS / 2 - 60))
    while IFS= read -r line; do
        printf "%${width}s %s\n" "" "$line"
    done
}

centerwide() {
    local width=$((COLUMNS / 2 - 30))
    while IFS= read -r line; do
        printf "%${width}s %s\n" "" "$line"
    done
}

# Root check
chk_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "${txtred}ERROR: Please run this script as root (sudo).${txtrst}" | centerwide
        exit 1
    fi
}

# Install necessary packages dynamically
install_package() {
    local pkg="$1"
    if ! command -v "$pkg" &>/dev/null; then
        echo "${txtylw}Installing $pkg...${txtrst}" | center
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y "$pkg"
        elif command -v yum &>/dev/null; then
            sudo yum install -y "$pkg"
        else
            echo "${txtred}ERROR: Unsupported package manager. Please install $pkg manually.${txtrst}" | center
            return 1
        fi
    fi
}

# Display sections with titles
section() {
    echo
    echo "${txtylw}--------------------------- $1 ---------------------------${txtrst}"
}

# System Information
system_info() {
    section "SYSTEM INFORMATION"
    dmidecode | grep -A4 '^System Information'
}

# Architecture
architecture_info() {
    section "ARCHITECTURE"
    echo "System Architecture: $(lscpu | grep -i 'Architecture' | awk '{print $2}')"
}

# Battery Information
battery_info() {
    section "BATTERY INFORMATION"
    if command -v acpi &>/dev/null; then
        acpi || echo "${txtred}No battery information available.${txtrst}"
    else
        echo "${txtred}acpi not found! Install it for battery information.${txtrst}"
    fi
}

# Memory Slots
memory_slots() {
    section "MEMORY SLOTS"
    lshw -short -C memory | grep -i empty &>/dev/null && \
        echo "${txtgrn}You have empty memory slots.${txtrst}" || \
        echo "${txtgrn}No empty memory slots detected.${txtrst}"
}

# RAM Information
ram_info() {
    section "RAM INFORMATION"
    free -h --si
}

# Disk Information
disk_info() {
    section "DISK INFORMATION"
    lshw -C disk | grep -i size:
    echo "Disk Usage: $(df -h --total | grep 'total')"
}

# Screen Resolution
screen_info() {
    section "SCREEN RESOLUTION"
    echo "Resolution and Refresh Rate: $(xrandr | grep -i '\*')"
}

# BIOS Information
bios_info() {
    section "BIOS INFORMATION"
    dmidecode -t bios | grep -iE 'release date|rom size|usb legacy|uefi'
}

# Processor Details
processor_info() {
    section "PROCESSOR DETAILS"
    lshw -C cpu | grep -iE 'product|configuration|mhz'
}

# IP Address
network_info() {
    section "NETWORK INFORMATION"
    if ip=$(hostname -I | awk '{print $1}'); then
        echo "IP Address for SSH Connection: $ip"
    else
        echo "${txtred}No network connection detected.${txtrst}"
    fi
}

# SSH Status
ssh_status() {
    section "SSH SERVICE STATUS"
    systemctl is-active ssh &>/dev/null && echo "${txtgrn}SSH is active.${txtrst}" || echo "${txtred}SSH is inactive.${txtrst}"
}

# Main function
main() {
    chk_root
    install_package dmidecode
    install_package acpi

    system_info
    architecture_info
    battery_info
    memory_slots
    ram_info
    disk_info
    screen_info
    bios_info
    processor_info
    network_info
    ssh_status

    echo
    echo "${txtgrn}All details have been displayed.${txtrst}" | centerwide
}

# Execute the main function
main

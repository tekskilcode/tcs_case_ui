#!/bin/bash

# Interface renaming script

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Function to add the udev rule
add_udev_rule() {
    rule_file="/etc/udev/rules.d/10-rename-network.rules"

    echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", NAME=\"enp3s0\"" | sudo tee "$rule_file" > /dev/null
}

# Function to trigger the udev rule
trigger_udev() {
    sudo udevadm trigger
}

# Function to display the interface information
display_interface_info() {
    echo "Interface renamed successfully."
    echo "Old interface name: $current_interface"
    echo "New interface name: enp3s0"
}

# Main script
read -p "Enter the current interface name: " current_interface

add_udev_rule
trigger_udev
display_interface_info

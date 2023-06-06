#!/bin/bash

sudo apt-get install chromium-browser 

# Name and command for the startup program
NAME="Chrome-boot-init"
COMMAND="chromium-browser --kiosk file:///home/tch/Documents/loading.html"

# Create the autostart directory if it doesn't exist
AUTOSTART_DIR="/home/tch/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

# Create a desktop entry file for the startup program
DESKTOP_FILE="$AUTOSTART_DIR/chrome.desktop"
echo "[Desktop Entry]" > "$DESKTOP_FILE"
echo "Type=Application" >> "$DESKTOP_FILE"
echo "Name=$NAME" >> "$DESKTOP_FILE"
echo "Exec=$COMMAND" >> "$DESKTOP_FILE"


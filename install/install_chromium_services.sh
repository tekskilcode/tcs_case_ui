#!/bin/bash

sudo apt-get install chromium-browser 

echo "///move html file///"

cp -r /home/tch/apps/tcs_ui/install/loading_page /home/tch/loading_page

echo "///change owner///"

sudo chown -R $SUDO_USER:$SUDO_USER /home/tch/loading_page

# Name and command for the startup program
NAME="Chrome-boot-init"
COMMAND="chromium-browser --disable-features=OverscrollHistoryNavigation --disable-pinch --clear-browsing-history --kiosk file:///home/tch/loading_page/loading.html"

# Create the autostart directory if it doesn't exist
AUTOSTART_DIR="/home/tch/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

# Create a desktop entry file for the startup program
DESKTOP_FILE="$AUTOSTART_DIR/chrome.desktop"
echo "[Desktop Entry]" > "$DESKTOP_FILE"
echo "Type=Application" >> "$DESKTOP_FILE"
echo "Name=$NAME" >> "$DESKTOP_FILE"
echo "Exec=$COMMAND" >> "$DESKTOP_FILE"


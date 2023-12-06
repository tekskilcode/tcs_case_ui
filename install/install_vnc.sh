#!/bin/bash

./setup_vnc_password.sh

echo "Setting up VNC Services"

sudo cp vnc_install_files/x11vnc-gdm.sh /etc

sudo chmod +x /etc/x11vnc-gdm.sh
sudo chown gdm /etc/x11vnc-gdm.sh

# Update GDM3 configuration - uncomment WaylandEnable=false

# Check if the file exists 
if [ -f "/etc/gdm3/custom.conf" ]; then 
	# Uncomment the line if it exists 
	sudo sed -i 's/#\(WaylandEnable=false\)/\1/' /etc/gdm3/custom.conf 
	echo "Uncommented the line 'WaylandEnable=false' in /etc/gdm3/custom.conf" 
else 
	echo "File /etc/gdm3/custom.conf not found."
fi

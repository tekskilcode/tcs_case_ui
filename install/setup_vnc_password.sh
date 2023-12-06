#!/bin/bash

sudo apt-get install -y x11vnc

echo "You will now be asked to enter the VNC password. (Use the same password that you use to log in)"

# Ask for the VNC password
until sudo -u tch x11vnc -storepasswd
do
	echo "Try again"
done


# Copy the vncpasswd file to /etc/vncpasswd, and chown to gdm
sudo cp /home/tch/.vnc/passwd /etc/vncpasswd
sudo chown gdm /etc/vncpasswd

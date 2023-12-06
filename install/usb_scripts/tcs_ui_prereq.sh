#!/bin/bash

if [[ $UID = 0 ]]; then
    echo "Do not run this script as root."
    echo "sudo $0 $*"
    exit 1
fi

echo "///Remove previous install///"
sudo rm -rf /usr/local/opt/apps/tcs_ui
sudo rm -rf ~/apps

sudo mkdir -p /usr/local/opt/apps/tcs_ui
sudo chmod -R 777 /usr/local/opt/apps/tcs_ui

echo "///Disable and remove unattended-upgrades///"
sudo systemctl stop unattended-upgrades
sudo apt-get -y purge unattended-upgrades

#echo "Update and upgrade packages"
sudo apt-get update
sudo apt-get -y upgrade

echo "///Install Git///"
sudo apt-get -y install git curl

echo "///Clone TCS UI repository///"
git clone https://github.com/beta-things/tcs_case_ui.git /usr/local/opt/apps/tcs_ui
#cp -r /home/tch/tcs_case_ui/* /usr/local/opt/apps/tcs_ui

sudo ln -s /usr/local/opt/apps /home/tch/apps

cd ~/apps/tcs_ui/install

echo "///Setup Docker///"
./install_docker.sh

echo "///Install WEB SERVER ///"
#sudo SUDO_USER="$SUDO_USER" sh  ./install_web_server.sh
#extract contents to Downloads

# This file must be downloaded to ~/Downloads before running this script.
tar -xf tkskl-server-setup.tar -C /home/tch/Downloads

cd /home/tch/Downloads/tkskl-server-setup

./setup_server.sh

cd ~/apps/tcs_ui/install

echo "///Install Chromium and autostart browser///"
./install_chromium_services.sh

echo "///Install VNC server///"
./install_vnc.sh

echo "///Install utilities///"
./install_utils.sh

echo "///Install Tailscale///"
./install_tailscale.sh

echo "///Install services///"
./install_services.sh

echo "///Stop crash notifications///"
./stop_crash_notifications.sh

echo "///set interface name///"
./change_net_interface.sh

echo "///Install DisplayLink driver///"
#sudo ./DisplayLink_USB_Ubuntu_5.6.1/displaylink-driver-5.6.1-59.184.run
#sudo chmod +x ./DisplayLink_USB_Graphics_5.7/displaylink-driver-5.7.0-61.129.run
#sudo ./DisplayLink_USB_Graphics_5.7/displaylink-driver-5.7.0-61.129.run
sudo apt install -y ./synaptics-repository-keyring.deb
sudo apt update
sudo apt install -y displaylink-driver


echo "///PRE-REQUISITES INSTALL COMPLETE///"

# Display information about Tailscale and x11vnc
./tailscale-vnc-info.sh

# Let the user know that a reboot is required for the WaylandEnable setting we changed to take effect.
echo "Please reboot so that GDM uses Xorg."

#!/bin/bash

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
sudo -u $SUDO_USER git clone https://github.com/beta-things/tcs_case_ui.git /usr/local/opt/apps/tcs_ui

sudo ln -s /usr/local/opt/apps /home/tch/apps

echo "///Setup Docker///"
sudo sh /home/tch/apps/tcs_ui/install/install_docker.sh

echo "///Install WEB SERVER ///"
#sudo SUDO_USER="$SUDO_USER" sh  ./install_web_server.sh
#extract contents to Downloads
tar -xf tkskl-server-setup.tar -C /home/tch/Downloads

cd /home/tch/Downloads/tkskl-server-setup

sudo SUDO_USER=$SUDO_USER ./setup_server.sh

cd /home/tch/apps/tcs_ui/install


echo "///Install Chromium and autostart browser///"
sudo SUDO_USER="$SUDO_USER" sh  ./install_chromium_services.sh

echo "///Install VNC server///"
sudo ./install_vnc.sh

echo "///Install utilities///"
sudo ./install_utils.sh

echo "///Install Tailscale///"
sudo ./install_tailscale.sh

echo "///Install services///"
sudo ./install_services.sh

echo "///Stop crash notifications///"
sudo ./stop_crash_notifications.sh

echo "///set interface name///"
sudo ./change_net_interface.sh


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

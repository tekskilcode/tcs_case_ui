#!/bin/bash

sudo mkdir -p /usr/local/opt/apps/tcs_ui
sudo chmod -R 777 /usr/local/opt/apps/tcs_ui



#echo "Update and upgrade packages"
sudo apt-get update
sudo apt-get upgrade


echo "///Install Git///"
sudo apt-get install git

echo "///Clone TCS UI repository///"
sudo -u $SUDO_USER git clone https://github.com/beta-things/tcs_case_ui.git /usr/local/opt/apps/tcs_ui

sudo ln -s /usr/local/opt/apps /home/tch/apps

cd /home/tch/apps/tcs_ui/install

echo "///Setup Docker///"
sudo ./install_docker.sh

echo "///Install Chromium and autostart browser///"
sudo SUDO_USER="$SUDO_USER" sh  ./install_chromium_services.sh


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
sudo apt install ./synaptics-repository-keyring.deb
sudo apt update
sudo apt install displaylink-driver


echo "///PRE-REQUISITES INSTALL COMPLETE///"

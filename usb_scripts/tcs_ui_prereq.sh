#!/bin/bash

#echo "Update and upgrade packages"
sudo apt-get update
sudo apt-get upgrade

#certain programs use specific folder name so make a tch symlink
sudo ln -s /home/tkskl-admin /home/tch


echo "///Install Git///"
sudo apt-get install git

echo "///Clone TCS UI repository///"
sudo -u $SUDO_USER git clone https://github.com/beta-things/tcs_case_ui.git /home/tch/Documents
cd /home/tch/Documents

echo "///Install DisplayLink driver///"
#sudo ./DisplayLink_USB_Ubuntu_5.6.1/displaylink-driver-5.6.1-59.184.run
sudo ./DisplayLink_USB_Graphics_5.7/displaylink-driver-5.7.0-61.129.run

echo "///Setup Docker///"
sudo ./install_docker.sh

echo "///Install Chromium and autostart browser///"
sudo ./install_chromium_services.sh

cd /home/tch/Documents
echo "///Install services///"
sudo ./install_services.sh

echo "///Stop crash notifications///"
sudo ./stop_crash_notifications.sh

echo "///set interface name///"
sudo ./change_net_interface.sh

echo "///PRE-REQUISITES INSTALL COMPLETE///"

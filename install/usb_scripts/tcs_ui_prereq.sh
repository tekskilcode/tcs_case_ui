#!/bin/bash

set -e

if [[ $UID = 0 ]]; then
    echo "Do not run this script as root."
    echo "sudo $0 $*"
    exit 1
fi

# UNINSTALL ===========================================================

echo "///Remove previous install///"

sudo rm -rf /usr/local/opt/apps/tcs_ui
sudo rm -rf ~/apps
sudo rm -rf /usr/local/opt/apps/docker
sudo rm -rf /etc/apt/keyrings/docker.gpg

sudo mkdir -p /usr/local/opt/apps/tcs_ui
sudo mkdir -p /usr/local/opt/apps/docker

sudo chmod -R 777 /usr/local/opt/apps/tcs_ui
sudo chmod -R 777 /usr/local/opt/apps/docker

# Uninstall Docker

sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce docker-compose-plugin

set +e
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
set -e
sudo groupdel docker
set +e
sudo rm -rf /var/run/docker.sock

# Uninstall changes made in install_chromium_services.sh

sudo rm -rf /home/tch/loading_page
sudo rm -rf /home/tch/.config/autostart

# Uninstall changes made in install_vnc.sh

sudo rm -rf /etc/x11vnc-gdm.sh
sudo rm -rf /home/tch/.vnc/passwd /etc/vncpasswd

# Uninstall tailscale, and delete all state information

sudo apt-get -y remove tailscale
sudo /var/lib/tailscale/tailscaled.state

# Stop and remove services

sudo systemctl stop tcs_case_ui.service 
sudo systemctl stop tcs_pipe.service
sudo systemctl stop tcs_web_ui.service 
sudo systemctl stop x11vnc@gdm.service
sudo systemctl stop x11vnc@tch.service

sudo systemctl disable tcs_case_ui.service 
sudo systemctl disable tcs_pipe.service
sudo systemctl disable tcs_web_ui.service 
sudo systemctl disable x11vnc@gdm.service
sudo systemctl disable x11vnc@tch.service

sudo rm -rf /etc/systemd/system/tcs_case_ui.service \
	    /etc/systemd/system/tcs_pipe.service \
	    /etc/systemd/system/tcs_web_ui.service \
	    /etc/systemd/system/x11vnc@gdm.service \
	    /etc/systemd/system/x11vnc@tch.service

rm -rf /home/tch/apps/tcs_ui/tcs_ui_pipe

# Install =============================================================

echo "///Disable and remove unattended-upgrades///"
set +e
sudo systemctl stop unattended-upgrades
sudo apt-get -y purge unattended-upgrades
set -e

#echo "Update and upgrade packages"
sudo apt-get update
sudo apt-get -y upgrade

echo "///Install Git///"
sudo apt-get -y install git curl

echo "///Clone TCS UI repository///"
git clone https://github.com/tekskilcode/tcs_case_ui.git /usr/local/opt/apps/tcs_ui

sudo ln -s /usr/local/opt/apps /home/tch/apps

cd ~/apps/tcs_ui/install

echo "///Setup Docker///"
./install_docker.sh

echo "///Install WEB SERVER ///"

TAG_NAME='v3.0.0-rc1'
RELEASE_NAME='tkskl-server-config.v3.0.0-rc1.tar.gz'

CURL="curl -LJ -H 'Authorization: Bearer $GITHUB_TOKEN' -H 'X-GitHub-Api-Version: 2022-11-28' https://api.github.com/repos/tekskilcode/tkskl-server/releases"

ASSET_ID=$(eval "$CURL/tags/$TAG_NAME" \
        | jq --arg RELEASE_NAME "$RELEASE_NAME" '.assets[] | select(.name == $RELEASE_NAME).id')

RESULT=$?

if [ $RESULT != 0 ]; then
        echo "There was a problem getting the release info. Incorrect token?"
        exit
fi

printf "Asset ID: $ASSET_ID\n"

eval "$CURL/assets/$ASSET_ID -LJH 'Accept: application/octet-stream' > $RELEASE_NAME"

RESULT=$?

if [ $RESULT != 0 ] ; then
        echo "Couldn't download the release."
        exit
fi

sudo tar zxvf $RELEASE_NAME --strip-components=1 -C /usr/local/opt/apps/docker

#sudo SUDO_USER="$SUDO_USER" sh  ./install_web_server.sh
#extract contents to Downloads
# This file must be downloaded to ~/Downloads before running this script.
#tar -xf tkskl-server-setup.tar -C /home/tch/Downloads

export GHCR_TOKEN=$GITHUB_TOKEN
export CR_PAT=$GITHUB_TOKEN
echo $CR_PAT | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

cd /usr/local/opt/apps/docker/install
sudo chmod +x install.sh
./install.sh

cd ~/apps/tcs_ui/install

echo "///Install Chromium and autostart browser///"
./install_chromium_services.sh

echo "///Install VNC server///"
./install_vnc.sh

echo "///Install utilities///"
./install_utils.sh

echo "///Install Tailscale///"
#./install_tailscale.sh

echo "///Install services///"
./install_services.sh

echo "///Stop crash notifications///"
./stop_crash_notifications.sh

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
echo "Please reboot for changes to take effect."


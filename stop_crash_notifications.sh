#! /bin/bash

sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport
sudo systemctl stop apport.service
sudo apt-get remove update-manager

#!/bin/bash

#extract contents to Downloads
tar -xf tkskl-server-setup.tar -C /home/tch/Downloads

cd /home/tch/Downloads/tkskl-server-setup

sudo ./setup_server.sh

sudo ln -s /usr/local/opt/apps /home/tch/apps

#!/bin/bash

sudo cp service_files/tcs_case_ui.service /etc/systemd/system/
sudo cp service_files/tcs_pipe.service /etc/systemd/system/
sudo cp service_files/tcs_web_ui.service /etc/systemd/system/
sudo cp service_files/x11vnc@gdm.service /etc/systemd/system/
sudo cp service_files/x11vnc@tch.service /etc/systemd/system/

sudo systemctl enable tcs_case_ui.service 
sudo systemctl enable tcs_pipe.service
sudo systemctl enable tcs_web_ui.service 
sudo systemctl enable x11vnc@gdm.service
sudo systemctl enable x11vnc@tch.service

sudo systemctl start tcs_case_ui.service 
sudo systemctl start tcs_pipe.service
sudo systemctl start tcs_web_ui.service 
sudo systemctl start x11vnc@gdm.service
sudo systemctl start x11vnc@tch.service

mkdir /home/tch/apps/tcs_ui/tcs_ui_pipe
sudo chmod -R 777 /home/tch/apps/tcs_ui/tcs_ui_pipe
sudo mkfifo /home/tch/apps/tcs_ui/tcs_ui_pipe/compipe

sudo apt install -y gnome-shell-extensions

sudo -u tch gnome-extensions install disable-gestures-2021verycrazydog.gmail.com.v4.shell-extension.zip

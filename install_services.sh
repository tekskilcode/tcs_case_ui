#!/bin/bash

sudo cp service_files/tcs_case_ui.service /etc/systemd/system/
sudo cp service_files/tcs_pipe.service /etc/systemd/system/
sudo cp service_files/tcs_web_ui.service /etc/systemd/system/

sudo systemctl enable tcs_case_ui.service 
sudo systemctl enable tcs_pipe.service
sudo systemctl enable tcs_web_ui.service 

sudo systemctl start tcs_case_ui.service 
sudo systemctl start tcs_pipe.service
sudo systemctl start tcs_web_ui.service 

mkdir tcs_ui_pipe
sudo mkfifo ./tcs_ui_pipe/compipe

sudo apt install gnome-shell-extensions

gnome-extensions install --force disable-gestures-2021verycrazydog.gmail.com.v4.shell-extension.zip

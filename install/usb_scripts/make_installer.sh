#!/bin/bash

# This expects the install.sh file in bootstrap/, which is not included in the repo (it contains many secret environment variables)

chmod +x bootstrap/install.sh
sudo apt install makeself
makeself bootstrap/ tkskl_setup.run "Installer" ./install.sh


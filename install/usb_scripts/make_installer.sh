#!/bin/bash

# This generates the install.sh file in the directory ./bootstrap
# The environment variables must be set becore calling this script.
# You may be asked for a password in order to install "makeself"

# GITHUB_USERNAME
# GITHUB_TOKEN
# VNC_PASSWD
# TAILSCALE_AUTHKEY

rm tkskl_setup.run
rm -f bootstrap/install.sh

tee ./bootstrap/install.sh <<EOT
#!/bin/bash

export GITHUB_USERNAME=$GITHUB_USERNAME
export GITHUB_TOKEN=$GITHUB_TOKEN
export VNC_PASSWD='$VNC_PASSWD'
export TAILSCALE_AUTHKEY=$TAILSCALE_AUTHKEY

if [[ $UID = 0 ]]; then
    echo "Do not run this script as root."
    exit 1
fi

echo "///Disable and remove unattended-upgrades///"

set +e
sudo systemctl stop unattended-upgrades
sudo apt-get -y purge unattended-upgrades

#sudo dpkg-reconfigure -plow unattended-upgrades
#sudo systemctl status unattended-upgrades.service
set -e

sudo apt update
sudo apt install -y curl

curl -s https://raw.githubusercontent.com/tekskilcode/tcs_case_ui/master/install/usb_scripts/tcs_ui_prereq.sh | bash
EOT

chmod +x bootstrap/install.sh
sudo apt install makeself
makeself bootstrap/ tkskl_setup.run "Installer" ./install.sh


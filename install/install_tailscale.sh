#!/bin/bash
echo "Installing Tailscale"
curl -fsSL https://tailscale.com/install.sh | sh

# https://tailscale.com/kb/1193/tailscale-ssh/
#sudo tailscale up --ssh
sudo tailscale up --ssh --accept-risk=lose-ssh --authkey $TAILSCALE_AUTHKEY

sudo systemctl enable --now tailscaled
sudo systemctl start tailscaled

printf "Done.\n\n"


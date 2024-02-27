#!/bin/bash
set +e
echo "Installing Tailscale"
curl -fsSL https://tailscale.com/install.sh | sh

# https://tailscale.com/kb/1193/tailscale-ssh/
#sudo tailscale up --ssh
sudo tailscale up --ssh --accept-risk=lose-ssh --authkey $TAILSCALE_AUTHKEY

sudo systemctl enable --now tailscaled
sudo systemctl start tailscaled

printf "Done. If any errors were displayed above, it's likely that the Tailscale Auth Key is invalid or expired.\n\n"

set -e

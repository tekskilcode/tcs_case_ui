echo "To check the status of the x11vnc services:"
echo "sudo journalctl -f -u x11vnc@gdm.service"
echo "sudo journalctl -f -u x11vnc@tch.service"

echo "To find the Tailscale IP:"
echo "tailscale ip"

printf "\nTailscale IP: %s\n" $(tailscale ip --4)
printf "\n"

printf "VNC address for the desktop: %s:5900\n" $(tailscale ip --4)
printf "VNC address for the login screen: %s:5910\n" $(tailscale ip --4)

printf "\n"

echo "When you initially SSH to this machine, you will get a prompt from Tailscale to login. This must be done before attempting to use mosh."

echo "Be sure to find this machine in the Tailscale control panel, click '...', and 'Disable Key Expiry'"

printf "\n"

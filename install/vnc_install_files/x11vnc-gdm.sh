#!/usr/bin/env bash
/usr/bin/x11vnc -auth /run/user/\$(id -u gdm)/gdm/Xauthority -rfbauth /etc/vncpasswd -rfbport 5910 -allow 100. -forever -loop -noxdamage -repeat -shared

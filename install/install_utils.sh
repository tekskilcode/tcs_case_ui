#!/bin/bash
sudo apt-get install -y mosh vim tmuxnet-tools python3-pip btop fonts-powerline

echo "Installing fzf for tch"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

echo "Installing powerline for tch"
pip install powerline-status

tee -a ~/.bashrc <<EOT
export PATH=\$PATH:\$HOME/.local/bin
export REPOSITORY_ROOT=\$(pip show powerline-status | grep Location | awk '{print \$2}')
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. \$REPOSITORY_ROOT/powerline/bindings/bash/powerline.sh
EOT

# wget https://github.com/powerline/fonts/raw/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf

echo "Creating tmux conf"
tee ~/.tmux.conf <<EOT
run-shell "powerline-daemon -q"
source \$REPOSITORY_ROOT/powerline/bindings/tmux/powerline.conf
set-option -g default-terminal "screen-256color"
set -g prefix C-a
set -g mouse on
EOT

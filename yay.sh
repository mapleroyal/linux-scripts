#!/bin/bash
set -e

echo "Installing yay"
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git
cd yay-git
makepkg -si --noconfirm

echo "Yay installed successfully."
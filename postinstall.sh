#!/bin/bash

set -e # exit on any error

echo "Enabling parallel downloads"
sudo sed -i '/^#Parallel/s/^#//' /etc/pacman.conf

echo "Installing spice-vdagent if not already installed"
if ! pacman -Qs spice-vdagent > /dev/null; then
sudo pacman -S spice-vdagent --noconfirm
fi

echo "Installing yay"
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git
cd yay-git
makepkg -si --noconfirm

echo "Updating the package database and upgrading the system"
yay -Syyu --noconfirm

echo "Script completed successfully"

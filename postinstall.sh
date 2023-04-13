#!/bin/bash

# exit on any error
set -e

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

echo "Removing subvol ID's from /etc/fstab"
sed -i 's/subvolid=[0-9]*,//g' /etc/fstab

# 1. Copy user1's home directory
echo "Copying user1's home directory..."
rsync -a --info=progress2 /home/user1 /user1

# 3. Comment out the line related to /home and @home in /etc/fstab
echo "Commenting out /home and @home in /etc/fstab..."
sudo sed -i '/^\s*[^#].*\s\/home\s.*@home/s/^/#/' /etc/fstab

echo "Script completed successfully"

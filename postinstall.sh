#!/bin/bash

# exit on any error
set -e

echo "Enabling parallel downloads"
sudo sed -i '/^#Parallel/s/^#//' /etc/pacman.conf

#!/bin/bash
echo "Checking if spice-vdagent and rsync are installed"

# Install packages if not already installed
packages_to_install=()
if ! pacman -Qs spice-vdagent > /dev/null; then
  packages_to_install+=("spice-vdagent")
else
  echo "spice-vdagent is already installed"
fi

if ! pacman -Qs rsync > /dev/null; then
  packages_to_install+=("rsync")
else
  echo "rsync is already installed"
fi

# If there are packages to install, install them
if [ "${#packages_to_install[@]}" -gt 0 ]; then
  echo "Installing packages: ${packages_to_install[*]}"
  sudo pacman -S "${packages_to_install[@]}" --noconfirm
else
  echo "All packages are already installed"
fi

echo "Removing subvol ID's from /etc/fstab"
sed -i 's/subvolid=[0-9]*,//g' /etc/fstab

echo "Copying user1's home directory..."
rsync -a --info=progress2 /home/user1 /user1

echo "Commenting out /home and @home in /etc/fstab..."
sudo sed -i '/^\s*[^#].*\s\/home\s.*@home/s/^/#/' /etc/fstab

echo "Script completed successfully"

#!/bin/bash
set -e

# 1. Copy user1's home directory
echo "Copying user1's home directory..."
cp -a /home/user1 /user1

# 2. Delete Btrfs subvolume with ID 257
echo "Deleting Btrfs subvolume with ID 257..."
sudo btrfs subvolume delete -i 257 /

# 3. Comment out the line related to /home and @home in /etc/fstab
echo "Commenting out /home and @home in /etc/fstab..."
sudo sed -i '/^\s*[^#].*\s\/home\s.*@home/s/^/#/' /etc/fstab

# 4. Move /user1 to /home/user1
echo "Moving /user1 to /home/user1..."
sudo mv /user1 /home/user1

# 5. Change ownership of /home/user1
echo "Changing ownership of /home/user1 to user1:user1..."
sudo chown user1:user1 /home/user1

# 6. Set permissions for /home/user1
echo "Setting permissions for /home/user1..."
sudo chmod 755 /home/user1

echo "Script completed successfully."


#!/bin/bash
set -e

# Steps 1 and 2 can be done as part of a post-install script, because a reboot is required one way or another before you can do step 4.

# 1. Copy user1's home directory
# echo "Copying user1's home directory..."
# rsync -a --info=progress2 /home/user1 /user1

# 3. Comment out the line related to /home and @home in /etc/fstab
# echo "Commenting out /home and @home in /etc/fstab..."
# sudo sed -i '/^\s*[^#].*\s\/home\s.*@home/s/^/#/' /etc/fstab

# 2. Delete Btrfs subvolume with ID 257
echo "Deleting Btrfs subvolume with ID 257..."
sudo btrfs subvolume delete -i 257 /

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

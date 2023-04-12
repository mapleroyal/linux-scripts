#!/bin/bash
set -e

# 1. Install packages
echo "Installing packages..."
sudo pacman -S snapper inotify-tools grub-btrfs snap-pac --noconfirm

# 2. Install btrfs-assistant
echo "Installing btrfs-assistant..."
yay -S btrfs-assistant --noconfirm

# 3. Add grub-btrfs-overlayfs to HOOKS in /etc/mkinitcpio.conf
echo "Adding grub-btrfs-overlayfs to HOOKS..."
sudo sed -i '/^HOOKS=/ s/\]/ grub-btrfs-overlayfs\]/' /etc/mkinitcpio.conf

# 4. Replace systemd with udev in HOOKS
echo "Replacing systemd with udev in HOOKS..."
sudo sed -i 's/\bsystemd\b/udev/' /etc/mkinitcpio.conf

# 5. Regenerate initramfs
echo "Regenerating initramfs..."
sudo mkinitcpio -P

# 6-7. Remove and unmount /.snapshots
echo "Unmounting and removing /.snapshots..."
sudo umount /.snapshots || true
sudo rm -rf /.snapshots

# 8. Create snapper config for root
echo "Creating snapper config for root..."
sudo snapper -c root create-config /

# 9. Delete /.snapshots subvolume
echo "Deleting /.snapshots subvolume..."
sudo btrfs subvolume delete /.snapshots

# 10-12. Create and set permissions for /.snapshots
echo "Creating and setting permissions for /.snapshots..."
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots

# 13. Add wheel to ALLOW_GROUPS in /etc/snapper/configs/root
echo "Adding wheel to ALLOW_GROUPS..."
sudo sed -i 's/ALLOW_GROUPS=""/ALLOW_GROUPS="wheel"/' /etc/snapper/configs/root

# 14. Set default subvolume
echo "Setting default subvolume..."
sudo btrfs subvol set-default 256 /

# 15-16. Enable and check grub-btrfsd
echo "Enabling and checking grub-btrfsd..."
sudo systemctl enable --now grub-btrfsd
sudo systemctl status grub-btrfsd

# 17. Update GRUB configuration
echo "Updating GRUB configuration..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

# 18-19. Enable snapper timers
echo "Enabling snapper timers..."
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# 20. Create first snapshot
echo "Creating first snapshot..."
sudo snapper -c root create --description "first snapshot"

echo "Script completed successfully."

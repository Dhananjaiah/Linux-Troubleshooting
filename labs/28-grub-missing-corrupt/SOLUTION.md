# Lab 28: GRUB Missing or Corrupt - Solution

## 🔍 Root Cause

GRUB issues occur when:
1. Bootloader overwritten
2. grub.cfg corrupted
3. Disk changes (new partitions)
4. OS upgrade issues

## 🔧 Fix

From live USB/rescue mode:
```bash
# Mount the root partition
mount /dev/sda1 /mnt

# Reinstall GRUB
grub-install --root-directory=/mnt /dev/sda

# Regenerate config
chroot /mnt
update-grub
exit
reboot
```

## 🛡️ Prevention

1. Keep rescue media available
2. Backup GRUB configuration
3. Test after disk changes

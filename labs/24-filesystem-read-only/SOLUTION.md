# Lab 24: Filesystem Read-Only - Solution

## 🔍 Root Cause

Filesystems become read-only when:
1. Disk errors detected
2. Filesystem corruption
3. Mount option errors
4. Hardware failures

## 🔧 Fix

```bash
# Check current mount status
mount | grep " / "

# Remount as read-write
sudo mount -o remount,rw /

# Check for errors (on unmounted filesystem)
sudo fsck /dev/sda1
```

## 🛡️ Prevention

1. Regular filesystem checks
2. Monitor disk health with SMART
3. Set up disk error monitoring
4. Regular backups

# Lab 23: New Disk Not Detected - Solution

## 🔍 Root Cause

The kernel hasn't scanned the bus to detect the newly attached disk. This is common when hot-adding disks to a running system.

## 🔧 Fix

```bash
# Rescan SCSI bus
for host in /sys/class/scsi_host/*/scan; do
    echo "- - -" > $host
done

# Check dmesg for detection
dmesg | tail

# Verify disk appears
lsblk
```

## 🛡️ Prevention

- Some systems auto-detect new disks
- Use monitoring to track available storage
- Document disk management procedures

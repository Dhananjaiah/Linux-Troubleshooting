# Lab 19: Emergency Mode Boot

## SOLUTION GUIDE

---

## 🔍 Root Cause

System enters emergency mode when it cannot mount filesystems listed in `/etc/fstab`. Common causes:
- Invalid UUID or device path
- Missing filesystem
- Disk failure
- Typo in fstab

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Identify the Problem

In emergency mode, check recent boot messages:
```bash
journalctl -xb | grep -i "mount\|fstab\|failed"
```

### Step 2: Check fstab

```bash
cat /etc/fstab
```

Look for:
- Entries pointing to non-existent devices
- Wrong UUIDs
- Typos

### Step 3: Fix fstab

```bash
# Remount root as read-write
mount -o remount,rw /

# Edit fstab
vi /etc/fstab

# Comment out problematic entry or fix it
```

### Step 4: Exit Emergency Mode

```bash
# Try to mount all
mount -a

# Or reboot
reboot
```

---

## 🛡️ Prevention

1. **Test fstab entries** before rebooting
2. **Use nofail option** for non-critical mounts
3. **Keep backups** of working fstab
4. **Use UUIDs** instead of device names

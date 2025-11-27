# Lab 11: Kernel Panic on Boot

## SOLUTION GUIDE

---

## 🔍 Root Cause

Common causes of kernel panic:
1. **Missing initramfs** - Kernel can't load initial filesystem
2. **Corrupt kernel module** - Essential driver fails to load
3. **Wrong root= parameter** - Kernel can't find root filesystem
4. **Hardware failure** - RAM, disk, or other hardware issues
5. **Driver incompatibility** - New kernel doesn't support hardware

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Boot into Recovery Mode

At GRUB menu:
1. Select "Advanced options for Ubuntu"
2. Select a kernel version with "(recovery mode)"
3. Select "root" for root shell

### Step 2: Check Boot Logs

```bash
journalctl -b -1 | grep -i "panic\|error\|fail"
```

### Step 3: Identify the Problem

Common patterns:
- `VFS: Unable to mount root fs` → initramfs issue or wrong root parameter
- `Kernel panic - not syncing` → Critical driver failure
- `Out of memory` → RAM exhausted during boot

### Step 4: Fix Based on Cause

**For initramfs issues:**
```bash
update-initramfs -u -k all
```

**For wrong root parameter:**
Edit `/etc/default/grub` and run `update-grub`

**For kernel module issues:**
Boot with previous kernel, blacklist problematic module

### Step 5: Boot Previous Kernel

At GRUB menu → Advanced options → Select older kernel

---

## 🛡️ Prevention

1. **Always keep at least 2 kernel versions** installed
2. **Test kernel updates** on non-production first
3. **Use stable kernels** in production
4. **Document kernel versions** that work with your hardware
5. **Have rescue boot media** ready

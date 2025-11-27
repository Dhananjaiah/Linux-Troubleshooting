# Lab 11: Kernel Panic on Boot

## 📖 Scenario / Story

After a routine system update, the server won't boot properly. It starts to boot but then shows a **kernel panic** message and hangs. The server is completely inaccessible.

This is a critical production server, and you need to get it back online quickly.

**Note**: This lab simulates the diagnostic process safely without actually causing a kernel panic.

**Your mission**: Learn to identify kernel panic causes and understand recovery procedures.

---

## 🎯 What You Will Learn

- Recognize kernel panic symptoms
- Use recovery/rescue mode
- Check boot logs with journalctl
- Identify problematic kernel modules
- Use GRUB to boot into previous kernels
- Understand initramfs issues

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- sudo access
- Understanding of boot process

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/11-kernel-panic-on-boot
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

**Note**: This lab simulates symptoms rather than causing actual kernel panics for safety.

---

## 🔴 Problem Symptoms

### Kernel Panic Screen
```
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]---
```

### System Hangs at Boot
- GRUB menu appears
- Kernel starts loading
- System freezes or shows panic message

---

## ✅ Tasks for You

1. **Review simulated kernel panic logs**
2. **Identify the cause** from boot logs
3. **Learn recovery options** (documented in lab)
4. **Understand how to boot** into a previous kernel
5. **Learn initramfs regeneration** commands

---

## 💡 Hints

<details>
<summary><b>Hint 1: Checking Boot Logs</b></summary>

```bash
# View previous boot logs
journalctl -b -1

# View specific boot
journalctl --list-boots
journalctl -b <boot-id>

# Check kernel messages
dmesg | tail -100
```
</details>

<details>
<summary><b>Hint 2: GRUB Recovery</b></summary>

At GRUB menu:
1. Press 'e' to edit boot entry
2. Select a previous kernel from "Advanced options"
3. Boot in recovery mode

```bash
# Regenerate GRUB config
sudo update-grub
```
</details>

<details>
<summary><b>Hint 3: Initramfs Regeneration</b></summary>

```bash
# Rebuild initramfs for current kernel
sudo update-initramfs -u

# Rebuild for specific kernel
sudo update-initramfs -u -k <version>

# Rebuild all
sudo update-initramfs -u -k all
```
</details>

---

## ✔️ Verification

```bash
./scripts/verify.sh
```

---

## 🧹 Cleanup

```bash
sudo ./scripts/cleanup.sh
```

---

## 🤔 Reflection Questions

1. What's the difference between a kernel panic and a system hang?
2. Why is it important to keep previous kernel versions installed?
3. How would you automate kernel panic detection and alerting?
4. What should you do before applying kernel updates in production?

---

**Previous Lab**: [10 - Disk I/O Slowness](../10-disk-io-slowness/)  
**Next Lab**: [12 - Password Change Not Working](../12-password-change-not-working/)

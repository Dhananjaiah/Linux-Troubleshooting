# Lab 19: Linux Server Booting into Emergency Mode

## 📖 Scenario / Story

After a power outage, your server boots but drops into **Emergency Mode** instead of starting normally. You see a message about filesystem errors or mounting failures.

**Your mission**: Understand why the system is in emergency mode and get it to boot normally.

---

## 🎯 What You Will Learn

- Understand emergency and rescue modes
- Read boot logs and error messages
- Fix `/etc/fstab` issues
- Perform filesystem checks
- Resume normal boot

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- Console/local access
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/19-emergency-mode-boot
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

**Note**: This simulates the issue without requiring actual reboot.

---

## 🔴 Problem Symptoms

- System boots to emergency mode prompt
- Message about failed mounts
- Prompt to enter root password or press Ctrl+D

---

## ✅ Tasks for You

1. **Review simulated emergency mode logs**
2. **Check `/etc/fstab`** for errors
3. **Identify the problematic entry**
4. **Fix the fstab** configuration
5. **Understand how to exit** emergency mode

---

## 💡 Hints

<details>
<summary><b>Hint 1: Common Causes</b></summary>

- Invalid entry in `/etc/fstab`
- Referenced device doesn't exist
- Filesystem corruption
- Wrong UUID
</details>

<details>
<summary><b>Hint 2: Fixing fstab</b></summary>

```bash
# Edit fstab
vi /etc/fstab

# Comment out problematic lines with #
# Or fix the UUID/path

# Remount root as read-write if needed
mount -o remount,rw /
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

**Previous Lab**: [18 - Crontab Not Running](../18-crontab-not-running/)  
**Next Lab**: [20 - Docker Containers Not Starting](../20-docker-containers-not-starting/)

# Lab 25: Kernel Logs Flooding Disk

## 📖 Scenario / Story

The disk is filling up rapidly. Upon investigation, you find that **kernel logs** are being written at an extremely high rate, consuming all available space.

**Your mission**: Stop the log flooding and prevent disk exhaustion.

---

## 🎯 What You Will Learn

- Check log growth rates
- Identify sources of excessive logging
- Configure log rotation and rate limiting
- Use `journalctl` to manage journal size

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/25-kernel-logs-flooding-disk
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ df -h /var
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       20G   19G    1G  95% /var

$ ls -lh /var/log/syslog
-rw-r--r-- 1 root root 15G  Jan 15 10:00 /var/log/syslog
```

---

## ✅ Tasks for You

1. Check which log files are growing
2. Identify the source of excessive logging
3. Stop the flood of messages
4. Clean up large log files
5. Configure log rotation

---

## 💡 Hints

<details>
<summary><b>Hint: Managing Logs</b></summary>

```bash
# Truncate a log file
sudo truncate -s 0 /var/log/syslog

# Vacuum journald
sudo journalctl --vacuum-size=100M

# Force log rotation
sudo logrotate -f /etc/logrotate.conf
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

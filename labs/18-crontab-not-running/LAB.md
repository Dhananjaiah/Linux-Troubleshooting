# Lab 18: Crontab Jobs Not Running

## 📖 Scenario / Story

You set up a backup script to run every night at 2 AM via cron. It's been a week, and you just realized the backups **haven't been running at all**! The crontab looks correct, but the job never executes.

**Your mission**: Debug why cron jobs aren't running and fix it.

---

## 🎯 What You Will Learn

- Crontab syntax and common mistakes
- Check cron service status
- Read cron logs
- Debug cron environment differences
- Test cron jobs effectively

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/18-crontab-not-running
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ crontab -l
* * * * * /home/user/scripts/backup.sh    # Should run every minute

$ ls -la /var/log/backup/
# Nothing! No backup files created.
```

---

## ✅ Tasks for You

1. **Check if cron service is running**
2. **Review crontab syntax**
3. **Check cron logs** for errors
4. **Verify script permissions** and path
5. **Test script manually**
6. **Fix the issue** and verify cron runs

---

## 💡 Hints

<details>
<summary><b>Hint 1: Check Cron Service</b></summary>

```bash
sudo systemctl status cron

# View cron logs
grep CRON /var/log/syslog
```
</details>

<details>
<summary><b>Hint 2: Common Cron Issues</b></summary>

- Script not executable
- Script uses relative paths (cron has different PATH)
- Script requires environment variables not set in cron
- Syntax errors in crontab
</details>

<details>
<summary><b>Hint 3: Debug Cron Environment</b></summary>

```bash
# Add to crontab to see cron's environment
* * * * * env > /tmp/cron-env.txt
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

**Previous Lab**: [17 - High Load Low CPU](../17-high-load-low-cpu/)  
**Next Lab**: [19 - Emergency Mode Boot](../19-emergency-mode-boot/)

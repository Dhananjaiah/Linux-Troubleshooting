# Lab 18: Crontab Not Running

## SOLUTION GUIDE

---

## 🔍 Root Cause

Multiple issues can cause cron jobs to not run:
1. Cron service stopped
2. Script not executable
3. Wrong path in script (cron has minimal PATH)
4. Script permission issues
5. Syntax errors in crontab

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Cron Service

```bash
sudo systemctl status cron
```

If stopped: `sudo systemctl start cron`

### Step 2: Check Cron Logs

```bash
grep CRON /var/log/syslog | tail -20
```

Look for:
- "No MTA installed" warnings
- Permission denied errors
- Command not found

### Step 3: Check Script

```bash
# Is it executable?
ls -la /path/to/script.sh

# Fix if needed
chmod +x /path/to/script.sh
```

### Step 4: Test Script Environment

```bash
# Run as cron would
/bin/sh -c '/path/to/script.sh'

# Check script uses absolute paths
head -20 /path/to/script.sh
```

---

## 🛡️ Prevention

1. **Always use absolute paths** in cron scripts
2. **Test scripts** outside cron first
3. **Set up logging** in your cron scripts
4. **Monitor cron execution** with your monitoring system

# Lab 25: Kernel Logs Flooding Disk - Solution

## 🔍 Root Cause

A process is generating excessive log messages. Common causes:
1. Hardware errors generating kernel messages
2. Application in error loop
3. Debug logging left enabled
4. Attack causing audit/security logs

## 🔧 Fix

```bash
# Stop the logging flood (find and kill the source)
pkill -f "log-flood"

# Truncate large log files
sudo truncate -s 0 /var/log/syslog

# Vacuum journald
sudo journalctl --vacuum-size=100M
```

## 🛡️ Prevention

1. Configure log rotation with size limits
2. Set up disk space alerts
3. Use rate limiting in rsyslog
4. Configure journald size limits

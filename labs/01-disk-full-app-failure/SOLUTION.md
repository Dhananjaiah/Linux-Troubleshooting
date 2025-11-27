# Lab 01: Disk Full - Application Failure

## SOLUTION GUIDE (Trainer/Answer Key)

---

## 📋 Recap of the Scenario

An e-commerce application called "order-service" has crashed during a high-traffic event. The service cannot write to its log files because the disk is completely full. This is preventing the application from processing new orders.

---

## 🔍 Root Cause

The root cause is that the `/var` partition (or root partition `/`) has reached 100% capacity due to large application log files in `/var/log/order-service/`. The application's logging was not properly configured with rotation, causing log files to grow unbounded.

Specifically, the `break.sh` script created:
- Multiple 100MB+ log files in `/var/log/order-service/`
- Total consumed space: approximately 1GB

When the disk filled up:
1. The order-service tried to write to its log file
2. The write operation failed with "No space left on device"
3. The application crashed due to the unhandled error

---

## 🔬 Step-by-Step Troubleshooting Walkthrough

### Step 1: Check Disk Space Usage

First, let's see the overall disk usage:

```bash
df -h
```

**Expected Output:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G   19G  100M  99% /
tmpfs           2.0G     0  2.0G   0% /dev/shm
/dev/sda2       100G   50G   50G  50% /home
```

**Key observation**: The root filesystem (`/`) is at 99% capacity.

### Step 2: Identify What's Consuming Space

Check the `/var` directory, which typically holds logs:

```bash
sudo du -sh /var/*
```

**Expected Output:**
```
4.0K    /var/backups
152M    /var/cache
4.0K    /var/crash
4.0K    /var/lib
4.0K    /var/local
4.0K    /var/lock
1.1G    /var/log          <-- This is unusually large!
4.0K    /var/mail
4.0K    /var/opt
4.0K    /var/run
4.0K    /var/snap
4.0K    /var/spool
4.0K    /var/tmp
```

**Key observation**: `/var/log` is consuming over 1GB.

### Step 3: Drill Down Into /var/log

```bash
sudo du -sh /var/log/* | sort -h
```

**Expected Output:**
```
4.0K    /var/log/alternatives.log
4.0K    /var/log/bootstrap.log
16K     /var/log/apt
48K     /var/log/journal
124K    /var/log/syslog
1.1G    /var/log/order-service     <-- Here's the culprit!
```

### Step 4: Examine the Problematic Directory

```bash
ls -lah /var/log/order-service/
```

**Expected Output:**
```
total 1.1G
drwxr-xr-x 2 root root 4.0K Jan 15 02:15 .
drwxr-xr-x 9 root root 4.0K Jan 15 02:10 ..
-rw-r--r-- 1 root root 105M Jan 15 02:12 order-service-debug-1.log
-rw-r--r-- 1 root root 105M Jan 15 02:12 order-service-debug-2.log
-rw-r--r-- 1 root root 105M Jan 15 02:13 order-service-debug-3.log
-rw-r--r-- 1 root root 105M Jan 15 02:13 order-service-debug-4.log
-rw-r--r-- 1 root root 105M Jan 15 02:14 order-service-debug-5.log
-rw-r--r-- 1 root root 105M Jan 15 02:14 order-service-debug-6.log
-rw-r--r-- 1 root root 105M Jan 15 02:15 order-service-debug-7.log
-rw-r--r-- 1 root root 105M Jan 15 02:15 order-service-debug-8.log
-rw-r--r-- 1 root root 105M Jan 15 02:15 order-service-debug-9.log
-rw-r--r-- 1 root root 105M Jan 15 02:15 order-service-debug-10.log
-rw-r--r-- 1 root root 12K  Jan 15 02:15 order-service.log
```

**Key observation**: Multiple large debug log files are consuming all space.

### Step 5: Check for Deleted But Open Files (Optional)

Sometimes files are deleted but still held open by processes:

```bash
sudo lsof | grep deleted
```

In this lab, there shouldn't be any, but in real scenarios, this is important to check.

### Step 6: Check Service Status and Logs

```bash
sudo systemctl status order-service
```

**Expected Output:**
```
● order-service.service - Order Processing Service
     Loaded: loaded (/etc/systemd/system/order-service.service; enabled)
     Active: failed (Result: exit-code) since Mon 2024-01-15 02:15:33 UTC
```

```bash
sudo journalctl -u order-service --no-pager -n 20
```

This shows the service failed due to disk write errors.

---

## 🔧 Fix Steps

### Step 1: Remove the Large Log Files

The debug log files are not critical for recovery. Remove them:

```bash
sudo rm -f /var/log/order-service/order-service-debug-*.log
```

**Why this works**: These are old debug logs that are no longer needed. Removing them immediately frees up disk space.

### Step 2: Verify Disk Space is Freed

```bash
df -h /
```

**Expected Output:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G   5G   15G  25% /
```

The disk should now show significant free space.

### Step 3: Restart the Service

```bash
sudo systemctl restart order-service
```

### Step 4: Verify Service is Running

```bash
sudo systemctl status order-service
```

**Expected Output:**
```
● order-service.service - Order Processing Service
     Loaded: loaded (/etc/systemd/system/order-service.service; enabled)
     Active: active (running) since Mon 2024-01-15 02:25:00 UTC
   Main PID: 23456 (order-service.sh)
```

---

## ✔️ Verification

### Automated Verification

```bash
./scripts/verify.sh
```

### Manual Verification Commands

```bash
# 1. Check disk space is healthy (below 90%)
df -h / | awk 'NR==2 {print "Disk usage: " $5}'

# 2. Check service is running
systemctl is-active order-service

# 3. Test write capability
touch /tmp/write-test && rm /tmp/write-test && echo "Write OK"

# 4. Check service logs for errors
sudo journalctl -u order-service -n 5 --no-pager
```

**Expected Results:**
- Disk usage below 90%
- Service status: active
- Write test successful
- No recent errors in logs

---

## 🛡️ How to Prevent This in Production

### 1. Implement Log Rotation

Create `/etc/logrotate.d/order-service`:

```bash
/var/log/order-service/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 640 root root
    sharedscripts
    postrotate
        systemctl reload order-service > /dev/null 2>&1 || true
    endscript
}
```

### 2. Set Up Disk Space Monitoring

Example Prometheus alert rule:
```yaml
- alert: DiskSpaceLow
  expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 20
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Low disk space on {{ $labels.instance }}"
    description: "Disk space is below 20% (current: {{ $value }}%)"
```

### 3. Set Up Disk Space Alerts

Using simple monitoring script:
```bash
#!/bin/bash
THRESHOLD=80
USAGE=$(df / | awk 'NR==2 {print int($5)}')
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "WARNING: Disk usage is at ${USAGE}%" | mail -s "Disk Alert" admin@example.com
fi
```

### 4. Implement Application-Level Log Limits

Configure applications to:
- Limit individual log file sizes
- Automatically rotate logs
- Write to separate log partitions

### 5. Use Separate Partitions

Consider separate partitions for:
- `/var/log` - Log files
- `/var/lib` - Application data
- `/tmp` - Temporary files

This prevents one category from filling up the entire disk.

---

## 🔄 Extra Variations

### Variation 1: Deleted File Still Consuming Space

Modify the break script to:
1. Create a large file
2. Open it with a background process
3. Delete the file (but process keeps it open)

Students must find the process with `lsof | grep deleted` and either kill it or truncate the file.

### Variation 2: Hidden Files Filling Disk

Create files starting with `.` (dot files) that won't show up with regular `ls`:
```bash
dd if=/dev/zero of=/var/log/.hidden-log bs=100M count=10
```

Students must use `ls -la` or `du` to find them.

### Variation 3: Journal Logs Filling Disk

Fill up `/var/log/journal/` with systemd journal entries:
```bash
# Generate many log entries
for i in {1..100000}; do logger "Test log message $i"; done
```

Students must use `journalctl --disk-usage` and `journalctl --vacuum-size=100M`.

### Variation 4: Multiple Applications Affected

Create multiple services that all fail when disk is full:
- Web server (nginx/apache)
- Database (mysql)
- Custom application

Students must triage and fix in order of business priority.

---

## 📝 Instructor Notes

1. **Time to complete**: 15-30 minutes for beginners
2. **Common mistakes**:
   - Students may try to expand the disk instead of cleaning up
   - Some may delete wrong files
   - May forget to restart the service after cleanup
3. **Discussion points**:
   - Ask about their production experiences with disk issues
   - Discuss the importance of monitoring
   - Talk about capacity planning

---

## 🎓 Learning Outcomes

After this lab, students should be able to:
- [ ] Quickly check disk space with `df -h`
- [ ] Identify space-consuming directories with `du`
- [ ] Find large files with `find`
- [ ] Safely remove files to free space
- [ ] Restart failed services
- [ ] Explain how disk full affects applications
- [ ] Describe prevention strategies

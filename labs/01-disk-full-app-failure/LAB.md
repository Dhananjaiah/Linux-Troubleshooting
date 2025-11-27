# Lab 01: Disk Full - Application Failure

## 📖 Scenario / Story

It's 2 AM on Black Friday, and your e-commerce company's monitoring system sends you an urgent alert: **"Application 'order-service' is DOWN!"**

The on-call engineer quickly checks the dashboard and sees that the order processing service stopped accepting new orders about 30 minutes ago. Customers are complaining on social media, and the business is losing thousands of dollars per minute.

Your manager calls you in for emergency support. You SSH into the production server and need to quickly figure out why the application crashed and get it back online.

**Your mission**: Diagnose the issue, fix it, and restore the service as quickly as possible.

---

## 🎯 What You Will Learn

By completing this lab, you will learn how to:

- Check disk space usage with `df` and `du`
- Identify which directories/files are consuming space
- Find and safely remove large unnecessary files
- Understand how disk full conditions affect applications
- Use `journalctl` to analyze service logs
- Restart and verify services with `systemctl`

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server (VM recommended)
- Non-root user with sudo access
- Basic knowledge of file navigation (`cd`, `ls`, `cat`)
- Terminal access via SSH or console

---

## 🛠️ Lab Setup

### Step 1: Navigate to the Lab Directory

```bash
cd /path/to/Linux-Troubleshooting/labs/01-disk-full-app-failure
```

### Step 2: Make Scripts Executable (First Time Only)

```bash
chmod +x scripts/*.sh
```

### Step 3: Run the Break Script

**⚠️ WARNING**: Only run this on a test system, never on production!

```bash
sudo ./scripts/break.sh
```

You should see output similar to:
```
[BREAK] Starting disk full simulation for Lab 01...
[INFO] Creating simulated application directory...
[INFO] Creating large log files to fill disk space...
[INFO] File 1/10 created (100MB)
[INFO] File 2/10 created (100MB)
...
[INFO] Simulated application 'order-service' installed
[BREAK] Disk full condition created!
[INFO] The 'order-service' application is now failing.
========================================
YOUR TASK: Find out why the service is failing and fix it!
========================================
```

### Step 4: Confirm the Problem Exists

Run these commands to see the symptoms:

```bash
# Check the service status
sudo systemctl status order-service

# Try to create a test file
touch /tmp/test-write-file
```

---

## 🔴 Problem Symptoms (What You See)

When you investigate, you might observe:

### Service Status Shows Failed
```bash
$ sudo systemctl status order-service
● order-service.service - Order Processing Service
     Loaded: loaded (/etc/systemd/system/order-service.service; enabled)
     Active: failed (Result: exit-code) since Mon 2024-01-15 02:15:33 UTC
    Process: 12345 ExecStart=/usr/local/bin/order-service.sh (code=exited, status=1/FAILURE)
   Main PID: 12345 (code=exited, status=1/FAILURE)

Jan 15 02:15:33 server order-service.sh[12345]: ERROR: Cannot write to log file
Jan 15 02:15:33 server order-service.sh[12345]: ERROR: No space left on device
Jan 15 02:15:33 server systemd[1]: order-service.service: Main process exited, code=exited, status=1/FAILURE
```

### Creating New Files Fails
```bash
$ touch /tmp/test-write-file
touch: cannot touch '/tmp/test-write-file': No space left on device
```

### Application Logs Show Errors
```bash
$ sudo tail /var/log/order-service/order-service.log
2024-01-15 02:14:55 [INFO] Processing order #12345
2024-01-15 02:14:57 [INFO] Processing order #12346  
2024-01-15 02:15:01 [ERROR] Failed to write transaction log
2024-01-15 02:15:01 [ERROR] Disk full - cannot continue
2024-01-15 02:15:01 [FATAL] Service shutting down due to disk error
```

---

## ✅ Tasks for You

Complete these tasks to fix the issue:

1. **Check current disk usage**
   - Use appropriate commands to see how full the disk is
   - Identify which partition is affected

2. **Find what is consuming disk space**
   - Navigate through the filesystem
   - Identify directories with unusually large sizes
   - Pinpoint the specific files causing the issue

3. **Analyze the situation**
   - Determine if these are legitimate files or can be safely removed
   - Check if any processes are holding deleted files open

4. **Free up disk space**
   - Remove or truncate the problematic files
   - Ensure you have enough free space (at least 20% is recommended)

5. **Restart the affected service**
   - Restart the order-service
   - Verify it starts successfully

6. **Verify the fix**
   - Confirm disk space is available
   - Confirm the service is running and healthy
   - Test that new files can be created

---

## 💡 Hints (Click to Expand)

<details>
<summary><b>Hint 1: Checking Disk Space</b></summary>

The `df` command shows disk filesystem usage:
```bash
df -h          # Human-readable output
df -h /        # Check specific mount point
```

Look for partitions with high usage percentage (90%+).

</details>

<details>
<summary><b>Hint 2: Finding Large Directories</b></summary>

The `du` command shows disk usage by directory:
```bash
sudo du -sh /var/*      # Summarize /var subdirectories
sudo du -sh /var/log/*  # Drill down into /var/log
```

Sort by size to find the biggest consumers:
```bash
sudo du -sh /var/log/* | sort -h
```

</details>

<details>
<summary><b>Hint 3: Finding Large Files</b></summary>

Use `find` to locate files over a certain size:
```bash
sudo find /var -type f -size +50M   # Files over 50MB
sudo find / -type f -size +100M 2>/dev/null   # Files over 100MB (system-wide)
```

</details>

<details>
<summary><b>Hint 4: Checking for Deleted Open Files</b></summary>

Files that are deleted but still held open by processes:
```bash
sudo lsof | grep deleted
```

These files still consume disk space until the process releases them!

</details>

<details>
<summary><b>Hint 5: Safe Cleanup Commands</b></summary>

Remove files:
```bash
sudo rm /path/to/large/file.log
```

Truncate file (keeps the file but empties it):
```bash
sudo truncate -s 0 /path/to/file.log
```

</details>

---

## ✔️ Verification

Run the verification script to check if you've fixed the issue:

```bash
./scripts/verify.sh
```

**Expected successful output:**
```
[VERIFY] Checking Lab 01: Disk Full - Application Failure
========================================
[✓] Disk usage is below 90%: Currently at XX%
[✓] order-service is running
[✓] Service is responding correctly
[✓] Can write to filesystem
========================================
[SUCCESS] All checks passed! Lab 01 completed successfully.
```

### Manual Verification Commands

You can also verify manually:

```bash
# Check disk is not full
df -h /

# Check service is running
sudo systemctl status order-service

# Test file creation
touch /tmp/test-file && rm /tmp/test-file && echo "Write test: OK"
```

---

## 🧹 Cleanup

After completing the lab, restore your system to a clean state:

```bash
sudo ./scripts/cleanup.sh
```

**Expected output:**
```
[CLEANUP] Starting cleanup for Lab 01...
[INFO] Stopping order-service...
[INFO] Removing simulated log files...
[INFO] Removing simulated application...
[INFO] Cleaning up systemd unit...
[CLEANUP] Environment restored to clean state.
```

---

## 🤔 Reflection / Interview Questions

After completing this lab, think about these questions:

1. **Detection**: How would you detect this issue before it causes an outage?
   - What monitoring metrics would you track?
   - At what threshold would you set alerts?

2. **Prevention**: How would you prevent disk full issues in production?
   - Log rotation policies
   - Disk space monitoring
   - Quotas

3. **Root Cause**: Besides application logs, what else commonly fills up `/var` partitions?
   - System logs
   - Package cache
   - Temporary files
   - Database files

4. **Interview Scenario**: "You receive an alert that a server's disk is 95% full. Walk me through your troubleshooting process."

5. **Follow-up**: What's the difference between `rm` and `truncate` when dealing with files held open by processes?

---

## 📚 Additional Resources

- `man df` - Disk space usage
- `man du` - Directory space usage
- `man lsof` - List open files
- `man journalctl` - Query the systemd journal

---

**Next Lab**: [02 - SSH Login Failure](../02-ssh-login-failure/)

# Lab 04: High CPU Usage

## SOLUTION GUIDE

---

## 📋 Recap

The server is experiencing 100% CPU utilization due to a runaway process that's performing busy-wait operations.

---

## 🔍 Root Cause

A script is running in an infinite loop, consuming all available CPU resources. This simulates common scenarios like:
- Infinite loops in application code
- Crypto-mining malware
- Misconfigured backup jobs
- Runaway CI/CD processes

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check System Load

```bash
uptime
```

**Output:**
```
10:30:00 up 5 days, load average: 4.50, 3.20, 1.80
```

High load average (greater than number of CPU cores) indicates CPU contention.

### Step 2: Identify High CPU Process

```bash
top -bn1 | head -15
```

or sort by CPU:
```bash
ps aux --sort=-%cpu | head -5
```

**Output:**
```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root     12345 99.0  0.1  10000  1000 ?        R    10:00  10:23 /bin/bash /tmp/cpu-stress.sh
```

### Step 3: Investigate the Process

```bash
# See the command
cat /proc/12345/cmdline

# Check process tree
pstree -p 12345

# See open files
ls -la /proc/12345/fd
```

### Step 4: Terminate the Process

```bash
# Graceful termination first
kill 12345

# If still running, force kill
kill -9 12345
```

### Step 5: Verify CPU Usage Normalized

```bash
top -bn1 | head -5
uptime
```

Load average should start decreasing.

---

## 🛡️ Prevention

1. **Set resource limits** using `ulimit` or cgroups
2. **Monitor CPU usage** with alerting thresholds
3. **Use process supervision** (systemd, supervisord)
4. **Implement application timeouts**
5. **Regular security scans** for crypto-miners

---

## 🔄 Extra Variations

1. **Multiple processes**: Several processes each using 25% CPU
2. **Zombie process parent**: Parent died but children keep running
3. **Nice process**: Low-priority process still consuming resources
4. **System process**: kworker or other kernel thread consuming CPU

# Lab 17: High Load Low CPU

## SOLUTION GUIDE

---

## 🔍 Root Cause

High load average with low CPU usage typically indicates I/O-bound processes. Processes waiting for disk, network, or other I/O are in "D" (uninterruptible sleep) state and contribute to load average.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Analyze Load vs CPU

```bash
uptime  # High load
vmstat 1 5  # Look at 'id' (idle) and 'wa' (wait)
```

High idle, high I/O wait = I/O bottleneck.

### Step 2: Find D State Processes

```bash
ps aux | awk '$8 ~ /D/'
```

### Step 3: Identify the Blocker

Check what the D state processes are waiting for:
- Disk I/O (check `iostat`)
- NFS mount (hanging)
- Hardware issue

### Step 4: Resolve

Kill blocking processes or fix underlying I/O issue.

---

## 🛡️ Prevention

1. **Monitor I/O wait** separately from CPU
2. **Set up alerts** for high load with low CPU
3. **Use SSDs** for I/O-intensive workloads
4. **Monitor disk health**

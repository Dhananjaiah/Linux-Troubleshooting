# Lab 10: Disk I/O Slowness

## SOLUTION GUIDE

---

## 🔍 Root Cause

A process is performing continuous heavy disk read/write operations, saturating the disk I/O bandwidth. This causes high I/O wait and slow response for all processes needing disk access.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Confirm High I/O Wait

```bash
vmstat 1 5
```

**Output:**
```
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  3      0 500000 100000 800000    0    0 50000 10000  500 1000  5  2  3 90  0
```

The `wa` (I/O wait) is 90%, indicating severe disk bottleneck.

### Step 2: Identify I/O-Heavy Process

```bash
sudo iotop -o
```

**Output:**
```
Total DISK READ:  50.00 M/s | Total DISK WRITE: 10.00 M/s
  PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
12345 be/4  root     50.00 M/s   10.00 M/s  0.00 %  95.00 %  dd if=/dev/sda ...
```

### Step 3: Kill the I/O-Heavy Process

```bash
kill 12345
```

### Step 4: Verify I/O Normalized

```bash
vmstat 1 3
iostat -x 1 3
```

I/O wait should drop to normal levels (<10%).

---

## 🛡️ Prevention

1. **Use I/O priority** with `ionice` for batch jobs
2. **Implement I/O limits** with cgroups
3. **Monitor I/O metrics** and alert on high utilization
4. **Use SSDs** for I/O-intensive workloads
5. **Spread workloads** across multiple disks

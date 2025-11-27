# Lab 17: High Load Average Without High CPU Usage

## 📖 Scenario / Story

The server is sluggish. You check `top` and see a **load average of 8.0**, but CPU usage is only 10%! This doesn't make sense. If CPU isn't busy, why is load so high?

**Your mission**: Understand what's causing high load without high CPU and fix it.

---

## 🎯 What You Will Learn

- Understand Linux load average
- Differentiate between CPU-bound and I/O-bound load
- Identify processes in D state (uninterruptible sleep)
- Troubleshoot I/O bottlenecks
- Use `vmstat`, `iostat`, and process state analysis

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/17-high-load-low-cpu
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ uptime
 10:30:00 up 5 days, load average: 8.50, 7.20, 4.30

$ top
%Cpu(s):  5.0 us,  2.0 sy,  0.0 ni, 90.0 id,  3.0 wa  # LOW CPU!

$ ps aux | grep " D"
root     12345  0.0  0.0   1000   500 ?   D    10:00   0:00 [process]
```

---

## ✅ Tasks for You

1. **Check load average** with `uptime`
2. **Check CPU and I/O wait** with `vmstat`
3. **Find processes in D state** (uninterruptible sleep)
4. **Investigate what's blocking** those processes
5. **Resolve the blockage**
6. **Verify load returns to normal**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Understanding Load Average</b></summary>

Load average includes:
- Running processes (R state)
- Processes waiting for CPU
- **Processes in uninterruptible sleep (D state)** - often waiting for I/O

High load + low CPU = likely I/O or resource contention.
</details>

<details>
<summary><b>Hint 2: Finding D State Processes</b></summary>

```bash
# Find processes in D state
ps aux | awk '$8 ~ /D/ {print}'

# Or with top, press '1' for per-CPU, look at wa%
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

**Previous Lab**: [16 - NFS Mount Failure](../16-nfs-mount-failure/)  
**Next Lab**: [18 - Crontab Not Running](../18-crontab-not-running/)

# Lab 10: Disk I/O Slowness

## 📖 Scenario / Story

Database queries that normally take milliseconds are now taking seconds. The application is responding slowly, but CPU and memory look fine. When you check the system, you notice **high I/O wait** percentages.

Something is causing heavy disk activity, and it's affecting all applications on the server.

**Your mission**: Identify what's causing the disk I/O bottleneck and resolve it.

---

## 🎯 What You Will Learn

- Monitor disk I/O with `iostat`, `iotop`
- Understand I/O wait and what it means
- Identify processes causing high I/O
- Use `iotop` to find I/O-intensive processes
- Understand disk performance metrics

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- `sysstat` and `iotop` packages installed
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/10-disk-io-slowness
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ top
%Cpu(s):  5.0 us,  2.0 sy,  0.0 ni,  3.0 id, 90.0 wa, ...
                                           ^^^^^^
                                        HIGH I/O WAIT!

$ iostat -x 1
Device    r/s     w/s   rkB/s   wkB/s  await  %util
sda      500.00  100.00  50000   10000  250.0  99.9%
```

---

## ✅ Tasks for You

1. **Confirm high I/O wait** with `top` or `vmstat`
2. **Check disk I/O statistics** with `iostat`
3. **Identify I/O-intensive processes** with `iotop`
4. **Investigate the problematic process**
5. **Take appropriate action** to reduce I/O load
6. **Verify I/O performance** has improved

---

## 💡 Hints

<details>
<summary><b>Hint 1: Checking I/O Wait</b></summary>

```bash
# In top, look at the %wa column
top

# Or use vmstat
vmstat 1 5
# Look at the 'wa' column

# Or use iostat
iostat -x 1
```
</details>

<details>
<summary><b>Hint 2: Finding I/O-Heavy Processes</b></summary>

```bash
# iotop shows I/O by process
sudo iotop

# iotop in batch mode
sudo iotop -o -b -n 5
```
</details>

<details>
<summary><b>Hint 3: Process Investigation</b></summary>

```bash
# What is this process doing?
ps -p <PID> -o comm,args

# Check open files
lsof -p <PID>

# Check what files it's reading/writing
strace -p <PID> -e read,write
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

## 🤔 Reflection Questions

1. What's the difference between I/O wait and CPU usage?
2. How would you distinguish between a disk hardware issue and a software issue?
3. What strategies can reduce I/O on a busy server?
4. When should you consider adding SSD storage?

---

**Previous Lab**: [09 - Wrong System Time](../09-wrong-system-time/)  
**Next Lab**: [11 - Kernel Panic on Boot](../11-kernel-panic-on-boot/)

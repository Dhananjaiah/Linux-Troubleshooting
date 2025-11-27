# Lab 05: Server Running Out of Memory (OOM)

## 📖 Scenario / Story

Your monitoring system just fired a critical alert: **"Server memory usage at 98%!"** Shortly after, the application becomes unresponsive, and users report intermittent errors.

When you check the server, processes are being killed randomly by the system. The development team says they haven't deployed any new code, but memory usage has been climbing steadily over the past few hours.

**Your mission**: Identify the memory-hungry process, prevent the OOM killer from causing more damage, and restore system stability.

---

## 🎯 What You Will Learn

By completing this lab, you will learn how to:

- Monitor memory usage with `free`, `top`, and `vmstat`
- Identify memory-consuming processes
- Understand the Linux OOM (Out-of-Memory) Killer
- Check for memory leaks
- Analyze `/proc/meminfo` and memory statistics
- Take appropriate action to free memory

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- Non-root user with sudo access
- At least 2GB RAM recommended for this lab

---

## 🛠️ Lab Setup

### Step 1: Navigate to the Lab Directory

```bash
cd /path/to/Linux-Troubleshooting/labs/05-low-memory-oom
```

### Step 2: Make Scripts Executable

```bash
chmod +x scripts/*.sh
```

### Step 3: Run the Break Script

```bash
sudo ./scripts/break.sh
```

### Step 4: Confirm the Problem Exists

```bash
# Check memory usage
free -h

# Check for OOM events
dmesg | grep -i "oom\|killed"
```

---

## 🔴 Problem Symptoms (What You See)

### Low Available Memory
```bash
$ free -h
              total        used        free      shared  buff/cache   available
Mem:          3.8Gi       3.5Gi       100Mi        10Mi       200Mi       150Mi
Swap:         2.0Gi       1.8Gi       200Mi
```

### OOM Killer Messages in dmesg
```bash
$ dmesg | tail -20
[12345.678901] Out of memory: Killed process 5678 (memory-hog)
[12345.678902] oom_reaper: reaped process 5678 (memory-hog)
```

### Slow System Response
- Commands take a long time to execute
- SSH sessions feel laggy
- Swap usage is very high

---

## ✅ Tasks for You

1. **Check current memory usage** with `free -h`
2. **Identify memory-consuming processes** using `top` or `ps`
3. **Check for OOM killer activity** in system logs
4. **Investigate the memory-hungry process**
5. **Take action** to free memory (kill process, clear cache, etc.)
6. **Verify memory has been freed**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Finding Memory-Hungry Processes</b></summary>

```bash
# Sort by memory usage
ps aux --sort=-%mem | head -10

# In top, press 'M' to sort by memory
top

# Check specific process memory
pmap -x <PID>
```
</details>

<details>
<summary><b>Hint 2: Checking OOM Killer Logs</b></summary>

```bash
# Recent OOM events
dmesg | grep -i oom

# Journal logs
journalctl -k | grep -i "oom\|killed"
```
</details>

<details>
<summary><b>Hint 3: Understanding Memory Output</b></summary>

In `free -h`:
- **total**: Total installed memory
- **used**: Memory used by processes
- **free**: Completely unused memory
- **available**: Memory available for new processes (includes reclaimable cache)

Watch the **available** column, not **free**.
</details>

<details>
<summary><b>Hint 4: Emergency Memory Recovery</b></summary>

```bash
# Clear page cache (safe)
sync; echo 1 > /proc/sys/vm/drop_caches

# Clear dentries and inodes (safe)
sync; echo 2 > /proc/sys/vm/drop_caches

# Clear all caches (safe)
sync; echo 3 > /proc/sys/vm/drop_caches
```
</details>

---

## ✔️ Verification

```bash
./scripts/verify.sh
```

**Expected output:**
```
[✓] Memory usage is below 80%
[✓] No memory-hog processes running
[✓] Swap usage is acceptable
[SUCCESS] Lab completed!
```

---

## 🧹 Cleanup

```bash
sudo ./scripts/cleanup.sh
```

---

## 🤔 Reflection Questions

1. What is the OOM Killer and when does it activate?
2. How would you configure OOM Killer priorities (`oom_score_adj`)?
3. What's the difference between RSS (Resident Set Size) and VSZ (Virtual Size)?
4. How would you detect a memory leak in a long-running process?
5. When should you add more RAM vs. optimizing the application?

---

**Previous Lab**: [04 - High CPU Usage](../04-high-cpu-usage/)  
**Next Lab**: [06 - Database Too Many Connections](../06-db-too-many-connections/)

# Lab 04: High CPU Usage Slowing Down the Server

## 📖 Scenario / Story

Users are complaining that the application is extremely slow. Response times have gone from milliseconds to several seconds. When you check the server monitoring dashboard, you see **CPU usage at 100%** and it's not going down.

The operations team is getting alerts, but no one knows what process is consuming all the CPU. The application logs don't show anything unusual.

**Your mission**: Identify the runaway process causing high CPU usage and resolve the performance issue.

---

## 🎯 What You Will Learn

By completing this lab, you will learn how to:

- Monitor CPU usage with `top`, `htop`, and `ps`
- Identify processes consuming high CPU
- Use `nice` and `renice` to adjust process priorities
- Safely terminate runaway processes
- Analyze process resource consumption
- Understand load average and CPU states

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- Non-root user with sudo access
- Basic understanding of processes

---

## 🛠️ Lab Setup

### Step 1: Navigate to the Lab Directory

```bash
cd /path/to/Linux-Troubleshooting/labs/04-high-cpu-usage
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
# Check CPU usage
top -bn1 | head -20

# Check load average
uptime
```

---

## 🔴 Problem Symptoms (What You See)

### High Load Average
```bash
$ uptime
 10:30:00 up 5 days,  3:22,  1 user,  load average: 8.50, 7.20, 4.30
```

### Top Shows High CPU Process
```bash
$ top
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
12345 root      20   0   10000   1000    800 R  99.9   0.1   10:23.45 stress-process
```

### System Sluggishness
- Commands take longer to execute
- SSH connections feel delayed
- Applications timeout

---

## ✅ Tasks for You

1. **Check current CPU usage** with `top` or `htop`
2. **Identify the process** consuming the most CPU
3. **Investigate the process** - what is it? Is it legitimate?
4. **Decide on action** - kill, renice, or leave it?
5. **Resolve the high CPU usage**
6. **Verify system performance** has returned to normal

---

## 💡 Hints

<details>
<summary><b>Hint 1: Finding High CPU Processes</b></summary>

```bash
# Using top (press 'P' to sort by CPU)
top

# Using ps
ps aux --sort=-%cpu | head -10

# Using htop (more user-friendly)
htop
```
</details>

<details>
<summary><b>Hint 2: Process Investigation</b></summary>

```bash
# Get process details
ps -p <PID> -o pid,user,cmd,%cpu,%mem

# Check process files
ls -la /proc/<PID>/fd

# See what the process is doing
strace -p <PID>
```
</details>

<details>
<summary><b>Hint 3: Stopping Processes</b></summary>

```bash
# Graceful termination
kill <PID>

# Force kill
kill -9 <PID>

# Kill by name
pkill <process_name>
killall <process_name>
```
</details>

---

## ✔️ Verification

```bash
./scripts/verify.sh
```

**Expected output:**
```
[✓] CPU usage is below 80%
[✓] Load average is reasonable
[✓] No runaway processes detected
[SUCCESS] Lab completed!
```

---

## 🧹 Cleanup

```bash
sudo ./scripts/cleanup.sh
```

---

## 🤔 Reflection Questions

1. How would you distinguish between legitimate high CPU (e.g., compilation) and a runaway process?
2. What monitoring would you set up to detect CPU spikes early?
3. When would you use `renice` instead of `kill`?
4. What could cause high CPU on a server with no obvious runaway processes?

---

**Previous Lab**: [03 - Webserver Down](../03-webserver-down-apache-nginx/)  
**Next Lab**: [05 - Low Memory OOM](../05-low-memory-oom/)

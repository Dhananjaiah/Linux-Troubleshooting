# Lab 05: Server Running Out of Memory (OOM)

## SOLUTION GUIDE

---

## 📋 Recap

The server is running out of memory due to a process that's allocating large amounts of RAM. The OOM Killer may activate and start terminating processes.

---

## 🔍 Root Cause

A memory-hogging script is running that continuously allocates memory without releasing it. This simulates:
- Memory leak in applications
- Large data processing jobs
- Misconfigured Java heap sizes
- Cache buildup without limits

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Memory Status

```bash
free -h
```

**Output:**
```
              total        used        free      shared  buff/cache   available
Mem:          3.8Gi       3.5Gi       100Mi        10Mi       200Mi       150Mi
Swap:         2.0Gi       1.8Gi       200Mi
```

Key indicators:
- High "used" memory
- Low "available" memory
- High swap usage (system is swapping)

### Step 2: Identify Memory-Heavy Processes

```bash
ps aux --sort=-%mem | head -10
```

**Output:**
```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root     12345  5.0 85.0 3500000 3400000 ?     R    10:00   5:00 /tmp/memory-hog.sh
```

The `%MEM` and `RSS` columns show the culprit.

### Step 3: Check OOM Killer Activity

```bash
dmesg | grep -i oom | tail -10
```

```bash
journalctl -k | grep -i "killed process"
```

### Step 4: Investigate the Process

```bash
# What is this process?
cat /proc/12345/cmdline

# Memory map
pmap -x 12345 | tail -10

# Memory details
cat /proc/12345/status | grep -i mem
```

### Step 5: Kill the Memory Hog

```bash
kill 12345

# If it doesn't die
kill -9 12345
```

### Step 6: Verify Memory Freed

```bash
free -h
```

Available memory should increase significantly.

---

## 🛡️ Prevention

1. **Set memory limits** using cgroups or systemd limits:
   ```ini
   # In systemd service file
   [Service]
   MemoryMax=512M
   ```

2. **Configure OOM priorities**:
   ```bash
   # Make process more likely to be killed
   echo 500 > /proc/<PID>/oom_score_adj
   
   # Protect process from OOM (-1000 to 1000)
   echo -500 > /proc/<PID>/oom_score_adj
   ```

3. **Set up memory monitoring** with alerts at 80% and 90%

4. **Application-level limits**:
   - Java: `-Xmx512m`
   - Python: Resource limits
   - Container memory limits

---

## 🔄 Extra Variations

1. **Cache filling memory**: Page cache consuming all RAM
2. **Swap storm**: System thrashing due to excessive swapping
3. **Multiple small leaks**: Several processes each leaking a little
4. **Fork bomb**: Process creating many children

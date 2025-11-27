# Lab 26: Server Suddenly Becomes Unresponsive

## 📖 Scenario / Story

The server has become **unresponsive** - SSH connections are timing out, applications aren't responding. You manage to access the console and need to diagnose what's causing the system freeze.

**Your mission**: Identify and resolve the cause of system unresponsiveness.

---

## 🎯 What You Will Learn

- Diagnose system freezes
- Use SysRq keys for emergency access
- Identify resource exhaustion
- Check for runaway processes

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/26-server-suddenly-unresponsive
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## ✅ Tasks for You

1. Check system load and resource usage
2. Identify any runaway processes
3. Check for I/O blocks or memory exhaustion
4. Restore system responsiveness

---

## 💡 Hints

<details>
<summary><b>Hint: Emergency Commands</b></summary>

```bash
# Check what's consuming resources
top
vmstat 1
iostat -x 1

# SysRq magic (if available)
echo 1 > /proc/sys/kernel/sysrq
echo m > /proc/sysrq-trigger  # Memory info
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

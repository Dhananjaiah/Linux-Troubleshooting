# Lab 26: Server Suddenly Unresponsive - Solution

## 🔍 Root Cause

System unresponsiveness is typically caused by:
1. CPU exhaustion (runaway processes)
2. Memory exhaustion (OOM)
3. I/O saturation
4. Kernel panic or deadlock

## 🔧 Fix

Identify and kill the resource-hogging process:
```bash
# Find high CPU/memory processes
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head

# Kill the culprit
kill -9 <PID>
```

## 🛡️ Prevention

1. Set resource limits (cgroups, ulimits)
2. Monitor system resources with alerts
3. Enable and understand SysRq keys for emergencies

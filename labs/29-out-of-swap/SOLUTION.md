# Lab 29: Out of Swap - Solution

## 🔍 Root Cause

Swap exhaustion occurs when:
1. Memory-intensive processes
2. Memory leaks
3. Insufficient RAM for workload
4. Too small swap partition

## 🔧 Fix

```bash
# Find memory hogs
ps aux --sort=-%mem | head

# Kill problematic process
kill <PID>

# Clear and restore swap
sudo swapoff -a
sudo swapon -a

# Or add temporary swap
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

## 🛡️ Prevention

1. Monitor memory and swap usage
2. Right-size RAM for workload
3. Fix memory leaks in applications
4. Configure OOM score adjustments

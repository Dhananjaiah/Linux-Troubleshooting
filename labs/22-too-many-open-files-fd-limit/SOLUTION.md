# Lab 22: Too Many Open Files - Solution

## 🔍 Root Cause

A process is holding open many file descriptors, approaching or exceeding system limits.

## 🔧 Fix

```bash
# Find the process with most open files
lsof | awk '{print $2}' | sort | uniq -c | sort -rn | head

# Kill the offending process
kill <PID>

# Or increase limits (temporary)
ulimit -n 65535
```

## 🛡️ Prevention

1. Configure appropriate limits in `/etc/security/limits.conf`
2. Monitor file descriptor usage
3. Fix application leaks

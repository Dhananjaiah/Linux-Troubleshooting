# Lab 31: Hidden or Orphaned Files Filling Disk - Solution

## 🔍 Root Cause

When a file is deleted while a process has it open, the directory entry is removed but the file's disk space isn't freed until the process closes the file handle.

## 🔧 Fix

```bash
# Find deleted open files
lsof | grep deleted
lsof +L1

# Option 1: Restart the process holding the file
systemctl restart <service>

# Option 2: Truncate the file (keeps process running)
: > /proc/<PID>/fd/<FD>

# Option 3: Kill the process
kill <PID>
```

## 🛡️ Prevention

1. Always restart services after deleting their log files
2. Use `truncate` instead of `rm` for log rotation
3. Configure proper log rotation
4. Monitor for deleted but open files

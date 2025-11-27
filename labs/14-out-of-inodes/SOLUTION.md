# Lab 14: Out of Inodes

## SOLUTION GUIDE

---

## 🔍 Root Cause

The filesystem has run out of **inodes** (index nodes). Each file, directory, and link consumes one inode. Even with free disk space, if all inodes are used, no new files can be created.

This typically happens when:
- Millions of small files are created (session files, cache, mail queue)
- Build processes create many temporary files
- Applications don't clean up old files

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Confirm Disk Space Available

```bash
df -h
```

Shows plenty of free space.

### Step 2: Check Inode Usage

```bash
df -i
```

**Output:**
```
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
/dev/sda1      1000000 1000000      0  100% /
```

Inodes are 100% used!

### Step 3: Find Inode-Heavy Directories

```bash
# Count files per directory
for d in /tmp /var /home; do
    echo "$(find $d -type f 2>/dev/null | wc -l) $d"
done | sort -rn
```

### Step 4: Identify and Remove Files

```bash
# Find the specific directory
ls -la /tmp/inode-test/  # Will show many files

# Remove them
rm -rf /tmp/inode-test/
```

### Step 5: Verify Inodes Freed

```bash
df -i
touch /tmp/test-file && rm /tmp/test-file
```

---

## 🛡️ Prevention

1. **Monitor inode usage** alongside disk space
2. **Set up log rotation** with file count limits
3. **Clean temp directories** regularly (tmpwatch, systemd-tmpfiles)
4. **Set application limits** on cache file counts

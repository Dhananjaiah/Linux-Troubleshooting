# Lab 14: Server Running Out of Inodes

## 📖 Scenario / Story

Your application is throwing "No space left on device" errors, but when you check disk space with `df -h`, there's **plenty of free space**! How can the disk be full when it's not full?

This is a classic puzzle that trips up many admins. Something is consuming a resource other than disk space.

**Your mission**: Figure out what's really exhausted and fix it.

---

## 🎯 What You Will Learn

- Understand inodes and what they are
- Check inode usage with `df -i`
- Find directories with too many files
- Clean up excess files safely
- Understand the difference between disk space and inodes

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/14-out-of-inodes
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ touch /tmp/newfile
touch: cannot touch '/tmp/newfile': No space left on device

$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G   5G   15G  25% /        # PLENTY OF SPACE!

# But wait...
$ df -i
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
/dev/sda1      1000000 1000000      0  100% /   # INODES EXHAUSTED!
```

---

## ✅ Tasks for You

1. **Confirm disk space is available** with `df -h`
2. **Check inode usage** with `df -i`
3. **Find directories with many small files**
4. **Identify the source** of excess files
5. **Clean up** to free inodes
6. **Verify** files can be created again

---

## 💡 Hints

<details>
<summary><b>Hint 1: Understanding Inodes</b></summary>

Every file and directory uses one inode. You can have free disk space but no free inodes if you have millions of tiny files.

```bash
# Check inode usage
df -i

# Count files in a directory
find /path -type f | wc -l
```
</details>

<details>
<summary><b>Hint 2: Finding Inode-Heavy Directories</b></summary>

```bash
# Find directories with most files
find / -xdev -type d -exec sh -c 'echo "$(find "$1" -maxdepth 1 | wc -l) $1"' _ {} \; 2>/dev/null | sort -rn | head -20

# Or simpler approach
for dir in /var /tmp /home; do
    echo "$(find $dir -type f 2>/dev/null | wc -l) $dir"
done
```
</details>

<details>
<summary><b>Hint 3: Common Culprits</b></summary>

- Session files in `/tmp`
- Mail queue files
- Log rotation creating many files
- Application cache directories
- PHP session files
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

1. What types of applications tend to create millions of small files?
2. How would you monitor inode usage proactively?
3. What's the relationship between filesystem type and inode limits?
4. How would you prevent this issue in a web application?

---

**Previous Lab**: [13 - DNS Resolution Failing](../13-dns-resolution-failing/)  
**Next Lab**: [15 - SSH Key Auth Not Working](../15-ssh-key-auth-not-working/)

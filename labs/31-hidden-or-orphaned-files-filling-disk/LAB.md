# Lab 31: Hidden or Orphaned Files Filling Disk

## 📖 Scenario / Story

You deleted large files to free disk space, but `df -h` still shows the disk as full! The space wasn't freed. This is a classic "deleted but open files" problem.

**Your mission**: Find and release the orphaned files to truly free the disk space.

---

## 🎯 What You Will Learn

- Understand how file deletion works in Linux
- Find deleted files still held open
- Use `lsof` to find orphaned files
- Release disk space properly

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/31-hidden-or-orphaned-files-filling-disk
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ rm /var/log/huge-file.log
$ df -h /var
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       20G   19G    1G  95% /var
# Space not freed!
```

---

## ✅ Tasks for You

1. Check for deleted but open files with `lsof`
2. Identify which process is holding the file
3. Release the file handle (restart process or truncate)
4. Verify space is freed

---

## 💡 Hints

<details>
<summary><b>Hint: Find Deleted Open Files</b></summary>

```bash
# Find deleted but still open files
lsof | grep deleted

# See size of deleted files
lsof +L1

# Truncate a deleted file (if you know the fd)
# : > /proc/<PID>/fd/<FD>
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

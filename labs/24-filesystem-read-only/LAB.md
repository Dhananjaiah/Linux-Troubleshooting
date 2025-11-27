# Lab 24: Filesystem Mounted as Read-Only

## 📖 Scenario / Story

Users report they can't create or modify files. You discover the filesystem has been **remounted as read-only**. This usually indicates a disk error or filesystem corruption.

**Your mission**: Identify why the filesystem is read-only and restore write access.

---

## 🎯 What You Will Learn

- Identify read-only filesystems
- Check for filesystem errors
- Remount filesystems with write access
- Use `fsck` for filesystem repair

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/24-filesystem-read-only
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ touch /test-file
touch: cannot touch '/test-file': Read-only file system

$ mount | grep " / "
/dev/sda1 on / type ext4 (ro,relatime)  # Notice: ro = read-only
```

---

## ✅ Tasks for You

1. Identify read-only filesystems with `mount`
2. Check dmesg for disk/filesystem errors
3. Remount the filesystem as read-write
4. Check for underlying issues (disk errors)

---

## 💡 Hints

<details>
<summary><b>Hint: Remount as Read-Write</b></summary>

```bash
# Remount root as read-write
sudo mount -o remount,rw /

# Check filesystem
sudo fsck -n /dev/sda1
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

# Lab 22: System Running Out of File Descriptors

## 📖 Scenario / Story

Applications are failing with **"Too many open files"** errors. Processes can't open new files, create sockets, or accept connections.

**Your mission**: Find what's consuming file descriptors and restore system functionality.

---

## 🎯 What You Will Learn

- Understand file descriptor limits
- Check system and per-process limits
- Use `lsof` to find open files
- Adjust ulimits and system limits
- Monitor file descriptor usage

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/22-too-many-open-files-fd-limit
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ cat /some/file
cat: /some/file: Too many open files

$ curl http://localhost
curl: (7) Couldn't connect to server
```

---

## ✅ Tasks for You

1. Check current open file count system-wide
2. Find processes with most open files
3. Check ulimit settings
4. Identify the culprit process
5. Fix the issue (kill process or raise limits)

---

## 💡 Hints

<details>
<summary><b>Hint 1: Check Open Files</b></summary>

```bash
# Count system-wide open files
cat /proc/sys/fs/file-nr

# Find top file descriptor users
lsof | awk '{print $2}' | sort | uniq -c | sort -rn | head
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

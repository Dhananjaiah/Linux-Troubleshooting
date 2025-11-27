# Lab 29: Out of Swap Space

## 📖 Scenario / Story

The server is experiencing severe **sluggishness** and applications are being killed randomly. Investigation shows swap space is **100% utilized** and the OOM killer is activating.

**Your mission**: Resolve the swap exhaustion and restore system stability.

---

## 🎯 What You Will Learn

- Monitor swap usage
- Understand swap behavior
- Clear swap safely
- Add temporary swap space
- Tune swappiness

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/29-out-of-swap
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## ✅ Tasks for You

1. Check swap usage with `free -h`
2. Identify memory-hungry processes
3. Kill or restart problematic processes
4. Clear swap if needed
5. Consider adding temporary swap

---

## 💡 Hints

<details>
<summary><b>Hint: Swap Management</b></summary>

```bash
# Check swap usage
free -h
swapon --show

# Clear swap (moves data to RAM first!)
sudo swapoff -a && sudo swapon -a

# Add temporary swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
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

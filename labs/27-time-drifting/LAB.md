# Lab 27: Server's Time Keeps Drifting

## 📖 Scenario / Story

The server's clock keeps **drifting** from the correct time. This causes certificate validation failures, log correlation problems, and authentication issues.

**Your mission**: Fix the time drift and ensure the clock stays synchronized.

---

## 🎯 What You Will Learn

- Understand NTP and time synchronization
- Use `chronyc` or `ntpq` for diagnostics
- Configure time sources
- Monitor time accuracy

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/27-time-drifting
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## ✅ Tasks for You

1. Check current time offset
2. Verify NTP configuration
3. Force time synchronization
4. Ensure time stays synchronized

---

## 💡 Hints

<details>
<summary><b>Hint: Chrony Commands</b></summary>

```bash
# Check time sources
chronyc sources

# Check tracking
chronyc tracking

# Force sync
chronyc makestep
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

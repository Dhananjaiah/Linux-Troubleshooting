# Lab 23: System Fails to Recognize a Newly Attached Disk

## 📖 Scenario / Story

You've attached a new disk to the server, but it's **not showing up** in `lsblk` or `fdisk -l`. The disk is physically connected but the system doesn't see it.

**Your mission**: Make the system recognize the new disk.

---

## 🎯 What You Will Learn

- Understand how Linux detects disks
- Use `lsblk`, `fdisk`, `blkid`
- Rescan SCSI bus
- Check dmesg for hardware detection

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/23-new-disk-not-detected
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

Note: This lab simulates the scenario for learning purposes.

---

## 🔴 Problem Symptoms

```bash
$ lsblk
NAME   MAJ:MIN SIZE TYPE MOUNTPOINT
sda      8:0   20G disk 
├─sda1   8:1   19G part /
└─sda2   8:2    1G part [SWAP]
# No sdb! Where's the new disk?
```

---

## ✅ Tasks for You

1. Check `dmesg` for disk detection messages
2. Rescan SCSI bus to detect new disks
3. Verify disk appears in `lsblk`
4. Optionally partition and mount the new disk

---

## 💡 Hints

<details>
<summary><b>Hint: Rescan SCSI Bus</b></summary>

```bash
# Rescan all SCSI hosts
for host in /sys/class/scsi_host/*/scan; do
    echo "- - -" > $host
done

# Or specific host
echo "- - -" > /sys/class/scsi_host/host0/scan
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

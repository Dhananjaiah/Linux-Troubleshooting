# Lab 28: GRUB Missing or Corrupt

## 📖 Scenario / Story

The server fails to boot, showing **"GRUB rescue"** prompt or boot errors. Something has corrupted the bootloader configuration.

**Note**: This lab provides education on GRUB recovery without actually breaking boot.

---

## 🎯 What You Will Learn

- Understand GRUB bootloader
- Boot into rescue mode
- Reinstall and configure GRUB
- Update GRUB configuration

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/28-grub-missing-corrupt
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## ✅ Tasks for You

1. Review GRUB configuration
2. Learn recovery commands
3. Understand `update-grub` and `grub-install`

---

## 💡 Hints

<details>
<summary><b>Hint: GRUB Recovery Commands</b></summary>

```bash
# Update GRUB config
sudo update-grub

# Reinstall GRUB (to MBR of /dev/sda)
sudo grub-install /dev/sda

# From rescue prompt
set prefix=(hd0,1)/boot/grub
set root=(hd0,1)
insmod normal
normal
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

# Lab 09: Server Time is Incorrect

## 📖 Scenario / Story

Your security team reports that SSL certificates are failing validation on a server. When you investigate, you notice the **server time is several hours off**. This is causing:
- SSL/TLS handshake failures
- Authentication token expiration issues
- Log timestamps that don't match other servers
- Cron jobs running at wrong times

**Your mission**: Correct the server time and ensure it stays synchronized.

---

## 🎯 What You Will Learn

- Check system time with `date` and `timedatectl`
- Configure NTP synchronization
- Use `chronyd` or `ntpd` for time sync
- Set the correct timezone
- Understand time drift and its impact

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- Internet access (for NTP servers)
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/09-wrong-system-time
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ date
Wed Jan 15 05:30:00 UTC 2024   # But actual time is 14:30:00!

$ timedatectl status
       Local time: Wed 2024-01-15 05:30:00 UTC
   Universal time: Wed 2024-01-15 05:30:00 UTC
         RTC time: Wed 2024-01-15 05:30:00
        Time zone: UTC (UTC, +0000)
     NTP enabled: no
```

Applications reporting certificate errors, token expiration, etc.

---

## ✅ Tasks for You

1. **Check current system time** and compare to actual time
2. **Check timezone configuration**
3. **Check NTP synchronization status**
4. **Enable and configure NTP**
5. **Force time synchronization**
6. **Verify time is correct**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Checking Time</b></summary>

```bash
# Current system time
date

# Detailed time status
timedatectl status

# Check if NTP is synchronized
timedatectl show --property=NTPSynchronized
```
</details>

<details>
<summary><b>Hint 2: Enabling NTP</b></summary>

```bash
# Enable NTP synchronization
sudo timedatectl set-ntp true

# Or with chrony
sudo systemctl start chronyd
sudo chronyc makestep
```
</details>

<details>
<summary><b>Hint 3: Manual Time Set</b></summary>

```bash
# Set time manually (if NTP unavailable)
sudo timedatectl set-time "2024-01-15 14:30:00"

# Set timezone
sudo timedatectl set-timezone America/New_York
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

---

## 🤔 Reflection Questions

1. Why is accurate time so critical for security (SSL, Kerberos, etc.)?
2. What happens if two servers in a cluster have different times?
3. How would you detect time drift before it causes problems?
4. What's the difference between NTP and chrony?

---

**Previous Lab**: [08 - Permission Denied Even as Root](../08-permission-denied-even-root/)  
**Next Lab**: [10 - Disk I/O Slowness](../10-disk-io-slowness/)

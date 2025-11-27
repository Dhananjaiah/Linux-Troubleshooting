# Lab 09: Wrong System Time

## SOLUTION GUIDE

---

## 🔍 Root Cause

NTP synchronization was disabled and the system time was manually set to an incorrect value. Without NTP, the system clock drifts and becomes inaccurate over time.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Current Time Status

```bash
timedatectl status
```

**Output:**
```
       Local time: Wed 2024-01-15 05:30:00 UTC
         NTP service: inactive
         NTP synchronized: no
```

Key issues:
- Time doesn't match actual time
- NTP service is inactive
- NTP synchronized is "no"

### Step 2: Enable NTP Synchronization

```bash
sudo timedatectl set-ntp true
```

### Step 3: Force Immediate Sync (if using chrony)

```bash
sudo chronyc makestep
```

Or restart the timesync service:
```bash
sudo systemctl restart systemd-timesyncd
```

### Step 4: Verify Time is Now Correct

```bash
date
timedatectl status
```

Time should now be accurate and NTP synchronized should be "yes".

---

## 🛡️ Prevention

1. **Always enable NTP** on production servers
2. **Monitor time offset** with alerting (>1 second drift)
3. **Use internal NTP servers** for isolated networks
4. **Configure NTP at provisioning** time

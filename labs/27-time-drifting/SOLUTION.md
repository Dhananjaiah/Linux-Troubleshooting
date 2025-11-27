# Lab 27: Time Drifting - Solution

## 🔍 Root Cause

Time drift occurs when NTP is disabled or misconfigured, causing the system clock to gradually deviate from correct time.

## 🔧 Fix

```bash
# Enable NTP
sudo timedatectl set-ntp true

# Or with chrony
sudo systemctl start chronyd
sudo chronyc makestep

# Verify sync
timedatectl status
```

## 🛡️ Prevention

1. Always enable NTP
2. Monitor time offset
3. Use reliable NTP servers
4. Set up alerts for time drift

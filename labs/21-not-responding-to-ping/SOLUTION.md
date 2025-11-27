# Lab 21: Not Responding to Ping - Solution

## 🔍 Root Cause

ICMP echo requests are being ignored because the kernel parameter `icmp_echo_ignore_all` is set to 1.

## 🔧 Fix

```bash
# Enable ICMP responses
sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0

# Or
echo 0 | sudo tee /proc/sys/net/ipv4/icmp_echo_ignore_all
```

## 🛡️ Prevention

Make persistent in `/etc/sysctl.conf`:
```
net.ipv4.icmp_echo_ignore_all = 0
```

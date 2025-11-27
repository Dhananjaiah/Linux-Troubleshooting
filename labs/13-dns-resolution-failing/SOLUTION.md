# Lab 13: DNS Resolution Failing

## SOLUTION GUIDE

---

## 🔍 Root Cause

The DNS configuration in `/etc/resolv.conf` was corrupted or had invalid nameservers. Without valid DNS servers, the system cannot translate hostnames to IP addresses.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Confirm DNS Is the Issue

```bash
# This fails
ping google.com

# This works (IP address)
ping 8.8.8.8
```

Network connectivity is fine; only name resolution is broken.

### Step 2: Check DNS Configuration

```bash
cat /etc/resolv.conf
```

**Output (broken):**
```
# Empty or invalid content
nameserver 127.0.0.53  # Points to local resolver which may be broken
```

### Step 3: Test DNS Directly

```bash
# Test with specific DNS server
dig @8.8.8.8 google.com
```

If this works, the problem is local DNS config.

### Step 4: Fix DNS Configuration

```bash
# Quick fix
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Or restore systemd-resolved
sudo systemctl restart systemd-resolved
```

### Step 5: Verify Fix

```bash
dig google.com
ping google.com
```

---

## 🛡️ Prevention

1. **Use DHCP** to automatically configure DNS
2. **Configure multiple DNS servers** for redundancy
3. **Monitor DNS resolution** as part of health checks
4. **Use local caching DNS** for performance

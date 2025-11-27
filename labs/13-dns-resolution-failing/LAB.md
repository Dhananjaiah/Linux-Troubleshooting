# Lab 13: DNS Resolution Failing

## 📖 Scenario / Story

Users report that they can ping IP addresses but **can't access websites by name**. When you try to access google.com, it fails, but `ping 8.8.8.8` works fine.

Applications are failing to connect to databases and APIs because they use hostnames, not IP addresses.

**Your mission**: Fix DNS resolution so hostnames resolve correctly.

---

## 🎯 What You Will Learn

- Check DNS configuration in `/etc/resolv.conf`
- Use `dig`, `nslookup`, and `host` for DNS testing
- Understand systemd-resolved
- Configure DNS servers
- Troubleshoot common DNS issues

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- sudo access
- dnsutils package (`sudo apt install dnsutils`)

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/13-dns-resolution-failing
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ ping google.com
ping: google.com: Temporary failure in name resolution

$ curl https://google.com
curl: (6) Could not resolve host: google.com

$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=10.1 ms
# ^^^ This works! Network is fine, only DNS is broken
```

---

## ✅ Tasks for You

1. **Confirm DNS is the problem** (IP works, hostname fails)
2. **Check `/etc/resolv.conf`**
3. **Check systemd-resolved status**
4. **Fix DNS configuration**
5. **Verify hostnames resolve**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Testing DNS</b></summary>

```bash
# Test resolution
dig google.com
nslookup google.com
host google.com

# Test specific DNS server
dig @8.8.8.8 google.com
```
</details>

<details>
<summary><b>Hint 2: Check DNS Config</b></summary>

```bash
# View DNS configuration
cat /etc/resolv.conf

# Check systemd-resolved
resolvectl status
systemctl status systemd-resolved
```
</details>

<details>
<summary><b>Hint 3: Fix DNS</b></summary>

```bash
# Quick fix - set Google DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# Or restart resolved
sudo systemctl restart systemd-resolved
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

1. Why might `/etc/resolv.conf` get corrupted or emptied?
2. What's the relationship between systemd-resolved and `/etc/resolv.conf`?
3. How would you set up redundant DNS servers?
4. What tools would you use to debug DNS issues in production?

---

**Previous Lab**: [12 - Password Change Not Working](../12-password-change-not-working/)  
**Next Lab**: [14 - Out of Inodes](../14-out-of-inodes/)

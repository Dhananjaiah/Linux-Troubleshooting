# Lab 21: Server Not Responding to Pings

## 📖 Scenario / Story

You can't ping a server from your network. The server appears to be up (you can access it via console), but it's **invisible to the network**. Other services on the same network can't reach it either.

**Your mission**: Figure out why the server isn't responding to network requests.

---

## 🎯 What You Will Learn

- Troubleshoot network connectivity
- Check firewall rules (iptables, ufw)
- Verify network interface configuration
- Understand ICMP blocking
- Debug routing issues

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/21-not-responding-to-ping
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
# From another host:
$ ping server-ip
PING 192.168.1.100: No response

# On the server:
$ ping localhost
PING localhost: 64 bytes from 127.0.0.1   # Works locally!
```

---

## ✅ Tasks for You

1. Check if ICMP is blocked by firewall
2. Verify network interface is up
3. Check routing table
4. Verify kernel parameters for ICMP
5. Fix the issue and verify connectivity

---

## 💡 Hints

<details>
<summary><b>Hint 1: Check Firewall</b></summary>

```bash
sudo iptables -L -n
sudo ufw status
```
</details>

<details>
<summary><b>Hint 2: Check Kernel ICMP Settings</b></summary>

```bash
cat /proc/sys/net/ipv4/icmp_echo_ignore_all
# 1 = ignore pings, 0 = respond to pings
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

**Next Lab**: [22 - Too Many Open Files](../22-too-many-open-files-fd-limit/)

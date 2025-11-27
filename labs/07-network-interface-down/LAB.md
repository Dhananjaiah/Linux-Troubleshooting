# Lab 07: Network Interface Down

## 📖 Scenario / Story

Users report they cannot reach any servers in a particular subnet. Upon investigation, one critical server has **lost network connectivity**. You can access it through console, but it can't reach the internet or other servers.

The server is physically fine, but something is wrong with its network configuration.

**Your mission**: Restore network connectivity to the server.

---

## 🎯 What You Will Learn

- Check network interface status with `ip` and `ifconfig`
- Bring interfaces up and down
- View and modify network configuration
- Troubleshoot common network issues
- Check routing tables
- Use network diagnostic tools

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- Console or local access (network will be down!)
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/07-network-interface-down
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

**⚠️ WARNING**: This will disable network! Ensure you have console access.

---

## 🔴 Problem Symptoms

```bash
$ ping 8.8.8.8
connect: Network is unreachable

$ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 ...
    inet 127.0.0.1/8 scope host lo
2: eth0: <BROADCAST,MULTICAST> mtu 1500 ...
    # Notice: NO "UP" flag, NO IP address
```

---

## ✅ Tasks for You

1. **Check network interface status**
2. **Identify which interface is down**
3. **Bring the interface up**
4. **Verify IP configuration**
5. **Test connectivity** with ping
6. **Check routing table**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Check Interface Status</b></summary>

```bash
ip link show
ip addr show
```

Look for interfaces without the "UP" flag.
</details>

<details>
<summary><b>Hint 2: Bring Interface Up</b></summary>

```bash
# Bring up the interface
sudo ip link set eth0 up

# Get IP via DHCP
sudo dhclient eth0

# Or manually set IP
sudo ip addr add 192.168.1.100/24 dev eth0
```
</details>

<details>
<summary><b>Hint 3: Check Routing</b></summary>

```bash
ip route show

# Add default gateway
sudo ip route add default via 192.168.1.1
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

1. What's the difference between `ip link set up` and getting an IP address?
2. How would you persist network configuration across reboots?
3. What tools would you use if ping works but HTTP doesn't?

---

**Previous Lab**: [06 - Database Too Many Connections](../06-db-too-many-connections/)  
**Next Lab**: [08 - Permission Denied Even as Root](../08-permission-denied-even-root/)

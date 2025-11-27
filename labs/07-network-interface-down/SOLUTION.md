# Lab 07: Network Interface Down

## SOLUTION GUIDE

---

## 🔍 Root Cause

The network interface (eth0/ens33) has been administratively disabled. The interface exists but is in DOWN state and has no IP address assigned.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Interface Status

```bash
ip link show
```

**Output:**
```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536
2: eth0: <BROADCAST,MULTICAST> mtu 1500  # Notice: NO "UP"
```

### Step 2: Bring Interface Up

```bash
sudo ip link set eth0 up
```

### Step 3: Get IP Address

For DHCP:
```bash
sudo dhclient eth0
```

For static IP:
```bash
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1
```

### Step 4: Verify Connectivity

```bash
ping -c 4 8.8.8.8
ping -c 4 google.com
```

---

## 🛡️ Prevention

1. **Use NetworkManager** or **netplan** for persistent configuration
2. **Monitor interface status** with SNMP or agents
3. **Set up redundant network paths** for critical servers
4. **Document network configuration** clearly

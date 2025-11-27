# Lab 16: NFS Mount Failure

## 📖 Scenario / Story

The application server needs to access shared storage on an NFS server, but the **mount is failing**. Users report that files they expect to find in `/mnt/shared` are not there, and applications depending on shared storage are failing.

**Your mission**: Troubleshoot and fix the NFS mount issue.

---

## 🎯 What You Will Learn

- NFS client/server architecture
- Check NFS exports and mount options
- Debug NFS with `showmount`, `rpcinfo`
- Configure `/etc/fstab` for NFS
- Troubleshoot network connectivity for NFS

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- NFS utilities (`sudo apt install nfs-common nfs-kernel-server`)
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/16-nfs-mount-failure
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ sudo mount -t nfs localhost:/srv/nfs_share /mnt/nfs
mount.nfs: Connection timed out

$ showmount -e localhost
clnt_create: RPC: Program not registered
```

---

## ✅ Tasks for You

1. **Check if NFS server services are running**
2. **Verify NFS exports** configuration
3. **Check RPC services** with `rpcinfo`
4. **Verify firewall** isn't blocking NFS
5. **Fix and mount** the NFS share
6. **Verify access** to shared files

---

## 💡 Hints

<details>
<summary><b>Hint 1: Check NFS Services</b></summary>

```bash
# Check NFS server status
sudo systemctl status nfs-server
sudo systemctl status rpcbind

# Start services
sudo systemctl start nfs-server
```
</details>

<details>
<summary><b>Hint 2: Check Exports</b></summary>

```bash
# View exports
cat /etc/exports

# Refresh exports
sudo exportfs -ra

# Show available exports
showmount -e localhost
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

**Previous Lab**: [15 - SSH Key Auth Not Working](../15-ssh-key-auth-not-working/)  
**Next Lab**: [17 - High Load Low CPU](../17-high-load-low-cpu/)

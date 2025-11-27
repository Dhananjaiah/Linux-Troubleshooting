# Lab 16: NFS Mount Failure

## SOLUTION GUIDE

---

## 🔍 Root Cause

The NFS server service was stopped and/or the exports were not properly configured. Without the NFS server running, clients cannot mount shares.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check NFS Server Status

```bash
sudo systemctl status nfs-server
```

Service is not running.

### Step 2: Start NFS Services

```bash
sudo systemctl start nfs-server
sudo systemctl start rpcbind
```

### Step 3: Verify Exports

```bash
cat /etc/exports
sudo exportfs -ra
showmount -e localhost
```

### Step 4: Mount the Share

```bash
sudo mount -t nfs localhost:/srv/nfs_share /mnt/nfs
```

---

## 🛡️ Prevention

1. **Enable NFS at boot**: `systemctl enable nfs-server`
2. **Monitor NFS services** with your monitoring system
3. **Test mounts** as part of health checks
4. **Use autofs** for automatic mounting

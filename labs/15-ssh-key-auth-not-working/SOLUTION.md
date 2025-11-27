# Lab 15: SSH Key Authentication Not Working

## SOLUTION GUIDE

---

## 🔍 Root Cause

The SSH key authentication is failing due to incorrect permissions on the `.ssh` directory or `authorized_keys` file. SSH enforces strict permission requirements for security.

Common causes:
1. `.ssh` directory not 700
2. `authorized_keys` not 600
3. Home directory group/world writable
4. Wrong ownership on key files

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Debug SSH Connection

```bash
ssh -v testuser@localhost
```

Look for lines like:
```
debug1: Authentications that can continue: publickey,password
debug1: Offering public key: /home/user/.ssh/id_rsa
debug1: Authentications that can continue: publickey,password
```

Key is offered but rejected.

### Step 2: Check Server-Side Logs

```bash
sudo tail -f /var/log/auth.log
```

**May show:**
```
sshd: Authentication refused: bad ownership or modes for directory /home/testuser/.ssh
```

### Step 3: Check Permissions

```bash
ls -la /home/testuser/
ls -la /home/testuser/.ssh/
```

### Step 4: Fix Permissions

```bash
# Fix home directory
chmod 755 /home/testuser

# Fix .ssh directory
chmod 700 /home/testuser/.ssh

# Fix authorized_keys
chmod 600 /home/testuser/.ssh/authorized_keys

# Fix ownership
chown -R testuser:testuser /home/testuser/.ssh
```

### Step 5: Verify Fix

```bash
ssh testuser@localhost
# Should not ask for password
```

---

## 🛡️ Prevention

1. **Use `ssh-copy-id`** which sets correct permissions automatically
2. **Audit permissions** as part of user setup scripts
3. **Use configuration management** (Ansible, etc.)
4. **Document SSH setup procedures**

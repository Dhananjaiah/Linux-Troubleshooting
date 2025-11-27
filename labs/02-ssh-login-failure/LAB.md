# Lab 02: SSH Login Failure

## 📖 Scenario / Story

It's Monday morning, and the helpdesk is flooded with tickets. Multiple developers are reporting that they **cannot SSH into the development server**. The error messages vary – some see "Connection refused," others see "Permission denied," and a few say it just hangs.

You're the senior sysadmin, and your manager needs this fixed ASAP because deployments are blocked. A junior admin made some "security improvements" over the weekend, and things haven't been the same since.

**Your mission**: Figure out what's blocking SSH access and restore it without physically accessing the server (assume you have console access or are already logged in locally).

---

## 🎯 What You Will Learn

By completing this lab, you will learn how to:

- Check SSH service status with `systemctl`
- View SSH-related logs with `journalctl`
- Understand SSH configuration in `/etc/ssh/sshd_config`
- Troubleshoot common SSH authentication problems
- Check firewall rules that might block SSH
- Diagnose user account issues that prevent login

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server (VM recommended)
- Non-root user with sudo access
- Console or local access to the server (since SSH might be broken!)
- Basic understanding of SSH concepts

---

## 🛠️ Lab Setup

### Step 1: Navigate to the Lab Directory

```bash
cd /path/to/Linux-Troubleshooting/labs/02-ssh-login-failure
```

### Step 2: Make Scripts Executable (First Time Only)

```bash
chmod +x scripts/*.sh
```

### Step 3: Run the Break Script

**⚠️ WARNING**: This will modify SSH configuration! Only run on a test system.

```bash
sudo ./scripts/break.sh
```

You should see output similar to:
```
[BREAK] Starting SSH failure simulation for Lab 02...
[INFO] Backing up current SSH configuration...
[INFO] Applying SSH misconfigurations...
[INFO] Creating test user for the lab...
[BREAK] SSH is now broken!
========================================
YOUR TASK: Restore SSH access for users!
========================================
```

### Step 4: Confirm the Problem Exists

Test from another terminal or machine:

```bash
# Try to SSH (should fail)
ssh testuser@localhost

# Or try with verbose output
ssh -v testuser@localhost
```

---

## 🔴 Problem Symptoms (What You See)

### Symptom 1: SSH Connection Refused

```bash
$ ssh testuser@localhost
ssh: connect to host localhost port 22: Connection refused
```

### Symptom 2: Permission Denied

```bash
$ ssh testuser@localhost
testuser@localhost: Permission denied (publickey,password).
```

### Symptom 3: Connection Hangs

```bash
$ ssh testuser@localhost
# (No output, just hangs...)
^C
```

### Symptom 4: Verbose SSH Shows Authentication Failures

```bash
$ ssh -v testuser@localhost
OpenSSH_8.9p1 Ubuntu, OpenSSL 3.0.2 15 Mar 2022
debug1: Connecting to localhost [127.0.0.1] port 22.
debug1: Connection established.
...
debug1: Authentications that can continue: publickey
debug1: No more authentication methods to try.
testuser@localhost: Permission denied (publickey).
```

---

## ✅ Tasks for You

Complete these tasks to restore SSH access:

1. **Check SSH service status**
   - Verify if the SSH daemon (sshd) is running
   - Look for any error messages in the service status

2. **Check SSH daemon logs**
   - Use journalctl to find SSH-related errors
   - Look for authentication failures or configuration errors

3. **Review SSH configuration**
   - Examine `/etc/ssh/sshd_config` for misconfigurations
   - Check for settings that might block users

4. **Check firewall rules**
   - Verify if port 22 is allowed
   - Check iptables or ufw status

5. **Verify user account status**
   - Check if the user account is locked
   - Verify the user's shell is valid
   - Check if the user is in the correct groups

6. **Fix the identified issues**
   - Correct any misconfigurations
   - Restart services as needed

7. **Test SSH access**
   - Verify users can now log in via SSH

---

## 💡 Hints (Click to Expand)

<details>
<summary><b>Hint 1: Checking SSH Service</b></summary>

Check if the SSH daemon is running:
```bash
sudo systemctl status ssh
# or
sudo systemctl status sshd
```

If it's not running, check why:
```bash
sudo journalctl -xe -u ssh
```

</details>

<details>
<summary><b>Hint 2: Common sshd_config Issues</b></summary>

Common settings that can break SSH:
```
PasswordAuthentication no    # Blocks password login
PermitRootLogin no          # Blocks root login (usually good!)
AllowUsers user1 user2      # Only allows specific users
DenyUsers user3             # Blocks specific users
Port 2222                   # Changes default port
```

After changes, restart SSH:
```bash
sudo systemctl restart ssh
```

</details>

<details>
<summary><b>Hint 3: Checking Firewall</b></summary>

Check UFW (Ubuntu's firewall):
```bash
sudo ufw status
```

Check iptables directly:
```bash
sudo iptables -L -n | grep 22
```

Allow SSH if blocked:
```bash
sudo ufw allow ssh
# or
sudo ufw allow 22
```

</details>

<details>
<summary><b>Hint 4: User Account Issues</b></summary>

Check if account is locked:
```bash
sudo passwd -S testuser
# "L" in second field means locked
```

Unlock account:
```bash
sudo passwd -u testuser
```

Check user's shell:
```bash
grep testuser /etc/passwd
# Shell should be /bin/bash, not /sbin/nologin
```

</details>

<details>
<summary><b>Hint 5: SSH Configuration Syntax Check</b></summary>

Validate sshd_config syntax before restarting:
```bash
sudo sshd -t
```

This will show any configuration errors.

</details>

---

## ✔️ Verification

Run the verification script to check if you've fixed the issue:

```bash
./scripts/verify.sh
```

**Expected successful output:**
```
[VERIFY] Checking Lab 02: SSH Login Failure
========================================
[✓] SSH service is running
[✓] SSH is listening on port 22
[✓] Firewall allows SSH (port 22)
[✓] testuser account is not locked
[✓] Password authentication is enabled
[✓] SSH connection test successful
========================================
[SUCCESS] All checks passed! Lab 02 completed successfully.
```

### Manual Verification Commands

```bash
# 1. Check SSH service
sudo systemctl is-active ssh

# 2. Check SSH is listening
ss -tlnp | grep :22

# 3. Test SSH connection (password: testpass123)
ssh testuser@localhost echo "SSH works!"

# 4. Check auth log for success
sudo tail /var/log/auth.log | grep sshd
```

---

## 🧹 Cleanup

After completing the lab, restore your system to a clean state:

```bash
sudo ./scripts/cleanup.sh
```

**Expected output:**
```
[CLEANUP] Starting cleanup for Lab 02...
[INFO] Restoring original SSH configuration...
[INFO] Removing test user...
[INFO] Restarting SSH service...
[CLEANUP] Environment restored to clean state.
```

---

## 🤔 Reflection / Interview Questions

After completing this lab, think about these questions:

1. **Security vs. Accessibility**: The "security improvements" broke access. How do you balance security hardening with maintaining access?

2. **Testing Changes**: What process should be followed before making SSH configuration changes on a production server?

3. **Backup Access**: If SSH is your only remote access method, what happens when it breaks? What backup access methods should you have?

4. **Monitoring**: How would you monitor SSH access and detect issues before users report them?

5. **Interview Scenario**: "Users can't SSH into a server. Walk me through your troubleshooting process."

---

## 📚 Additional Resources

- `man sshd_config` - SSH daemon configuration
- `man ssh` - SSH client options
- `man journalctl` - Systemd journal
- `/var/log/auth.log` - Authentication logs

---

**Previous Lab**: [01 - Disk Full - Application Failure](../01-disk-full-app-failure/)  
**Next Lab**: [03 - Webserver Down (Apache/Nginx)](../03-webserver-down-apache-nginx/)

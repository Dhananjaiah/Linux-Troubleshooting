# Lab 02: SSH Login Failure

## SOLUTION GUIDE (Trainer/Answer Key)

---

## 📋 Recap of the Scenario

Developers cannot SSH into the development server. Multiple symptoms are observed:
- "Connection refused" errors
- "Permission denied" errors
- Connections hanging

A junior admin made "security improvements" over the weekend that introduced multiple SSH misconfigurations.

---

## 🔍 Root Cause

The lab introduces **multiple issues** that can cause SSH failures:

1. **SSH service not running** - The sshd service was stopped
2. **Password authentication disabled** - Only key-based auth allowed, but no keys set up
3. **User account locked** - The testuser account was locked
4. **Invalid AllowUsers directive** - Only specific users allowed, excluding the test user
5. **Firewall blocking port 22** (optional variation)

This simulates real-world scenarios where multiple small changes cascade into a complete outage.

---

## 🔬 Step-by-Step Troubleshooting Walkthrough

### Step 1: Check SSH Service Status

First, let's see if the SSH daemon is even running:

```bash
sudo systemctl status ssh
```

**Expected Output (if stopped):**
```
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: inactive (dead) since Mon 2024-01-15 09:00:00 UTC
```

**Key observation**: Service is not running (`inactive (dead)`).

### Step 2: Try to Start the SSH Service

```bash
sudo systemctl start ssh
```

Check status again:
```bash
sudo systemctl status ssh
```

**Expected Output (with config error):**
```
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: failed (Result: exit-code) since Mon 2024-01-15 09:05:00 UTC
    Process: 12345 ExecStart=/usr/sbin/sshd -D $SSHD_OPTS (code=exited, status=255/EXCEPTION)
   Main PID: 12345 (code=exited, status=255/EXCEPTION)
```

**Key observation**: Service fails to start, likely due to configuration error.

### Step 3: Check SSH Configuration Syntax

```bash
sudo sshd -t
```

**Expected Output (if config error):**
```
/etc/ssh/sshd_config line 42: Bad configuration option: InvalidOption
```

Or it may pass syntax check but have logical issues.

### Step 4: Review SSH Configuration

```bash
sudo cat /etc/ssh/sshd_config | grep -v "^#" | grep -v "^$"
```

**Look for these problematic settings:**
```
PasswordAuthentication no     # Problem: Blocks password login
PermitEmptyPasswords no
PubkeyAuthentication yes
AllowUsers admin              # Problem: testuser not in list
```

### Step 5: Check SSH Logs for More Details

```bash
sudo journalctl -xe -u ssh --no-pager | tail -30
```

Or check auth log:
```bash
sudo tail -50 /var/log/auth.log | grep sshd
```

**Expected Output:**
```
Jan 15 09:10:15 server sshd[12345]: User testuser not allowed because not listed in AllowUsers
Jan 15 09:10:15 server sshd[12345]: Connection closed by authenticating user testuser 127.0.0.1 port 54321
```

### Step 6: Check User Account Status

```bash
sudo passwd -S testuser
```

**Expected Output (if locked):**
```
testuser L 01/15/2024 0 99999 7 -1 (Password locked.)
```

**Key observation**: The "L" indicates the account is locked.

Check user's shell:
```bash
grep testuser /etc/passwd
```

**Expected Output:**
```
testuser:x:1001:1001:Test User:/home/testuser:/bin/bash
```

### Step 7: Check Firewall Rules

```bash
sudo ufw status
```

**Expected Output (if blocking):**
```
Status: active

To                         Action      From
--                         ------      ----
22                         DENY        Anywhere
```

Or check iptables:
```bash
sudo iptables -L -n | grep -E "(22|ssh)"
```

---

## 🔧 Fix Steps

### Fix 1: Correct SSH Configuration

Edit the SSH configuration:
```bash
sudo nano /etc/ssh/sshd_config
```

Make these changes:

1. **Enable password authentication** (for this lab):
```
PasswordAuthentication yes
```

2. **Remove or fix AllowUsers** (either remove the line or add testuser):
```
# Option A: Comment out the AllowUsers line
# AllowUsers admin

# Option B: Add testuser to the list
AllowUsers admin testuser
```

3. **Verify no syntax errors**:
```bash
sudo sshd -t
echo $?    # Should return 0
```

**Why this works**: `PasswordAuthentication yes` allows users to log in with passwords (when no SSH keys are set up). Removing/fixing `AllowUsers` allows testuser to connect.

### Fix 2: Unlock the User Account

```bash
sudo passwd -u testuser
```

**Expected Output:**
```
passwd: password expiry information changed.
```

Verify:
```bash
sudo passwd -S testuser
```

**Expected Output:**
```
testuser P 01/15/2024 0 99999 7 -1 (Password set, SHA512 crypt.)
```

**Why this works**: The `-u` flag unlocks the account, allowing authentication.

### Fix 3: Fix Firewall (if needed)

If the firewall is blocking SSH:
```bash
sudo ufw allow ssh
# or
sudo ufw allow 22/tcp
```

**Why this works**: Opens port 22 in the firewall.

### Fix 4: Restart SSH Service

```bash
sudo systemctl restart ssh
```

Verify it's running:
```bash
sudo systemctl status ssh
```

**Expected Output:**
```
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: active (running) since Mon 2024-01-15 09:30:00 UTC
```

---

## ✔️ Verification

### Automated Verification

```bash
./scripts/verify.sh
```

### Manual Verification Commands

```bash
# 1. Check SSH service is running
sudo systemctl is-active ssh

# 2. Check SSH is listening on port 22
ss -tlnp | grep :22

# 3. Test SSH connection (password: testpass123)
ssh -o BatchMode=no testuser@localhost echo "SSH works!"

# 4. Check auth log for successful login
sudo grep "Accepted password" /var/log/auth.log | tail -1
```

**Expected Results:**
- Service is active
- Port 22 is listening
- SSH connection succeeds
- Auth log shows accepted authentication

---

## 🛡️ How to Prevent This in Production

### 1. Test SSH Configuration Before Applying

Always validate configuration before restarting:
```bash
sudo sshd -t && sudo systemctl restart ssh
```

### 2. Keep a Console/Out-of-Band Access

Always have backup access:
- Console access (IPMI, iLO, DRAC)
- Cloud provider console
- Serial console
- Secondary admin account with different auth method

### 3. Use Configuration Management

Use Ansible, Puppet, or similar to manage SSH configs:
```yaml
# Ansible example
- name: Configure SSH
  template:
    src: sshd_config.j2
    dest: /etc/ssh/sshd_config
    validate: /usr/sbin/sshd -t -f %s
  notify: restart sshd
```

### 4. Staged Rollout of Changes

Never apply SSH changes to all servers at once:
1. Test in dev environment
2. Apply to one production server
3. Verify access
4. Roll out to remaining servers

### 5. Set Up SSH Access Monitoring

Monitor for:
- Failed login attempts
- SSH service status
- Changes to sshd_config

Example monitoring:
```bash
# Alert on multiple failed SSH attempts
grep "Failed password" /var/log/auth.log | wc -l
```

### 6. Document Changes

Maintain a change log:
```
[2024-01-15] Added AllowUsers directive - Ticket #1234
[2024-01-14] Disabled root login - Security review
```

---

## 🔄 Extra Variations

### Variation 1: SSH Key Only Authentication

Configure to only allow key-based auth but don't set up any keys:
```
PasswordAuthentication no
PubkeyAuthentication yes
```

Students must either:
- Enable password auth, OR
- Set up SSH keys for the user

### Variation 2: Wrong SSH Port

Change SSH to a non-standard port:
```
Port 2222
```

Students must discover the new port and update firewall rules.

### Variation 3: PAM Configuration Issue

Break PAM configuration that affects SSH:
```bash
# Corrupt /etc/pam.d/sshd
```

Students must fix PAM configuration.

### Variation 4: SELinux/AppArmor Blocking

If SELinux/AppArmor is available, configure it to block sshd:
```bash
# Set restrictive context
```

Students must check and fix security module rules.

### Variation 5: Home Directory Permissions

Set wrong permissions on user's home or .ssh directory:
```bash
chmod 777 /home/testuser/.ssh
```

SSH key auth fails with strict permission checks.

---

## 📝 Instructor Notes

1. **Time to complete**: 20-40 minutes for beginners
2. **Common mistakes**:
   - Not checking if service is running first
   - Forgetting to restart ssh after config changes
   - Not validating config syntax before restart
   - Overlooking the locked user account
3. **Discussion points**:
   - Security vs. accessibility trade-offs
   - Importance of change management
   - Backup access methods
4. **Follow-up questions**:
   - What's the difference between `AllowUsers` and `DenyUsers`?
   - Why is disabling password auth considered more secure?
   - What logs would show a brute-force SSH attack?

---

## 🎓 Learning Outcomes

After this lab, students should be able to:
- [ ] Check SSH service status
- [ ] Validate SSH configuration syntax
- [ ] Identify common sshd_config misconfigurations
- [ ] Check and unlock user accounts
- [ ] View authentication logs
- [ ] Diagnose firewall issues affecting SSH
- [ ] Explain SSH security best practices

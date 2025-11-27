# Lab 12: Password Change Not Working

## 📖 Scenario / Story

A user reports that they changed their password, but they still can't log in with the new password. The old password doesn't work either! The same user can't authenticate to any service - SSH, sudo, nothing works.

The security team is getting anxious because this could indicate a compromised authentication system.

**Your mission**: Figure out why password authentication is failing and restore access.

---

## 🎯 What You Will Learn

- Understand Linux authentication (PAM)
- Check `/etc/passwd`, `/etc/shadow` file integrity
- Diagnose PAM configuration issues
- Use `passwd` command effectively
- Check account status and expiration

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/12-password-change-not-working
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ su - testuser
Password: 
su: Authentication failure

$ ssh testuser@localhost
testuser@localhost's password: 
Permission denied, please try again.
```

Even after setting a new password:
```bash
$ sudo passwd testuser
New password: 
Retype new password: 
passwd: password updated successfully

$ su - testuser
Password: 
su: Authentication failure   # STILL FAILS!
```

---

## ✅ Tasks for You

1. **Check user account status** with `passwd -S`
2. **Verify `/etc/shadow`** file permissions and content
3. **Check account expiration**
4. **Examine PAM configuration**
5. **Fix the authentication issue**
6. **Verify login works**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Account Status</b></summary>

```bash
# Check account status
sudo passwd -S testuser
# L = locked, P = usable password, NP = no password

# Check account aging
sudo chage -l testuser
```
</details>

<details>
<summary><b>Hint 2: Shadow File</b></summary>

```bash
# Check shadow file permissions
ls -la /etc/shadow

# View user's shadow entry (look for special characters)
sudo grep testuser /etc/shadow
```

An `!` or `*` at the start of the password hash means locked account.
</details>

<details>
<summary><b>Hint 3: Unlock Account</b></summary>

```bash
# Unlock account
sudo passwd -u testuser

# Or force password change
sudo passwd testuser

# Check if expired
sudo chage -E -1 testuser  # Remove expiration
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

1. What's the difference between a locked account and an expired account?
2. How does PAM affect authentication?
3. What would cause password changes to appear to work but authentication to fail?
4. How would you audit authentication failures?

---

**Previous Lab**: [11 - Kernel Panic on Boot](../11-kernel-panic-on-boot/)  
**Next Lab**: [13 - DNS Resolution Failing](../13-dns-resolution-failing/)

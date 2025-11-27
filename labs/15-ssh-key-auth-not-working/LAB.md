# Lab 15: SSH Key Authentication Not Working

## 📖 Scenario / Story

You've set up SSH key authentication for a user, but when they try to connect, they're **still being prompted for a password**. The keys are in place, the config looks right, but key authentication just won't work.

This is frustrating because key-based auth is more secure and convenient.

**Your mission**: Debug the SSH key authentication and make it work.

---

## 🎯 What You Will Learn

- Understand SSH key authentication flow
- Check key file permissions
- Debug with `ssh -v` verbose mode
- Configure `sshd_config` for key auth
- Troubleshoot common SSH key issues

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/15-ssh-key-auth-not-working
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ ssh -i ~/.ssh/id_rsa testuser@localhost
testuser@localhost's password:          # Still asking for password!

$ ssh -v -i ~/.ssh/id_rsa testuser@localhost
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: Offering public key: /home/user/.ssh/id_rsa
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: password
```

The key is offered but not accepted!

---

## ✅ Tasks for You

1. **Check key file permissions** on both sides
2. **Verify authorized_keys** file content
3. **Check .ssh directory permissions**
4. **Use `ssh -v` for debugging**
5. **Check `sshd_config`** settings
6. **Fix the issue** and test

---

## 💡 Hints

<details>
<summary><b>Hint 1: Permission Requirements</b></summary>

SSH is very strict about permissions:
```bash
# Home directory: 755 or stricter
chmod 755 ~

# .ssh directory: 700
chmod 700 ~/.ssh

# authorized_keys: 600
chmod 600 ~/.ssh/authorized_keys

# Private key: 600
chmod 600 ~/.ssh/id_rsa
```
</details>

<details>
<summary><b>Hint 2: Debug SSH Connection</b></summary>

```bash
# Client-side verbose
ssh -v user@host

# Server-side logs
sudo tail -f /var/log/auth.log

# Test specific key
ssh -v -i /path/to/key user@host
```
</details>

<details>
<summary><b>Hint 3: Check authorized_keys</b></summary>

```bash
# View the authorized_keys file
cat ~/.ssh/authorized_keys

# Ensure it matches the public key
cat ~/.ssh/id_rsa.pub

# Check for extra whitespace or newlines
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

1. Why is SSH so strict about file permissions?
2. What's the difference between `authorized_keys` and `known_hosts`?
3. How would you set up SSH key auth for automation (scripts, CI/CD)?
4. What are the security considerations for SSH key management?

---

**Previous Lab**: [14 - Out of Inodes](../14-out-of-inodes/)  
**Next Lab**: [16 - NFS Mount Failure](../16-nfs-mount-failure/)

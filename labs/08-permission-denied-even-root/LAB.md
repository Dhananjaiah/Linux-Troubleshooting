# Lab 08: Permission Denied (Even as Root)

## 📖 Scenario / Story

You need to modify a critical configuration file. You're logged in as root, but when you try to edit or delete the file, you get **"Permission denied"** or **"Operation not permitted"** - even though you're root!

This is confusing because root should be able to do anything... right?

**Your mission**: Figure out why root can't modify the file and fix it.

---

## 🎯 What You Will Learn

- Understand Linux file attributes (beyond permissions)
- Use `chattr` and `lsattr` commands
- Learn about immutable files
- Understand security implications
- Learn about SELinux/AppArmor contexts

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- Root or sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/08-permission-denied-even-root
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ sudo rm /etc/important-config
rm: cannot remove '/etc/important-config': Operation not permitted

$ sudo chmod 777 /etc/important-config
chmod: changing permissions of '/etc/important-config': Operation not permitted

$ sudo chown user:user /etc/important-config
chown: changing ownership of '/etc/important-config': Operation not permitted
```

Even `ls -la` shows root owns the file with full permissions!

---

## ✅ Tasks for You

1. **Check regular file permissions** with `ls -la`
2. **Check extended file attributes** 
3. **Identify what's preventing modification**
4. **Remove the protection**
5. **Verify the file can be modified**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Extended Attributes</b></summary>

Regular permissions (`ls -la`) aren't everything. Check extended attributes:
```bash
lsattr /etc/important-config
```

Look for letters like `i` (immutable) or `a` (append-only).
</details>

<details>
<summary><b>Hint 2: Removing Immutable Flag</b></summary>

```bash
# Remove immutable flag
sudo chattr -i /etc/important-config

# Remove append-only flag
sudo chattr -a /etc/important-config

# View attributes
lsattr filename
```
</details>

<details>
<summary><b>Hint 3: Understanding Attributes</b></summary>

Common attributes:
- `i` - Immutable: Cannot be modified, deleted, or renamed (even by root)
- `a` - Append only: Can only add data, not modify existing
- `s` - Secure deletion: Blocks are zeroed on deletion
- `u` - Undeletable: Contents saved for possible recovery
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

1. When would you want to make a file immutable?
2. What are the security implications of the `chattr` command?
3. How would SELinux/AppArmor cause similar symptoms?
4. How would you audit changes to file attributes?

---

**Previous Lab**: [07 - Network Interface Down](../07-network-interface-down/)  
**Next Lab**: [09 - Wrong System Time](../09-wrong-system-time/)

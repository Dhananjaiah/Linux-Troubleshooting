# Lab 12: Password Change Not Working

## SOLUTION GUIDE

---

## 🔍 Root Cause

The user account is **locked** and/or **expired**. Even though `passwd` updates the password hash, a locked account prefix (`!`) prevents authentication, and account expiration blocks login regardless of password validity.

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Account Status

```bash
sudo passwd -S testuser
```

**Output:**
```
testuser L 01/15/2024 0 99999 7 -1 (Password locked.)
```

The `L` indicates the account is locked.

### Step 2: Check Account Expiration

```bash
sudo chage -l testuser
```

**Output:**
```
Account expires                                     : Jan 01, 2020
```

Account has expired!

### Step 3: Check Shadow File

```bash
sudo grep testuser /etc/shadow
```

**Output:**
```
testuser:!$6$abc123...:19300:0:99999:7:::
```

The `!` prefix indicates locked.

### Step 4: Fix the Issues

**Unlock the account:**
```bash
sudo passwd -u testuser
```

**Remove expiration:**
```bash
sudo chage -E -1 testuser
```

**Or set new expiration:**
```bash
sudo chage -E 2025-12-31 testuser
```

### Step 5: Verify Fix

```bash
su - testuser
# Should work now
```

---

## 🛡️ Prevention

1. **Monitor account expiration** dates
2. **Use account management tools** properly
3. **Document account policies** clearly
4. **Set up alerts** for expiring accounts

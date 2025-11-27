# Lab 30: Too Many Open TCP Connections

## 📖 Scenario / Story

The server is refusing new connections with **"Cannot assign requested address"** or **"Too many open files"** errors. Network services are failing.

**Your mission**: Identify and resolve TCP connection exhaustion.

---

## 🎯 What You Will Learn

- Monitor TCP connections with `ss` and `netstat`
- Understand TCP connection limits
- Tune kernel TCP parameters
- Identify connection leaks

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/30-too-many-open-tcp-connections
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## ✅ Tasks for You

1. Check current TCP connection count
2. Identify applications with most connections
3. Find connection leaks or attacks
4. Tune TCP parameters if needed

---

## 💡 Hints

<details>
<summary><b>Hint: TCP Monitoring</b></summary>

```bash
# Count TCP connections
ss -s
netstat -ant | wc -l

# Connections by state
ss -ant | awk '{print $1}' | sort | uniq -c

# Connections by process
ss -antp | awk '{print $7}' | sort | uniq -c | sort -rn
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

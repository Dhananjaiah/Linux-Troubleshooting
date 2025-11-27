# Lab 06: Database Connection Failing - Too Many Connections

## 📖 Scenario / Story

Your e-commerce application suddenly starts throwing errors. Users see "Database connection failed" messages when trying to checkout. The database server is up, but applications can't connect.

The DBA checks MySQL and sees: **"Too many connections"** error. The connection pool is exhausted, and no new connections can be established.

**Your mission**: Understand why connections are exhausted and restore database access.

---

## 🎯 What You Will Learn

- Check MySQL connection status and limits
- View active database connections
- Identify connection leaks
- Adjust MySQL max_connections setting
- Kill idle database connections
- Implement connection pooling best practices

---

## 📋 Prerequisites

- Ubuntu 22.04 LTS server
- MySQL server installed (`sudo apt install mysql-server`)
- sudo access

---

## 🛠️ Lab Setup

```bash
cd /path/to/Linux-Troubleshooting/labs/06-db-too-many-connections
chmod +x scripts/*.sh
sudo ./scripts/break.sh
```

---

## 🔴 Problem Symptoms

```bash
$ mysql -u root -e "SELECT 1"
ERROR 1040 (HY000): Too many connections
```

```bash
$ mysqladmin -u root status
Uptime: 12345  Threads: 151  Questions: 50000  Slow queries: 0
```

---

## ✅ Tasks for You

1. **Check MySQL connection status**
2. **View current connections** with `SHOW PROCESSLIST`
3. **Check max_connections setting**
4. **Identify and kill unnecessary connections**
5. **Adjust configuration if needed**
6. **Verify database is accessible**

---

## 💡 Hints

<details>
<summary><b>Hint 1: Checking Connections</b></summary>

```sql
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Max_used_connections';
SHOW VARIABLES LIKE 'max_connections';
```
</details>

<details>
<summary><b>Hint 2: View Active Connections</b></summary>

```sql
SHOW FULL PROCESSLIST;
SELECT user, host, db, command, time, state FROM information_schema.processlist;
```
</details>

<details>
<summary><b>Hint 3: Kill Connections</b></summary>

```sql
-- Kill specific connection
KILL <connection_id>;

-- Kill all connections from a user
-- (requires privileges)
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

1. What causes connection leaks in applications?
2. How do connection pools help prevent this issue?
3. What's the downside of setting max_connections too high?

---

**Previous Lab**: [05 - Low Memory OOM](../05-low-memory-oom/)  
**Next Lab**: [07 - Network Interface Down](../07-network-interface-down/)

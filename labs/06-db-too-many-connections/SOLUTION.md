# Lab 06: Database Too Many Connections

## SOLUTION GUIDE

---

## 🔍 Root Cause

The MySQL server has reached its `max_connections` limit. This happens when:
- Connection leaks in application code
- Connection pool misconfiguration
- Sudden traffic spike
- Long-running queries holding connections

---

## 🔬 Troubleshooting Walkthrough

### Step 1: Check Connection Count

```bash
mysqladmin -u root status
```

Or via SQL (if you can connect):
```sql
SHOW STATUS LIKE 'Threads_connected';
SHOW VARIABLES LIKE 'max_connections';
```

### Step 2: View Active Connections

```sql
SHOW FULL PROCESSLIST;
```

Look for:
- Many connections from same host
- Connections in "Sleep" state for long time
- Queries running too long

### Step 3: Kill Idle Connections

```sql
-- Find idle connections
SELECT id, user, host, db, command, time 
FROM information_schema.processlist 
WHERE command = 'Sleep' AND time > 300;

-- Kill them
KILL <id>;
```

### Step 4: Increase max_connections (Temporary)

```sql
SET GLOBAL max_connections = 300;
```

For permanent change, edit `/etc/mysql/mysql.conf.d/mysqld.cnf`:
```ini
[mysqld]
max_connections = 300
```

---

## 🛡️ Prevention

1. **Use connection pooling** in your application
2. **Set wait_timeout** to close idle connections
3. **Monitor connection usage** with alerts
4. **Implement retry logic** in applications

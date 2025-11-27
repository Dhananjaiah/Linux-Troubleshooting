# Lab 30: Too Many TCP Connections - Solution

## 🔍 Root Cause

TCP exhaustion occurs due to:
1. Connection leak in application
2. DDoS attack
3. Improper connection pooling
4. TIME_WAIT accumulation

## 🔧 Fix

```bash
# Identify source
ss -antp | awk '{print $7}' | sort | uniq -c | sort -rn | head

# Kill problematic process
kill <PID>

# Tune kernel (temporary)
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout
```

## 🛡️ Prevention

1. Implement proper connection pooling
2. Set connection limits per client
3. Monitor connection counts
4. Tune TIME_WAIT handling

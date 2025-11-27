#!/usr/bin/env bash
#
# Lab 04: High CPU Usage
# verify.sh - Checks if CPU usage is normalized
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 04: High CPU Usage"
echo "========================================"

# Check 1: No cpu-stress.sh running
if pgrep -f "cpu-stress.sh" >/dev/null 2>&1; then
    print_fail "CPU stress process is still running"
else
    print_pass "CPU stress process has been stopped"
fi

# Check 2: CPU usage below threshold
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'.' -f1)
if [[ -z "$CPU_IDLE" ]]; then
    CPU_IDLE=$(vmstat 1 2 | tail -1 | awk '{print $15}')
fi
CPU_USED=$((100 - CPU_IDLE))

if [[ $CPU_USED -lt 80 ]]; then
    print_pass "CPU usage is below 80% (currently ${CPU_USED}%)"
else
    print_fail "CPU usage is still high (${CPU_USED}%)"
fi

# Check 3: Load average reasonable
LOAD=$(cat /proc/loadavg | awk '{print $1}' | cut -d'.' -f1)
CPUS=$(nproc)
if [[ $LOAD -le $((CPUS * 2)) ]]; then
    print_pass "Load average is reasonable"
else
    print_fail "Load average is still high"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 04 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

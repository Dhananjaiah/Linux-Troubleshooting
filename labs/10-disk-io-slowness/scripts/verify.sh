#!/usr/bin/env bash
#
# Lab 10: Disk I/O Slowness
# verify.sh - Checks if I/O is normalized
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 10: Disk I/O Slowness"
echo "========================================"

# Check 1: I/O stress process stopped
if pgrep -f "io-stress.sh" >/dev/null 2>&1; then
    print_fail "I/O stress process is still running"
else
    print_pass "I/O stress process stopped"
fi

# Check 2: I/O wait below threshold
IO_WAIT=$(vmstat 1 2 | tail -1 | awk '{print $16}')
if [[ -z "$IO_WAIT" ]]; then
    IO_WAIT=$(top -bn1 | grep "Cpu" | awk -F',' '{for(i=1;i<=NF;i++) if($i ~ /wa/) print $i}' | grep -o '[0-9.]*' | head -1 | cut -d'.' -f1)
fi

if [[ -n "$IO_WAIT" && "$IO_WAIT" -lt 20 ]]; then
    print_pass "I/O wait is below 20% (currently ${IO_WAIT}%)"
else
    print_fail "I/O wait is still high (${IO_WAIT}%)"
fi

# Clean up test file
rm -f /tmp/io-test-file

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 10 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

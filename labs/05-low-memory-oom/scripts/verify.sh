#!/usr/bin/env bash
#
# Lab 05: Low Memory / OOM
# verify.sh - Checks if memory situation is resolved
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 05: Low Memory OOM"
echo "========================================"

# Check 1: Memory hog process stopped
if pgrep -f "memory-hog.sh" >/dev/null 2>&1; then
    print_fail "Memory hog process is still running"
else
    print_pass "Memory hog process has been stopped"
fi

# Check 2: Memory usage below threshold
MEM_AVAIL=$(free -m | awk '/^Mem:/{print $7}')
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
MEM_PERCENT=$((MEM_AVAIL * 100 / MEM_TOTAL))

if [[ $MEM_PERCENT -gt 20 ]]; then
    print_pass "Memory available is above 20% (${MEM_PERCENT}% available)"
else
    print_fail "Memory available is below 20% (${MEM_PERCENT}% available)"
fi

# Check 3: Swap usage reasonable
SWAP_USED=$(free -m | awk '/^Swap:/{print $3}')
SWAP_TOTAL=$(free -m | awk '/^Swap:/{print $2}')
if [[ $SWAP_TOTAL -gt 0 ]]; then
    SWAP_PERCENT=$((SWAP_USED * 100 / SWAP_TOTAL))
    if [[ $SWAP_PERCENT -lt 50 ]]; then
        print_pass "Swap usage is acceptable (${SWAP_PERCENT}%)"
    else
        print_fail "Swap usage is high (${SWAP_PERCENT}%)"
    fi
else
    print_pass "No swap configured"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 05 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

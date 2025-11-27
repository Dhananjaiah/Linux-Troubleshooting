#!/usr/bin/env bash
#
# Lab 17: High Load Low CPU
# verify.sh - Checks if load is normalized
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab17_active"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 17: High Load Low CPU"
echo "========================================"

# Check 1: Marker file removed (processes stopped)
if [[ ! -f "$MARKER_FILE" ]]; then
    print_pass "Load-generating processes stopped"
else
    print_fail "Load-generating processes still running"
fi

# Check 2: Load average reasonable
LOAD=$(cat /proc/loadavg | awk '{print int($1)}')
CPUS=$(nproc)
if [[ $LOAD -le $((CPUS + 2)) ]]; then
    print_pass "Load average is reasonable ($LOAD)"
else
    print_fail "Load average still high ($LOAD)"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 17 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

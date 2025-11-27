#!/usr/bin/env bash
#
# Lab 09: Wrong System Time
# verify.sh - Checks if time is corrected
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 09: Wrong System Time"
echo "========================================"

# Check 1: NTP is enabled
if timedatectl show --property=NTP 2>/dev/null | grep -q "yes"; then
    print_pass "NTP synchronization is enabled"
else
    print_fail "NTP synchronization is not enabled"
fi

# Check 2: Time is synchronized
if timedatectl show --property=NTPSynchronized 2>/dev/null | grep -q "yes"; then
    print_pass "Time is NTP synchronized"
else
    # Allow a moment for sync
    sleep 2
    if timedatectl show --property=NTPSynchronized 2>/dev/null | grep -q "yes"; then
        print_pass "Time is NTP synchronized"
    else
        print_fail "Time is not NTP synchronized yet"
    fi
fi

echo ""
echo "Current system time: $(date)"
echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 09 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

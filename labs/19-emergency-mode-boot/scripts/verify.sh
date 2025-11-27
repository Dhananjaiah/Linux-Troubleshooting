#!/usr/bin/env bash
#
# Lab 19: Emergency Mode Boot
# verify.sh - Checks if fstab is fixed
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 19: Emergency Mode Boot"
echo "========================================"

# Check 1: Bad entry removed or commented
if grep -qE "^UUID=12345678-1234-5678-1234-567812345678" /etc/fstab 2>/dev/null; then
    print_fail "Bad fstab entry still active"
else
    print_pass "Bad fstab entry removed or commented"
fi

# Check 2: fstab is valid
if mount -a 2>/dev/null; then
    print_pass "fstab entries are valid (mount -a succeeds)"
else
    print_fail "fstab still has issues"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 19 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

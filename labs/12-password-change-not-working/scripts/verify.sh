#!/usr/bin/env bash
#
# Lab 12: Password Change Not Working
# verify.sh - Checks if authentication is fixed
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TEST_USER="labuser12"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 12: Password Change Not Working"
echo "========================================"

# Check 1: Account is not locked
STATUS=$(passwd -S "$TEST_USER" 2>/dev/null | awk '{print $2}')
if [[ "$STATUS" == "P" ]]; then
    print_pass "Account is not locked"
else
    print_fail "Account is still locked (status: $STATUS)"
fi

# Check 2: Account is not expired
EXPIRE_DATE=$(chage -l "$TEST_USER" 2>/dev/null | grep "Account expires" | cut -d: -f2 | tr -d ' ')
if [[ "$EXPIRE_DATE" == "never" || "$EXPIRE_DATE" > "2024" ]]; then
    print_pass "Account is not expired"
else
    print_fail "Account is expired (expires: $EXPIRE_DATE)"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 12 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

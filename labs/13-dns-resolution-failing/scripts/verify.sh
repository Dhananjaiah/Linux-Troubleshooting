#!/usr/bin/env bash
#
# Lab 13: DNS Resolution Failing
# verify.sh - Checks if DNS is working
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 13: DNS Resolution Failing"
echo "========================================"

# Check 1: Can resolve hostname
if host google.com &>/dev/null || dig +short google.com 2>/dev/null | grep -q "."; then
    print_pass "Can resolve hostnames (google.com works)"
else
    print_fail "Cannot resolve hostnames"
fi

# Check 2: resolv.conf has valid nameserver
if grep -qE "^nameserver [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" /etc/resolv.conf 2>/dev/null; then
    NS=$(grep "^nameserver" /etc/resolv.conf | head -1)
    print_pass "resolv.conf has nameserver configured ($NS)"
else
    print_fail "resolv.conf missing valid nameserver"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 13 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

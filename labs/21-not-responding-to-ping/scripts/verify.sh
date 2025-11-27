#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo "[VERIFY] Checking Lab 21"
echo "========================================"

ICMP_IGNORE=$(cat /proc/sys/net/ipv4/icmp_echo_ignore_all)
if [[ "$ICMP_IGNORE" == "0" ]]; then
    print_pass "ICMP responses enabled"
else
    print_fail "ICMP still blocked"
fi

echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 21 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

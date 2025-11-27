#!/usr/bin/env bash
#
# Lab 07: Network Interface Down
# verify.sh - Checks if network is restored
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab07_active"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 07: Network Interface Down"
echo "========================================"

# Get interface from marker file
IFACE=""
if [[ -f "$MARKER_FILE" ]]; then
    IFACE=$(cat "$MARKER_FILE")
fi

# Check 1: Interface is up
if [[ -n "$IFACE" ]] && ip link show "$IFACE" 2>/dev/null | grep -q "UP"; then
    print_pass "Interface $IFACE is UP"
elif ip link show 2>/dev/null | grep -E "(eth|ens|enp)" | grep -q "UP"; then
    print_pass "Network interface is UP"
else
    print_fail "Network interface is DOWN"
fi

# Check 2: Has IP address
if ip addr show 2>/dev/null | grep -E "inet [0-9]+\." | grep -v "127.0.0.1" | grep -q .; then
    print_pass "Has IP address assigned"
else
    print_fail "No IP address assigned"
fi

# Check 3: Can ping gateway or external
if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
    print_pass "Can reach external network"
else
    print_fail "Cannot reach external network"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 07 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

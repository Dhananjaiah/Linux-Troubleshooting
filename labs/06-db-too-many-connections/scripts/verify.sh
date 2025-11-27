#!/usr/bin/env bash
#
# Lab 06: Database Too Many Connections
# verify.sh - Checks if database is accessible
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 06: Too Many Connections"
echo "========================================"

# Check 1: Can connect to MySQL
if mysql -u root -e "SELECT 1" &>/dev/null; then
    print_pass "Can connect to MySQL"
else
    print_fail "Cannot connect to MySQL"
fi

# Check 2: Connection count below max
if mysql -u root -N -e "SELECT IF(@@max_connections - (SELECT COUNT(*) FROM information_schema.processlist) > 5, 'OK', 'FULL')" 2>/dev/null | grep -q "OK"; then
    print_pass "Connection pool has available slots"
else
    print_fail "Connection pool is still exhausted"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 06 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

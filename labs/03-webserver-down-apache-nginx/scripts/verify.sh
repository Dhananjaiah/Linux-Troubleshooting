#!/usr/bin/env bash
#
# Lab 03: Website Down Due to Apache/Nginx Failure
# verify.sh - Checks if web server is working
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 03: Website Down"
echo "========================================"

# Check 1: Nginx service running
if systemctl is-active --quiet nginx; then
    print_pass "Nginx service is running"
else
    print_fail "Nginx service is not running"
fi

# Check 2: Port 80 listening
if ss -tlnp | grep -q ":80 "; then
    print_pass "Port 80 is listening"
else
    print_fail "Port 80 is not listening"
fi

# Check 3: HTTP 200 response
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost 2>/dev/null)
if [[ "$HTTP_CODE" == "200" ]]; then
    print_pass "Website returns HTTP 200"
else
    print_fail "Website returns HTTP $HTTP_CODE (expected 200)"
fi

# Check 4: Config syntax valid
if nginx -t 2>/dev/null; then
    print_pass "Nginx configuration syntax is valid"
else
    print_fail "Nginx configuration has syntax errors"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 03 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo "[VERIFY] Checking Lab 22"
echo "========================================"

# Check if FD hog process is still running
if pgrep -f "fd-hog.sh" >/dev/null 2>&1; then
    print_fail "FD hog process still running"
else
    print_pass "FD hog process stopped"
fi

# Check FD usage is reasonable
if [[ $(ls /tmp/fd-test-* 2>/dev/null | wc -l) -lt 100 ]]; then
    print_pass "Test files cleaned up"
else
    print_fail "Test files still exist"
fi

echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 22 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

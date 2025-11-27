#!/usr/bin/env bash
#
# Lab 08: Permission Denied Even as Root
# verify.sh - Checks if file can be modified
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TARGET_FILE="/etc/important-config"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 08: Permission Denied Even as Root"
echo "========================================"

# Check 1: Immutable flag removed
ATTRS=$(lsattr "$TARGET_FILE" 2>/dev/null | cut -d' ' -f1)
if [[ "$ATTRS" != *"i"* ]]; then
    print_pass "Immutable attribute removed"
else
    print_fail "File is still immutable"
fi

# Check 2: Can modify file
if echo "verify-test" >> "$TARGET_FILE" 2>/dev/null; then
    print_pass "File can be modified"
    # Clean up test line
    sed -i '/verify-test/d' "$TARGET_FILE" 2>/dev/null
else
    print_fail "File cannot be modified"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 08 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

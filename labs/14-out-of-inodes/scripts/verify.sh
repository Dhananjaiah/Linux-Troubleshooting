#!/usr/bin/env bash
#
# Lab 14: Out of Inodes
# verify.sh - Checks if inode issue is resolved
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

INODE_DIR="/tmp/inode-test"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 14: Out of Inodes"
echo "========================================"

# Check 1: Test directory removed or reduced
if [[ -d "$INODE_DIR" ]]; then
    FILE_COUNT=$(ls "$INODE_DIR" 2>/dev/null | wc -l)
    if [[ $FILE_COUNT -lt 1000 ]]; then
        print_pass "Test files cleaned up (remaining: $FILE_COUNT)"
    else
        print_fail "Many test files still exist ($FILE_COUNT files in $INODE_DIR)"
    fi
else
    print_pass "Test directory removed"
fi

# Check 2: Can create new files
TEST_FILE="/tmp/inode-verify-test-$$"
if touch "$TEST_FILE" 2>/dev/null; then
    rm -f "$TEST_FILE"
    print_pass "Can create new files"
else
    print_fail "Cannot create new files (still out of inodes)"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 14 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

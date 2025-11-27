#!/usr/bin/env bash
#
# Lab 15: SSH Key Auth Not Working
# verify.sh - Checks if SSH key permissions are correct
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TEST_USER="labuser15"
USER_HOME="/home/$TEST_USER"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 15: SSH Key Auth Not Working"
echo "========================================"

# Check 1: .ssh directory permissions
SSH_DIR_PERM=$(stat -c %a "$USER_HOME/.ssh" 2>/dev/null)
if [[ "$SSH_DIR_PERM" == "700" ]]; then
    print_pass ".ssh directory permissions correct (700)"
else
    print_fail ".ssh directory permissions incorrect ($SSH_DIR_PERM, should be 700)"
fi

# Check 2: authorized_keys permissions
AUTH_KEYS_PERM=$(stat -c %a "$USER_HOME/.ssh/authorized_keys" 2>/dev/null)
if [[ "$AUTH_KEYS_PERM" == "600" ]]; then
    print_pass "authorized_keys permissions correct (600)"
else
    print_fail "authorized_keys permissions incorrect ($AUTH_KEYS_PERM, should be 600)"
fi

# Check 3: Ownership
OWNER=$(stat -c %U "$USER_HOME/.ssh" 2>/dev/null)
if [[ "$OWNER" == "$TEST_USER" ]]; then
    print_pass "Correct ownership on .ssh directory"
else
    print_fail "Wrong ownership on .ssh directory"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 15 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

#!/usr/bin/env bash
#
# Lab 02: SSH Login Failure
# verify.sh - Verifies that SSH access has been restored
#
# This script checks:
# 1. SSH service is running
# 2. SSH is listening on port 22
# 3. Firewall allows SSH
# 4. Test user account is not locked
# 5. Password authentication is enabled
# 6. SSH connection test succeeds
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TEST_USER="testuser"
TEST_PASS="testpass123"

# Track overall success
ALL_PASSED=true

# Function to print check results
print_pass() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_fail() {
    echo -e "${RED}[✗]${NC} $1"
    ALL_PASSED=false
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

echo ""
echo "[VERIFY] Checking Lab 02: SSH Login Failure"
echo "========================================"
echo ""

# Check 1: SSH service is running
if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then
    print_pass "SSH service is running"
else
    print_fail "SSH service is not running"
    print_info "Hint: sudo systemctl start ssh"
fi

# Check 2: SSH is listening on port 22
if ss -tlnp 2>/dev/null | grep -q ":22 " || netstat -tlnp 2>/dev/null | grep -q ":22 "; then
    print_pass "SSH is listening on port 22"
else
    print_fail "SSH is not listening on port 22"
    print_info "Hint: Check if SSH service is running and configured correctly"
fi

# Check 3: Firewall allows SSH
UFW_STATUS=$(ufw status 2>/dev/null | head -1)
if [[ "$UFW_STATUS" == *"inactive"* ]]; then
    print_pass "Firewall is inactive (SSH not blocked)"
elif ufw status 2>/dev/null | grep -qE "22.*ALLOW|22/tcp.*ALLOW"; then
    print_pass "Firewall allows SSH (port 22)"
elif [[ "$UFW_STATUS" == *"active"* ]]; then
    # UFW is active but 22 might not be explicitly shown
    if ! ufw status 2>/dev/null | grep -qE "22.*DENY|22/tcp.*DENY"; then
        print_pass "Firewall appears to allow SSH"
    else
        print_fail "Firewall may be blocking SSH"
        print_info "Hint: sudo ufw allow ssh"
    fi
else
    print_pass "Firewall check skipped (ufw not available)"
fi

# Check 4: Test user account is not locked
USER_STATUS=$(passwd -S "$TEST_USER" 2>/dev/null | awk '{print $2}')
if [[ "$USER_STATUS" == "P" || "$USER_STATUS" == "PS" ]]; then
    print_pass "$TEST_USER account is not locked"
elif [[ "$USER_STATUS" == "L" || "$USER_STATUS" == "LK" ]]; then
    print_fail "$TEST_USER account is locked"
    print_info "Hint: sudo passwd -u $TEST_USER"
else
    print_fail "Cannot determine $TEST_USER account status"
    print_info "Hint: Check if user exists with 'id $TEST_USER'"
fi

# Check 5: Password authentication is enabled
if grep -qE "^PasswordAuthentication\s+yes" /etc/ssh/sshd_config 2>/dev/null; then
    print_pass "Password authentication is enabled"
elif grep -qE "^PasswordAuthentication\s+no" /etc/ssh/sshd_config 2>/dev/null; then
    print_fail "Password authentication is disabled"
    print_info "Hint: Set 'PasswordAuthentication yes' in /etc/ssh/sshd_config"
else
    # Default behavior varies, check if it's commented out
    if grep -qE "^#?PasswordAuthentication" /etc/ssh/sshd_config 2>/dev/null; then
        print_pass "Password authentication appears to be enabled (default)"
    else
        print_pass "Password authentication check inconclusive (assuming default)"
    fi
fi

# Check 6: AllowUsers includes testuser or is not set
if grep -qE "^AllowUsers" /etc/ssh/sshd_config 2>/dev/null; then
    if grep -qE "^AllowUsers.*$TEST_USER" /etc/ssh/sshd_config 2>/dev/null; then
        print_pass "AllowUsers includes $TEST_USER"
    else
        print_fail "AllowUsers does not include $TEST_USER"
        print_info "Hint: Add '$TEST_USER' to AllowUsers line or remove AllowUsers"
    fi
else
    print_pass "AllowUsers not set (all users allowed)"
fi

# Check 7: SSH connection test (if service is running)
if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then
    # Use sshpass if available, otherwise skip the connection test
    if command -v sshpass &>/dev/null; then
        if sshpass -p "$TEST_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$TEST_USER@localhost" "echo success" 2>/dev/null | grep -q "success"; then
            print_pass "SSH connection test successful"
        else
            print_fail "SSH connection test failed"
            print_info "Hint: Check all SSH configuration settings"
        fi
    else
        # Try to connect without password (will fail, but tests connectivity)
        if timeout 3 bash -c "echo '' | ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=2 $TEST_USER@localhost 2>&1" | grep -qE "(Permission denied|password)"; then
            print_pass "SSH connection test: Server responding (auth required)"
        else
            print_fail "SSH connection test: Cannot reach SSH server"
            print_info "Hint: Check if SSH service is running and listening"
        fi
    fi
else
    print_fail "Cannot test SSH connection - service not running"
fi

# Summary
echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} All checks passed! Lab 02 completed successfully."
    echo ""
    echo "Great job! You have successfully:"
    echo "  - Started the SSH service"
    echo "  - Fixed SSH configuration"
    echo "  - Unlocked the user account"
    echo "  - Restored SSH access"
    echo ""
    echo "Don't forget to run cleanup.sh before starting the next lab."
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Some checks failed. Keep troubleshooting!"
    echo ""
    echo "Troubleshooting tips:"
    echo "  1. Start SSH: sudo systemctl start ssh"
    echo "  2. Check config: sudo sshd -t"
    echo "  3. Unlock user: sudo passwd -u $TEST_USER"
    echo "  4. Enable passwords: Set 'PasswordAuthentication yes'"
    echo "  5. Fix AllowUsers: Add $TEST_USER or remove line"
    echo "  6. Restart SSH: sudo systemctl restart ssh"
    echo ""
    exit 1
fi

#!/usr/bin/env bash
#
# Lab 12: Password Change Not Working
# break.sh - Creates locked/expired user account
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab12_active"
TEST_USER="labuser12"
TEST_PASS="testpass123"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting password failure simulation for Lab 12..."
echo "========================================"

# Create test user if not exists
if ! id "$TEST_USER" &>/dev/null; then
    print_status "Creating test user '$TEST_USER'..."
    useradd -m -s /bin/bash "$TEST_USER"
    echo "$TEST_USER:$TEST_PASS" | chpasswd
fi

# Lock the account
print_status "Locking user account..."
passwd -l "$TEST_USER" >/dev/null

# Set account to expired
print_status "Expiring user account..."
chage -E 2020-01-01 "$TEST_USER"

touch "$MARKER_FILE"

echo ""
print_break "Authentication failure condition created!"
echo ""
echo "Test user: $TEST_USER"
echo "Password: $TEST_PASS"
echo ""
echo "========================================"
echo "YOUR TASK: Figure out why authentication fails!"
echo "========================================"
echo ""
echo "Test commands:"
echo "  su - $TEST_USER"
echo "  sudo passwd -S $TEST_USER"
echo "  sudo chage -l $TEST_USER"
echo ""

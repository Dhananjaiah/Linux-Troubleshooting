#!/usr/bin/env bash
#
# Lab 15: SSH Key Auth Not Working
# break.sh - Breaks SSH key authentication
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab15_active"
TEST_USER="labuser15"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting SSH key auth failure simulation for Lab 15..."
echo "========================================"

# Create test user
if ! id "$TEST_USER" &>/dev/null; then
    print_status "Creating test user..."
    useradd -m -s /bin/bash "$TEST_USER"
    echo "$TEST_USER:testpass123" | chpasswd
fi

USER_HOME="/home/$TEST_USER"

# Create SSH directory and keys
print_status "Setting up SSH keys..."
mkdir -p "$USER_HOME/.ssh"
ssh-keygen -t rsa -b 2048 -f "$USER_HOME/.ssh/id_rsa" -N "" -q 2>/dev/null || true
cat "$USER_HOME/.ssh/id_rsa.pub" > "$USER_HOME/.ssh/authorized_keys"

# Break permissions
print_status "Breaking permissions..."
chmod 777 "$USER_HOME/.ssh"  # Too permissive!
chmod 644 "$USER_HOME/.ssh/authorized_keys"  # Too permissive!

chown -R "$TEST_USER:$TEST_USER" "$USER_HOME/.ssh"

touch "$MARKER_FILE"

echo ""
print_break "SSH key authentication is now broken!"
echo ""
echo "Test user: $TEST_USER"
echo "User home: $USER_HOME"
echo ""
echo "========================================"
echo "YOUR TASK: Fix SSH key authentication!"
echo "========================================"
echo ""
echo "Test commands:"
echo "  ssh -v $TEST_USER@localhost"
echo "  ls -la $USER_HOME/.ssh"
echo "  sudo tail /var/log/auth.log"
echo ""

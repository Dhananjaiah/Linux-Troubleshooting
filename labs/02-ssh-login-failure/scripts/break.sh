#!/usr/bin/env bash
#
# Lab 02: SSH Login Failure
# break.sh - Creates SSH authentication issues
#
# This script:
# 1. Backs up the current SSH configuration
# 2. Creates a test user
# 3. Introduces multiple SSH issues:
#    - Stops the SSH service
#    - Disables password authentication
#    - Adds restrictive AllowUsers
#    - Locks the test user account
#
# WARNING: Only run this on a test system!
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="/root/.ssh-lab-backup"
SSHD_CONFIG="/etc/ssh/sshd_config"
TEST_USER="testuser"
TEST_PASS="testpass123"

# Function to print colored status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_break() {
    echo -e "${RED}[BREAK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    echo "Usage: sudo $0"
    exit 1
fi

# Check if SSH is installed
if ! command -v sshd &>/dev/null; then
    echo "SSH server (openssh-server) is not installed."
    echo "Install it with: sudo apt install openssh-server"
    exit 1
fi

echo ""
print_break "Starting SSH failure simulation for Lab 02..."
echo "========================================"
echo ""

# Step 1: Create backup directory
print_status "Creating backup directory..."
mkdir -p "$BACKUP_DIR"

# Step 2: Backup current SSH configuration
if [[ -f "$SSHD_CONFIG" ]]; then
    print_status "Backing up current SSH configuration..."
    cp "$SSHD_CONFIG" "$BACKUP_DIR/sshd_config.backup"
fi

# Backup AllowUsers/DenyUsers state
grep -E "^(AllowUsers|DenyUsers|PasswordAuthentication)" "$SSHD_CONFIG" > "$BACKUP_DIR/ssh_settings.backup" 2>/dev/null || true

# Step 3: Create test user if it doesn't exist
if ! id "$TEST_USER" &>/dev/null; then
    print_status "Creating test user '$TEST_USER'..."
    useradd -m -s /bin/bash "$TEST_USER"
    echo "$TEST_USER:$TEST_PASS" | chpasswd
else
    print_status "Test user '$TEST_USER' already exists"
    # Reset password anyway
    echo "$TEST_USER:$TEST_PASS" | chpasswd
fi

# Step 4: Apply SSH misconfigurations

print_status "Applying SSH misconfigurations..."

# 4a: Disable password authentication
if grep -q "^PasswordAuthentication" "$SSHD_CONFIG"; then
    sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
elif grep -q "^#PasswordAuthentication" "$SSHD_CONFIG"; then
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
else
    echo "PasswordAuthentication no" >> "$SSHD_CONFIG"
fi

# 4b: Add restrictive AllowUsers (excluding testuser)
# First remove any existing AllowUsers/DenyUsers
sed -i '/^AllowUsers/d' "$SSHD_CONFIG"
sed -i '/^DenyUsers/d' "$SSHD_CONFIG"
# Add AllowUsers with only root (testuser not included)
echo "AllowUsers root" >> "$SSHD_CONFIG"

# Step 5: Lock the test user account
print_status "Locking test user account..."
passwd -l "$TEST_USER" >/dev/null 2>&1

# Step 6: Stop the SSH service
print_status "Stopping SSH service..."
systemctl stop ssh 2>/dev/null || systemctl stop sshd 2>/dev/null || true

# Create a marker file to indicate the lab is active
touch "$BACKUP_DIR/.lab02_active"

# Summary
echo ""
echo "========================================"
print_break "SSH is now broken!"
echo ""
echo "Multiple issues have been introduced:"
echo "  1. SSH service is stopped"
echo "  2. Password authentication is disabled"
echo "  3. AllowUsers restricts who can log in"
echo "  4. Test user account is locked"
echo ""
echo "Test user credentials:"
echo "  Username: $TEST_USER"
echo "  Password: $TEST_PASS"
echo ""
echo "========================================"
echo "YOUR TASK: Restore SSH access for users!"
echo "========================================"
echo ""
echo "Useful commands to start:"
echo "  sudo systemctl status ssh"
echo "  sudo journalctl -xe -u ssh"
echo "  sudo cat /etc/ssh/sshd_config"
echo "  sudo passwd -S $TEST_USER"
echo ""

#!/usr/bin/env bash
#
# Lab 02: SSH Login Failure
# cleanup.sh - Restores the system to a clean state
#
# This script:
# 1. Restores the original SSH configuration
# 2. Removes the test user
# 3. Restarts the SSH service
#

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="/root/.ssh-lab-backup"
SSHD_CONFIG="/etc/ssh/sshd_config"
TEST_USER="testuser"

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_cleanup() {
    echo -e "${YELLOW}[CLEANUP]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    echo "Usage: sudo $0"
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 02..."
echo "========================================"
echo ""

# Step 1: Restore original SSH configuration
if [[ -f "$BACKUP_DIR/sshd_config.backup" ]]; then
    print_status "Restoring original SSH configuration..."
    cp "$BACKUP_DIR/sshd_config.backup" "$SSHD_CONFIG"
else
    print_status "No backup found, fixing SSH configuration manually..."
    
    # Enable password authentication
    if grep -q "^PasswordAuthentication" "$SSHD_CONFIG"; then
        sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"
    fi
    
    # Remove AllowUsers line if it was added by the lab
    sed -i '/^AllowUsers root$/d' "$SSHD_CONFIG"
fi

# Step 2: Remove the test user
if id "$TEST_USER" &>/dev/null; then
    print_status "Removing test user '$TEST_USER'..."
    
    # Kill any processes owned by the user
    pkill -u "$TEST_USER" 2>/dev/null || true
    
    # Remove the user and their home directory
    if ! userdel -r "$TEST_USER" 2>/dev/null; then
        # If home directory removal fails, try removing user only
        print_status "Note: Home directory removal may have failed, removing user only..."
        userdel "$TEST_USER" 2>/dev/null || true
    fi
else
    print_status "Test user '$TEST_USER' does not exist"
fi

# Step 3: Remove backup directory
if [[ -d "$BACKUP_DIR" ]]; then
    print_status "Removing backup files..."
    rm -rf "$BACKUP_DIR"
fi

# Step 4: Restart SSH service
print_status "Restarting SSH service..."
systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null || true

# Verify SSH is running
sleep 1
if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then
    print_status "SSH service is running"
else
    print_status "Warning: SSH service may not be running"
fi

# Summary
echo ""
echo "========================================"
print_cleanup "Environment restored to clean state."
echo ""
echo "Cleanup complete! You can now:"
echo "  - Run this lab again with: sudo ./scripts/break.sh"
echo "  - Move to the next lab: cd ../03-webserver-down-apache-nginx"
echo ""

# Show SSH service status
echo "SSH service status:"
systemctl is-active ssh 2>/dev/null || systemctl is-active sshd 2>/dev/null || echo "unknown"
echo ""

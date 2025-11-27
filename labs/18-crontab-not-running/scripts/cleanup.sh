#!/usr/bin/env bash
#
# Lab 18: Crontab Not Running
# cleanup.sh - Removes test user and cron setup
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TEST_USER="labuser18"
MARKER_FILE="/tmp/.lab18_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 18..."
echo "========================================"

# Remove crontab
crontab -r -u "$TEST_USER" 2>/dev/null || true

# Remove test user
if id "$TEST_USER" &>/dev/null; then
    userdel -r "$TEST_USER" 2>/dev/null || true
fi

# Start cron service
systemctl start cron 2>/dev/null || true

# Remove log directory
rm -rf /var/log/backup-lab18
rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored to clean state."
echo ""

#!/usr/bin/env bash
#
# Lab 15: SSH Key Auth Not Working
# cleanup.sh - Removes test user
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TEST_USER="labuser15"
MARKER_FILE="/tmp/.lab15_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 15..."
echo "========================================"

if id "$TEST_USER" &>/dev/null; then
    print_status "Removing test user..."
    userdel -r "$TEST_USER" 2>/dev/null || true
fi

rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored to clean state."
echo ""

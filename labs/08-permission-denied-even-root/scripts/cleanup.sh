#!/usr/bin/env bash
#
# Lab 08: Permission Denied Even as Root
# cleanup.sh - Removes test file
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TARGET_FILE="/etc/important-config"
MARKER_FILE="/tmp/.lab08_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 08..."
echo "========================================"

# Remove immutable flag if set
print_status "Removing file attributes..."
chattr -i "$TARGET_FILE" 2>/dev/null || true

# Remove file
print_status "Removing test file..."
rm -f "$TARGET_FILE" "$MARKER_FILE"

echo ""
print_cleanup "Environment restored to clean state."
echo ""

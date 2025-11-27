#!/usr/bin/env bash
#
# Lab 14: Out of Inodes
# cleanup.sh - Removes test files
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

INODE_DIR="/tmp/inode-test"
MARKER_FILE="/tmp/.lab14_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 14..."
echo "========================================"

if [[ -d "$INODE_DIR" ]]; then
    print_status "Removing test files..."
    rm -rf "$INODE_DIR"
fi

rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored to clean state."
echo ""
echo "Inode usage:"
df -i / | head -2
echo ""

#!/usr/bin/env bash
#
# Lab 16: NFS Mount Failure
# cleanup.sh - Removes NFS setup
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab16_active"
NFS_SHARE="/srv/nfs_share"
NFS_MOUNT="/mnt/nfs"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 16..."
echo "========================================"

# Unmount
print_status "Unmounting NFS share..."
umount "$NFS_MOUNT" 2>/dev/null || true

# Clear exports
print_status "Clearing exports..."
echo "" > /etc/exports
exportfs -ra 2>/dev/null || true

# Remove directories
rm -rf "$NFS_SHARE" "$NFS_MOUNT"
rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored to clean state."
echo ""

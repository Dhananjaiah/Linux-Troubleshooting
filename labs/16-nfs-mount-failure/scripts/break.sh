#!/usr/bin/env bash
#
# Lab 16: NFS Mount Failure
# break.sh - Breaks NFS mount
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab16_active"
NFS_SHARE="/srv/nfs_share"
NFS_MOUNT="/mnt/nfs"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting NFS mount failure simulation for Lab 16..."
echo "========================================"

# Install NFS if needed
if ! command -v exportfs &>/dev/null; then
    print_status "Installing NFS packages..."
    apt-get update && apt-get install -y nfs-kernel-server nfs-common
fi

# Create NFS share directory
mkdir -p "$NFS_SHARE"
echo "This is shared NFS content" > "$NFS_SHARE/test-file.txt"

# Create mount point
mkdir -p "$NFS_MOUNT"

# Configure export
echo "$NFS_SHARE localhost(rw,sync,no_subtree_check)" > /etc/exports

# Break by stopping the service
print_status "Breaking NFS service..."
systemctl stop nfs-server 2>/dev/null || true
systemctl stop rpcbind 2>/dev/null || true

touch "$MARKER_FILE"

echo ""
print_break "NFS is now broken!"
echo ""
echo "========================================"
echo "YOUR TASK: Fix the NFS mount!"
echo "========================================"
echo ""
echo "Test commands:"
echo "  sudo mount -t nfs localhost:$NFS_SHARE $NFS_MOUNT"
echo "  showmount -e localhost"
echo "  sudo systemctl status nfs-server"
echo ""

#!/usr/bin/env bash
#
# Lab 16: NFS Mount Failure
# verify.sh - Checks if NFS is working
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

NFS_SHARE="/srv/nfs_share"
NFS_MOUNT="/mnt/nfs"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 16: NFS Mount Failure"
echo "========================================"

# Check 1: NFS server running
if systemctl is-active --quiet nfs-server; then
    print_pass "NFS server is running"
else
    print_fail "NFS server is not running"
fi

# Check 2: Export visible
if showmount -e localhost 2>/dev/null | grep -q "$NFS_SHARE"; then
    print_pass "NFS export is visible"
else
    print_fail "NFS export not visible"
fi

# Check 3: Mount accessible (if mounted)
if mount | grep -q "$NFS_MOUNT"; then
    print_pass "NFS share is mounted"
else
    print_fail "NFS share is not mounted"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 16 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

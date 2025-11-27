#!/usr/bin/env bash
#
# Lab 10: Disk I/O Slowness
# cleanup.sh - Stops I/O stress and cleans up
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab10_active"
IO_SCRIPT="/tmp/io-stress.sh"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 10..."
echo "========================================"

print_status "Stopping I/O stress processes..."
pkill -f "io-stress.sh" 2>/dev/null || true

print_status "Removing temporary files..."
rm -f "$MARKER_FILE" "$IO_SCRIPT" /tmp/io-test-file

echo ""
print_cleanup "Environment restored to clean state."
echo ""

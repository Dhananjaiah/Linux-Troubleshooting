#!/usr/bin/env bash
#
# Lab 09: Wrong System Time
# cleanup.sh - Restores time synchronization
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab09_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 09..."
echo "========================================"

# Re-enable NTP
print_status "Enabling NTP synchronization..."
timedatectl set-ntp true 2>/dev/null || true

# Wait for sync
sleep 2

rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored."
echo ""
echo "Current time: $(date)"
echo ""

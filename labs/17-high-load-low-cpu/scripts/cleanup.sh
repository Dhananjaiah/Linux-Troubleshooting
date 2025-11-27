#!/usr/bin/env bash
#
# Lab 17: High Load Low CPU
# cleanup.sh - Stops load processes
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab17_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 17..."
echo "========================================"

# Remove marker to stop loops
rm -f "$MARKER_FILE"

# Kill any remaining dd processes from this lab
pkill -f "io-load-" 2>/dev/null || true

# Clean temp files
rm -f /tmp/io-load-*

sleep 2

echo ""
print_cleanup "Environment restored to clean state."
echo ""
echo "Current load: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
echo ""

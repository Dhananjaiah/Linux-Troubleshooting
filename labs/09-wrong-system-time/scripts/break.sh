#!/usr/bin/env bash
#
# Lab 09: Wrong System Time
# break.sh - Sets incorrect system time
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab09_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting wrong time simulation for Lab 09..."
echo "========================================"

# Save current NTP status
timedatectl show --property=NTP > "$MARKER_FILE"

# Disable NTP
print_status "Disabling NTP synchronization..."
timedatectl set-ntp false 2>/dev/null || true

# Set time to 8 hours in the past
print_status "Setting incorrect system time..."
WRONG_TIME=$(date -d "8 hours ago" "+%Y-%m-%d %H:%M:%S")
timedatectl set-time "$WRONG_TIME" 2>/dev/null || date -s "$WRONG_TIME" 2>/dev/null || true

echo ""
print_break "System time is now incorrect!"
echo ""
echo "Current system time: $(date)"
echo "Actual time is approximately 8 hours ahead."
echo ""
echo "========================================"
echo "YOUR TASK: Correct the system time!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  date"
echo "  timedatectl status"
echo "  sudo timedatectl set-ntp true"
echo ""

#!/usr/bin/env bash
#
# Lab 17: High Load Low CPU
# break.sh - Creates high load without high CPU
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab17_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting high load simulation for Lab 17..."
echo "========================================"

# Create I/O-bound processes that will cause high load
print_status "Creating I/O-bound processes..."

# Use sync writes to create I/O wait
for i in {1..4}; do
    (
        while [[ -f "$MARKER_FILE" ]]; do
            dd if=/dev/zero of=/tmp/io-load-$i bs=1M count=10 conv=fdatasync 2>/dev/null
            sync
            sleep 1
        done
    ) &
done

touch "$MARKER_FILE"

sleep 3

echo ""
print_break "High load condition created!"
echo ""
echo "========================================"
echo "YOUR TASK: Find why load is high but CPU isn't!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  uptime"
echo "  vmstat 1 5"
echo "  iostat -x 1"
echo "  ps aux | awk '\$8 ~ /D/'"
echo ""

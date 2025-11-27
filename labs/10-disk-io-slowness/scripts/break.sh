#!/usr/bin/env bash
#
# Lab 10: Disk I/O Slowness
# break.sh - Creates high disk I/O load
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab10_active"
IO_SCRIPT="/tmp/io-stress.sh"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting I/O slowness simulation for Lab 10..."
echo "========================================"

# Install iotop if needed
if ! command -v iotop &>/dev/null; then
    apt-get update && apt-get install -y iotop sysstat
fi

# Create I/O stress script
cat > "$IO_SCRIPT" << 'EOF'
#!/bin/bash
# I/O stress script - continuous disk read/write
while true; do
    dd if=/dev/zero of=/tmp/io-test-file bs=1M count=100 conv=fdatasync 2>/dev/null
    dd if=/tmp/io-test-file of=/dev/null bs=1M 2>/dev/null
done
EOF
chmod +x "$IO_SCRIPT"

print_status "Starting I/O-intensive process..."
nohup "$IO_SCRIPT" >/dev/null 2>&1 &
echo "$!" > "$MARKER_FILE"

sleep 2

echo ""
print_break "High I/O condition created!"
echo ""
echo "========================================"
echo "YOUR TASK: Find and stop the I/O-heavy process!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  top  (look at %wa column)"
echo "  iostat -x 1"
echo "  sudo iotop"
echo ""

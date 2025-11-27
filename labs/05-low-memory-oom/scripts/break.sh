#!/usr/bin/env bash
#
# Lab 05: Low Memory / OOM
# break.sh - Creates low memory condition
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab05_active"
MEMORY_SCRIPT="/tmp/memory-hog.sh"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

echo ""
print_break "Starting low memory simulation for Lab 05..."
echo "========================================"

# Get available memory in MB
TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
# Allocate 60% of memory to leave some room
ALLOC_MEM=$((TOTAL_MEM * 60 / 100))

print_status "Total system memory: ${TOTAL_MEM}MB"
print_status "Will allocate: ${ALLOC_MEM}MB"

# Create memory consumption script
cat > "$MEMORY_SCRIPT" << 'EOF'
#!/bin/bash
# Memory hog script - allocates and holds memory
# Uses bash array to consume memory

declare -a MEM_ARRAY
CHUNK_SIZE=10000000  # Characters per chunk

# Keep allocating memory
for i in {1..100}; do
    MEM_ARRAY[$i]=$(head -c $CHUNK_SIZE /dev/urandom | base64)
    sleep 0.5
done

# Hold the memory
while true; do
    sleep 60
done
EOF
chmod +x "$MEMORY_SCRIPT"

print_status "Starting memory-intensive process..."

# Start memory hog in background
nohup "$MEMORY_SCRIPT" >/dev/null 2>&1 &
MEM_PID=$!
echo "$MEM_PID" > "$MARKER_FILE"

# Wait for memory to be consumed
print_status "Waiting for memory allocation..."
sleep 10

echo ""
print_break "Low memory condition created!"
echo ""
echo "========================================"
echo "YOUR TASK: Find the memory hog and free up memory!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  free -h"
echo "  ps aux --sort=-%mem | head"
echo "  top (press M to sort by memory)"
echo "  dmesg | grep -i oom"
echo ""

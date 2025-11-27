#!/usr/bin/env bash
#
# Lab 05: Low Memory / OOM
# cleanup.sh - Stops memory hog and cleans up
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab05_active"
MEMORY_SCRIPT="/tmp/memory-hog.sh"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 05..."
echo "========================================"

# Kill memory hog processes
print_status "Stopping memory hog processes..."
pkill -f "memory-hog.sh" 2>/dev/null || true

# Clear caches to free memory faster
print_status "Clearing system caches..."
sync
echo 3 > /proc/sys/vm/drop_caches

# Remove files
print_status "Removing temporary files..."
rm -f "$MARKER_FILE" "$MEMORY_SCRIPT"

echo ""
print_cleanup "Environment restored to clean state."
echo ""
echo "Current memory status:"
free -h
echo ""

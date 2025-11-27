#!/usr/bin/env bash
#
# Lab 04: High CPU Usage
# cleanup.sh - Stops stress processes and cleans up
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab04_active"
STRESS_SCRIPT="/tmp/cpu-stress.sh"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 04..."
echo "========================================"

# Kill any remaining stress processes
print_status "Stopping any running stress processes..."
pkill -f "cpu-stress.sh" 2>/dev/null || true

# Remove files
print_status "Removing temporary files..."
rm -f "$MARKER_FILE" "$STRESS_SCRIPT"

echo ""
print_cleanup "Environment restored to clean state."
echo ""

#!/usr/bin/env bash
#
# Lab 11: Kernel Panic on Boot
# cleanup.sh - Removes simulation files
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab11_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 11..."
echo "========================================"

print_status "Removing simulation files..."
rm -rf /var/log/lab-simulation
rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored to clean state."
echo ""

#!/usr/bin/env bash
#
# Lab 07: Network Interface Down
# cleanup.sh - Restores network to original state
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab07_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 07..."
echo "========================================"

# Get interface from marker
if [[ -f "$MARKER_FILE" ]]; then
    IFACE=$(cat "$MARKER_FILE")
    print_status "Restoring interface $IFACE..."
    ip link set "$IFACE" up 2>/dev/null || true
    dhclient "$IFACE" 2>/dev/null || true
fi

# Clean up backup files
rm -f /tmp/.network_backup_* /tmp/.route_backup "$MARKER_FILE"

echo ""
print_cleanup "Environment restored."
echo ""
echo "Network status:"
ip addr show | grep -E "^[0-9]+:|inet "
echo ""

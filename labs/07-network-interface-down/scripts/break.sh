#!/usr/bin/env bash
#
# Lab 07: Network Interface Down
# break.sh - Brings down network interface
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab07_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting network interface down simulation for Lab 07..."
echo "========================================"
print_warning "This will disable your primary network interface!"
print_warning "Ensure you have console access to this machine."
echo ""
read -p "Continue? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Aborted."
    exit 0
fi

# Find the primary interface (not lo)
IFACE=$(ip route | grep default | awk '{print $5}' | head -1)
if [[ -z "$IFACE" ]]; then
    IFACE=$(ip link show | grep -E "^[0-9]+: (eth|ens|enp)" | head -1 | cut -d: -f2 | tr -d ' ')
fi

if [[ -z "$IFACE" ]]; then
    echo "Could not determine network interface. Aborting."
    exit 1
fi

print_status "Primary interface detected: $IFACE"

# Save current config
ip addr show "$IFACE" > /tmp/.network_backup_$IFACE
ip route show > /tmp/.route_backup
echo "$IFACE" > "$MARKER_FILE"

# Bring interface down
print_status "Bringing down $IFACE..."
ip link set "$IFACE" down

echo ""
print_break "Network interface is DOWN!"
echo ""
echo "========================================"
echo "YOUR TASK: Restore network connectivity!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  ip link show"
echo "  ip addr show"
echo "  sudo ip link set $IFACE up"
echo "  sudo dhclient $IFACE"
echo ""

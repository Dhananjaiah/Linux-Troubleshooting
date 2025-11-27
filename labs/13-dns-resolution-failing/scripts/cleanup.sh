#!/usr/bin/env bash
#
# Lab 13: DNS Resolution Failing
# cleanup.sh - Restores DNS configuration
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab13_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 13..."
echo "========================================"

# Restore backup if exists
if [[ -f /tmp/.resolv.conf.backup ]]; then
    print_status "Restoring original resolv.conf..."
    cp /tmp/.resolv.conf.backup /etc/resolv.conf
    rm -f /tmp/.resolv.conf.backup
else
    print_status "Setting default DNS (Google)..."
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
fi

# Restart systemd-resolved
systemctl restart systemd-resolved 2>/dev/null || true

rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored."
echo ""
echo "DNS test:"
host google.com 2>/dev/null && echo "DNS is working!" || echo "Note: DNS may need a moment"
echo ""

#!/usr/bin/env bash
#
# Lab 13: DNS Resolution Failing
# break.sh - Breaks DNS resolution
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab13_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting DNS failure simulation for Lab 13..."
echo "========================================"

# Backup current resolv.conf
if [[ -f /etc/resolv.conf ]]; then
    cp /etc/resolv.conf /tmp/.resolv.conf.backup
fi

# Break DNS by pointing to invalid server
print_status "Breaking DNS configuration..."
chattr -i /etc/resolv.conf 2>/dev/null || true
cat > /etc/resolv.conf << EOF
# Broken DNS configuration
nameserver 192.0.2.1
EOF

touch "$MARKER_FILE"

echo ""
print_break "DNS is now broken!"
echo ""
echo "========================================"
echo "YOUR TASK: Fix DNS resolution!"
echo "========================================"
echo ""
echo "Test commands:"
echo "  ping google.com    # Should fail"
echo "  ping 8.8.8.8       # Should work"
echo "  cat /etc/resolv.conf"
echo ""

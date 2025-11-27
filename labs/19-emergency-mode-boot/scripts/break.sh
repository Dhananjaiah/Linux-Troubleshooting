#!/usr/bin/env bash
#
# Lab 19: Emergency Mode Boot
# break.sh - Simulates fstab issue
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab19_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting emergency mode simulation for Lab 19..."
echo "========================================"

# Backup fstab
cp /etc/fstab /etc/fstab.backup.lab19

# Create simulated emergency log
mkdir -p /var/log/lab-simulation
cat > /var/log/lab-simulation/emergency-boot.log << 'EOF'
systemd[1]: Starting File System Check...
systemd[1]: Failed to mount /mnt/data.
systemd[1]: Dependency failed for Local File Systems.
systemd[1]: Emergency mode activated.

The system is in emergency mode. After logging in, type "journalctl -xb" to view
system logs, "systemctl reboot" to reboot, "systemctl default" to try again to
boot into default mode.

Give root password for maintenance
(or press Control-D to continue):
EOF

# Add a bad entry to fstab (with nofail so it won't actually break boot)
echo "# Lab 19 bad entry - non-existent device" >> /etc/fstab
echo "UUID=12345678-1234-5678-1234-567812345678 /mnt/data ext4 defaults,nofail 0 0" >> /etc/fstab

touch "$MARKER_FILE"

echo ""
print_break "Emergency mode simulation created!"
echo ""
echo "Simulated boot log at: /var/log/lab-simulation/emergency-boot.log"
echo ""
echo "========================================"
echo "YOUR TASK: Find and fix the fstab issue!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  cat /var/log/lab-simulation/emergency-boot.log"
echo "  cat /etc/fstab"
echo "  sudo blkid"
echo ""

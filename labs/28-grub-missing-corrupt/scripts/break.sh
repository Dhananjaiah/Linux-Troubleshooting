#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab28_active"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating GRUB recovery simulation..."

# Create simulated GRUB rescue log
mkdir -p /var/log/lab-simulation
cat > /var/log/lab-simulation/grub-recovery.log << 'EOF'
GRUB loading.
error: no such partition.
Entering rescue mode...
grub rescue>

Recovery steps:
1. Boot from live USB
2. Mount partitions
3. Run: grub-install /dev/sda
4. Run: update-grub
5. Reboot
EOF

touch "$MARKER_FILE"

echo ""
echo "GRUB recovery simulation created!"
echo ""
echo "Review: cat /var/log/lab-simulation/grub-recovery.log"
echo ""
echo "Key recovery commands:"
echo "  sudo grub-install /dev/sda"
echo "  sudo update-grub"

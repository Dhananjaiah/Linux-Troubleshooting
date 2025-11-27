#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab23_active"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating disk detection simulation for Lab 23..."

# Create simulated dmesg output
mkdir -p /var/log/lab-simulation
cat > /var/log/lab-simulation/disk-detection.log << 'EOF'
[timestamp] scsi host0: target 0:0:1: adding device
[timestamp] sd 0:0:1:0: [sdb] 41943040 512-byte logical blocks
[timestamp] sd 0:0:1:0: [sdb] Write Protect is off
[timestamp] sd 0:0:1:0: Attached SCSI disk
EOF

touch "$MARKER_FILE"

echo ""
echo "Disk detection simulation created!"
echo ""
echo "This lab simulates a scenario where a new disk isn't detected."
echo ""
echo "In a real scenario, you would run:"
echo "  echo '- - -' > /sys/class/scsi_host/host0/scan"
echo ""
echo "Review the simulation log:"
echo "  cat /var/log/lab-simulation/disk-detection.log"

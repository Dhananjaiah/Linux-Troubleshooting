#!/usr/bin/env bash
echo "[VERIFY] Checking Lab 23"
echo "========================================"

if [[ -f /var/log/lab-simulation/disk-detection.log ]]; then
    echo "[✓] Simulation files present - review the concepts"
    echo ""
    echo "Key commands for detecting new disks:"
    echo "  echo '- - -' > /sys/class/scsi_host/host0/scan"
    echo "  lsblk"
    echo "  dmesg | tail"
    exit 0
else
    echo "[!] Run break.sh first"
    exit 1
fi

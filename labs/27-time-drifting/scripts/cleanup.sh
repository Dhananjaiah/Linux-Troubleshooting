#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Re-enabling NTP..."
timedatectl set-ntp true 2>/dev/null || true
rm -f /tmp/.ntp_backup /tmp/.lab27_active
echo "Cleanup complete."

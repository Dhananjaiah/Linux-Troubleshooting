#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab27_active"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating time drift simulation..."

# Save NTP status
timedatectl show --property=NTP > /tmp/.ntp_backup

# Disable NTP
timedatectl set-ntp false 2>/dev/null || true

touch "$MARKER_FILE"

echo ""
echo "NTP disabled - time will drift!"
echo ""
echo "YOUR TASK: Re-enable time synchronization!"
echo ""
echo "Useful commands:"
echo "  timedatectl status"
echo "  chronyc tracking"
echo "  sudo timedatectl set-ntp true"

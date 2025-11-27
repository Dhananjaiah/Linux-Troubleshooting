#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Removing simulation files..."
rm -rf /var/log/lab-simulation /tmp/.lab23_active
echo "Cleanup complete."

#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Stopping log flood..."
pkill -f "log-flood.sh" 2>/dev/null || true
rm -f /tmp/log-flood.sh /tmp/.lab25_active
echo "Cleanup complete."

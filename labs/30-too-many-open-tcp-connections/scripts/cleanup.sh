#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Killing test connections..."
pkill -f "nc -l 0 1" 2>/dev/null || true
rm -f /tmp/.lab30_active
echo "Cleanup complete."

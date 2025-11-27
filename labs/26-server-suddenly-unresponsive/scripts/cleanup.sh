#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Killing runaway processes..."

# Kill all bash processes with high CPU that are just looping
pkill -f "while true; do :; done" 2>/dev/null || true

# Also try killing background jobs from this script
jobs -p | xargs -r kill 2>/dev/null || true

rm -f /tmp/.lab26_active
echo "Cleanup complete."

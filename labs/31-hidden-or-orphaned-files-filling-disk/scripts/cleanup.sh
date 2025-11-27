#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Stopping file holder..."
pkill -f "file-holder.sh" 2>/dev/null || true
rm -f /tmp/file-holder.sh /tmp/deleted-but-open.dat /tmp/.lab31_active
echo "Cleanup complete."

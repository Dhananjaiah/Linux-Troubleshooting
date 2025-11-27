#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Stopping FD hog and cleaning up..."

pkill -f "fd-hog.sh" 2>/dev/null || true
rm -f /tmp/fd-test-* /tmp/fd-hog.sh /tmp/.lab22_active

echo "Cleanup complete."

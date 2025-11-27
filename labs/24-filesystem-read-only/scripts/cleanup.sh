#!/usr/bin/env bash
TEST_DIR="/tmp/lab24-test"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Unmounting and cleaning..."
umount "$TEST_DIR" 2>/dev/null || true
rm -rf "$TEST_DIR" /tmp/.lab24_active
echo "Cleanup complete."

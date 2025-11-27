#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab24_active"
TEST_DIR="/tmp/lab24-test"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating read-only filesystem simulation..."

# Create a test directory with tmpfs mounted read-only
mkdir -p "$TEST_DIR"
mount -t tmpfs -o ro,size=10M tmpfs "$TEST_DIR" 2>/dev/null || true

touch "$MARKER_FILE"

echo ""
echo "Read-only mount created at $TEST_DIR"
echo ""
echo "YOUR TASK: Make the filesystem writable!"
echo ""
echo "Test commands:"
echo "  touch $TEST_DIR/test-file"
echo "  mount | grep $TEST_DIR"
echo "  sudo mount -o remount,rw $TEST_DIR"

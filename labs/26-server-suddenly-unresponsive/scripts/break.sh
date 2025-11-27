#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab26_active"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating unresponsive system simulation..."

# Start multiple CPU-hungry processes
for i in {1..4}; do
    (while true; do :; done) &
done

echo $! > "$MARKER_FILE"

echo ""
echo "System is now under heavy load!"
echo ""
echo "YOUR TASK: Identify and stop the runaway processes!"
echo ""
echo "Useful commands:"
echo "  top"
echo "  ps aux --sort=-%cpu | head"
echo "  uptime"

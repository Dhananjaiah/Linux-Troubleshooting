#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

MARKER_FILE="/tmp/.lab26_active"

echo "[CLEANUP] Killing runaway processes..."

# Kill PIDs stored in marker file
if [[ -f "$MARKER_FILE" ]]; then
    PIDS=$(cat "$MARKER_FILE")
    for pid in $PIDS; do
        kill "$pid" 2>/dev/null || true
    done
fi

# Also try the pattern-based approach as backup
pkill -f "while true; do :; done" 2>/dev/null || true

rm -f "$MARKER_FILE"
echo "Cleanup complete."

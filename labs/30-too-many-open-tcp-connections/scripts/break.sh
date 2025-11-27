#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab30_active"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating TCP connection simulation..."

# Create many connections to localhost (safe)
for i in {1..100}; do
    (nc -l 0 $((10000 + i)) &) 2>/dev/null
done

touch "$MARKER_FILE"

echo ""
echo "Many connections created!"
echo ""
echo "YOUR TASK: Analyze TCP connections!"
echo ""
echo "Useful commands:"
echo "  ss -s"
echo "  ss -antp | head -20"
echo "  netstat -ant | wc -l"

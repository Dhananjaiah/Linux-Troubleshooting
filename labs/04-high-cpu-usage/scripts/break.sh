#!/usr/bin/env bash
#
# Lab 04: High CPU Usage
# break.sh - Creates high CPU usage condition
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab04_active"
STRESS_SCRIPT="/tmp/cpu-stress.sh"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

echo ""
print_break "Starting high CPU simulation for Lab 04..."
echo "========================================"

# Create CPU stress script
cat > "$STRESS_SCRIPT" << 'EOF'
#!/bin/bash
# CPU stress script - infinite loop
while true; do
    # Busy loop to consume CPU
    : $((i++))
done
EOF
chmod +x "$STRESS_SCRIPT"

print_status "Starting CPU-intensive process..."

# Start stress process in background
nohup "$STRESS_SCRIPT" >/dev/null 2>&1 &
STRESS_PID=$!
echo "$STRESS_PID" > "$MARKER_FILE"

# Give it a moment to start
sleep 2

echo ""
print_break "High CPU condition created!"
echo ""
echo "Process PID: $STRESS_PID"
echo ""
echo "========================================"
echo "YOUR TASK: Find and stop the runaway process!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  top"
echo "  htop"
echo "  ps aux --sort=-%cpu | head"
echo ""

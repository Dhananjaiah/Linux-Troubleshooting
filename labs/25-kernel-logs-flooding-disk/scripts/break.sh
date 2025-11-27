#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab25_active"
LOG_SCRIPT="/tmp/log-flood.sh"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Starting log flooding simulation..."

# Create log flooding script
cat > "$LOG_SCRIPT" << 'EOF'
#!/bin/bash
while true; do
    logger -t "LOG-FLOOD" "Simulated log message at $(date)"
    sleep 0.1
done
EOF
chmod +x "$LOG_SCRIPT"

# Start flooding in background
nohup "$LOG_SCRIPT" >/dev/null 2>&1 &
echo $! > "$MARKER_FILE"

sleep 3

echo ""
echo "Log flooding started!"
echo ""
echo "YOUR TASK: Stop the log flood and clean up!"
echo ""
echo "Useful commands:"
echo "  tail -f /var/log/syslog"
echo "  du -sh /var/log/*"
echo "  ps aux | grep log"

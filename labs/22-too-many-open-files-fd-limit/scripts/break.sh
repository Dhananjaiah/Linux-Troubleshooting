#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab22_active"
FD_SCRIPT="/tmp/fd-hog.sh"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating file descriptor exhaustion simulation..."

# Create script that opens many files
cat > "$FD_SCRIPT" << 'EOF'
#!/bin/bash
# Open many file descriptors
exec 3>/dev/null
for i in {1..1000}; do
    exec {fd}>/tmp/fd-test-$i 2>/dev/null || break
done
sleep 3600
EOF
chmod +x "$FD_SCRIPT"

# Run it in background
nohup "$FD_SCRIPT" >/dev/null 2>&1 &
echo $! > "$MARKER_FILE"

sleep 2

echo ""
echo "File descriptor hog started!"
echo ""
echo "YOUR TASK: Find and stop the process consuming FDs!"
echo ""
echo "Useful commands:"
echo "  cat /proc/sys/fs/file-nr"
echo "  lsof | wc -l"
echo "  lsof | awk '{print \$2}' | sort | uniq -c | sort -rn | head"

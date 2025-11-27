#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab31_active"
TEST_FILE="/tmp/deleted-but-open.dat"
HOLDER_SCRIPT="/tmp/file-holder.sh"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating orphaned file simulation..."

# Create a script that holds a file open
cat > "$HOLDER_SCRIPT" << 'EOF'
#!/bin/bash
exec 3>/tmp/deleted-but-open.dat
while true; do
    echo "data" >&3
    sleep 10
done
EOF
chmod +x "$HOLDER_SCRIPT"

# Create the file and start holding it
dd if=/dev/zero of="$TEST_FILE" bs=1M count=50 2>/dev/null

# Start the holder process
nohup "$HOLDER_SCRIPT" >/dev/null 2>&1 &
HOLDER_PID=$!
echo "$HOLDER_PID" > "$MARKER_FILE"

sleep 1

# Delete the file (but process still holds it)
rm -f "$TEST_FILE"

echo ""
echo "Deleted file but process still holds it!"
echo ""
echo "YOUR TASK: Find and release the orphaned file!"
echo ""
echo "Useful commands:"
echo "  lsof | grep deleted"
echo "  lsof +L1"
echo "  df -h /tmp"

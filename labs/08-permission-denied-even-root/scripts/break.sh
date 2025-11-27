#!/usr/bin/env bash
#
# Lab 08: Permission Denied Even as Root
# break.sh - Creates immutable file
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TARGET_FILE="/etc/important-config"
MARKER_FILE="/tmp/.lab08_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting permission denied simulation for Lab 08..."
echo "========================================"

# Create the target file
print_status "Creating configuration file..."
cat > "$TARGET_FILE" << EOF
# Important Configuration File
# This file contains critical settings
setting1=value1
setting2=value2
EOF

# Make it immutable
print_status "Setting file attributes..."
chattr +i "$TARGET_FILE"

touch "$MARKER_FILE"

echo ""
print_break "Permission issue created!"
echo ""
echo "========================================"
echo "YOUR TASK: Figure out why root can't modify $TARGET_FILE"
echo "========================================"
echo ""
echo "Test commands:"
echo "  sudo cat $TARGET_FILE"
echo "  sudo rm $TARGET_FILE"
echo "  sudo echo 'test' >> $TARGET_FILE"
echo "  ls -la $TARGET_FILE"
echo ""

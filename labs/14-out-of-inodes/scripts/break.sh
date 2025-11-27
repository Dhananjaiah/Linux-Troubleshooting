#!/usr/bin/env bash
#
# Lab 14: Out of Inodes
# break.sh - Creates many small files to exhaust inodes
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab14_active"
INODE_DIR="/tmp/inode-test"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting inode exhaustion simulation for Lab 14..."
echo "========================================"

# Get current inode info
TOTAL_INODES=$(df -i / | awk 'NR==2 {print $2}')
FREE_INODES=$(df -i / | awk 'NR==2 {print $4}')

# Create many empty files (safer than filling all inodes)
# We'll create enough to demonstrate the issue
print_status "Creating many small files..."
mkdir -p "$INODE_DIR"

# Create 50000 empty files (enough to demonstrate, not dangerous)
for i in $(seq 1 50000); do
    touch "$INODE_DIR/file_$i" 2>/dev/null || break
    if [[ $((i % 10000)) -eq 0 ]]; then
        print_status "Created $i files..."
    fi
done

touch "$MARKER_FILE"

echo ""
print_break "Many small files created!"
echo ""
echo "Files created in: $INODE_DIR"
echo "File count: $(ls $INODE_DIR | wc -l)"
echo ""
echo "========================================"
echo "YOUR TASK: Find what's consuming inodes!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  df -h    # Check disk space"
echo "  df -i    # Check inode usage"
echo "  find /tmp -type f | wc -l"
echo ""

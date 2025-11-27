#!/usr/bin/env bash
#
# Lab 20: Docker Containers Not Starting
# cleanup.sh - Removes test containers
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CONTAINER_NAME="lab20-webapp"
MARKER_FILE="/tmp/.lab20_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 20..."
echo "========================================"

# Start Docker if not running
systemctl start docker 2>/dev/null || true
sleep 2

# Remove test container
print_status "Removing test container..."
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

rm -f "$MARKER_FILE"

echo ""
print_cleanup "Environment restored to clean state."
echo ""

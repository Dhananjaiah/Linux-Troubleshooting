#!/usr/bin/env bash
#
# Lab 20: Docker Containers Not Starting
# break.sh - Creates broken Docker container scenario
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab20_active"
CONTAINER_NAME="lab20-webapp"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting Docker container failure simulation for Lab 20..."
echo "========================================"

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
    print_status "Installing Docker..."
    apt-get update && apt-get install -y docker.io
    systemctl start docker
fi

# Clean up any existing container
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

# Create a container that will fail (bad command)
print_status "Creating failing container..."
docker run -d --name "$CONTAINER_NAME" alpine sh -c "echo 'Starting app...' && sleep 2 && exit 1" 2>/dev/null || true

# Stop Docker daemon (another issue to find)
print_status "Stopping Docker daemon..."
systemctl stop docker

touch "$MARKER_FILE"

echo ""
print_break "Docker is now broken!"
echo ""
echo "========================================"
echo "YOUR TASK: Get the container running!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  sudo systemctl status docker"
echo "  docker ps -a"
echo "  docker logs $CONTAINER_NAME"
echo ""

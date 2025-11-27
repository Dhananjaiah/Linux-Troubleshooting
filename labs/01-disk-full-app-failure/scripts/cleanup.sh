#!/usr/bin/env bash
#
# Lab 01: Disk Full - Application Failure
# cleanup.sh - Restores the system to a clean state
#
# This script:
# 1. Stops the order-service
# 2. Removes the simulated application
# 3. Removes all created log files
# 4. Removes the systemd unit file
#

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="order-service"
LOG_DIR="/var/log/order-service"
APP_SCRIPT="/usr/local/bin/order-service.sh"
SYSTEMD_UNIT="/etc/systemd/system/order-service.service"

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_cleanup() {
    echo -e "${YELLOW}[CLEANUP]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    echo "Usage: sudo $0"
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 01..."
echo "========================================"
echo ""

# Step 1: Stop the service if it's running
if systemctl is-active --quiet order-service 2>/dev/null; then
    print_status "Stopping ${APP_NAME} service..."
    systemctl stop order-service 2>/dev/null || true
else
    print_status "${APP_NAME} service is not running"
fi

# Step 2: Disable the service
if systemctl is-enabled --quiet order-service 2>/dev/null; then
    print_status "Disabling ${APP_NAME} service..."
    systemctl disable order-service 2>/dev/null || true
fi

# Step 3: Remove the systemd unit file
if [[ -f "$SYSTEMD_UNIT" ]]; then
    print_status "Removing systemd unit file..."
    rm -f "$SYSTEMD_UNIT"
    systemctl daemon-reload
fi

# Step 4: Remove the application script
if [[ -f "$APP_SCRIPT" ]]; then
    print_status "Removing simulated application..."
    rm -f "$APP_SCRIPT"
fi

# Step 5: Remove the log directory and all files
if [[ -d "$LOG_DIR" ]]; then
    print_status "Removing simulated log files..."
    rm -rf "$LOG_DIR"
fi

# Step 6: Verify cleanup
echo ""
echo "========================================"

CLEANUP_SUCCESS=true

# Check service is gone
if systemctl list-unit-files | grep -q "^order-service"; then
    echo "Warning: order-service unit may still exist"
    CLEANUP_SUCCESS=false
fi

# Check log directory is gone
if [[ -d "$LOG_DIR" ]]; then
    echo "Warning: Log directory still exists"
    CLEANUP_SUCCESS=false
fi

# Check app script is gone
if [[ -f "$APP_SCRIPT" ]]; then
    echo "Warning: Application script still exists"
    CLEANUP_SUCCESS=false
fi

if $CLEANUP_SUCCESS; then
    print_cleanup "Environment restored to clean state."
    echo ""
    echo "Cleanup complete! You can now:"
    echo "  - Run this lab again with: sudo ./scripts/break.sh"
    echo "  - Move to the next lab"
    echo ""
else
    echo ""
    echo "Cleanup may be incomplete. Check the warnings above."
    echo ""
fi

# Show current disk usage
echo "Current disk usage:"
df -h / | head -2
echo ""

#!/usr/bin/env bash
#
# Lab 01: Disk Full - Application Failure
# break.sh - Creates a simulated disk full condition
#
# This script:
# 1. Creates a simulated application (order-service)
# 2. Fills up disk space with large log files
# 3. Causes the application to fail
#
# WARNING: Only run this on a test system!
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="order-service"
LOG_DIR="/var/log/order-service"
APP_SCRIPT="/usr/local/bin/order-service.sh"
SYSTEMD_UNIT="/etc/systemd/system/order-service.service"
NUM_FILES=10
FILE_SIZE_MB=100

# Function to print colored status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_break() {
    echo -e "${RED}[BREAK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo or as root."
    echo "Usage: sudo $0"
    exit 1
fi

# Check available disk space before proceeding
AVAILABLE_MB=$(df / | awk 'NR==2 {print int($4/1024)}')
REQUIRED_MB=$((NUM_FILES * FILE_SIZE_MB + 100))

if [[ $AVAILABLE_MB -lt $REQUIRED_MB ]]; then
    print_warning "Not enough disk space to simulate disk full condition."
    print_warning "Available: ${AVAILABLE_MB}MB, Required: ${REQUIRED_MB}MB"
    print_warning "This lab needs enough space to fill the disk safely."
    exit 1
fi

echo ""
print_break "Starting disk full simulation for Lab 01..."
echo "========================================"
echo ""

# Step 1: Create the application directory
print_status "Creating simulated application directory..."
mkdir -p "$LOG_DIR"

# Step 2: Create the simulated application script
print_status "Installing simulated application '${APP_NAME}'..."
cat > "$APP_SCRIPT" << 'APPSCRIPT'
#!/usr/bin/env bash
# Simulated Order Service Application
LOG_FILE="/var/log/order-service/order-service.log"
ORDER_NUM=1

# Function to log messages
log_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${timestamp} $1" >> "$LOG_FILE"
}

# Check if we can write to the log file
write_test() {
    if ! echo "test" >> "$LOG_FILE" 2>/dev/null; then
        echo "ERROR: Cannot write to log file" >&2
        echo "ERROR: No space left on device" >&2
        exit 1
    fi
}

# Main loop
echo "Order Service starting..."
log_message "[INFO] Order Service started successfully"

while true; do
    write_test
    log_message "[INFO] Processing order #${ORDER_NUM}"
    ORDER_NUM=$((ORDER_NUM + 1))
    sleep 5
done
APPSCRIPT

chmod +x "$APP_SCRIPT"

# Step 3: Create the systemd service unit
print_status "Creating systemd service unit..."
cat > "$SYSTEMD_UNIT" << 'UNITFILE'
[Unit]
Description=Order Processing Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/order-service.sh
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
UNITFILE

# Step 4: Reload systemd and enable the service
systemctl daemon-reload
systemctl enable order-service >/dev/null 2>&1

# Step 5: Create large log files to fill disk
print_status "Creating large log files to fill disk space..."
echo ""

for i in $(seq 1 $NUM_FILES); do
    FILENAME="${LOG_DIR}/order-service-debug-${i}.log"
    print_status "Creating file ${i}/${NUM_FILES} (${FILE_SIZE_MB}MB)..."
    dd if=/dev/zero of="$FILENAME" bs=1M count=$FILE_SIZE_MB status=none 2>/dev/null || true
    
    # Check if disk is nearly full
    USAGE=$(df / | awk 'NR==2 {print int($5)}')
    if [[ $USAGE -ge 98 ]]; then
        print_status "Disk usage at ${USAGE}% - stopping file creation"
        break
    fi
done

echo ""

# Step 6: Create the main application log file
touch "${LOG_DIR}/order-service.log"
cat > "${LOG_DIR}/order-service.log" << 'LOGFILE'
2024-01-15 02:10:00 [INFO] Order Service started successfully
2024-01-15 02:10:05 [INFO] Processing order #1
2024-01-15 02:10:10 [INFO] Processing order #2
2024-01-15 02:10:15 [INFO] Processing order #3
2024-01-15 02:14:55 [INFO] Processing order #12345
2024-01-15 02:14:57 [INFO] Processing order #12346
2024-01-15 02:15:01 [ERROR] Failed to write transaction log
2024-01-15 02:15:01 [ERROR] Disk full - cannot continue
2024-01-15 02:15:01 [FATAL] Service shutting down due to disk error
LOGFILE

# Step 7: Start the service (it will fail due to disk full)
print_status "Starting ${APP_NAME} service (expected to fail)..."
systemctl start order-service 2>/dev/null || true

# Give service time to fail
sleep 2

# Show current disk usage
echo ""
echo "========================================"
print_break "Disk full condition created!"
echo ""
echo "Current disk usage:"
df -h / | head -2
echo ""
print_status "The '${APP_NAME}' application is now failing."
echo ""
echo "========================================"
echo "YOUR TASK: Find out why the service is failing and fix it!"
echo "========================================"
echo ""
echo "Useful commands to start:"
echo "  sudo systemctl status order-service"
echo "  df -h"
echo "  sudo du -sh /var/log/*"
echo ""

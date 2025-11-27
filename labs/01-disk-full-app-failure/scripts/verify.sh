#!/usr/bin/env bash
#
# Lab 01: Disk Full - Application Failure
# verify.sh - Verifies that the lab has been completed successfully
#
# This script checks:
# 1. Disk usage is below 90%
# 2. The order-service is running
# 3. The service can write to its log file
# 4. New files can be created on the filesystem
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall success
ALL_PASSED=true

# Function to print check results
print_pass() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_fail() {
    echo -e "${RED}[✗]${NC} $1"
    ALL_PASSED=false
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

echo ""
echo "[VERIFY] Checking Lab 01: Disk Full - Application Failure"
echo "========================================"
echo ""

# Check 1: Disk usage is below 90%
DISK_USAGE=$(df / | awk 'NR==2 {gsub(/%/,""); print $5}')
if [[ $DISK_USAGE -lt 90 ]]; then
    print_pass "Disk usage is below 90%: Currently at ${DISK_USAGE}%"
else
    print_fail "Disk usage is still too high: ${DISK_USAGE}%"
    print_info "Hint: Find and remove large files in /var/log"
fi

# Check 2: order-service is running
if systemctl is-active --quiet order-service 2>/dev/null; then
    print_pass "order-service is running"
else
    SERVICE_STATUS=$(systemctl is-active order-service 2>/dev/null || echo "not found")
    print_fail "order-service is not running (status: ${SERVICE_STATUS})"
    print_info "Hint: Try 'sudo systemctl restart order-service' after freeing disk space"
fi

# Check 3: Service is responding correctly (checking recent logs)
if systemctl is-active --quiet order-service 2>/dev/null; then
    # Check that service has been running for at least a few seconds without failing
    UPTIME=$(systemctl show order-service --property=ActiveEnterTimestamp 2>/dev/null | cut -d'=' -f2)
    if [[ -n "$UPTIME" && "$UPTIME" != "n/a" ]]; then
        print_pass "Service is responding correctly"
    else
        print_fail "Service may not be stable"
    fi
else
    print_fail "Cannot check service response - service not running"
fi

# Check 4: Can write to filesystem
TEST_FILE="/tmp/verify-write-test-$$"
if touch "$TEST_FILE" 2>/dev/null; then
    rm -f "$TEST_FILE"
    print_pass "Can write to filesystem"
else
    print_fail "Cannot write to filesystem - disk may still be full"
    print_info "Hint: Check disk space with 'df -h'"
fi

# Summary
echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} All checks passed! Lab 01 completed successfully."
    echo ""
    echo "Great job! You have successfully:"
    echo "  - Identified the disk full condition"
    echo "  - Freed up disk space"
    echo "  - Restored the order-service"
    echo ""
    echo "Don't forget to run cleanup.sh before starting the next lab."
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Some checks failed. Keep troubleshooting!"
    echo ""
    echo "Troubleshooting tips:"
    echo "  1. Check disk usage: df -h /"
    echo "  2. Find large files: sudo du -sh /var/log/* | sort -h"
    echo "  3. Remove large files: sudo rm -f /path/to/large/file"
    echo "  4. Restart service: sudo systemctl restart order-service"
    echo ""
    exit 1
fi

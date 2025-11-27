#!/usr/bin/env bash
#
# Lab 06: Database Too Many Connections
# cleanup.sh - Restores MySQL to normal state
#

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_cleanup() { echo -e "${YELLOW}[CLEANUP]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_cleanup "Starting cleanup for Lab 06..."
echo "========================================"

# Kill all sleep processes from the test
print_status "Killing test connections..."
pkill -f "SELECT SLEEP" 2>/dev/null || true

# Restore max_connections
if [[ -f /tmp/.mysql_max_connections_backup ]]; then
    MAX_CONN=$(cat /tmp/.mysql_max_connections_backup)
    print_status "Restoring max_connections to $MAX_CONN..."
    mysql -u root -e "SET GLOBAL max_connections = $MAX_CONN;" 2>/dev/null || true
    rm -f /tmp/.mysql_max_connections_backup
fi

rm -f /tmp/.lab06_active

echo ""
print_cleanup "Environment restored to clean state."
echo ""

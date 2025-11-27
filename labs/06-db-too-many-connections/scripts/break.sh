#!/usr/bin/env bash
#
# Lab 06: Database Too Many Connections
# break.sh - Creates too many MySQL connections
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab06_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

# Check if MySQL is installed
if ! command -v mysql &>/dev/null; then
    echo "MySQL is not installed. Installing..."
    apt-get update && apt-get install -y mysql-server
    systemctl start mysql
fi

echo ""
print_break "Starting too many connections simulation for Lab 06..."
echo "========================================"

# Backup current max_connections
CURRENT_MAX=$(mysql -u root -N -e "SHOW VARIABLES LIKE 'max_connections'" 2>/dev/null | awk '{print $2}' || echo "151")
echo "$CURRENT_MAX" > /tmp/.mysql_max_connections_backup

# Set a low max_connections
print_status "Setting max_connections to 10..."
mysql -u root -e "SET GLOBAL max_connections = 10;" 2>/dev/null

# Create dummy connections with shorter timeout (5 minutes max)
print_status "Creating connections to exhaust the pool..."
for i in {1..15}; do
    mysql -u root -e "SELECT SLEEP(300);" &>/dev/null &
done

echo "$!" > "$MARKER_FILE"
sleep 2

echo ""
print_break "Too many connections condition created!"
echo ""
echo "========================================"
echo "YOUR TASK: Restore database access!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  mysql -u root -e 'SELECT 1'"
echo "  mysqladmin -u root processlist"
echo ""

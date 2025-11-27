#!/usr/bin/env bash
#
# Lab 18: Crontab Not Running
# break.sh - Creates broken cron setup
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab18_active"
TEST_USER="labuser18"
SCRIPT_PATH="/home/$TEST_USER/scripts/backup.sh"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting cron failure simulation for Lab 18..."
echo "========================================"

# Create test user
if ! id "$TEST_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$TEST_USER"
fi

# Create script directory
mkdir -p "/home/$TEST_USER/scripts"
mkdir -p "/var/log/backup-lab18"

# Create backup script (but don't make it executable - the bug!)
cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash
echo "Backup ran at $(date)" >> /var/log/backup-lab18/backup.log
EOF

# Intentionally NOT making it executable (chmod +x)
chown -R "$TEST_USER:$TEST_USER" "/home/$TEST_USER/scripts"

# Stop cron service (another bug!)
print_status "Stopping cron service..."
systemctl stop cron

# Add crontab entry
print_status "Setting up crontab..."
echo "* * * * * $SCRIPT_PATH" | crontab -u "$TEST_USER" -

touch "$MARKER_FILE"

echo ""
print_break "Cron is now broken!"
echo ""
echo "========================================"
echo "YOUR TASK: Figure out why the cron job isn't running!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  sudo systemctl status cron"
echo "  crontab -l -u $TEST_USER"
echo "  ls -la $SCRIPT_PATH"
echo "  grep CRON /var/log/syslog"
echo ""

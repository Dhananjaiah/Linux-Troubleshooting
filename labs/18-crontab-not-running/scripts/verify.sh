#!/usr/bin/env bash
#
# Lab 18: Crontab Not Running
# verify.sh - Checks if cron is working
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TEST_USER="labuser18"
SCRIPT_PATH="/home/$TEST_USER/scripts/backup.sh"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 18: Crontab Not Running"
echo "========================================"

# Check 1: Cron service running
if systemctl is-active --quiet cron; then
    print_pass "Cron service is running"
else
    print_fail "Cron service is not running"
fi

# Check 2: Script is executable
if [[ -x "$SCRIPT_PATH" ]]; then
    print_pass "Backup script is executable"
else
    print_fail "Backup script is not executable"
fi

# Check 3: Backup log exists (cron ran)
if [[ -f /var/log/backup-lab18/backup.log ]]; then
    print_pass "Backup has run (log file exists)"
else
    print_fail "Backup has not run yet"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 18 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

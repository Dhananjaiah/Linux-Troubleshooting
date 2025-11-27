#!/usr/bin/env bash
#
# Lab 20: Docker Containers Not Starting
# verify.sh - Checks if Docker is working
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

CONTAINER_NAME="lab20-webapp"
ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 20: Docker Containers Not Starting"
echo "========================================"

# Check 1: Docker daemon running
if systemctl is-active --quiet docker; then
    print_pass "Docker daemon is running"
else
    print_fail "Docker daemon is not running"
fi

# Check 2: A container is running (any container)
if docker ps 2>/dev/null | grep -q .; then
    print_pass "At least one container is running"
else
    print_fail "No containers are running"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 20 completed!"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Keep troubleshooting!"
    exit 1
fi

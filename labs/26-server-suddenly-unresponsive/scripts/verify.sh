#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "[VERIFY] Checking Lab 26"
echo "========================================"

# Check load average
LOAD=$(cat /proc/loadavg | awk '{print int($1)}')
CPUS=$(nproc)

if [[ $LOAD -le $((CPUS * 2)) ]]; then
    echo -e "${GREEN}[✓]${NC} Load average normalized ($LOAD)"
    echo -e "${GREEN}[SUCCESS]${NC} Lab 26 completed!"
    exit 0
else
    echo -e "${RED}[✗]${NC} Load still high ($LOAD)"
    exit 1
fi

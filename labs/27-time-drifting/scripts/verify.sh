#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "[VERIFY] Checking Lab 27"
echo "========================================"

if timedatectl show --property=NTP 2>/dev/null | grep -q "yes"; then
    echo -e "${GREEN}[✓]${NC} NTP is enabled"
    echo -e "${GREEN}[SUCCESS]${NC} Lab 27 completed!"
    exit 0
else
    echo -e "${RED}[✗]${NC} NTP is not enabled"
    exit 1
fi

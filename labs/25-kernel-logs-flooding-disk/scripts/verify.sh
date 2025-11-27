#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "[VERIFY] Checking Lab 25"
echo "========================================"

if pgrep -f "log-flood.sh" >/dev/null 2>&1; then
    echo -e "${RED}[✗]${NC} Log flood process still running"
    exit 1
else
    echo -e "${GREEN}[✓]${NC} Log flood process stopped"
    echo -e "${GREEN}[SUCCESS]${NC} Lab 25 completed!"
    exit 0
fi

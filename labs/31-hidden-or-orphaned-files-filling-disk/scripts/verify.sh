#!/usr/bin/env bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "[VERIFY] Checking Lab 31"
echo "========================================"

# Check if file holder is still running
if pgrep -f "file-holder.sh" >/dev/null 2>&1; then
    echo -e "${RED}[✗]${NC} File holder process still running"
    echo ""
    echo "Hint: lsof | grep deleted"
    exit 1
else
    echo -e "${GREEN}[✓]${NC} Orphaned file released"
    echo -e "${GREEN}[SUCCESS]${NC} Lab 31 completed!"
    exit 0
fi

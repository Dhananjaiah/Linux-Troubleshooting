#!/usr/bin/env bash
TEST_DIR="/tmp/lab24-test"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "[VERIFY] Checking Lab 24"
echo "========================================"

# Check if we can write
if touch "$TEST_DIR/verify-test" 2>/dev/null; then
    rm -f "$TEST_DIR/verify-test"
    echo -e "${GREEN}[✓]${NC} Filesystem is writable"
    echo -e "${GREEN}[SUCCESS]${NC} Lab 24 completed!"
    exit 0
else
    echo -e "${RED}[✗]${NC} Filesystem is still read-only"
    exit 1
fi

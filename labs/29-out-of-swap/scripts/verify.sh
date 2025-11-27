#!/usr/bin/env bash
echo "[VERIFY] Checking Lab 29"
echo "========================================"

echo "[✓] Swap status:"
free -h | grep -i swap
echo ""
echo "[SUCCESS] Lab 29 review completed!"
exit 0

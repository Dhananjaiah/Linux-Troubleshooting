#!/usr/bin/env bash
echo "[VERIFY] Checking Lab 30"
echo "========================================"

echo "[✓] TCP connection summary:"
ss -s | head -5
echo ""
echo "[SUCCESS] Lab 30 review completed!"
exit 0

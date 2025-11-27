#!/usr/bin/env bash
echo "[VERIFY] Checking Lab 28"
echo "========================================"

if [[ -f /boot/grub/grub.cfg ]]; then
    echo "[✓] GRUB configuration exists"
    echo "[SUCCESS] Lab 28 (simulation) completed!"
    exit 0
else
    echo "[!] No GRUB config found"
    exit 1
fi

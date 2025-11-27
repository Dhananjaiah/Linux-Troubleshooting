#!/usr/bin/env bash
#
# Lab 11: Kernel Panic on Boot
# verify.sh - Checks understanding of recovery procedures
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ALL_PASSED=true

print_pass() { echo -e "${GREEN}[✓]${NC} $1"; }
print_fail() { echo -e "${RED}[✗]${NC} $1"; ALL_PASSED=false; }

echo ""
echo "[VERIFY] Checking Lab 11: Kernel Panic on Boot"
echo "========================================"

# Check 1: Simulated log exists
if [[ -f /var/log/lab-simulation/kernel-panic.log ]]; then
    print_pass "Simulated kernel panic log found"
else
    print_fail "Simulated log not found - run break.sh first"
fi

# Check 2: Multiple kernels installed (good practice)
KERNEL_COUNT=$(ls /boot/vmlinuz-* 2>/dev/null | wc -l)
if [[ $KERNEL_COUNT -gt 1 ]]; then
    print_pass "Multiple kernel versions available ($KERNEL_COUNT found)"
else
    print_pass "At least one kernel version installed"
fi

# Check 3: GRUB is configured
if [[ -f /boot/grub/grub.cfg ]]; then
    print_pass "GRUB configuration exists"
else
    print_fail "GRUB configuration not found"
fi

echo ""
echo "========================================"
if $ALL_PASSED; then
    echo -e "${GREEN}[SUCCESS]${NC} Lab 11 review completed!"
    echo ""
    echo "Key takeaways:"
    echo "  - Always keep multiple kernel versions installed"
    echo "  - Know how to boot into recovery mode from GRUB"
    echo "  - Understand update-initramfs and update-grub commands"
    exit 0
else
    echo -e "${RED}[INCOMPLETE]${NC} Review the lab materials"
    exit 1
fi

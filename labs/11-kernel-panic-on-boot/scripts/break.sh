#!/usr/bin/env bash
#
# Lab 11: Kernel Panic on Boot (Simulation)
# break.sh - Simulates kernel panic symptoms for learning
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER_FILE="/tmp/.lab11_active"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_break() { echo -e "${RED}[BREAK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

echo ""
print_break "Starting kernel panic simulation for Lab 11..."
echo "========================================"
print_warning "This is a SIMULATION - no actual kernel panic will occur"
echo ""

# Create simulated panic log
mkdir -p /var/log/lab-simulation
cat > /var/log/lab-simulation/kernel-panic.log << 'EOF'
[    0.000000] Linux version 5.15.0-91-generic (buildd@lcy02-amd64-021)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-5.15.0-91-generic root=/dev/sda1 ro quiet splash
...
[    5.234567] VFS: Cannot open root device "sda1" or unknown-block(0,0): error -6
[    5.234568] Please append a correct "root=" boot option; here are the available partitions:
[    5.234569] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    5.234570] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-91-generic
[    5.234571] Hardware name: VMware Virtual Platform
[    5.234572] Call Trace:
[    5.234573]  dump_stack_lvl+0x34/0x44
[    5.234574]  panic+0x102/0x2b4
[    5.234575]  mount_block_root+0x194/0x21b
[    5.234576]  mount_root+0x61/0x65
[    5.234577]  prepare_namespace+0x130/0x166
[    5.234578]  kernel_init_freeable+0x1fc/0x221
[    5.234579]  kernel_init+0x11/0x120
[    5.234580]  ret_from_fork+0x22/0x30
[    5.234581] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]---
EOF

touch "$MARKER_FILE"

echo ""
print_break "Kernel panic simulation created!"
echo ""
echo "Simulated panic log created at: /var/log/lab-simulation/kernel-panic.log"
echo ""
echo "========================================"
echo "YOUR TASK: Review the simulated panic log and learn recovery procedures"
echo "========================================"
echo ""
echo "Commands to try:"
echo "  cat /var/log/lab-simulation/kernel-panic.log"
echo "  journalctl --list-boots"
echo "  journalctl -b -1 (if available)"
echo ""
echo "Recovery procedures to review:"
echo "  1. GRUB boot menu → Advanced options → Previous kernel"
echo "  2. Boot to recovery mode"
echo "  3. update-initramfs -u"
echo "  4. update-grub"
echo ""

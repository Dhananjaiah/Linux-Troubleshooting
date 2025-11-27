#!/usr/bin/env bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
MARKER_FILE="/tmp/.lab21_active"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo -e "${RED}[BREAK]${NC} Starting ping blocking simulation..."

# Save original value
cat /proc/sys/net/ipv4/icmp_echo_ignore_all > /tmp/.icmp_backup

# Block ICMP
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

touch "$MARKER_FILE"

echo ""
echo "Server will no longer respond to pings!"
echo ""
echo "YOUR TASK: Figure out why and fix it!"
echo ""
echo "Useful commands:"
echo "  ping localhost"
echo "  cat /proc/sys/net/ipv4/icmp_echo_ignore_all"
echo "  sudo sysctl -a | grep icmp"

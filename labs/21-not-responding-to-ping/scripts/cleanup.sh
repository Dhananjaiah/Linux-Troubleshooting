#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[CLEANUP] Restoring ICMP settings..."

if [[ -f /tmp/.icmp_backup ]]; then
    cat /tmp/.icmp_backup > /proc/sys/net/ipv4/icmp_echo_ignore_all
    rm -f /tmp/.icmp_backup
else
    echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all
fi

rm -f /tmp/.lab21_active
echo "Cleanup complete."

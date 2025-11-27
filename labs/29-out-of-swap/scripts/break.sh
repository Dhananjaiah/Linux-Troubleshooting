#!/usr/bin/env bash
set -e
MARKER_FILE="/tmp/.lab29_active"

if [[ $EUID -ne 0 ]]; then echo "Run with sudo"; exit 1; fi

echo "[BREAK] Creating swap exhaustion information..."

# We won't actually exhaust swap as that's dangerous
# Instead, show educational info

cat > /var/log/lab-simulation/swap-info.log 2>/dev/null << 'EOF' || mkdir -p /var/log/lab-simulation && cat > /var/log/lab-simulation/swap-info.log << 'EOF'
=== Swap Exhaustion Scenario ===

Symptoms:
- System becomes very slow
- OOM killer messages in dmesg
- Applications being killed randomly

Commands to diagnose:
- free -h
- swapon --show
- dmesg | grep -i oom
- ps aux --sort=-%mem | head

Resolution:
1. Identify memory-hungry processes
2. Kill or restart them
3. Consider adding more swap or RAM
EOF

touch "$MARKER_FILE"

echo ""
echo "Swap exhaustion simulation created!"
echo ""
echo "Current swap status:"
free -h | grep -i swap
echo ""
echo "Review: cat /var/log/lab-simulation/swap-info.log"

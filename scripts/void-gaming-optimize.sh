#!/bin/bash
# VOID Gaming Optimizer - Gamemode + CPU + system tweaks
# Run with: sudo bash scripts/void-gaming-optimize.sh

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Run as root: sudo bash scripts/void-gaming-optimize.sh"
    exit 1
fi

echo "=== VOID Gaming Optimizer ==="

echo "[1/5] Installing gamemode..."
pacman -S --needed --noconfirm gamemode lib32-gamemode 2>/dev/null || true

echo "[2/5] Enabling gamemode daemon..."
systemctl enable gamemoded --now 2>/dev/null || true

echo "[3/5] Setting CPU governor to performance..."
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance > "$cpu" 2>/dev/null || true
done

echo "[4/5] Optimizing swap..."
sysctl vm.swappiness=10
sysctl vm.dirty_ratio=15
sysctl vm.dirty_background_ratio=5

echo "[5/5] Disabling transparent hugepages..."
echo never > /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null || true

echo ""
echo "=== Done! Reboot for full effect. ==="

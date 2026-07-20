#!/bin/bash
# VOID Sober Launcher - Aggressively Optimized for AMD 3020e

echo "[VOID] Optimizing system for Roblox..."

# Kill unnecessary services to free RAM
killall mako 2>/dev/null
killall waybar 2>/dev/null

# Drop caches to free up memory (polkit handles auth)
pkexec sh -c 'sync && echo 3 > /proc/sys/vm/drop_caches' 2>/dev/null || true

# Set CPU governor to performance (if available)
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    pkexec sh -c "echo performance > $cpu" 2>/dev/null || true
done

# Disable compositor animations during gaming
hyprctl keyword decoration:enabled false 2>/dev/null

echo "[VOID] Launching Roblox..."
flatpak run org.vinegarhq.Sober &

# Wait for Sober to start
sleep 5

# Restore compositor when Roblox closes
while pgrep -f "org.vinegarhq.Sober" > /dev/null; do
    sleep 2
done

echo "[VOID] Roblox closed. Restoring system..."
hyprctl keyword decoration:enabled true 2>/dev/null

# Restart waybar and mako
waybar &>/dev/null &
mako &>/dev/null &
disown

# Restore CPU governor
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    pkexec sh -c "echo powersave > $cpu" 2>/dev/null || true
done

echo "[VOID] System restored."

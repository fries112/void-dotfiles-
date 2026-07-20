#!/bin/bash
# VOID Sober Launcher - Aggressively Optimized for AMD 3020e

echo "[VOID] Optimizing system for Roblox..."

# Kill unnecessary services to free RAM
systemctl --user stop mako 2>/dev/null
systemctl --user stop waybar 2>/dev/null

# Drop caches to free up memory
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1

# Set CPU governor to performance (if available)
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance | sudo tee "$cpu" > /dev/null 2>&1
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
systemctl --user start waybar 2>/dev/null
systemctl --user start mako 2>/dev/null

# Restore CPU governor
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo powersave | sudo tee "$cpu" > /dev/null 2>&1
done

echo "[VOID] System restored."

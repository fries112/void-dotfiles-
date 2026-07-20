#!/bin/bash
# VOID Ultimate Debloat & Optimization
# For AMD 3020e + 3.2GB RAM
# Run with: sudo bash ~/void-ultimate-debloat.sh

set -e

echo "============================================"
echo "  VOID Ultimate Debloat & Optimization"
echo "  AMD 3020e + 3.2GB RAM"
echo "============================================"
echo ""
echo "This will remove ~8GB of bloat:"
echo "  - Pacman cache (4.3GB)"
echo "  - Docs/man pages (490MB)"
echo "  - NVIDIA/Intel firmware (~200MB)"
echo "  - CachyOS bloat (~500MB)"
echo "  - KDE Plasma remnants (~1GB)"
echo "  - Extra kernel (~500MB)"
echo "  - Other bloat packages"
echo "  - Optimize sysctl for low RAM"
echo "  - Set up ZRAM (compressed swap)"
echo ""
read -p "Continue? (y/n): " confirm < /dev/tty
if [[ "$confirm" != "y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "[1/10] Cleaning pacman cache..."
paccache -r 2>/dev/null
paccache -rk1 2>/dev/null
echo "  Done."

echo ""
echo "[2/10] Cleaning journals..."
journalctl --vacuum-time=2d 2>/dev/null
journalctl --vacuum-size=30M 2>/dev/null
echo "  Done."

echo ""
echo "[3/10] Removing docs and man pages..."
rm -rf /usr/share/doc/* 2>/dev/null
rm -rf /usr/share/man/* 2>/dev/null
rm -rf /usr/share/info/* 2>/dev/null
rm -rf /usr/share/gtk-doc/* 2>/dev/null
echo "  Done."

echo ""
echo "[4/10] Removing unneeded firmware..."
pacman -Rns --noconfirm \
    linux-firmware-nvidia \
    linux-firmware-intel \
    linux-firmware-broadcom \
    linux-firmware-cirrus \
    linux-firmware-atheros \
    linux-firmware-mediatek \
    linux-firmware-realtek \
    linux-firmware-other \
    alsa-firmware \
    sof-firmware \
    2>/dev/null || true
echo "  Done. Keeping AMD/Radeon firmware only."

echo ""
echo "[5/10] Removing CachyOS bloat..."
pacman -Rns --noconfirm \
    cachyos-emerald-kde-theme-git \
    cachyos-iridescent-kde \
    cachyos-nord-kde-theme-git \
    cachyos-kde-settings \
    cachyos-hello \
    cachyos-packageinstaller \
    cachyos-plymouth-bootanimation \
    cachyos-plymouth-theme \
    cachyos-wallpapers \
    cachyos-alacritty-config \
    cachyos-fish-config \
    cachyos-zsh-config \
    cachyos-micro-settings \
    cachyos-rate-mirrors \
    cachyos-grub-theme \
    cachyos-hooks \
    cachyos-kernel-manager \
    2>/dev/null || true
echo "  Done."

echo ""
echo "[6/10] Removing extra kernel..."
pacman -Rns --noconfirm \
    linux-cachyos-lts \
    linux-cachyos-lts-headers \
    2>/dev/null || true
echo "  Done."

echo ""
echo "[7/10] Removing KDE Plasma remnants..."
pacman -Rns --noconfirm \
    xdg-desktop-portal-kde \
    kactivitymanagerd \
    kinfocenter \
    kmenuedit \
    kdeplasma-addons \
    systemsettings \
    kde-cli-tools \
    kde-gtk-config \
    kdesu \
    konsole \
    kdeclarative \
    kded \
    kpackage \
    kservice \
    vlc-plugin-kate \
    kio \
    kio-admin \
    kio-extras \
    kio-fuse \
    kdegraphics-mobipocket \
    kdegraphics-thumbnailers \
    spectacle \
    gwenview \
    ark \
    kate \
    dolphin \
    2>/dev/null || true
echo "  Done."

echo ""
echo "[8/10] Removing other bloat..."
pacman -Rns --noconfirm \
    latte-dock-ng-git \
    modemmanager \
    modemmanager-qt \
    mobile-broadband-provider-info \
    extension-manager \
    clinfo \
    cpuinfo \
    hwinfo \
    kwalletmanager \
    kitty-terminfo \
    ghostty-terminfo \
    fwupd \
    fwupd-efi \
    power-profiles-daemon \
    cpupower \
    2>/dev/null || true
echo "  Done."

echo ""
echo "[9/10] Optimizing sysctl for low RAM..."
cat > /etc/sysctl.d/99-void-optimize.conf << 'EOF'
# Swappiness - use swap less aggressively
vm.swappiness=10

# Dirty writeback - less frequent disk writes
vm.dirty_writeback_centisecs=1500
vm.dirty_ratio=15
vm.dirty_background_ratio=5

# Drop caches when memory is low
vm.vfs_cache_pressure=50

# Reduce memory fragmentation
vm.min_free_kbytes=65536
vm.zone_reclaim_mode=0

# Network optimizations
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_congestion_control=bbr
net.core.default_qdisc=fq

# Kernel - reduce logging
kernel.printk=3 3 3 3
EOF
sysctl --system 2>/dev/null
echo "  Done."

echo ""
echo "[10/10] Setting up ZRAM (compressed swap)..."
if ! pacman -Qi zram-generator &>/dev/null; then
    pacman -S --noconfirm zram-generator
fi
cat > /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram, 16384)
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF
systemctl daemon-reload
systemctl enable --now systemd-zram-setup@zram0.service 2>/dev/null || true
echo "  Done."

echo ""
echo "============================================"
echo "  Complete! Reboot recommended."
echo "============================================"
echo ""
echo "Freed space:"
du -sh /var/cache/pacman/pkg/ 2>/dev/null || echo "  Cache cleaned"
echo ""
echo "Current RAM:"
free -h

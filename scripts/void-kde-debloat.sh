#!/bin/bash
# VOID KDE Debloat - Nuclear option for Hyprland
# Run with: sudo bash scripts/void-kde-debloat.sh

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Run as root: sudo bash scripts/void-kde-debloat.sh"
    exit 1
fi

echo "=== VOID KDE NUCLEAR DEBLOAT ==="

echo "[1/4] Removing KDE applications..."
pacman -Rns --noconfirm \
    ark dolphin ffmpegthumbs filelight gwenview kate kcalc \
    kdeconnect konsole spectacle kinfocenter kmenuedit systemsettings \
    plasma-systemmonitor kio-extras kio-admin kdegraphics-mobipocket \
    kdegraphics-thumbnailers kdesu kdialog kholidays kwalletmanager \
    partitionmanager phonon-qt6 signon-kwallet-extension kcontacts \
    libappindicator 2>/dev/null || true

echo "[2/4] Removing CachyOS KDE themes..."
pacman -Rns --noconfirm \
    cachyos-emerald-kde-theme-git cachyos-iridescent-kde \
    cachyos-nord-kde-theme-git cachyos-kde-settings \
    capitaine-cursors 2>/dev/null || true

echo "[3/4] Removing Plasma bloat..."
pacman -Rns --noconfirm \
    latte-dock-ng-git kdeplasma-addons plasma-firewall \
    plasma-thunderbolt plasma-browser-integration plymouth-kcm \
    kinfocenter kscreen 2>/dev/null || true

echo "[4/4] Cleaning orphans..."
pacman -Rns --noconfirm $(pacman -Qdtq 2>/dev/null) 2>/dev/null || true

echo ""
echo "=== DONE ==="
echo "RAM: $(free -h | awk '/Mem:/{print $3 "/" $2}')"
echo "Reboot recommended."

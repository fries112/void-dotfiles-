#!/bin/bash
# VOID Debloat - Remove KDE Plasma bloat
# Run with: sudo bash ~/void-debloat.sh

echo "VOID Debloat Script"
echo "==================="
echo ""
echo "This will remove KDE Plasma packages you don't need with Hyprland."
echo "KEEPING: polkit-kde-agent, kglobalacceld, kdeconnect, bluedevil"
echo ""
read -p "Continue? (y/n): " confirm < /dev/tty
if [[ "$confirm" != "y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Removing KDE Plasma bloat..."

# KDE Plasma desktop (the big one)
pacman -Rns --noconfirm \
    plasma-desktop \
    plasma-workspace \
    plasma5support \
    plasma-wayland-protocols \
    plasma-activities \
    plasma-activities-stats \
    plasma-browser-integration \
    plasma-firewall \
    plasma-integration \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    plasma-thunderbolt \
    2>/dev/null

# KDE window manager and decorations
pacman -Rns --noconfirm \
    kwin \
    aurorae \
    kdecoration \
    kscreenlocker \
    libkscreen \
    kscreen \
    2>/dev/null

# KDE bloat services
pacman -Rns --noconfirm \
    baloo \
    baloo-widgets \
    kactivitymanagerd \
    powerdevil \
    kinfocenter \
    kmenuedit \
    kdeplasma-addons \
    systemsettings \
    2>/dev/null

# KDE themes (using our own)
pacman -Rns --noconfirm \
    breeze \
    breeze-cursors \
    breeze-gtk \
    breeze-icons \
    oxygen \
    qqc2-breeze-style \
    cachyos-emerald-kde-theme-git \
    cachyos-iridescent-kde \
    cachyos-kde-settings \
    cachyos-nord-kde-theme-git \
    2>/dev/null

# KDE graphics (using other apps)
pacman -Rns --noconfirm \
    kdegraphics-mobipocket \
    kdegraphics-thumbnailers \
    gwenview \
    spectacle \
    2>/dev/null

# KDE I/O (not needed)
pacman -Rns --noconfirm \
    kio \
    kio-admin \
    kio-extras \
    kio-fuse \
    2>/dev/null

# KDE CLI tools (using our own)
pacman -Rns --noconfirm \
    kde-cli-tools \
    kde-gtk-config \
    kdesu \
    konsole \
    2>/dev/null

# KDE addons
pacman -Rns --noconfirm \
    kdeclarative \
    kded \
    kpackage \
    kservice \
    vlc-plugin-kate \
    2>/dev/null

echo ""
echo "Done! KDE bloat removed."
echo "You may need to reboot for full cleanup."
echo ""
echo "Remaining KDE packages (needed):"
pacman -Qs "kde\|plasma" 2>/dev/null | grep "^local/" | awk '{print "  " $1}'

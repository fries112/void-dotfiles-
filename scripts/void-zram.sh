#!/bin/bash
# VOID ZRAM Setup - Compressed swap for low RAM
# Run with: sudo bash scripts/void-zram.sh

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Run as root: sudo bash scripts/void-zram.sh"
    exit 1
fi

echo "=== VOID ZRAM Setup ==="

echo "[1/2] Installing zram-generator..."
pacman -S --needed --noconfirm zram-generator 2>/dev/null

echo "[2/2] Configuring ZRAM..."
cat > /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram, 16384)
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

systemctl daemon-reload
systemctl enable --now systemd-zram-setup@zram0.service 2>/dev/null || true

echo ""
echo "=== Done! ZRAM active ==="
echo "Swap: $(zramctl 2>/dev/null | tail -1 || echo 'check zramctl manually')"

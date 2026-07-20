#!/bin/bash
# ============================================
# VOID Noir - Hyprland Dotfiles Installer
# Dark Purple Minimal Theme
# ============================================

set -e

# Colors
P='\033[38;2;124;58;237m'
PK='\033[38;2;168;85;247m'
LT='\033[38;2;196;181;253m'
W='\033[38;2;226;232;240m'
D='\033[38;2;74;85;104m'
R='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${P}"
echo "    ██╗   ██╗██╗   ██╗██╗     ███╗   ██╗"
echo "    ██║   ██║██║   ██║██║     ████╗  ██║"
echo "    ██║   ██║██║   ██║██║     ██╔██╗ ██║"
echo "    ╚██╗ ██╔╝██║   ██║██║     ██║╚██╗██║"
echo "     ╚████╔╝ ╚██████╔╝███████╗██║ ╚████║"
echo "      ╚═══╝   ╚═════╝ ╚══════╝╚═╝  ╚═══╝"
echo -e "${R}"
echo -e "${D}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
echo -e "${LT}  VOID Noir Dotfiles Installer${R}"
echo -e "${D}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
echo ""

# Check Arch Linux
if [ ! -f /etc/arch-release ]; then
    echo -e "${PK}▸${R} This installer is for Arch Linux only."
    exit 1
fi

# Check root
if [ "$EUID" -eq 0 ]; then
    echo -e "${PK}▸${R} Don't run as root. Use sudo when prompted."
    exit 1
fi

echo -e "${PK}▸${R} This will install VOID Noir dotfiles on your system."
echo -e "${PK}▸${R} Packages will be installed via pacman."
echo -e "${PK}▸${R} Existing configs in ~/.config/ will be backed up."
echo ""
read -p "Continue? [y/N] " -n 1 -r
echo ""
[[ $REPLY =~ ^[Yy]$ ]] || exit 0

# ============================================
# STEP 1: Install packages
# ============================================
echo ""
echo -e "${P}[1/8]${R} Installing packages..."

PACKAGES=(
    # Core
    hyprland hyprpaper hyprlock hypridle hyprutils
    # Bar & menus
    waybar fuzzel
    # Notifications
    mako
    # Terminal
    ghostty
    # Shell
    fish starship
    # Screenshot
    grim slurp
    # Clipboard
    wl-clipboard
    # Wallpaper
    brightnessctl
    # App launcher deps
    wlogout
    # File manager
    yazi
    # System info
    fastfetch
    # Network
    networkmanager network-manager-applet
    # Bluetooth
    bluez bluez-utils blueman
    # Audio
    pipewire pipewire-pulse wireplumber pavucontrol
    # Screen recording
    gpu-screen-recorder
    # Polkit
    polkit-kde-authentication-agent
    # Fonts
    ttf-jetbrains-mono-nerd
    # Misc
    socat jq
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# ============================================
# STEP 2: Backup existing configs
# ============================================
echo ""
echo -e "${P}[2/8]${R} Backing up existing configs..."

BACKUP_DIR="$HOME/.config/void-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for dir in hypr waybar fuzzel mako ghostty fastfetch; do
    if [ -d "$HOME/.config/$dir" ]; then
        cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

for file in starship.toml; do
    if [ -f "$HOME/.config/$file" ]; then
        cp "$HOME/.config/$file" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

echo -e "  ${D}Backup saved to: $BACKUP_DIR${R}"

# ============================================
# STEP 3: Create directories
# ============================================
echo ""
echo -e "${P}[3/8]${R} Creating directories..."

mkdir -p "$HOME/.config/hypr/backgrounds"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/fuzzel"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/fish/functions"
mkdir -p "$HOME/Pictures/wallpapers"
mkdir -p "$HOME/Videos/Recordings"

# Auto-detect monitor
MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '.[0].name' 2>/dev/null || echo "")
if [ -n "$MONITOR" ] && [ "$MONITOR" != "null" ]; then
    echo "monitor = $MONITOR, preferred, auto, 1" > "$HOME/.config/hypr/monitors.conf"
    echo -e "  ${D}→${R} Detected monitor: $MONITOR"
else
    echo -e "  ${D}→${R} No monitor detected, using auto config"
fi

# ============================================
# STEP 4: Copy Hyprland configs
# ============================================
echo ""
echo -e "${P}[4/8]${R} Installing Hyprland configs..."

cp "$DOTFILES_DIR/hypr/hyprland.conf"      "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/animations.conf"    "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/keybinds.conf"      "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/windowrules.conf"   "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/monitors.conf"      "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/input.conf"         "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/env.conf"           "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/hyprpaper.conf"     "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/hyprlock.conf"      "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/hypridle.conf"      "$HOME/.config/hypr/"

# Scripts
cp "$DOTFILES_DIR/hypr/void-menu.sh"       "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/void-power.sh"      "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/void-record.sh"     "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/void-sober.sh"      "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/wallpaper-picker.sh" "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/wallpaper-next.sh"  "$HOME/.config/hypr/"
cp "$DOTFILES_DIR/hypr/keybinds-help.sh"   "$HOME/.config/hypr/"

chmod +x "$HOME/.config/hypr/"*.sh

# Backgrounds
cp "$DOTFILES_DIR/hypr/backgrounds/"* "$HOME/.config/hypr/backgrounds/" 2>/dev/null || true

# ============================================
# STEP 5: Copy app configs
# ============================================
echo ""
echo -e "${P}[5/8]${R} Installing app configs..."

cp "$DOTFILES_DIR/waybar/config.jsonc"  "$HOME/.config/waybar/"
cp "$DOTFILES_DIR/waybar/style.css"     "$HOME/.config/waybar/"
cp "$DOTFILES_DIR/fuzzel/fuzzel.ini"    "$HOME/.config/fuzzel/"
cp "$DOTFILES_DIR/mako/config"          "$HOME/.config/mako/"
cp "$DOTFILES_DIR/ghostty/config"       "$HOME/.config/ghostty/"
cp "$DOTFILES_DIR/starship.toml"        "$HOME/.config/"
cp "$DOTFILES_DIR/fastfetch/config.jsonc" "$HOME/.config/fastfetch/"
cp "$DOTFILES_DIR/fastfetch/logo.txt"   "$HOME/.config/fastfetch/"

# Fish shell
cp "$DOTFILES_DIR/fish/config.fish"                "$HOME/.config/fish/"
cp "$DOTFILES_DIR/fish/functions/fish_greeting.fish" "$HOME/.config/fish/functions/"

# ============================================
# STEP 6: Download wallpapers
# ============================================
echo ""
echo -e "${P}[6/8]${R} Downloading wallpapers..."

WALLPAPER_URLS=(
    "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1920&q=80|dark-mountains.jpg"
    "https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1920&q=80|abstract-dark.jpg"
    "https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?w=1920&q=80|purple-space.jpg"
    "https://images.unsplash.com/photo-1477346611705-65d1883cee1e?w=1920&q=80|forest-fog.jpg"
    "https://images.unsplash.com/photo-1519608487953-e999c86e7455?w=1920&q=80|neon-city.jpg"
)

for entry in "${WALLPAPER_URLS[@]}"; do
    URL="${entry%%|*}"
    NAME="${entry##*|}"
    if [ ! -f "$HOME/Pictures/wallpapers/$NAME" ]; then
        curl -sL "$URL" -o "$HOME/Pictures/wallpapers/$NAME" 2>/dev/null && \
            echo -e "  ${D}✓${R} $NAME" || \
            echo -e "  ${D}✗${R} Failed: $NAME"
    else
        echo -e "  ${D}→${R} $NAME (exists)"
    fi
done

# Set first wallpaper as active
if [ -f "$HOME/Pictures/wallpapers/dark-mountains.jpg" ]; then
    cp "$HOME/Pictures/wallpapers/dark-mountains.jpg" "$HOME/.config/hypr/backgrounds/active-wallpaper.jpg"
    echo "$HOME/Pictures/wallpapers/dark-mountains.jpg" > "$HOME/.config/hypr/backgrounds/.current-source"
fi

# ============================================
# STEP 7: Set fish as default shell
# ============================================
echo ""
echo -e "${P}[7/8]${R} Configuring shell..."

if [ "$SHELL" != "/usr/bin/fish" ]; then
    echo -e "  ${D}→${R} Setting fish as default shell..."
    chsh -s /usr/bin/fish
else
    echo -e "  ${D}→${R} Fish is already default shell"
fi

# ============================================
# STEP 8: Optional optimizations
# ============================================
echo ""
echo -e "${P}[8/8]${R} Optional system optimizations..."
echo ""
echo -e "  ${PK}▸${R} ${LT}1${R}  Ultimate debloat (~8GB freed, removes caches/docs/nvidia firmware/CachyOS bloat)"
echo -e "  ${PK}▸${R} ${LT}2${R}  ZRAM setup (compressed swap, great for low RAM)"
echo -e "  ${PK}▸${R} ${LT}3${R}  Gaming optimize (gamemode + CPU performance governor)"
echo -e "  ${PK}▸${R} ${LT}4${R}  KDE debloat (careful, keeps polkit agent + essential services)"
echo -e "  ${PK}▸${R} ${LT}5${R}  KDE nuclear (removes ALL KDE/Plasma packages)"
echo -e "  ${PK}▸${R} ${LT}6${R}  Apply ALL optimizations"
echo -e "  ${PK}▸${R} ${LT}s${R}  Skip (just dotfiles, no optimizations)"
echo ""
read -p "Choose [1-6/s]: " opt_choice

run_opt() {
    local script="$1"
    local desc="$2"
    echo ""
    echo -e "  ${PK}▸${R} Running ${LT}$desc${R}..."
    if [ -f "$DOTFILES_DIR/scripts/$script" ]; then
        sudo bash "$DOTFILES_DIR/scripts/$script"
    else
        echo -e "  ${D}✗${R} Script not found: scripts/$script"
    fi
}

case "$opt_choice" in
    1) run_opt "void-ultimate-debloat.sh" "ultimate debloat" ;;
    2) run_opt "void-zram.sh" "ZRAM setup" ;;
    3) run_opt "void-gaming-optimize.sh" "gaming optimize" ;;
    4) run_opt "void-debloat.sh" "KDE debloat (careful)" ;;
    5) run_opt "void-kde-debloat.sh" "KDE nuclear" ;;
    6)
        run_opt "void-ultimate-debloat.sh" "ultimate debloat"
        run_opt "void-zram.sh" "ZRAM setup"
        run_opt "void-gaming-optimize.sh" "gaming optimize"
        run_opt "void-debloat.sh" "KDE debloat (careful)"
        ;;
    s|S) echo -e "  ${D}→${R} Skipped optimizations" ;;
    *) echo -e "  ${D}→${R} Invalid choice, skipped" ;;
esac

# ============================================
# Done!
# ============================================
echo ""
echo -e "${P}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
echo -e "${W}  VOID Noir installed successfully!${R}"
echo -e "${P}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
echo ""
echo -e "  ${PK}▸${R} Log out and select Hyprland as session"
echo -e "  ${PK}▸${R} Or run: ${LT}Hyprland${R}"
echo ""
echo -e "  ${D}Keybinds:${R}"
echo -e "    Super+Enter     Terminal"
echo -e "    Super+D         App launcher"
echo -e "    Super+E         File manager (yazi)"
echo -e "    Super+X         Power menu"
echo -e "    Super+W         Wallpaper picker"
echo -e "    Super+Shift+W   Next wallpaper"
echo -e "    Super+?         Keybind cheat sheet"
echo -e "    Super+G         Launch Roblox (Sober)"
echo -e "    Super+Shift+R   Record screen"
echo ""
echo -e "  ${D}Backup location: $BACKUP_DIR${R}"
echo ""

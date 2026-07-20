#!/bin/bash
# VOID Wallpaper Picker - Smooth dark purple

PICS_DIR="$HOME/Pictures/wallpapers"
CURRENT="$HOME/.config/hypr/backgrounds/active-wallpaper.jpg"
TRACKER="$HOME/.config/hypr/backgrounds/.current-source"

if [ ! -d "$PICS_DIR" ]; then
    notify-send "VOID" "No ~/Pictures/wallpapers/ folder"
    exit 1
fi

FILES=$(find "$PICS_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

if [ -z "$FILES" ]; then
    notify-send "VOID" "No images in ~/Pictures/wallpapers/"
    exit 1
fi

LIST=""
while IFS= read -r f; do
    LIST="${LIST}$(basename "$f")\n"
done <<< "$FILES"

SELECTED=$(echo -e "$LIST" | fuzzel \
    --dmenu \
    --width=35 \
    --lines=8 \
    --prompt=" wallpaper > " \
    --font="CaskaydiaCove Nerd Font:size=12" \
    --color=7c3aedcc,1a1525ee,a855f7aa,e2e8f0ff,7c3aed66,a855f744 \
    --border-color=7c3aed88 \
    --border=1 \
    --background-radius=10 \
    --inner-pad=6)

if [ -z "$SELECTED" ]; then
    exit 0
fi

WALLPAPER=$(find "$PICS_DIR" -maxdepth 1 -name "$SELECTED" -type f | head -1)

if [ -z "$WALLPAPER" ]; then
    notify-send "VOID" "File not found: $SELECTED"
    exit 1
fi

cp "$WALLPAPER" "$CURRENT"
echo "$WALLPAPER" > "$TRACKER"

cat > ~/.config/hypr/hyprpaper.conf << EOF
splash = false

wallpaper {
    monitor = 
    path = $CURRENT
    fit_mode = cover
}
EOF

pkill hyprpaper
sleep 0.3
cd ~/.config/hypr && hyprpaper &>/dev/null &
disown

notify-send "VOID" "Wallpaper: $SELECTED"

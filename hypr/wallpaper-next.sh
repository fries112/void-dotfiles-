#!/bin/bash
# VOID Wallpaper Switcher - next wallpaper

PICS_DIR="$HOME/Pictures/wallpapers"
CURRENT="$HOME/.config/hypr/backgrounds/active-wallpaper.jpg"
TRACKER="$HOME/.config/hypr/backgrounds/.current-source"

WALLPAPERS=($(find "$PICS_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort))

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "VOID" "No wallpapers in ~/Pictures/wallpapers/"
    exit 1
fi

CURRENT_INDEX=0
if [ -f "$TRACKER" ]; then
    LAST=$(cat "$TRACKER")
    for i in "${!WALLPAPERS[@]}"; do
        if [ "${WALLPAPERS[$i]}" = "$LAST" ]; then
            CURRENT_INDEX=$i
            break
        fi
    done
fi

NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

cp "$NEXT_WALLPAPER" "$CURRENT"
echo "$NEXT_WALLPAPER" > "$TRACKER"

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

notify-send "VOID" "$(basename "$NEXT_WALLPAPER")"

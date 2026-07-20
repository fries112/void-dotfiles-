#!/bin/bash
# VOID App Menu - Dark Purple

options=(
    "  Terminal"
    "  Files"
    "  Wallpaper"
    "  Bluetooth"
    "  Network"
    "  Audio"
    "  Screenshots"
    "  Lock"
    "  Power"
)

selected=$(printf '%s\n' "${options[@]}" | fuzzel \
    --dmenu \
    --width=25 \
    --lines=10 \
    --prompt=" void > " \
    --font="CaskaydiaCove Nerd Font:size=12" \
    --color=7c3aedcc,1a1525ee,a855f7aa,e2e8f0ff,7c3aed66,a855f744 \
    --border-color=7c3aed88 \
    --border=1 \
    --background-radius=10 \
    --inner-pad=6)

case "$selected" in
    *"Terminal"*) ghostty ;;
    *"Files"*) ghostty -e yazi ;;
    *"Wallpaper"*) ~/.config/hypr/wallpaper-picker.sh ;;
    *"Bluetooth"*) blueman-manager ;;
    *"Network"*) nm-connection-editor ;;
    *"Audio"*) pavucontrol ;;
    *"Screenshots"*) grim -g "$(slurp)" - | wl-copy && notify-send "VOID" "Screenshot saved" ;;
    *"Lock"*) hyprlock ;;
    *"Power"*) ~/.config/hypr/void-power.sh ;;
esac

#!/bin/bash
# VOID Power Menu - Glowy purple minimal

OPTIONS="  Power Off
  Restart
  Lock
  Suspend
  Logout"

SELECTED=$(echo "$OPTIONS" | fuzzel \
    --dmenu \
    --width=20 \
    --lines=5 \
    --prompt=" " \
    --font="CaskaydiaCove Nerd Font:size=12" \
    --color=7c3aedcc,1a1525ee,a855f7aa,e2e8f0ff,7c3aed66,a855f744 \
    --border-color=7c3aed88 \
    --border=1 \
    --background-radius=12 \
    --inner-pad=8)

case "$SELECTED" in
    *"Power Off"*)  systemctl poweroff ;;
    *"Restart"*)    systemctl reboot ;;
    *"Lock"*)       hyprlock ;;
    *"Suspend"*)    systemctl suspend ;;
    *"Logout"*)     hyprctl dispatch exit ;;
esac

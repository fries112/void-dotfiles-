# opencode
fish_add_path ~/.opencode/bin

if status is-interactive
    # Starship prompt
    starship init fish | source

    # VOID aliases
    alias ll='ls -la --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF'
    alias ff='fastfetch'
    alias yz='yazi'
    alias vi='nvim'
    alias vim='nvim'
    alias cls='clear'
    alias rr='void-record.sh'
    alias wp='~/.config/hypr/wallpaper-picker.sh'
    alias menu='~/.config/hypr/void-menu.sh'
    alias kb='~/.config/hypr/keybinds-help.sh'

    # System
    alias update='sudo pacman -Syu'
    alias install='sudo pacman -S'
    alias remove='sudo pacman -Rns'
    alias cleanup='sudo pacman -Sc --noconfirm'
    alias mirror='sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

    # Hyprland
    alias reload='hyprctl reload'
    alias kb-list='hyprctl binds'
    alias wp-next='~/.config/hypr/wallpaper-next.sh'

    # Fun greeting
    set -g fish_greeting ""
end

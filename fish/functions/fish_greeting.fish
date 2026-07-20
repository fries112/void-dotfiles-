function fish_greeting
    set PURPLE '\033[38;2;124;58;237m'
    set PINK '\033[38;2;168;85;247m'
    set LIGHT '\033[38;2;196;181;253m'
    set WHITE '\033[38;2;226;232;240m'
    set DIM '\033[38;2;74;85;104m'
    set GLOW '\033[38;2;124;58;237m'
    set RESET '\033[0m'

    echo ""
    echo -e "$PURPLE"
    echo "    ██╗   ██╗██╗   ██╗██╗     ███╗   ██╗"
    echo "    ██║   ██║██║   ██║██║     ████╗  ██║"
    echo "    ██║   ██║██║   ██║██║     ██╔██╗ ██║"
    echo "    ╚██╗ ██╔╝██║   ██║██║     ██║╚██╗██║"
    echo "     ╚████╔╝ ╚██████╔╝███████╗██║ ╚████║"
    echo "      ╚═══╝   ╚═════╝ ╚══════╝╚═╝  ╚═══╝"
    echo -e "$RESET"
    echo -e "$DIM  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$RESET"
    echo ""
    echo -ne "  $PINK▸$RESET booting void"
    sleep 0.12
    echo -n "."
    sleep 0.08
    echo -n "."
    sleep 0.08
    echo -n "."
    sleep 0.08
    echo -e " $WHITE done$RESET"
    echo -ne "  $PINK▸$RESET loading neural core"
    sleep 0.12
    echo -n "."
    sleep 0.08
    echo -n "."
    sleep 0.08
    echo -n "."
    sleep 0.08
    echo -e " $WHITE done$RESET"
    echo -ne "  $PINK▸$RESET syncing shadows"
    sleep 0.12
    echo -n "."
    sleep 0.08
    echo -n "."
    sleep 0.08
    echo -n "."
    sleep 0.08
    echo -e " $WHITE done$RESET"
    echo ""
    echo -e "  $DIM ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓$RESET"
    echo -e "  $PURPLE ▓$RESET $LIGHT welcome back, $USER$RESET                       $PURPLE ▓$RESET"
    echo -e "  $DIM ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓$RESET"
    echo ""
    echo ""
end

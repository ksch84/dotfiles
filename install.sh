#!/bin/bash
# Install required binaries for dotfiles on Debian/apt-based systems
# Usage: sudo ./install.sh [minimal|window-manager|full]
#   minimal        - install only minimal dependencies (default)
#   window-manager - install window manager dependencies
#   full           - install all dependencies

set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script requires root privileges."
    echo "Please run: sudo $0 [minimal|window-manager|full]"
    exit 1
fi

# Detect package manager
if ! command -v apt &> /dev/null; then
    echo "Error: apt not found. This script is for Debian/Ubuntu based systems."
    exit 1
fi

# Determine mode
MODE="${1:-minimal}"

echo "============================================"
echo "  Dotfiles - Installing dependencies"
echo "  Mode: ${MODE}"
echo "============================================"
echo ""

# Update package lists
echo "[1/3] Updating package lists..."
apt update -qq

# Minimal dependencies
MINIMAL_PKGS=(
    stow
    mpd
    ncmpcpp
    x11-xserver-utils
    x11-xkb-utils
    zsh             # .zshrc
    vim             # EDITOR and .vimrc
    fzf             # Ctrl-F binding in bash/zsh
    htop            # the `top` alias
)

# Window manager dependencies
WM_PKGS=(
    bspwm
    sxhkd
    polybar
    feh             # sets the wallpaper (bspwmrc)
    picom
    rofi
    zathura
    pulseaudio-utils
    fonts-font-awesome
    x11-utils
    xinit           # startx
    rxvt-unicode    # urxvt, the terminal (super + Return)
    scrot           # screenshots (Print key)
    libnotify-bin   # notify-send, used by the power menu
    dunst           # shows the notifications notify-send sends
    i3lock          # screen locker
    xss-lock        # runs i3lock when the session is locked (see bspwmrc)
    pavucontrol     # volume mixer (right-click on the polybar mute icon)
)

# Install minimal packages
echo "[2/3] Installing minimal dependencies..."
apt install -y "${MINIMAL_PKGS[@]}"

# Install window manager packages if requested
if [ "$MODE" = "full" ] || [ "$MODE" = "window-manager" ]; then
    echo ""
    echo "[3/3] Installing window manager dependencies..."
    apt install -y "${WM_PKGS[@]}"

    # ibus (the input method tool) has its own shortcuts that take over
    # keys sxhkd needs: super + space (switch input language) and
    # super + period (emoji picker). A key can only belong to one program,
    # so sxhkd never sees them. Turn off the language switch shortcut and
    # keep the emoji picker on super + ; only.
    # Only runs if ibus is installed.
    if [ -n "$SUDO_USER" ] && command -v gsettings &> /dev/null \
        && gsettings list-schemas | grep -qx org.freedesktop.ibus.general.hotkey; then
        echo ""
        echo "[ibus] Releasing super + space and super + period for sxhkd..."
        # This script runs as root, but the settings belong to the normal
        # user who ran sudo ($SUDO_USER), so run gsettings as that user.
        # dbus-run-session starts the small background service gsettings
        # needs to save the settings, since root has none for that user.
        # A running ibus only picks this up after `ibus restart` or re-login.
        sudo -H -u "$SUDO_USER" dbus-run-session sh -c '
            gsettings set org.freedesktop.ibus.general.hotkey triggers "[]"
            gsettings set org.freedesktop.ibus.panel.emoji hotkey "[\"<Super>semicolon\"]"
        '
    fi
fi

echo ""
echo "============================================"
echo "  All dependencies installed successfully!"
echo "============================================"

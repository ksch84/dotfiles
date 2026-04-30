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
)

# Window manager dependencies
WM_PKGS=(
    bspwm
    sxhkd
    polybar
    nitrogen
    picom
    rofi
    zathura
    pulseaudio-utils
    fonts-font-awesome
    x11-utils
)

# Install minimal packages
echo "[2/3] Installing minimal dependencies..."
apt install -y "${MINIMAL_PKGS[@]}"

# Install window manager packages if requested
if [ "$MODE" = "full" ] || [ "$MODE" = "window-manager" ]; then
    echo ""
    echo "[3/3] Installing window manager dependencies..."
    apt install -y "${WM_PKGS[@]}"
fi

# Clean up
echo ""
echo "[Cleanup] Removing unnecessary packages..."
apt autoremove -y

echo ""
echo "============================================"
echo "  All dependencies installed successfully!"
echo "============================================"

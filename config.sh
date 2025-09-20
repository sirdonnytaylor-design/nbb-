# Xero Linux KDE ISO Builder Configuration
# This file contains customizable settings for the ISO build process

# Basic ISO settings
ISO_NAME_PREFIX="xero-linux-kde-hyprland"
ISO_VERSION="1.0"
OUTPUT_DIR="$HOME/Downloads"

# Build settings
BUILD_PARALLEL_JOBS=4
COMPRESSION_LEVEL=6

# Desktop Environment Settings
DEFAULT_USER="xero"
DEFAULT_PASSWORD="xero"
HOSTNAME="xero-linux"

# Package selections (space-separated)
KDE_PACKAGES="plasma-meta plasma-wayland-session kde-applications-meta sddm sddm-kcm"
HYPRLAND_PACKAGES="hyprland hyprpaper hyprlock hyprcursor waybar wofi kitty"
ESSENTIAL_PACKAGES="firefox thunar networkmanager network-manager-applet"
UTILITIES="neofetch git wget curl vim nano htop tree"
AUDIO_PACKAGES="pulseaudio pulseaudio-alsa pavucontrol"
FONTS="ttf-dejavu ttf-liberation noto-fonts"

# Xero Linux specific settings
ENABLE_XERO_TOOLS=true
XERO_REPO_URL="https://github.com/xerolinux/xlapit-cli.git"

# Hyprland specific settings
HYPRLAND_REPO_URL="https://github.com/hyprwm/Hyprland.git"
ENABLE_HYPRLAND_ANIMATIONS=true
ENABLE_BLUR_EFFECTS=true

# System settings
ENABLE_AUTOLOGIN=true
DEFAULT_SHELL="/bin/bash"
TIMEZONE="UTC"
LOCALE="en_US.UTF-8"

# Services to enable by default
SERVICES_ENABLE="sddm NetworkManager"
SERVICES_DISABLE=""

# Custom repository settings
ENABLE_AUR=true
CUSTOM_REPOS=""

# Boot settings
BOOT_TIMEOUT=30
QUIET_BOOT=false

# Security settings
ENABLE_FIREWALL=true
SSH_ENABLED=false
ROOT_PASSWORD_DISABLED=true
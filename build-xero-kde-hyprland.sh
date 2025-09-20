#!/bin/bash

# Xero Linux KDE Hyprland Build Script
# This script builds and configures Xero Linux with KDE Plasma and Hyprland
# Version: 1.0
# Author: Build Script Generator

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root for safety reasons."
        error "Please run as a regular user. The script will prompt for sudo when needed."
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    log "Checking system requirements..."
    
    # Check if we're on a supported system
    if ! command -v pacman &> /dev/null; then
        error "This script requires an Arch-based system with pacman package manager."
        exit 1
    fi
    
    # Check available disk space (minimum 10GB)
    available_space=$(df / | awk 'NR==2 {print $4}')
    if [[ $available_space -lt 10485760 ]]; then  # 10GB in KB
        warning "Less than 10GB available disk space. Installation may fail."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check internet connectivity
    if ! ping -c 1 google.com &> /dev/null; then
        error "No internet connection detected. Internet is required for package installation."
        exit 1
    fi
    
    log "System requirements check passed."
}

# Update system
update_system() {
    log "Updating system packages..."
    sudo pacman -Syu --noconfirm
    log "System update completed."
}

# Install Xero Linux repositories and base
setup_xero_repos() {
    log "Setting up Xero Linux repositories..."
    
    # Add Xero Linux keyring if not already present
    if ! pacman -Qi xero-keyring &> /dev/null; then
        info "Installing Xero Linux keyring..."
        wget -O /tmp/xero-keyring.pkg.tar.xz "https://github.com/xerolinux/xero-keyring/releases/latest/download/xero-keyring-latest-any.pkg.tar.xz"
        sudo pacman -U /tmp/xero-keyring.pkg.tar.xz --noconfirm
    fi
    
    # Add Xero repositories to pacman.conf if not already present
    if ! grep -q "xerolinux" /etc/pacman.conf; then
        info "Adding Xero Linux repositories..."
        sudo tee -a /etc/pacman.conf << 'EOF'

# Xero Linux Repositories
[xerolinux-repo]
SigLevel = Optional TrustAll
Server = https://repo.xerolinux.xyz/$repo/$arch

[xerolinux-xl]
SigLevel = Optional TrustAll
Server = https://repo.xerolinux.xyz/$repo/$arch
EOF
    fi
    
    sudo pacman -Sy
    log "Xero Linux repositories configured."
}

# Install KDE Plasma Desktop Environment
install_kde() {
    log "Installing KDE Plasma Desktop Environment..."
    
    # Core KDE packages
    local kde_packages=(
        plasma-meta
        plasma-desktop
        plasma-workspace
        plasma-systemmonitor
        kde-applications-meta
        konsole
        kate
        dolphin
        gwenview
        okular
        firefox
        vlc
        gimp
        libreoffice-fresh
        ark
        spectacle
        kwrite
        kcalc
        krunner
        kwin
        plasma-nm
        plasma-pa
        bluedevil
        powerdevil
        breeze-gtk
        kde-gtk-config
    )
    
    info "Installing KDE packages: ${kde_packages[*]}"
    sudo pacman -S --needed --noconfirm "${kde_packages[@]}"
    
    # Enable SDDM display manager
    sudo systemctl enable sddm
    
    log "KDE Plasma installation completed."
}

# Install Hyprland and dependencies
install_hyprland() {
    log "Installing Hyprland and dependencies..."
    
    # Hyprland and essential packages
    local hyprland_packages=(
        hyprland
        waybar
        wofi
        mako
        swaylock-effects
        swayidle
        wl-clipboard
        grim
        slurp
        swappy
        thunar
        alacritty
        kitty
        polkit-gnome
        xdg-desktop-portal-hyprland
        qt5-wayland
        qt6-wayland
        pipewire
        pipewire-alsa
        pipewire-pulse
        pipewire-jack
        wireplumber
        wlroots
        wayland
    )
    
    info "Installing Hyprland packages: ${hyprland_packages[*]}"
    sudo pacman -S --needed --noconfirm "${hyprland_packages[@]}"
    
    log "Hyprland installation completed."
}

# Configure Hyprland
configure_hyprland() {
    log "Configuring Hyprland..."
    
    # Create Hyprland config directory
    mkdir -p ~/.config/hypr
    
    # Create basic Hyprland configuration
    cat > ~/.config/hypr/hyprland.conf << 'EOF'
# Hyprland Configuration
# For Xero Linux KDE Hyprland Setup

# Monitor configuration
monitor=,preferred,auto,auto

# Execute your favorite apps at launch
exec-once = waybar
exec-once = mako
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000'

# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Some default env vars.
env = XCURSOR_SIZE,24

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle
}

decoration {
    rounding = 10
    blur = yes
    blur_size = 3
    blur_passes = 1
    blur_new_optimizations = on

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    pseudotile = yes
    preserve_split = yes
}

master {
    new_is_master = true
}

gestures {
    workspace_swipe = off
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

# Key bindings
$mainMod = SUPER

# Example binds
bind = $mainMod, Q, exec, kitty
bind = $mainMod, C, killactive, 
bind = $mainMod, M, exit, 
bind = $mainMod, E, exec, thunar
bind = $mainMod, V, togglefloating, 
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, L, exec, swaylock

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
EOF

    log "Hyprland configuration created."
}

# Configure Waybar
configure_waybar() {
    log "Configuring Waybar..."
    
    mkdir -p ~/.config/waybar
    
    # Waybar config
    cat > ~/.config/waybar/config << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 4,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["hyprland/window"],
    "modules-right": ["idle_inhibitor", "pulseaudio", "network", "cpu", "memory", "temperature", "backlight", "battery", "clock", "tray"],
    
    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
            "1": "",
            "2": "",
            "3": "",
            "4": "",
            "5": "",
            "urgent": "",
            "focused": "",
            "default": ""
        }
    },
    "keyboard-state": {
        "numlock": true,
        "capslock": true,
        "format": "{name} {icon}",
        "format-icons": {
            "locked": "",
            "unlocked": ""
        }
    },
    "hyprland/window": {
        "format": "{title}"
    },
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "",
            "deactivated": ""
        }
    },
    "tray": {
        "spacing": 10
    },
    "clock": {
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format-alt": "{:%Y-%m-%d}"
    },
    "cpu": {
        "format": "{usage}% ",
        "tooltip": false
    },
    "memory": {
        "format": "{}% "
    },
    "temperature": {
        "critical-threshold": 80,
        "format": "{temperatureC}°C {icon}",
        "format-icons": ["", "", ""]
    },
    "backlight": {
        "format": "{percent}% {icon}",
        "format-icons": ["", "", "", "", "", "", "", "", ""]
    },
    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        "format-charging": "{capacity}% ",
        "format-plugged": "{capacity}% ",
        "format-alt": "{time} {icon}",
        "format-icons": ["", "", "", "", ""]
    },
    "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "tooltip-format": "{ifname} via {gwaddr} ",
        "format-linked": "{ifname} (No IP) ",
        "format-disconnected": "Disconnected ⚠",
        "format-alt": "{ifname}: {ipaddr}/{cidr}"
    },
    "pulseaudio": {
        "format": "{volume}% {icon} {format_source}",
        "format-bluetooth": "{volume}% {icon} {format_source}",
        "format-bluetooth-muted": " {icon} {format_source}",
        "format-muted": " {format_source}",
        "format-source": "{volume}% ",
        "format-source-muted": "",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    }
}
EOF

    # Waybar style
    cat > ~/.config/waybar/style.css << 'EOF'
* {
    border: none;
    border-radius: 0;
    font-family: "Fira Code", "Font Awesome 5";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: rgba(43, 48, 59, 0.8);
    border-bottom: 3px solid rgba(100, 114, 125, 0.5);
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.2;
}

button {
    box-shadow: inset 0 -3px transparent;
    border: none;
    border-radius: 0;
}

button:hover {
    background: inherit;
    box-shadow: inset 0 -3px #ffffff;
}

#workspaces button {
    padding: 0 5px;
    background-color: transparent;
    color: #ffffff;
}

#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
}

#workspaces button.focused {
    background-color: #64727D;
    box-shadow: inset 0 -3px #ffffff;
}

#workspaces button.urgent {
    background-color: #eb4d4b;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#mpd {
    padding: 0 10px;
    color: #ffffff;
}

#window,
#workspaces {
    margin: 0 4px;
}

.modules-left > widget:first-child > #workspaces {
    margin-left: 0;
}

.modules-right > widget:last-child > #workspaces {
    margin-right: 0;
}

#clock {
    background-color: #64727D;
}

#battery {
    background-color: #ffffff;
    color: #000000;
}

#battery.charging, #battery.plugged {
    color: #ffffff;
    background-color: #26A65B;
}

@keyframes blink {
    to {
        background-color: #ffffff;
        color: #000000;
    }
}

#battery.critical:not(.charging) {
    background-color: #f53c3c;
    color: #ffffff;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

label:focus {
    background-color: #000000;
}

#cpu {
    background-color: #2ecc71;
    color: #000000;
}

#memory {
    background-color: #9b59b6;
}

#disk {
    background-color: #964B00;
}

#backlight {
    background-color: #90b1b1;
}

#network {
    background-color: #2980b9;
}

#network.disconnected {
    background-color: #f53c3c;
}

#pulseaudio {
    background-color: #f1c40f;
    color: #000000;
}

#pulseaudio.muted {
    background-color: #90b1b1;
    color: #2a5c45;
}

#temperature {
    background-color: #f0932b;
}

#temperature.critical {
    background-color: #eb4d4b;
}

#tray {
    background-color: #2980b9;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
}

#idle_inhibitor {
    background-color: #2d3748;
}

#idle_inhibitor.activated {
    background-color: #ecf0f1;
    color: #2d3748;
}
EOF

    log "Waybar configuration created."
}

# Configure desktop session files
configure_sessions() {
    log "Configuring desktop session files..."
    
    # Create Hyprland session file
    sudo tee /usr/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

    # Create script to switch between KDE and Hyprland
    cat > ~/switch-desktop.sh << 'EOF'
#!/bin/bash

echo "Desktop Environment Switcher"
echo "1. KDE Plasma (X11/Wayland)"
echo "2. Hyprland (Wayland)"
echo "3. Current session info"

read -p "Choose an option (1-3): " choice

case $choice in
    1)
        echo "To use KDE Plasma:"
        echo "1. Log out of current session"
        echo "2. At login screen, select 'Plasma (X11)' or 'Plasma (Wayland)'"
        echo "3. Log in"
        ;;
    2)
        echo "To use Hyprland:"
        echo "1. Log out of current session"
        echo "2. At login screen, select 'Hyprland'"
        echo "3. Log in"
        ;;
    3)
        echo "Current session information:"
        echo "Desktop: $XDG_CURRENT_DESKTOP"
        echo "Session: $XDG_SESSION_DESKTOP"
        echo "Session Type: $XDG_SESSION_TYPE"
        echo "Wayland Display: $WAYLAND_DISPLAY"
        ;;
    *)
        echo "Invalid option"
        ;;
esac
EOF
    chmod +x ~/switch-desktop.sh

    log "Desktop session configuration completed."
}

# Post-installation setup
post_install_setup() {
    log "Performing post-installation setup..."
    
    # Enable necessary services
    sudo systemctl enable NetworkManager
    sudo systemctl enable bluetooth
    
    # Configure audio
    systemctl --user enable pipewire pipewire-pulse wireplumber
    
    # Create default directories
    mkdir -p ~/Pictures/Screenshots
    mkdir -p ~/.local/bin
    
    # Add local bin to PATH if not already there
    if ! grep -q "$HOME/.local/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    log "Post-installation setup completed."
}

# Create useful aliases and functions
create_aliases() {
    log "Creating useful aliases..."
    
    cat >> ~/.bashrc << 'EOF'

# Xero Linux KDE Hyprland aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias hypr-config='nano ~/.config/hypr/hyprland.conf'
alias waybar-config='nano ~/.config/waybar/config'
alias reload-waybar='killall waybar && waybar &'
alias screenshot='grim ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d_%H%M%S).png'
alias screenshot-area='grim -g "$(slurp)" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d_%H%M%S).png'

# Quick system info
alias sysinfo='echo "System: $(uname -a)" && echo "Desktop: $XDG_CURRENT_DESKTOP" && echo "Session: $XDG_SESSION_TYPE"'
EOF

    log "Aliases created. Source ~/.bashrc or restart terminal to use them."
}

# Main installation function
main() {
    clear
    echo -e "${BLUE}"
    echo "==============================================="
    echo "  Xero Linux KDE Hyprland Build Script"
    echo "==============================================="
    echo -e "${NC}"
    echo
    echo "This script will install:"
    echo "- Xero Linux repositories and packages"
    echo "- KDE Plasma Desktop Environment"
    echo "- Hyprland Window Manager"
    echo "- Essential applications and configurations"
    echo
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    
    # Run installation steps
    check_root
    check_requirements
    update_system
    setup_xero_repos
    install_kde
    install_hyprland
    configure_hyprland
    configure_waybar
    configure_sessions
    post_install_setup
    create_aliases
    
    echo
    log "Installation completed successfully!"
    echo
    echo -e "${GREEN}Next steps:${NC}"
    echo "1. Reboot your system: sudo reboot"
    echo "2. At the login screen, you can choose between:"
    echo "   - Plasma (X11) - for KDE with X11"
    echo "   - Plasma (Wayland) - for KDE with Wayland"
    echo "   - Hyprland - for Hyprland compositor"
    echo "3. Use ~/switch-desktop.sh for session switching help"
    echo
    echo -e "${BLUE}Hyprland Quick Start:${NC}"
    echo "- Super+Q: Open terminal"
    echo "- Super+R: Application launcher"
    echo "- Super+E: File manager"
    echo "- Super+L: Lock screen"
    echo "- Super+C: Close window"
    echo
    echo -e "${YELLOW}Configuration files:${NC}"
    echo "- Hyprland: ~/.config/hypr/hyprland.conf"
    echo "- Waybar: ~/.config/waybar/config"
    echo "- Desktop switcher: ~/switch-desktop.sh"
    echo
    echo "Enjoy your new Xero Linux KDE Hyprland setup! 🚀"
}

# Run main function
main "$@"
#!/bin/bash

# Xero Linux KDE ISO Builder with Hyprland
# This script builds a bootable ISO of Xero Linux KDE with Hyprland toolkit

set -e

# Configuration
BUILD_DIR="./build"
ISO_OUTPUT_DIR="$HOME/Downloads"
ISO_NAME="xero-linux-kde-hyprland-$(date +%Y%m%d-%H%M%S).iso"
WORK_DIR="$BUILD_DIR/work"
OUT_DIR="$BUILD_DIR/out"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root for security reasons."
        error "Please run as a regular user. The script will use sudo when needed."
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    log "Checking dependencies..."
    
    local deps=("archiso" "git" "wget" "curl" "pacman")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error "Missing dependencies: ${missing_deps[*]}"
        log "Installing missing dependencies..."
        
        # Install archiso and other tools
        sudo pacman -Sy --noconfirm archiso git wget curl
    fi
    
    success "All dependencies satisfied"
}

# Setup build environment
setup_build_env() {
    log "Setting up build environment..."
    
    # Create build directories
    mkdir -p "$BUILD_DIR"
    mkdir -p "$WORK_DIR"
    mkdir -p "$OUT_DIR"
    mkdir -p "$ISO_OUTPUT_DIR"
    
    # Copy archiso profile as base
    if [[ ! -d "$BUILD_DIR/archiso-profile" ]]; then
        cp -r /usr/share/archiso/configs/releng "$BUILD_DIR/archiso-profile"
    fi
    
    success "Build environment ready"
}

# Download and integrate Xero Linux components
setup_xero_linux() {
    log "Setting up Xero Linux components..."
    
    local xero_dir="$BUILD_DIR/xero-linux"
    
    if [[ ! -d "$xero_dir" ]]; then
        log "Cloning Xero Linux repository..."
        git clone https://github.com/xerolinux/xlapit-cli.git "$xero_dir" || {
            warning "Could not clone Xero Linux repo, creating custom configuration..."
            mkdir -p "$xero_dir"
        }
    fi
    
    success "Xero Linux components ready"
}

# Setup Hyprland from official toolkit
setup_hyprland() {
    log "Setting up Hyprland from official toolkit..."
    
    local hyprland_dir="$BUILD_DIR/hyprland"
    
    if [[ ! -d "$hyprland_dir" ]]; then
        log "Cloning Hyprland repository..."
        git clone https://github.com/hyprwm/Hyprland.git "$hyprland_dir" || {
            warning "Could not clone Hyprland repo, will use package manager version"
            mkdir -p "$hyprland_dir"
        }
    fi
    
    success "Hyprland setup complete"
}

# Customize archiso profile for Xero Linux KDE + Hyprland
customize_profile() {
    log "Customizing ISO profile..."
    
    local profile_dir="$BUILD_DIR/archiso-profile"
    local packages_file="$profile_dir/packages.x86_64"
    local airootfs_dir="$profile_dir/airootfs"
    
    # Add KDE and Hyprland packages
    cat >> "$packages_file" << 'EOF'

# KDE Plasma Desktop
plasma-meta
plasma-wayland-session
kde-applications-meta
sddm
sddm-kcm

# Hyprland and related packages
hyprland
hyprpaper
hyprlock
hyprcursor
waybar
wofi
kitty
thunar
firefox

# Xero Linux specific tools
neofetch
git
wget
curl
vim
nano
htop
tree

# Additional utilities
networkmanager
network-manager-applet
pulseaudio
pulseaudio-alsa
pavucontrol
ttf-dejavu
ttf-liberation
noto-fonts

EOF

    # Create custom configuration scripts
    mkdir -p "$airootfs_dir/etc/skel/.config"
    mkdir -p "$airootfs_dir/usr/local/bin"
    
    # Create Hyprland configuration
    cat > "$airootfs_dir/etc/skel/.config/hyprland.conf" << 'EOF'
# Hyprland configuration for Xero Linux
monitor=,preferred,auto,auto

exec-once = waybar
exec-once = hyprpaper

input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = no
    }
    sensitivity = 0
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
    blur {
        enabled = true
        size = 3
        passes = 1
    }
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

# Key bindings
$mainMod = SUPER

bind = $mainMod, Q, exec, kitty
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, thunar
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,

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

    # Create startup script
    cat > "$airootfs_dir/usr/local/bin/xero-setup" << 'EOF'
#!/bin/bash

# Xero Linux post-boot setup script
echo "Welcome to Xero Linux with Hyprland!"
echo "Setting up desktop environment..."

# Start display manager
systemctl enable sddm
systemctl enable NetworkManager

# Set default session to Hyprland
echo "[Autologin]" > /etc/sddm.conf.d/autologin.conf
echo "Session=hyprland" >> /etc/sddm.conf.d/autologin.conf
echo "User=xero" >> /etc/sddm.conf.d/autologin.conf

echo "Setup complete!"
EOF

    chmod +x "$airootfs_dir/usr/local/bin/xero-setup"
    
    # Create user setup
    cat > "$airootfs_dir/etc/systemd/system/xero-setup.service" << 'EOF'
[Unit]
Description=Xero Linux Setup
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/xero-setup
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    success "Profile customization complete"
}

# Build the ISO
build_iso() {
    log "Building ISO image..."
    
    local profile_dir="$BUILD_DIR/archiso-profile"
    
    # Build with archiso
    cd "$BUILD_DIR"
    
    sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$profile_dir"
    
    # Find the generated ISO
    local iso_file=$(find "$OUT_DIR" -name "*.iso" | head -n1)
    
    if [[ -n "$iso_file" && -f "$iso_file" ]]; then
        # Copy to downloads folder with custom name
        cp "$iso_file" "$ISO_OUTPUT_DIR/$ISO_NAME"
        success "ISO built successfully: $ISO_OUTPUT_DIR/$ISO_NAME"
        
        # Show file size
        local size=$(du -h "$ISO_OUTPUT_DIR/$ISO_NAME" | cut -f1)
        log "ISO size: $size"
        
        return 0
    else
        error "ISO build failed - no output file found"
        return 1
    fi
}

# Cleanup function
cleanup() {
    log "Cleaning up build artifacts..."
    sudo rm -rf "$WORK_DIR"
    log "Build artifacts cleaned"
}

# Main execution
main() {
    log "Starting Xero Linux KDE with Hyprland ISO build..."
    
    check_root
    check_dependencies
    setup_build_env
    setup_xero_linux
    setup_hyprland
    customize_profile
    
    if build_iso; then
        success "Build completed successfully!"
        log "Your bootable ISO is ready at: $ISO_OUTPUT_DIR/$ISO_NAME"
        log "You can now burn this ISO to a USB drive or DVD"
    else
        error "Build failed!"
        exit 1
    fi
    
    # Ask if user wants to cleanup
    read -p "Do you want to clean up build artifacts? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cleanup
    fi
}

# Run main function
main "$@"
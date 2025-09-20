# Xero Linux KDE Hyprland Build Script

This repository contains a comprehensive build script for setting up Xero Linux with both KDE Plasma desktop environment and Hyprland window manager.

## Features

- **Dual Desktop Setup**: Install both KDE Plasma and Hyprland
- **Xero Linux Integration**: Properly configures Xero Linux repositories and packages
- **Complete Configuration**: Includes Waybar, terminal, file manager, and essential applications
- **Session Switching**: Easy switching between desktop environments
- **User-Friendly**: Comprehensive error checking and user feedback

## Quick Start

1. **Clone and run the script:**
   ```bash
   git clone https://github.com/sirdonnytaylor-design/nbb-.git
   cd nbb-
   ./build-xero-kde-hyprland.sh
   ```

2. **Follow the prompts** and let the script install everything

3. **Reboot** when installation is complete

4. **Choose your desktop** at the login screen:
   - Plasma (X11) - KDE with X11
   - Plasma (Wayland) - KDE with Wayland  
   - Hyprland - Tiling window manager

## What Gets Installed

### KDE Plasma Desktop
- Full KDE Plasma desktop environment
- Essential KDE applications (Konsole, Kate, Dolphin, etc.)
- LibreOffice, Firefox, GIMP, VLC
- SDDM display manager

### Hyprland Window Manager
- Hyprland compositor with optimized configuration
- Waybar status bar with system monitoring
- Wofi application launcher
- Mako notification daemon
- Swaylock screen locker
- Essential Wayland utilities

### System Components
- Xero Linux repositories and keyring
- PipeWire audio system
- NetworkManager for connectivity
- Bluetooth support
- Screenshot utilities

## Usage

### Hyprland Key Bindings
- `Super + Q` - Open terminal
- `Super + R` - Application launcher
- `Super + E` - File manager
- `Super + L` - Lock screen
- `Super + C` - Close window
- `Super + 1-9` - Switch workspaces
- `Super + Shift + 1-9` - Move window to workspace

### Configuration Files
- Hyprland: `~/.config/hypr/hyprland.conf`
- Waybar: `~/.config/waybar/config`
- Waybar style: `~/.config/waybar/style.css`

### Desktop Switching
Use the included `~/switch-desktop.sh` script for help switching between desktop environments.

### Useful Aliases
The script installs several useful aliases:
- `hypr-config` - Edit Hyprland configuration
- `waybar-config` - Edit Waybar configuration  
- `reload-waybar` - Restart Waybar
- `screenshot` - Take full screenshot
- `screenshot-area` - Take area screenshot
- `sysinfo` - Show system information

## Requirements

- Arch Linux based system with pacman
- Internet connection for package downloads
- At least 10GB available disk space
- Regular user account (script will request sudo when needed)

## Troubleshooting

### Common Issues

1. **Package conflicts**: The script handles most conflicts automatically
2. **Network issues**: Ensure stable internet connection during installation
3. **Disk space**: Monitor available space, especially on root partition

### Getting Help

1. Check the installation logs for error messages
2. Verify system requirements are met
3. Ensure you're running on a supported Arch-based distribution

## Customization

After installation, you can customize:

- **Hyprland**: Edit `~/.config/hypr/hyprland.conf` for window manager settings
- **Waybar**: Modify `~/.config/waybar/config` for status bar layout
- **Themes**: Use KDE system settings or install additional themes
- **Applications**: Install additional software via pacman or AUR

## Contributing

Feel free to submit issues and enhancement requests!

## License

This script is provided as-is for educational and personal use.
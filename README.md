# Xero Linux KDE ISO Builder

This repository contains scripts to build a bootable ISO of Xero Linux with KDE Plasma desktop and Hyprland window manager pre-configured.

## Features

- **Xero Linux Base**: Built on top of Arch Linux with Xero Linux customizations
- **KDE Plasma Desktop**: Full KDE Plasma desktop environment
- **Hyprland Integration**: Modern Wayland compositor with beautiful animations
- **Pre-configured Setup**: Ready-to-use configuration for both KDE and Hyprland
- **Automatic Downloads**: ISO is automatically placed in your Downloads folder

## Prerequisites

- Arch Linux or Arch-based distribution (recommended)
- `archiso` package installed
- At least 4GB of free disk space
- Internet connection for downloading packages
- `sudo` privileges

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sirdonnytaylor-design/nbb-.git
   cd nbb-
   ```

2. **Install dependencies:**
   ```bash
   make dependencies
   ```

3. **Build the ISO:**
   ```bash
   make build
   ```

4. **Find your ISO:**
   The completed ISO will be in your `~/Downloads` folder with a timestamp.

## Manual Installation

If you prefer to run the script directly:

```bash
chmod +x build-iso.sh
./build-iso.sh
```

## Configuration

Edit `config.sh` to customize:
- Package selections
- User settings
- Desktop environment options
- System configurations

## What's Included

### Desktop Environments
- **KDE Plasma**: Full-featured desktop with Wayland support
- **Hyprland**: Tiling window manager with animations and blur effects

### Pre-installed Applications
- Firefox web browser
- Thunar file manager
- Kitty terminal emulator
- Waybar status bar
- Wofi application launcher
- Essential system utilities

### System Features
- NetworkManager for network connectivity
- PulseAudio for audio management
- SDDM display manager with auto-login
- Pre-configured Hyprland with custom keybindings

## Usage After Boot

### Switching Between Desktop Environments

1. **KDE Plasma**: Select "Plasma (Wayland)" from the login screen
2. **Hyprland**: Select "Hyprland" from the login screen

### Default User
- **Username**: `xero`
- **Password**: `xero`

### Hyprland Keybindings

- `Super + Q`: Open terminal (Kitty)
- `Super + C`: Close active window
- `Super + R`: Open application launcher (Wofi)
- `Super + E`: Open file manager (Thunar)
- `Super + M`: Exit Hyprland
- `Super + V`: Toggle floating mode
- `Super + 1-9`: Switch to workspace 1-9
- `Super + Shift + 1-9`: Move window to workspace 1-9

## File Structure

```
nbb-/
├── build-iso.sh      # Main build script
├── Makefile          # Build automation
├── config.sh         # Configuration file
├── README.md         # This file
├── INSTALL.md        # Detailed installation guide
└── build/            # Build directory (created during build)
    ├── archiso-profile/  # Customized archiso profile
    ├── work/             # Temporary build files
    └── out/              # Output directory
```

## Troubleshooting

### Build Fails with Permission Errors
Make sure you're not running as root and have sudo privileges:
```bash
sudo pacman -S archiso
```

### Missing Dependencies
Install all required packages:
```bash
sudo pacman -S archiso git wget curl
```

### ISO Too Large
Edit `config.sh` to remove unnecessary packages or reduce compression level.

### Boot Issues
Verify the ISO was created successfully and burn it to a USB drive using:
```bash
sudo dd if=xero-linux-kde-hyprland-*.iso of=/dev/sdX bs=4M status=progress
```

## Development

### Testing Changes
```bash
make test          # Test script syntax
make build         # Build ISO with changes
```

### Cleaning Build Files
```bash
make clean         # Remove build artifacts
make distclean     # Complete clean including downloads
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build process
5. Submit a pull request

## License

This project is open source. See the repository for license details.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review build logs in the `build/` directory
3. Open an issue on GitHub

## Acknowledgments

- [Xero Linux](https://xerolinux.xyz/) for the base distribution
- [Hyprland](https://hyprland.org/) for the amazing window manager
- [KDE](https://kde.org/) for the desktop environment
- [Arch Linux](https://archlinux.org/) for the solid foundation
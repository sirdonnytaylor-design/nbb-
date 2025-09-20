# Xero Linux Hyprland KDE ISO Builder

This repository contains the configuration files and build scripts to create a custom Arch Linux ISO featuring both Hyprland (Wayland compositor) and KDE Plasma desktop environments.

## Features

- **Dual Desktop Environment**: Pre-configured with both Hyprland and KDE Plasma
- **Wayland Support**: Native Wayland support with Hyprland
- **Modern Applications**: Includes Firefox, VS Code, LibreOffice, GIMP, VLC, and more
- **Audio**: PipeWire audio system with ALSA and PulseAudio compatibility
- **Graphics**: Support for Intel, AMD, and NVIDIA graphics
- **Development Tools**: Python, Node.js, Git, and other development essentials

## System Requirements

- x86_64 architecture
- At least 4GB RAM (8GB+ recommended)
- 2GB free disk space for building
- Internet connection for downloading packages

## Building the ISO

### Prerequisites

1. **Arch Linux system** (or Arch-based distribution)
2. **archiso package** installed:
   ```bash
   sudo pacman -S archiso
   ```

### Build Process

1. Clone this repository:
   ```bash
   git clone https://github.com/sirdonnytaylor-design/nbb-.git
   cd nbb-
   ```

2. Run the build script:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

   The script will:
   - Check for required dependencies
   - Clean any previous builds
   - Build the ISO using mkarchiso
   - Place the final ISO in the `out/` directory

### Manual Build

If you prefer to build manually:

```bash
# Clean previous builds
sudo rm -rf work/ out/

# Create output directory
mkdir -p out/

# Build the ISO
sudo mkarchiso -v -w work/ -o out/ ./
```

## What's Included

### Desktop Environments
- **Hyprland**: Modern Wayland compositor with tiling window management
- **KDE Plasma**: Full-featured desktop environment with Wayland session support

### Applications
- **Web Browser**: Firefox
- **Text Editor**: VS Code, Kate, Nano, Vim
- **File Manager**: Dolphin (KDE)
- **Terminal**: Konsole
- **Office Suite**: LibreOffice Fresh
- **Graphics**: GIMP, Gwenview, Spectacle
- **Media**: VLC, PipeWire audio system
- **Archive**: Ark
- **PDF Viewer**: Okular
- **Calculator**: KCalc

### Development Tools
- Python
- Node.js and npm
- Git
- Various text editors

### System Utilities
- NetworkManager for network management
- Bluetooth support
- Audio system (PipeWire)
- Multiple filesystem support (NTFS, exFAT)
- Compression tools

## Default Credentials

- **Username**: live
- **Password**: live

Root access is available with password: root

## Boot Options

The ISO provides several boot options:

1. **Xero Linux Hyprland KDE (x86_64)** - Full desktop environment
2. **Console Mode** - Command line only
3. **Memory Test** - Hardware testing
4. **Boot Existing OS** - Boot from hard drive

## Desktop Environments

### Hyprland
- **Launch**: Available in display manager or run `Hyprland` from terminal
- **Key Bindings**:
  - `Super + Q`: Open terminal (Konsole)
  - `Super + R`: Application launcher (Wofi)
  - `Super + E`: File manager (Dolphin)
  - `Super + C`: Close window
  - `Super + 1-9`: Switch workspaces

### KDE Plasma
- **Launch**: Select "Plasma (Wayland)" from SDDM login screen
- **Features**: Full desktop environment with panels, widgets, and system settings

## Customization

### Adding Packages
Edit `packages.x86_64` to add or remove packages from the ISO.

### Configuration Files
- **Hyprland**: `archiso/airootfs/etc/skel/.config/hypr/hyprland.conf`
- **System**: `archiso/airootfs/root/customize_airootfs.sh`

### Building Custom Variants
Modify the configuration files and rebuild using the build script.

## Troubleshooting

### Build Fails
1. Ensure you have sufficient disk space (at least 2GB free)
2. Check internet connection
3. Verify all dependencies are installed:
   ```bash
   sudo pacman -S archiso squashfs-tools libisoburn
   ```

### ISO Won't Boot
1. Verify the ISO was written correctly to USB/DVD
2. Check UEFI/BIOS settings for secure boot (may need to be disabled)
3. Try different boot options from the menu

## File Structure

```
.
├── profiledef.sh              # ISO profile definition
├── packages.x86_64            # Package list
├── pacman.conf               # Pacman configuration
├── build.sh                  # Build script
├── archiso/                  # ISO customization files
│   └── airootfs/            # Root filesystem overlay
├── syslinux/                # BIOS boot configuration
└── grub/                    # UEFI boot configuration
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Open an issue on GitHub
3. Consult the Arch Linux and Hyprland documentation
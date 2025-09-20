# Xero Linux Hyprland KDE ISO - Quick Start Guide

## Overview
This repository provides a complete build configuration for creating a custom Arch Linux ISO that includes both Hyprland (modern Wayland compositor) and KDE Plasma desktop environments.

## Quick Build Instructions

### 1. Prerequisites
```bash
# On Arch Linux or Arch-based system
sudo pacman -S archiso squashfs-tools libisoburn
```

### 2. Build the ISO
```bash
git clone https://github.com/sirdonnytaylor-design/nbb-.git
cd nbb-
./build.sh
```

### 3. Find Your ISO
The completed ISO will be in the `out/` directory with a name like:
`xero-linux-hyprland-kde-YYYY.MM.DD-x86_64.iso`

## What You Get

- **Live Environment**: Ready-to-use Linux desktop
- **Dual Desktop**: Choice between Hyprland and KDE Plasma
- **Modern Apps**: Firefox, LibreOffice, GIMP, VS Code, VLC
- **Development Ready**: Python, Node.js, Git included
- **Hardware Support**: Intel, AMD, NVIDIA graphics drivers

## Boot Options

1. **Xero Linux Hyprland KDE** - Full desktop environment
2. **Console Mode** - Command line interface
3. **Memory Test** - Hardware diagnostics

## Default Login
- Username: `live`
- Password: `live`

## Desktop Environments

### Hyprland (Wayland)
Modern tiling window manager with:
- Super + Q: Terminal
- Super + R: App launcher
- Super + E: File manager

### KDE Plasma
Traditional desktop with:
- Full taskbar and system tray
- Application menu
- System settings

## Validation
Test your configuration before building:
```bash
./validate.sh
```

## File Structure
```
├── profiledef.sh         # ISO metadata
├── packages.x86_64       # Software packages
├── build.sh             # Build automation
├── validate.sh          # Configuration validator
├── archiso/             # System customizations
├── syslinux/            # BIOS boot config
└── grub/                # UEFI boot config
```

## Customization
- Edit `packages.x86_64` to add/remove software
- Modify files in `archiso/airootfs/` to change system defaults
- Update Hyprland config in `archiso/airootfs/etc/skel/.config/hypr/`

For detailed information, see the main README.md.
# Detailed Installation Guide

This guide provides step-by-step instructions for building and using the Xero Linux KDE ISO with Hyprland.

## System Requirements

### Host System (for building)
- **Operating System**: Arch Linux or Arch-based distribution
- **RAM**: At least 4GB (8GB recommended)
- **Storage**: 10GB free space for build process
- **Internet**: Stable broadband connection
- **Privileges**: sudo access

### Target System (for running the ISO)
- **RAM**: 2GB minimum (4GB recommended)
- **Storage**: 8GB for live session, 20GB+ for installation
- **Graphics**: Any modern GPU with KMS support
- **Boot**: UEFI or BIOS support

## Pre-Installation Steps

### 1. Prepare Your System

Update your Arch Linux system:
```bash
sudo pacman -Syu
```

Install base development tools:
```bash
sudo pacman -S base-devel git
```

### 2. Download the Repository

```bash
cd ~/
git clone https://github.com/sirdonnytaylor-design/nbb-.git
cd nbb-
```

### 3. Verify Files

Check that all required files are present:
```bash
ls -la
```

You should see:
- `build-iso.sh` - Main build script
- `Makefile` - Build automation
- `config.sh` - Configuration file
- `README.md` - Documentation

## Building the ISO

### Method 1: Using Make (Recommended)

```bash
# Install dependencies
make dependencies

# Build the ISO
make build
```

### Method 2: Manual Build

```bash
# Make script executable
chmod +x build-iso.sh

# Run the build script
./build-iso.sh
```

## Build Process Explanation

The build process follows these steps:

1. **Dependency Check**: Verifies archiso and other tools are installed
2. **Environment Setup**: Creates build directories and copies archiso profile
3. **Xero Linux Integration**: Downloads and integrates Xero Linux components
4. **Hyprland Setup**: Clones Hyprland repository and configurations
5. **Profile Customization**: Modifies archiso profile with custom packages and configs
6. **ISO Generation**: Uses mkarchiso to create the bootable ISO
7. **Output**: Copies the final ISO to your Downloads folder

## Configuration Options

### Basic Configuration

Edit `config.sh` to customize the build:

```bash
# Change ISO name
ISO_NAME_PREFIX="my-custom-xero"

# Change default user
DEFAULT_USER="myuser"
DEFAULT_PASSWORD="mypassword"

# Modify hostname
HOSTNAME="my-linux-box"
```

### Package Selection

Add or remove packages by editing the package variables:

```bash
# Add additional KDE applications
KDE_PACKAGES="plasma-meta plasma-wayland-session kde-applications-meta krita kdenlive"

# Add development tools
UTILITIES="neofetch git wget curl vim nano htop tree code"
```

### Desktop Environment Settings

Customize the desktop experience:

```bash
# Enable/disable features
ENABLE_HYPRLAND_ANIMATIONS=true
ENABLE_BLUR_EFFECTS=true
ENABLE_AUTOLOGIN=true
```

## Using the Built ISO

### 1. Locate the ISO

After successful build, find your ISO in:
```bash
ls ~/Downloads/xero-linux-kde-hyprland-*.iso
```

### 2. Create Bootable Media

#### USB Drive (Linux):
```bash
# Replace /dev/sdX with your USB device
sudo dd if=~/Downloads/xero-linux-kde-hyprland-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

#### USB Drive (Windows):
Use tools like Rufus or Etcher to write the ISO to a USB drive.

#### DVD:
Burn the ISO to a DVD using your preferred burning software.

### 3. Boot from the Media

1. Insert the USB drive or DVD
2. Restart your computer
3. Access boot menu (usually F12, F8, or Del during startup)
4. Select the USB drive or DVD
5. Choose "Boot Arch Linux (x86_64)" from the menu

### 4. Login to the System

- **Username**: `xero` (or what you configured)
- **Password**: `xero` (or what you configured)

### 5. Choose Desktop Environment

From the SDDM login screen, you can select:
- **Plasma (Wayland)**: Full KDE Plasma desktop
- **Hyprland**: Tiling window manager

## Post-Boot Setup

### First Boot Checklist

1. **Network Connection**: NetworkManager should automatically connect to available networks
2. **Audio**: PulseAudio should be working out of the box
3. **Applications**: All pre-installed applications should be available

### Hyprland Quick Start

If you choose Hyprland:

1. Press `Super + R` to open the application launcher
2. Type "firefox" to open the web browser
3. Press `Super + Q` to open a terminal
4. Press `Super + E` to open the file manager

### KDE Plasma Quick Start

If you choose KDE Plasma:

1. The desktop should load with a taskbar and desktop icons
2. Click the application launcher in the bottom-left corner
3. Browse applications by category
4. Configure the desktop through System Settings

## Troubleshooting

### Build Issues

#### "archiso not found"
```bash
sudo pacman -S archiso
```

#### "Permission denied"
Make sure you're not running as root:
```bash
whoami  # Should not return 'root'
```

#### "No space left on device"
Clean up space or change build directory:
```bash
make clean
df -h  # Check disk usage
```

### Boot Issues

#### "Boot failed"
- Verify ISO integrity with checksums
- Try a different USB drive
- Check BIOS/UEFI settings

#### "Kernel panic"
- Try the fallback boot option
- Check system requirements
- Update target system BIOS

#### "Black screen after boot"
- Wait for the system to fully load
- Try switching TTY with Ctrl+Alt+F2
- Check if graphics drivers are loading

### Runtime Issues

#### "No internet connection"
```bash
# Check network status
nmcli device status

# Connect to Wi-Fi
nmtui
```

#### "No audio"
```bash
# Check PulseAudio
pulseaudio --check
pavucontrol  # Open audio control panel
```

#### "Applications won't start"
- Check if you're using Wayland or X11
- Try launching from terminal to see error messages
- Verify all dependencies are installed

### Performance Issues

#### "System is slow"
- Check RAM usage with `htop`
- Reduce visual effects in KDE or Hyprland
- Close unnecessary applications

#### "High CPU usage"
- Identify processes with `top` or `htop`
- Disable animations if using Hyprland
- Check for background services

## Advanced Customization

### Custom Packages

To add packages that aren't in the official repositories:

1. Edit `build-iso.sh`
2. Add AUR helper installation
3. Include AUR packages in package lists

### Custom Configurations

To include your own dotfiles:

1. Create `airootfs/etc/skel/.config/` directory
2. Copy your configuration files
3. Set proper permissions

### Branding

To customize the boot screen and desktop:

1. Replace images in `airootfs/usr/share/pixmaps/`
2. Modify SDDM themes
3. Update desktop wallpapers

## Maintenance

### Updating the Build

To update the ISO with latest packages:

```bash
make clean
make build
```

### Security Updates

Regularly update the base system before building:

```bash
sudo pacman -Syu
make build
```

## Additional Resources

- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [Archiso Documentation](https://wiki.archlinux.org/title/archiso)
- [Hyprland Documentation](https://wiki.hyprland.org/)
- [KDE UserBase](https://userbase.kde.org/)
- [Xero Linux Community](https://xerolinux.xyz/)

## Getting Help

If you encounter issues:

1. Check the troubleshooting section above
2. Review build logs in the `build/` directory
3. Search existing issues on GitHub
4. Create a new issue with detailed information:
   - System specifications
   - Build logs
   - Error messages
   - Steps to reproduce
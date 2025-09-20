# Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### Script Permission Denied
```bash
# Make script executable
chmod +x build-xero-kde-hyprland.sh
```

#### Package Not Found Errors
- Ensure you have an active internet connection
- Update package databases: `sudo pacman -Sy`
- Check if Xero Linux repositories are properly configured

#### Insufficient Disk Space
- Free up space: `sudo pacman -Sc` (clean package cache)
- Check disk usage: `df -h`
- Remove unnecessary packages: `sudo pacman -Rns package-name`

#### Network Connection Issues
```bash
# Test connectivity
ping -c 4 google.com

# Reset network
sudo systemctl restart NetworkManager
```

### Post-Installation Issues

#### Display Manager Not Starting
```bash
# Enable and start SDDM
sudo systemctl enable sddm
sudo systemctl start sddm

# Check status
sudo systemctl status sddm
```

#### Hyprland Won't Start
- Check if wayland session exists: `ls /usr/share/wayland-sessions/`
- Verify Hyprland installation: `which Hyprland`
- Check configuration: `hyprland --config ~/.config/hypr/hyprland.conf --test`

#### Audio Not Working
```bash
# Enable audio services
systemctl --user enable pipewire pipewire-pulse
systemctl --user start pipewire pipewire-pulse

# Check audio devices
pactl list sinks short
```

#### Waybar Not Showing
```bash
# Restart Waybar
killall waybar
waybar &

# Check configuration
waybar --config ~/.config/waybar/config --style ~/.config/waybar/style.css
```

### Configuration Issues

#### Wrong Display Resolution
Edit Hyprland config:
```bash
nano ~/.config/hypr/hyprland.conf
# Modify monitor line: monitor=,1920x1080,auto,1
```

#### Keyboard Layout Issues
In Hyprland config:
```
input {
    kb_layout = us
    # Change 'us' to your layout (e.g., 'de', 'fr', 'es')
}
```

#### Screen Locking Not Working
```bash
# Install swaylock if missing
sudo pacman -S swaylock-effects

# Test manually
swaylock -f -c 000000
```

### Performance Issues

#### High CPU Usage
- Check running processes: `htop`
- Disable animations in Hyprland config: `animations { enabled = no }`
- Reduce blur effects: `blur_size = 1`

#### System Lag
- Close unnecessary applications
- Check memory usage: `free -h`
- Restart window manager: logout and login again

### Getting More Help

#### Check System Logs
```bash
# System logs
journalctl -xe

# Display manager logs
journalctl -u sddm

# User session logs
journalctl --user -xe
```

#### Hyprland Debugging
```bash
# Start Hyprland with debug output
Hyprland --verbose

# Check Hyprland logs
cat ~/.hyprland/hyprland.log
```

#### Package Information
```bash
# Check installed packages
pacman -Q | grep -E "(hyprland|plasma|kde)"

# Package information
pacman -Qi package-name

# Missing dependencies
pactree package-name
```

### Recovery Options

#### Boot to Console
If graphical interface fails:
1. Press `Ctrl+Alt+F2` to switch to TTY
2. Log in with username/password
3. Troubleshoot from command line

#### Restore Original Session
```bash
# Remove Hyprland config
mv ~/.config/hypr ~/.config/hypr.backup

# Use default KDE session
# Select "Plasma" at login screen
```

#### Emergency Fixes
```bash
# Reset display manager
sudo systemctl disable sddm
sudo systemctl enable lightdm  # or gdm

# Reinstall problematic packages
sudo pacman -S package-name --overwrite='*'
```

## Getting Support

1. **Documentation**: Check Hyprland wiki and KDE documentation
2. **Forums**: Visit Arch Linux and Xero Linux forums
3. **Logs**: Always include relevant log files when asking for help
4. **System Info**: Provide output of `uname -a` and `pacman -Q` when reporting issues

## Useful Commands

```bash
# Show current session
echo $XDG_CURRENT_DESKTOP
echo $XDG_SESSION_TYPE

# Reload configurations
source ~/.bashrc
killall waybar && waybar &

# Check service status
systemctl --user status pipewire
sudo systemctl status NetworkManager

# Monitor system resources
htop
iostat 1
```
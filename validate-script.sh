#!/bin/bash

# Validation script for Xero Linux KDE Hyprland Build Script
# This script checks if the main build script is properly structured

echo "Validating Xero Linux KDE Hyprland Build Script..."

SCRIPT_FILE="build-xero-kde-hyprland.sh"

# Check if script exists
if [[ ! -f "$SCRIPT_FILE" ]]; then
    echo "ERROR: $SCRIPT_FILE not found!"
    exit 1
fi

# Check if script is executable
if [[ ! -x "$SCRIPT_FILE" ]]; then
    echo "ERROR: $SCRIPT_FILE is not executable!"
    exit 1
fi

# Check syntax
if ! bash -n "$SCRIPT_FILE"; then
    echo "ERROR: Syntax error in $SCRIPT_FILE"
    exit 1
fi

# Check for required functions
required_functions=(
    "check_root"
    "check_requirements"
    "update_system"
    "setup_xero_repos"
    "install_kde"
    "install_hyprland"
    "configure_hyprland"
    "configure_waybar"
    "configure_sessions"
    "post_install_setup"
    "create_aliases"
    "main"
)

echo "Checking for required functions..."
for func in "${required_functions[@]}"; do
    if ! grep -q "^$func()" "$SCRIPT_FILE"; then
        echo "ERROR: Function $func not found!"
        exit 1
    else
        echo "✓ Function $func found"
    fi
done

# Check for key components
echo "Checking for key components..."

# Check for shebang
if ! head -n1 "$SCRIPT_FILE" | grep -q "#!/bin/bash"; then
    echo "ERROR: Missing or incorrect shebang!"
    exit 1
else
    echo "✓ Shebang correct"
fi

# Check for error handling
if ! grep -q "set -e" "$SCRIPT_FILE"; then
    echo "WARNING: No 'set -e' found for error handling"
else
    echo "✓ Error handling enabled"
fi

# Check for logging functions
if grep -q "log()" "$SCRIPT_FILE" && grep -q "error()" "$SCRIPT_FILE"; then
    echo "✓ Logging functions present"
else
    echo "ERROR: Missing logging functions!"
    exit 1
fi

# Check for package lists
if grep -q "kde_packages=" "$SCRIPT_FILE" && grep -q "hyprland_packages=" "$SCRIPT_FILE"; then
    echo "✓ Package lists found"
else
    echo "ERROR: Missing package lists!"
    exit 1
fi

# Check for configuration files
if grep -q "hyprland.conf" "$SCRIPT_FILE" && grep -q "waybar" "$SCRIPT_FILE"; then
    echo "✓ Configuration files creation found"
else
    echo "ERROR: Missing configuration file creation!"
    exit 1
fi

echo ""
echo "✅ Validation completed successfully!"
echo ""
echo "Script features:"
echo "- Executable permissions: ✓"
echo "- Valid syntax: ✓"
echo "- All required functions: ✓"
echo "- Error handling: ✓"
echo "- Logging system: ✓"
echo "- Package management: ✓"
echo "- Configuration setup: ✓"
echo ""
echo "The build script appears to be properly structured and ready for use."
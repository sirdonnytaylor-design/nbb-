#!/bin/bash

# Xero Linux Hyprland KDE ISO Configuration Validator
# This script validates the ISO build configuration

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[PASS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[FAIL]${NC} $1"; }

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
test_file() {
    local file="$1"
    local description="$2"
    
    if [[ -f "$file" ]]; then
        print_success "$description exists: $file"
        ((TESTS_PASSED++))
        return 0
    else
        print_error "$description missing: $file"
        ((TESTS_FAILED++))
        return 1
    fi
}

test_directory() {
    local dir="$1"
    local description="$2"
    
    if [[ -d "$dir" ]]; then
        print_success "$description exists: $dir"
        ((TESTS_PASSED++))
        return 0
    else
        print_error "$description missing: $dir"
        ((TESTS_FAILED++))
        return 1
    fi
}

test_executable() {
    local file="$1"
    local description="$2"
    
    if [[ -x "$file" ]]; then
        print_success "$description is executable: $file"
        ((TESTS_PASSED++))
        return 0
    else
        print_error "$description not executable: $file"
        ((TESTS_FAILED++))
        return 1
    fi
}

print_status "Starting Xero Linux Hyprland KDE ISO Configuration Validation"
print_status "================================================================"

# Test core files
print_status "\nTesting core configuration files..."
test_file "profiledef.sh" "Profile definition"
test_file "packages.x86_64" "Package list"
test_file "pacman.conf" "Pacman configuration"
test_file "build.sh" "Build script"

# Test executable permissions
print_status "\nTesting executable permissions..."
test_executable "profiledef.sh" "Profile definition script"
test_executable "build.sh" "Build script"

# Test directory structure
print_status "\nTesting directory structure..."
test_directory "archiso" "Archiso directory"
test_directory "archiso/airootfs" "Airootfs directory"
test_directory "archiso/airootfs/etc" "System etc directory"
test_directory "archiso/airootfs/etc/skel" "User skeleton directory"
test_directory "archiso/airootfs/root" "Root directory"

# Test bootloader configurations
print_status "\nTesting bootloader configurations..."
test_file "syslinux/syslinux.cfg" "SYSLINUX configuration"
test_file "grub/grub.cfg" "GRUB configuration"

# Test user configurations
print_status "\nTesting user configurations..."
test_file "archiso/airootfs/etc/skel/.config/hypr/hyprland.conf" "Hyprland configuration"
test_file "archiso/airootfs/etc/skel/.config/waybar/config" "Waybar configuration"

# Test system configurations
print_status "\nTesting system configurations..."
test_file "archiso/airootfs/root/customize_airootfs.sh" "System customization script"
test_file "archiso/airootfs/etc/pacman.d/mirrorlist" "Mirror list"

# Test specific content
print_status "\nTesting configuration content..."

# Check if profile definition has required variables
if grep -q "iso_name=" profiledef.sh && grep -q "iso_label=" profiledef.sh; then
    print_success "Profile definition contains required metadata"
    ((TESTS_PASSED++))
else
    print_error "Profile definition missing required metadata"
    ((TESTS_FAILED++))
fi

# Check if package list contains essential packages
essential_packages=("base" "linux" "hyprland" "plasma-meta" "networkmanager")
missing_packages=()

for package in "${essential_packages[@]}"; do
    if ! grep -q "^$package$" packages.x86_64; then
        missing_packages+=("$package")
    fi
done

if [[ ${#missing_packages[@]} -eq 0 ]]; then
    print_success "All essential packages are listed"
    ((TESTS_PASSED++))
else
    print_error "Missing essential packages: ${missing_packages[*]}"
    ((TESTS_FAILED++))
fi

# Check Hyprland configuration
if grep -q "monitor=" archiso/airootfs/etc/skel/.config/hypr/hyprland.conf; then
    print_success "Hyprland configuration contains monitor settings"
    ((TESTS_PASSED++))
else
    print_error "Hyprland configuration missing monitor settings"
    ((TESTS_FAILED++))
fi

# Summary
print_status "\n================================================================"
print_status "Validation Summary:"
print_success "Tests Passed: $TESTS_PASSED"

if [[ $TESTS_FAILED -gt 0 ]]; then
    print_error "Tests Failed: $TESTS_FAILED"
    print_status "\nConfiguration validation FAILED. Please fix the issues above."
    exit 1
else
    print_status "Tests Failed: $TESTS_FAILED"
    print_success "\nConfiguration validation PASSED!"
    print_status "Your Xero Linux Hyprland KDE ISO configuration is ready for building."
    print_status "\nTo build the ISO, run: ./build.sh"
    exit 0
fi
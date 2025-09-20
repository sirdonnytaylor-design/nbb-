#!/bin/bash

# Xero Linux Hyprland KDE ISO Build Script
# This script builds a custom Arch Linux ISO with Hyprland and KDE

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    local deps=("archiso" "git" "squashfs-tools" "libisoburn")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! pacman -Qi "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_status "Install them with: sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "All dependencies are installed"
}

# Clean previous builds
clean_build() {
    print_status "Cleaning previous builds..."
    sudo rm -rf work/ out/
    print_success "Build directory cleaned"
}

# Build the ISO
build_iso() {
    print_status "Starting ISO build process..."
    print_warning "This will take some time depending on your internet connection and system performance"
    
    # Create output directory
    mkdir -p out/
    
    # Run mkarchiso
    sudo mkarchiso -v -w work/ -o out/ ./
    
    if [[ $? -eq 0 ]]; then
        print_success "ISO build completed successfully!"
        print_status "ISO file location: $(find out/ -name "*.iso" -type f)"
    else
        print_error "ISO build failed!"
        exit 1
    fi
}

# Main execution
main() {
    print_status "Xero Linux Hyprland KDE ISO Builder"
    print_status "====================================="
    
    # Check if we're in the right directory
    if [[ ! -f "profiledef.sh" ]]; then
        print_error "profiledef.sh not found. Please run this script from the ISO build directory."
        exit 1
    fi
    
    check_dependencies
    clean_build
    build_iso
    
    print_success "Build process completed!"
    print_status "Your Xero Linux Hyprland KDE ISO is ready!"
}

# Handle command line arguments
case "${1:-}" in
    "clean")
        clean_build
        ;;
    "build")
        build_iso
        ;;
    *)
        main
        ;;
esac
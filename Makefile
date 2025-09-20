# Xero Linux KDE ISO Builder Makefile

.PHONY: help build clean dependencies setup test

# Default target
help:
	@echo "Xero Linux KDE ISO Builder"
	@echo "=========================="
	@echo ""
	@echo "Available targets:"
	@echo "  build        - Build the bootable ISO"
	@echo "  clean        - Clean build artifacts"
	@echo "  dependencies - Install required dependencies"
	@echo "  setup        - Setup build environment"
	@echo "  test         - Test the build script"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make build          # Build the ISO"
	@echo "  make clean          # Clean up"
	@echo "  make dependencies   # Install deps"

# Install dependencies
dependencies:
	@echo "Installing dependencies..."
	@sudo pacman -Sy --noconfirm archiso git wget curl || \
	sudo apt-get update && sudo apt-get install -y git wget curl || \
	echo "Please install dependencies manually: archiso, git, wget, curl"

# Setup build environment
setup:
	@echo "Setting up build environment..."
	@chmod +x build-iso.sh
	@mkdir -p build
	@echo "Build environment ready"

# Build the ISO
build: setup
	@echo "Building Xero Linux KDE ISO with Hyprland..."
	@./build-iso.sh

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build/
	@echo "Clean complete"

# Test the build script
test:
	@echo "Testing build script..."
	@bash -n build-iso.sh && echo "Script syntax is valid"

# Complete clean (including downloaded repos)
distclean: clean
	@echo "Performing complete clean..."
	@rm -rf build/
	@echo "Complete clean finished"
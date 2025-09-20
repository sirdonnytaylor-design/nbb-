#!/bin/bash

# Test script for Xero Linux KDE ISO Builder
# This script performs basic validation without actually building the ISO

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Test file existence
test_files_exist() {
    log "Testing file existence..."
    
    local files=("build-iso.sh" "Makefile" "config.sh" "README.md" "INSTALL.md" ".gitignore")
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            success "File exists: $file"
        else
            fail "File missing: $file"
        fi
    done
}

# Test script syntax
test_script_syntax() {
    log "Testing script syntax..."
    
    if bash -n build-iso.sh; then
        success "build-iso.sh syntax is valid"
    else
        fail "build-iso.sh has syntax errors"
    fi
    
    if bash -n config.sh; then
        success "config.sh syntax is valid"
    else
        fail "config.sh has syntax errors"
    fi
}

# Test script permissions
test_permissions() {
    log "Testing file permissions..."
    
    if [[ -x "build-iso.sh" ]]; then
        success "build-iso.sh is executable"
    else
        warning "build-iso.sh is not executable (will be fixed automatically)"
        chmod +x build-iso.sh
        success "Made build-iso.sh executable"
    fi
}

# Test configuration loading
test_config_loading() {
    log "Testing configuration loading..."
    
    if source config.sh 2>/dev/null; then
        success "config.sh loads without errors"
        
        # Test if key variables are defined
        if [[ -n "$ISO_NAME_PREFIX" ]]; then
            success "ISO_NAME_PREFIX is defined: $ISO_NAME_PREFIX"
        else
            fail "ISO_NAME_PREFIX is not defined"
        fi
        
        if [[ -n "$DEFAULT_USER" ]]; then
            success "DEFAULT_USER is defined: $DEFAULT_USER"
        else
            fail "DEFAULT_USER is not defined"
        fi
        
    else
        fail "config.sh has errors and cannot be loaded"
    fi
}

# Test dependencies (without installing)
test_dependencies() {
    log "Testing dependency availability..."
    
    local deps=("git" "wget" "curl" "make")
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" &> /dev/null; then
            success "Dependency available: $dep"
        else
            warning "Dependency missing: $dep (install with package manager)"
        fi
    done
    
    # Test for archiso (main dependency)
    if command -v mkarchiso &> /dev/null; then
        success "archiso is installed"
    else
        warning "archiso is not installed (required for building)"
    fi
}

# Test Makefile targets
test_makefile() {
    log "Testing Makefile..."
    
    if make -n help &> /dev/null; then
        success "Makefile help target is valid"
    else
        fail "Makefile help target has issues"
    fi
    
    if make -n test &> /dev/null; then
        success "Makefile test target is valid"
    else
        fail "Makefile test target has issues"
    fi
    
    if make -n setup &> /dev/null; then
        success "Makefile setup target is valid"
    else
        fail "Makefile setup target has issues"
    fi
}

# Test directory structure
test_directory_structure() {
    log "Testing directory structure..."
    
    if [[ -d ".git" ]]; then
        success "Git repository detected"
    else
        warning "Not in a git repository"
    fi
    
    # Test Downloads directory exists
    if [[ -d "$HOME/Downloads" ]]; then
        success "Downloads directory exists"
    else
        warning "Downloads directory does not exist, will be created"
        mkdir -p "$HOME/Downloads"
        success "Created Downloads directory"
    fi
}

# Test user privileges
test_user_privileges() {
    log "Testing user privileges..."
    
    if [[ $EUID -eq 0 ]]; then
        fail "Running as root (should run as regular user)"
    else
        success "Running as regular user"
    fi
    
    if sudo -n true 2>/dev/null; then
        success "Sudo access available"
    else
        warning "Sudo access not available (may be prompted during build)"
    fi
}

# Test system resources
test_system_resources() {
    log "Testing system resources..."
    
    # Check available disk space (in KB)
    local available_space=$(df . | awk 'NR==2 {print $4}')
    local required_space=$((4 * 1024 * 1024)) # 4GB in KB
    
    if [[ $available_space -gt $required_space ]]; then
        success "Sufficient disk space available"
    else
        warning "Low disk space (need at least 4GB free)"
    fi
    
    # Check RAM
    local ram_mb=$(free -m | awk 'NR==2{printf "%.0f", $2}')
    if [[ $ram_mb -gt 2048 ]]; then
        success "Sufficient RAM available ($ram_mb MB)"
    else
        warning "Low RAM ($ram_mb MB, recommend 4GB+)"
    fi
}

# Main test function
main() {
    echo "Xero Linux KDE ISO Builder - Test Suite"
    echo "======================================="
    echo
    
    test_files_exist
    test_script_syntax
    test_permissions
    test_config_loading
    test_dependencies
    test_makefile
    test_directory_structure
    test_user_privileges
    test_system_resources
    
    echo
    echo "Test Summary"
    echo "============"
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}All tests passed! Ready to build ISO.${NC}"
        echo
        echo "To build the ISO, run:"
        echo "  make build"
        echo
        echo "Or manually:"
        echo "  ./build-iso.sh"
        return 0
    else
        echo -e "${RED}Some tests failed. Please fix issues before building.${NC}"
        return 1
    fi
}

# Run tests
main "$@"
#!/bin/bash

# Claude Screenshot System - Secure Installer
# Safe two-step installation process
# Author: Claude AI Assistant
# Version: 1.0
# Date: 2025-07-09

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://raw.githubusercontent.com/miyashita337/claude-screenshot/main"
INSTALLER_FILE="install.sh"
HASH_FILE="install.sh.sha256"
TEMP_DIR="/tmp/claude-screenshot-install"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if we're on a supported platform
    case "$OSTYPE" in
        darwin*)
            log_success "Platform: macOS detected"
            ;;
        linux*)
            log_success "Platform: Linux detected"
            ;;
        *)
            log_error "Unsupported platform: $OSTYPE"
            echo "This installer supports macOS and Linux only."
            echo "For Windows, please use: install.ps1"
            exit 1
            ;;
    esac
    
    # Check required tools
    local missing_tools=()
    
    for tool in curl shasum; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        echo "Please install the missing tools and try again."
        exit 1
    fi
    
    log_success "All prerequisites satisfied"
}

# Create secure temporary directory
setup_temp_dir() {
    log_info "Setting up secure temporary directory..."
    
    # Remove existing temp directory if it exists
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
    
    # Create new temp directory with restricted permissions
    mkdir -p "$TEMP_DIR"
    chmod 700 "$TEMP_DIR"
    
    log_success "Temporary directory created: $TEMP_DIR"
}

# Download installer with integrity verification
download_installer() {
    log_step "Step 1: Downloading installer files..."
    
    # Download installer
    log_info "Downloading installer: $INSTALLER_FILE"
    if ! curl -fsSL "$REPO_URL/$INSTALLER_FILE" -o "$TEMP_DIR/$INSTALLER_FILE"; then
        log_error "Failed to download installer"
        exit 1
    fi
    
    # Download hash file
    log_info "Downloading hash file: $HASH_FILE"
    if ! curl -fsSL "$REPO_URL/$HASH_FILE" -o "$TEMP_DIR/$HASH_FILE"; then
        log_warning "Hash file not available - skipping integrity verification"
        SKIP_HASH=true
    else
        SKIP_HASH=false
    fi
    
    log_success "Files downloaded successfully"
}

# Verify file integrity
verify_integrity() {
    if [ "$SKIP_HASH" = true ]; then
        log_warning "Skipping integrity verification (hash file not available)"
        return 0
    fi
    
    log_step "Step 2: Verifying file integrity..."
    
    cd "$TEMP_DIR"
    
    # Verify SHA256 hash
    if shasum -a 256 -c "$HASH_FILE" >/dev/null 2>&1; then
        log_success "File integrity verified ✓"
    else
        log_error "File integrity verification failed!"
        echo "The downloaded file may be corrupted or tampered with."
        echo "Please try again or report this issue."
        exit 1
    fi
}

# Display installer content for review
show_installer_preview() {
    log_step "Step 3: Installer content preview..."
    
    echo
    echo -e "${CYAN}=================== INSTALLER PREVIEW ===================${NC}"
    echo "File: $TEMP_DIR/$INSTALLER_FILE"
    echo "Size: $(wc -c < "$TEMP_DIR/$INSTALLER_FILE") bytes"
    echo "Lines: $(wc -l < "$TEMP_DIR/$INSTALLER_FILE") lines"
    echo
    echo "First 20 lines:"
    echo -e "${YELLOW}$(head -20 "$TEMP_DIR/$INSTALLER_FILE")${NC}"
    echo
    if [ $(wc -l < "$TEMP_DIR/$INSTALLER_FILE") -gt 20 ]; then
        echo "... ($(( $(wc -l < "$TEMP_DIR/$INSTALLER_FILE") - 20 )) more lines)"
        echo
    fi
    echo -e "${CYAN}=======================================================${NC}"
    echo
}

# Provide next steps instructions
show_next_steps() {
    log_step "Step 4: Ready for installation"
    
    echo
    echo -e "${GREEN}📋 NEXT STEPS:${NC}"
    echo
    echo "1. ${YELLOW}Review the installer:${NC}"
    echo "   cat $TEMP_DIR/$INSTALLER_FILE"
    echo
    echo "2. ${YELLOW}Make it executable:${NC}"
    echo "   chmod +x $TEMP_DIR/$INSTALLER_FILE"
    echo
    echo "3. ${YELLOW}Run the installer:${NC}"
    echo "   $TEMP_DIR/$INSTALLER_FILE"
    echo
    echo "4. ${YELLOW}Clean up (optional):${NC}"
    echo "   rm -rf $TEMP_DIR"
    echo
    echo -e "${BLUE}💡 TIP:${NC} You can copy the installer to your preferred location:"
    echo "   cp $TEMP_DIR/$INSTALLER_FILE ./claude-screenshot-install.sh"
    echo
}

# Interactive installation option
offer_auto_install() {
    echo
    echo -e "${CYAN}🚀 QUICK INSTALL OPTION:${NC}"
    echo "Would you like to proceed with automatic installation now?"
    echo -e "${YELLOW}Note: This will execute the installer immediately.${NC}"
    echo
    read -p "Proceed with installation? [y/N]: " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Proceeding with automatic installation..."
        chmod +x "$TEMP_DIR/$INSTALLER_FILE"
        
        echo
        echo -e "${GREEN}=============== RUNNING INSTALLER ===============${NC}"
        "$TEMP_DIR/$INSTALLER_FILE"
        
        # Clean up after successful installation
        log_info "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
        
        echo
        log_success "Installation completed successfully!"
        echo
        echo -e "${GREEN}🎉 Claude Screenshot System is now ready!${NC}"
        echo
        echo "Quick start:"
        echo "1. Take a screenshot: Command+Shift+4"
        echo "2. In Claude Code, use: /ss"
        echo "3. Claude will analyze your screenshot!"
        echo
    else
        log_info "Manual installation selected"
        show_next_steps
    fi
}

# Cleanup function
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        log_info "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Trap for cleanup on exit
trap cleanup EXIT

# Main execution
main() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE} Claude Screenshot System       ${NC}"
    echo -e "${BLUE} Secure Installer               ${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    
    check_prerequisites
    setup_temp_dir
    download_installer
    verify_integrity
    show_installer_preview
    offer_auto_install
}

# Show help
show_help() {
    cat << 'EOF'
Claude Screenshot System - Secure Installer

Usage: ./safe-install.sh [OPTION]

Options:
  install   Download and prepare installer (default)
  help      Show this help message

This secure installer follows a two-step process:
1. Download and verify the installer integrity
2. Allow user review before execution

Security features:
- SHA256 integrity verification
- Secure temporary directory (700 permissions)
- Content preview before execution
- User confirmation for automatic installation

Repository: https://github.com/miyashita337/claude-screenshot
EOF
}

# Command handling
case "${1:-install}" in
    "install")
        main
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        log_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
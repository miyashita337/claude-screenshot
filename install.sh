#!/bin/bash

# Claude Screenshot System - Master Installer
# One-command installation for the complete system
# Author: Claude AI Assistant
# Version: 1.0
# Date: 2025-07-09

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/Pictures/Screenshots"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

# Logging with colors
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
            log_error "This system supports macOS and Linux only"
            echo "For Windows, please use: install.ps1"
            exit 1
            ;;
    esac
    
    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
        log_warning "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Check if fswatch is installed
    if ! command -v fswatch >/dev/null 2>&1; then
        log_info "Installing fswatch..."
        brew install fswatch
        log_success "fswatch installed"
    else
        log_success "fswatch is already installed"
    fi
}

# Install scripts
install_scripts() {
    log_info "Installing screenshot system scripts..."
    
    # Create installation directory
    mkdir -p "$INSTALL_DIR"
    log_success "Created installation directory: $INSTALL_DIR"
    
    # Copy scripts
    cp "$REPO_DIR"/scripts/*.sh "$INSTALL_DIR/"
    cp "$REPO_DIR"/scripts/ss "$INSTALL_DIR/"
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR"/*.sh
    chmod +x "$INSTALL_DIR"/ss
    
    log_success "Scripts installed to $INSTALL_DIR"
}

# Install Claude Code commands
install_claude_commands() {
    log_info "Installing Claude Code custom commands..."
    
    # Create Claude commands directory
    mkdir -p "$CLAUDE_COMMANDS_DIR"
    
    # Copy command files
    cp "$REPO_DIR"/claude-commands/*.md "$CLAUDE_COMMANDS_DIR/"
    
    log_success "Claude commands installed to $CLAUDE_COMMANDS_DIR"
}

# Configure macOS screenshots
configure_macos() {
    log_info "Configuring macOS screenshot settings..."
    
    # Set screenshot location
    defaults write com.apple.screencapture location "$INSTALL_DIR"
    log_success "Screenshot location set to: $INSTALL_DIR"
    
    # Restart SystemUIServer to apply changes
    killall SystemUIServer 2>/dev/null || true
    log_success "SystemUIServer restarted"
}

# Setup shell aliases
setup_aliases() {
    log_info "Setting up shell aliases..."
    
    local shell_rc=""
    if [ -n "${ZSH_VERSION:-}" ]; then
        shell_rc="$HOME/.zshrc"
    elif [ -n "${BASH_VERSION:-}" ]; then
        shell_rc="$HOME/.bashrc"
    fi
    
    if [ -n "$shell_rc" ] && [ -f "$shell_rc" ]; then
        if ! grep -q "Claude Screenshot System" "$shell_rc"; then
            {
                echo ""
                echo "# Claude Screenshot System Aliases"
                echo "alias screenshot-monitor='$INSTALL_DIR/screenshot_manager.sh monitor'"
                echo "alias screenshot-process='$INSTALL_DIR/screenshot_manager.sh process'"
                echo "alias clipboard-monitor='$INSTALL_DIR/clipboard_handler.sh monitor'"
                echo "alias clipboard-save='$INSTALL_DIR/clipboard_handler.sh save'"
                echo "alias ss='$INSTALL_DIR/ss'"
                echo "alias sslist='$INSTALL_DIR/claude_integration.sh list'"
                echo "alias ssselect='$INSTALL_DIR/claude_integration.sh select'"
                echo ""
            } >> "$shell_rc"
            log_success "Added aliases to $shell_rc"
        else
            log_info "Aliases already exist in $shell_rc"
        fi
    else
        log_warning "Could not determine shell configuration file"
    fi
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    local errors=0
    
    # Check if scripts are executable
    for script in "screenshot_manager.sh" "claude_integration.sh" "clipboard_handler.sh"; do
        if [ -x "$INSTALL_DIR/$script" ]; then
            log_success "$script is executable"
        else
            log_error "$script is not executable"
            ((errors++))
        fi
    done
    
    # Test integration
    if "$INSTALL_DIR/claude_integration.sh" help >/dev/null 2>&1; then
        log_success "Claude integration is working"
    else
        log_error "Claude integration has issues"
        ((errors++))
    fi
    
    if [ $errors -eq 0 ]; then
        log_success "Installation verified successfully!"
        return 0
    else
        log_error "Installation has $errors error(s)"
        return 1
    fi
}

# Show usage instructions
show_usage() {
    cat << 'EOF'

🎉 Claude Screenshot System Installation Complete!

Quick Start:
  1. Take a screenshot: Command+Shift+4
  2. In Claude Code, use: /ss
  3. Claude will analyze your screenshot!

Available Commands:
  📸 Screenshot Management:
    screenshot-monitor     # Monitor for new screenshots
    screenshot-process     # Process existing screenshots
    
  📋 Clipboard Handling:
    clipboard-monitor      # Monitor clipboard screenshots
    clipboard-save         # Save current clipboard screenshot
    
  🔍 Claude Integration:
    /ss                    # Show latest screenshot (Claude Code)
    /sslist                # List recent screenshots (Claude Code)
    /ssshow NUMBER         # Show specific screenshot (Claude Code)

Files:
  📁 Scripts: ~/Pictures/Screenshots/
  📁 Commands: ~/.claude/commands/
  📁 Screenshots: ~/Pictures/Screenshots/*.png

Next Steps:
  1. Restart Claude Code to load new /ss commands
  2. Restart your shell or run: source ~/.zshrc
  3. Take a screenshot and try: /ss

🚀 Happy screenshotting with Claude!
EOF
}

# User confirmation
confirm_installation() {
    echo -e "${BLUE}=== Claude Screenshot System Installer ===${NC}"
    echo
    echo "This installer will:"
    echo "• Install screenshot management scripts to ~/Pictures/Screenshots"
    echo "• Install Claude Code custom commands to ~/.claude/commands"
    echo "• Configure macOS screenshot settings"
    echo "• Set up shell aliases in your shell configuration"
    echo "• Install dependencies via Homebrew (if needed)"
    echo
    echo -e "${YELLOW}⚠️  Security Notice:${NC}"
    echo "This installer will modify your system configuration and install software."
    echo "Please review the source code before proceeding:"
    echo "https://github.com/miyashita337/claude-screenshot"
    echo
    
    read -p "Do you want to proceed with the installation? [y/N]: " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled by user"
        exit 0
    fi
    
    log_info "Starting installation..."
}

# Main execution
main() {
    confirm_installation
    
    check_prerequisites
    install_scripts
    install_claude_commands
    configure_macos
    setup_aliases
    
    echo
    if verify_installation; then
        show_usage
    else
        log_error "Installation completed with errors. Please check the output above."
        exit 1
    fi
}

# Show help
show_help() {
    cat << 'EOF'
Claude Screenshot System Installer

Usage: ./install.sh [OPTION]

Options:
  install   Complete installation (default)
  help      Show this help message

This installer sets up a complete screenshot automation system
with Claude Code integration for macOS.

Repository: https://github.com/USER/claude-screenshot
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
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Screenshot System is a shell script-based automation tool for macOS, Linux, and Windows that integrates screenshot management with Claude Code and Obsidian. This is NOT a Node.js project - it's a collection of bash scripts (macOS/Linux) and PowerShell scripts (Windows).

## Essential Commands

### Installation & Setup
```bash
# Secure installation (recommended)
./safe-install.sh                     # Linux/macOS with integrity verification
.\install.ps1                        # Windows PowerShell

# Direct installation
./install.sh                         # Linux/macOS
.\install_latest.ps1                 # Windows (latest version)

# Complete system setup
./scripts/master_setup.sh            # Full configuration and dependencies
```

### Core Screenshot Commands
```bash
# Claude Code integration commands (use within Claude Code)
/ss                                  # Show latest screenshot
/sslist                              # List recent screenshots with numbers
/ssshow NUMBER                       # Show specific screenshot by number

# Shell aliases (after setup)
ss                                   # Get latest screenshot path
sslist                              # List recent screenshots
ssselect                            # Interactive screenshot selection
```

### Monitoring & Management
```bash
# Start automated monitoring
screenshot-monitor                   # Monitor file screenshots
clipboard-monitor                    # Monitor clipboard screenshots

# Manual processing
screenshot-process                   # Process existing screenshots
clipboard-save                       # Save clipboard screenshot to file
```

### Development & Troubleshooting
```bash
# Setup and configuration
./scripts/claude_commands_setup.sh   # Install Claude Code custom commands
./scripts/setup_screenshot_automation.sh  # Configure automation

# Debug and verify
chmod +x ~/Pictures/Screenshots/*.sh # Fix permissions
ls ~/Pictures/Screenshots/*.png      # Verify screenshots exist
defaults read com.apple.screencapture location  # Check macOS screenshot location

# WSL2 debugging
DEBUG=1 ./scripts/claude_integration.sh latest  # Debug WSL2 path detection
```

## Architecture Overview

### Core System Design
The Claude Screenshot System is built around **screenshot-driven development** workflows, enabling seamless integration between visual debugging and Claude Code AI assistance.

**Primary Components:**
- **Screenshot Management** - Automated detection, organization, and processing
- **Claude Integration** - Custom `/ss` commands for immediate AI analysis  
- **Cross-Platform Support** - Unix/Linux/Windows compatibility
- **Workflow Automation** - Real-time monitoring and processing

### Key File Structure
```
claude-screenshot/
├── scripts/                         # Core functionality
│   ├── claude_integration.sh        # /ss command implementation
│   ├── screenshot_manager.sh        # File monitoring and organization  
│   ├── clipboard_handler.sh         # Clipboard processing
│   ├── master_setup.sh              # Complete system configuration
│   └── setup_screenshot_automation.sh # Automation setup
├── claude-commands/                 # Claude Code custom commands
│   ├── ss.md                       # /ss - latest screenshot
│   ├── sslist.md                   # /sslist - numbered list
│   └── ssshow.md                   # /ssshow N - specific image
├── install.sh / install.ps1        # Platform installers
└── safe-install.sh                 # Secure two-stage installer
```

### Integration Points
- **`~/.claude/commands/`** - Claude Code custom command definitions
- **`~/Pictures/Screenshots/`** - Standard screenshot directory
- **Shell profiles** - Aliases and automation hooks
- **Obsidian Vault** - Optional markdown reference generation

### WSL2/Windows Path Resolution
The system automatically detects WSL2 environments and resolves Windows screenshot paths:
1. **Environment Detection** → `$WSL_DISTRO_NAME` variable detection
2. **Path Resolution** → `/mnt/c/Users/$USER/Pictures/Screenshots/` for WSL2
3. **Fallback Logic** → Standard Unix paths if WSL2 not detected
4. **Override Support** → `$SCREENSHOT_DIR` environment variable

## Development Workflow

### Screenshot-Driven Development Process
This system optimizes the **problem → screenshot → AI analysis → solution** cycle:

1. **Problem Identification**: Error screens, UI issues, unexpected behavior
2. **Immediate Capture**: OS hotkeys for instant screenshot
3. **AI Analysis**: `/ss` command shares image with Claude Code
4. **Solution Implementation**: Claude provides analysis and code fixes
5. **Verification**: Screenshot results and iterate

### Testing Scripts Locally

```bash
# Test screenshot monitoring
bash scripts/screenshot_manager.sh monitor

# Test screenshot processing  
bash scripts/screenshot_manager.sh process

# Test clipboard handling
bash scripts/clipboard_handler.sh monitor

# Test Claude integration (with debug mode)
DEBUG=1 bash scripts/claude_integration.sh latest

# Run complete setup (dry run)
bash scripts/master_setup.sh --dry-run
```

### WSL2 Debugging

```bash
# Enable debug mode for WSL2 path detection
DEBUG=1 bash scripts/claude_integration.sh latest

# Check WSL environment detection
echo "WSL_DISTRO_NAME: ${WSL_DISTRO_NAME:-not_set}"
echo "Current screenshot dir: $(bash -c 'source scripts/claude_integration.sh; echo $SCREENSHOT_DIR')"

# Test from different directories
cd test_subdir && DEBUG=1 ../scripts/claude_integration.sh latest
```

### Installation Testing

```bash
# Test macOS/Linux installer
bash install.sh --test

# Test secure installer
bash safe-install.sh

# Test Windows installer (in PowerShell)
.\install.ps1 -WhatIf
```

## Critical Implementation Details

### File Naming Convention
Screenshots are expected to follow macOS naming: `Screenshot YYYY-MM-DD at HH.MM.SS.png`
WSL2 supports Windows naming: `スクリーンショット 2025-07-21 224103.png`

### Shell Compatibility
- Scripts use `#!/bin/bash` (not sh) for array support
- Tested on bash 3.2+ (macOS default) and zsh
- Windows scripts require PowerShell 5.1+
- WSL2 Ubuntu 22.04+ tested and supported

### Error Handling
- All scripts use `set -euo pipefail` for strict error handling
- Comprehensive logging to `~/Library/Logs/` (macOS) or stderr
- Non-zero exit codes indicate specific failure types
- Debug mode with `DEBUG=1` environment variable

### Security Considerations
- Scripts never execute downloaded code without verification
- File permissions set to 755 for executables
- No sensitive data stored in scripts
- SHA256 verification for secure installation

## Common Modifications

### Changing Screenshot Directory
The system now auto-detects screenshot directories, but can be overridden:
```bash
export SCREENSHOT_DIR="/custom/path/to/screenshots"
```

Update hardcoded paths in:
- `scripts/screenshot_manager.sh`
- `scripts/clipboard_handler.sh`  
- `scripts/claude_integration.sh` (fallback only)
- `install.sh` (macOS screenshot location)

### Changing Obsidian Vault Path
Update `VAULT_DIR` variable in:
- `scripts/screenshot_manager.sh`
- `scripts/master_setup.sh`

### Adding New Image Formats
Modify the file pattern in:
- `scripts/screenshot_manager.sh` (fswatch filter)
- `scripts/claude_integration.sh` (find patterns)

## Testing Checklist

When modifying scripts, verify:
1. **Script Syntax**: `bash -n script.sh`
2. **Function Isolation**: Test monitor, process, etc. independently
3. **File Permissions**: Preserved (755 for scripts)
4. **Log Files**: Created and written correctly
5. **Claude Code Commands**: Still function after changes
6. **Installation**: Completes successfully on clean system
7. **WSL2 Compatibility**: Test path detection in WSL2 environment
8. **Cross-Directory**: Test `/ss` command from various working directories

## Platform-Specific Considerations

### macOS Integration
- **Homebrew dependencies**: `fswatch` for file monitoring
- **System settings**: Screenshot location via `defaults` commands
- **LaunchAgents**: Optional automatic startup configuration
- **Keyboard shortcuts**: Cmd+Shift+4 (file), Cmd+Shift+Control+4 (clipboard)

### Linux Compatibility
- **File monitoring**: `inotify`-based alternatives to fswatch
- **Package managers**: Automatic dependency installation
- **Desktop environments**: X11/Wayland screenshot integration
- **Shell support**: Bash/Zsh configuration

### Windows Support
- **PowerShell integration**: Native Windows PowerShell scripts
- **File system watchers**: .NET FileSystemWatcher implementation
- **Snipping Tool integration**: Win+Shift+S screenshot workflow
- **Desktop shortcuts**: Automatic shortcuts to screenshot folder

### WSL2 Specifics
- **Automatic detection**: Via `$WSL_DISTRO_NAME` environment variable
- **Path mapping**: `/mnt/c/Users/$USER/Pictures/Screenshots/` resolution
- **Cross-platform files**: Handle Windows filenames with spaces/Unicode
- **Performance**: Optimized file search using `find` instead of `ls`

## Troubleshooting Guide

### Common Issues

**Screenshots not detected:**
```bash
# Check screenshot location (macOS)
defaults read com.apple.screencapture location

# Check WSL2 path detection
DEBUG=1 ./scripts/claude_integration.sh latest

# Reset to correct location (macOS)
defaults write com.apple.screencapture location ~/Pictures/Screenshots
killall SystemUIServer
```

**Claude commands not working:**
```bash
# Verify commands installed
ls ~/.claude/commands/ss*

# Reinstall commands
./scripts/claude_commands_setup.sh

# Check script permissions
chmod +x ~/Pictures/Screenshots/*.sh
```

**WSL2 /ss command failing:**
```bash
# Check WSL environment
echo $WSL_DISTRO_NAME

# Test path resolution
DEBUG=1 ./scripts/claude_integration.sh latest

# Manual path override
export SCREENSHOT_DIR="/mnt/c/Users/$USER/Pictures/Screenshots"
```

### Best Practices

#### Efficient Usage Patterns
- **Immediate capture**: Screenshot problems as they occur
- **Descriptive analysis**: Provide context when using `/ss`
- **Iterative improvement**: Screenshot → analyze → fix → verify cycle
- **Batch organization**: Regular cleanup and organization of screenshots

#### Security Considerations  
- **Sensitive information**: Be mindful of credentials/secrets in screenshots
- **Automatic cleanup**: Configure retention policies for old screenshots
- **Access controls**: Appropriate file permissions for screenshot directories

#### Performance Optimization
- **Selective monitoring**: Configure specific directories for monitoring
- **Resource management**: Monitor system impact of file watchers
- **Storage management**: Regular cleanup of processed screenshots
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

### Data Flow Architecture
1. **Screenshot Capture** → OS screenshot (Cmd+Shift+4 / Win+Shift+S)
2. **Detection** → fswatch/PowerShell monitoring detects new files
3. **Processing** → Metadata extraction, organization, reference generation
4. **Claude Integration** → `/ss` command provides instant AI analysis
5. **Workflow Loop** → Problem analysis → Solution → Verification → Repeat

## Development Workflow

### Screenshot-Driven Development Process
This system optimizes the **problem → screenshot → AI analysis → solution** cycle:

1. **Problem Identification**: Error screens, UI issues, unexpected behavior
2. **Immediate Capture**: OS hotkeys for instant screenshot
3. **AI Analysis**: `/ss` command shares image with Claude Code
4. **Solution Implementation**: Claude provides analysis and code fixes
5. **Verification**: Screenshot results and iterate

### Multi-Image Analysis Workflows
```bash
# Compare before/after states
/ssshow 1    # Show latest (after fix)
/ssshow 2    # Show previous (before fix)

# Analyze error patterns across multiple screens  
/ss          # Show latest error
/sslist      # View numbered list of recent screenshots
/ssshow 3    # Show specific error from list
```

### Batch Processing Workflows
```bash
# Process existing screenshots retroactively
screenshot-process

# Monitor new screenshots in real-time
screenshot-monitor &

# Handle clipboard screenshots
clipboard-monitor &
```

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

## Security & Reliability

### Installation Security
- **SHA256 verification**: Script integrity checking via `safe-install.sh`
- **Two-stage installation**: Download → verify → confirm → execute
- **User confirmation**: Explicit approval before system modifications
- **Minimal privileges**: No admin/sudo requirements for normal operation

### Error Handling
- **Graceful failures**: Comprehensive error checking and user feedback
- **Path validation**: Robust handling of missing directories and files
- **Permission checks**: Automatic detection and resolution of access issues
- **Logging**: Detailed logs for troubleshooting and monitoring

## Troubleshooting Guide

### Common Issues
**Screenshots not detected:**
```bash
# Check screenshot location
defaults read com.apple.screencapture location

# Reset to correct location
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

**Monitoring not active:**
```bash
# Install fswatch (macOS)
brew install fswatch

# Start monitoring manually
screenshot-monitor

# Check for running processes
ps aux | grep screenshot
```

### Log Files and Debugging
```bash
# Monitor system activity
tail -f ~/Library/Logs/claude-screenshot-monitor.log

# Debug script execution
DEBUG=1 ./scripts/claude_integration.sh latest

# Verify configuration
./scripts/master_setup.sh --diagnose
```

## Best Practices

### Efficient Usage Patterns
- **Immediate capture**: Screenshot problems as they occur
- **Descriptive analysis**: Provide context when using `/ss`
- **Iterative improvement**: Screenshot → analyze → fix → verify cycle
- **Batch organization**: Regular cleanup and organization of screenshots

### Security Considerations  
- **Sensitive information**: Be mindful of credentials/secrets in screenshots
- **Automatic cleanup**: Configure retention policies for old screenshots
- **Access controls**: Appropriate file permissions for screenshot directories

### Performance Optimization
- **Selective monitoring**: Configure specific directories for monitoring
- **Resource management**: Monitor system impact of file watchers
- **Storage management**: Regular cleanup of processed screenshots
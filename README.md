# Claude Screenshot System

A comprehensive macOS screenshot automation system that integrates with Claude Code and Obsidian vaults.

## Features

- 🖼️ **Automatic Screenshot Management**: Organizes screenshots in a dedicated directory
- 📝 **Obsidian Integration**: Auto-generates markdown references with metadata
- 🤖 **Claude Code Integration**: Seamless `/ss` command support for AI assistance
- 📋 **Clipboard Support**: Handles both file and clipboard screenshots
- 🔍 **Smart Monitoring**: Real-time detection of new screenshots
- ⚡ **Quick Commands**: Shell aliases for efficient workflow

## Quick Start

### 🔒 Secure Installation (Recommended)

**macOS/Linux:**
```bash
# Secure two-step installation
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/safe-install.sh | bash
```

**Windows:**
```powershell
# Download and run PowerShell installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

### ⚡ Direct Installation (Advanced Users)

**macOS/Linux:**
```bash
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.sh | bash
```

**Windows:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"; .\install.ps1 -Force
```

### 📸 Usage

**macOS:**
- `Command+Shift+4` - Save to file
- `Command+Shift+Control+4` - Copy to clipboard

**Windows:**
- `Win+Shift+S` - Snipping Tool
- Save screenshots to `%USERPROFILE%\Pictures\Screenshots`

**Claude Code Integration:**
- Use `/ss` command to show latest screenshot to Claude
- Restart Claude Code to load new commands

## Installation Methods

### 🔒 Method 1: Secure Installation (Recommended)

**For macOS/Linux users who want maximum security:**

```bash
# Step 1: Download secure installer
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/safe-install.sh | bash

# The secure installer will:
# 1. Download the main installer
# 2. Verify SHA256 integrity 
# 3. Show preview of installer content
# 4. Ask for confirmation before execution
```

**For Windows users:**
```powershell
# Download installer for review
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"

# Review the script (optional but recommended)
Get-Content install.ps1 | Select-Object -First 50

# Run installer
.\install.ps1
```

### ⚡ Method 2: Direct Installation

**macOS/Linux:**
```bash
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.sh | bash
```

**Windows:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"; .\install.ps1 -Force
```

### 🛠️ Method 3: Manual/Development Setup

1. **Clone Repository**:
   ```bash
   git clone https://github.com/miyashita337/claude-screenshot.git
   cd claude-screenshot
   ```

2. **Run Platform-Specific Installer**:
   ```bash
   # macOS/Linux
   ./install.sh
   
   # Windows (PowerShell)
   .\install.ps1
   ```

### 📋 What Gets Installed

**All Platforms:**
- Screenshot management scripts
- Claude Code custom commands (`/ss`, `/sslist`, `/ssshow`)
- Configuration files and aliases

**macOS/Linux Specific:**
- Homebrew dependencies (fswatch)
- macOS screenshot location configuration
- Shell aliases in `.bashrc`/`.zshrc`

**Windows Specific:**
- PowerShell-based screenshot monitoring
- Windows file system watcher
- PowerShell profile configuration
- Desktop shortcut to screenshots folder

## Components

### Core Scripts

| Script | Purpose |
|--------|---------|
| `screenshot_manager.sh` | Main screenshot monitoring and organization |
| `clipboard_handler.sh` | Clipboard screenshot processing |
| `claude_integration.sh` | Claude Code integration and `/ss` functionality |
| `ss` | Simple wrapper for `/ss` command (legacy) |
| `master_setup.sh` | Complete system setup and configuration |
| `claude_commands_setup.sh` | Claude Code custom commands setup |

### Claude Code Custom Commands

| Command File | Purpose |
|--------------|---------|
| `~/.claude/commands/ss.md` | `/ss` - Show latest screenshot |
| `~/.claude/commands/sslist.md` | `/sslist` - List recent screenshots |
| `~/.claude/commands/ssshow.md` | `/ssshow NUMBER` - Show specific screenshot |

### Shell Aliases

After setup, these aliases are available:

```bash
# Screenshot Management
screenshot-monitor     # Monitor for new file screenshots
screenshot-process     # Process existing screenshots

# Clipboard Handling
clipboard-monitor      # Monitor clipboard for screenshots
clipboard-save         # Save current clipboard screenshot

# Claude Integration
ss                     # Get latest screenshot path (/ss command)
sslist                 # List recent screenshots
ssselect               # Interactive screenshot selection
```

## Usage

### Taking Screenshots

- **File Screenshot**: `Command+Shift+4`
  - Saves directly to `~/Pictures/Screenshots`
  - Automatically processed and added to `Screenshots.md`

- **Clipboard Screenshot**: `Command+Shift+Control+4`
  - Saves to clipboard only
  - Use `clipboard-save` to save to file and process

### Claude Code Integration

### Custom Slash Commands

The system includes three custom Claude Code slash commands:

- **`/ss`** - Show the latest screenshot
- **`/sslist`** - List recent screenshots with numbers
- **`/ssshow NUMBER`** - Show specific screenshot by number

### Setup Claude Commands

1. Run the Claude commands setup:
   ```bash
   ~/Pictures/Screenshots/claude_commands_setup.sh
   ```

2. Restart Claude Code to load the new commands

### Usage Workflow

1. Take a screenshot with `Command+Shift+4`
2. In Claude Code, use `/ss` to show the latest screenshot
3. Claude will automatically read and analyze the image

### Advanced Usage

```
/ss              # Show latest screenshot
/sslist          # List all recent screenshots
/ssshow 1        # Show most recent screenshot
/ssshow 3        # Show 3rd most recent screenshot
```

### Monitoring

Start automatic monitoring:
```bash
screenshot-monitor    # Monitor file screenshots
clipboard-monitor     # Monitor clipboard screenshots
```

### Manual Processing

Process existing screenshots:
```bash
screenshot-process    # Add references for existing screenshots
```

## File Structure

```
~/Pictures/Screenshots/
├── screenshot_manager.sh          # Main monitoring script
├── clipboard_handler.sh           # Clipboard handling
├── claude_integration.sh          # Claude Code integration
├── ss                             # /ss command wrapper (legacy)
├── master_setup.sh               # Complete setup script
├── claude_commands_setup.sh      # Claude commands setup
├── README.md                     # This file
└── *.png                         # Screenshot files

~/.claude/commands/
├── ss.md                         # /ss custom command
├── sslist.md                     # /sslist custom command
└── ssshow.md                     # /ssshow custom command

~/my-vault/test/
└── Screenshots.md                # Auto-generated references
```

## Configuration

### Screenshot Directory
Default: `~/Pictures/Screenshots`

To change:
```bash
# Edit the SCREENSHOT_DIR variable in each script
SCREENSHOT_DIR="$HOME/path/to/your/directory"
```

### Vault Directory
Default: `~/my-vault/test`

To change:
```bash
# Edit the VAULT_DIR variable in each script
VAULT_DIR="$HOME/path/to/your/vault"
```

### Supported Formats
- PNG (primary)
- JPG/JPEG
- GIF
- BMP

## Advanced Features

### Automatic Startup

Enable automatic screenshot monitoring on login:
```bash
launchctl load ~/Library/LaunchAgents/com.claude.screenshot-monitor.plist
```

Disable:
```bash
launchctl unload ~/Library/LaunchAgents/com.claude.screenshot-monitor.plist
```

### Interactive Selection

Choose from recent screenshots:
```bash
ssselect
```

### Batch Processing

Process all existing screenshots:
```bash
screenshot-process
```

## Troubleshooting

### Screenshots Not Saving to Directory

1. Check macOS setting:
   ```bash
   defaults read com.apple.screencapture location
   ```

2. Reset if needed:
   ```bash
   defaults write com.apple.screencapture location ~/Pictures/Screenshots
   killall SystemUIServer
   ```

### Monitoring Not Working

1. Check if fswatch is installed:
   ```bash
   brew install fswatch
   ```

2. Verify script permissions:
   ```bash
   chmod +x ~/Pictures/Screenshots/*.sh
   ```

### Claude Code `/ss` Command Not Working

1. Test the ss command:
   ```bash
   ~/Pictures/Screenshots/ss
   ```

2. Check if screenshots exist:
   ```bash
   ls ~/Pictures/Screenshots/*.png
   ```

### No References in Screenshots.md

1. Run manual processing:
   ```bash
   screenshot-process
   ```

2. Check vault directory exists:
   ```bash
   mkdir -p ~/my-vault/test
   ```

## Uninstallation

To completely remove the Claude Screenshot System:

### Manual Uninstallation

**macOS/Linux:**
```bash
# Remove Claude Code commands
rm -f ~/.claude/commands/ss.md
rm -f ~/.claude/commands/sslist.md
rm -f ~/.claude/commands/ssshow.md

# Remove shell aliases from profile
# Edit ~/.zshrc or ~/.bash_profile and remove the lines:
# alias screenshot-monitor='~/Pictures/Screenshots/screenshot-monitor.sh'
# alias screenshot-process='~/Pictures/Screenshots/screenshot-process.sh'
# alias screenshot-list='~/Pictures/Screenshots/screenshot-list.sh'
# alias clipboard-save='~/Pictures/Screenshots/clipboard-save.sh'

# Remove scripts (optional - keeps your screenshot files)
rm -f ~/Pictures/Screenshots/screenshot-monitor.sh
rm -f ~/Pictures/Screenshots/screenshot-process.sh  
rm -f ~/Pictures/Screenshots/screenshot-list.sh
rm -f ~/Pictures/Screenshots/clipboard-save.sh
rm -f ~/Pictures/Screenshots/ss

# Remove launch agents
rm -f ~/Library/LaunchAgents/com.user.claude-screenshot.plist
launchctl unload ~/Library/LaunchAgents/com.user.claude-screenshot.plist 2>/dev/null

# Remove log files
rm -f ~/Library/Logs/claude-screenshot-monitor.log
rm -f ~/Library/Logs/claude-screenshot-monitor.error.log

# Reset screenshot location (optional)
defaults write com.apple.screencapture location ~/Desktop
killall SystemUIServer
```

**Windows:**
```powershell
# Remove Claude Code commands
Remove-Item -Path "$env:USERPROFILE\.claude\commands\ss.md" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:USERPROFILE\.claude\commands\sslist.md" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:USERPROFILE\.claude\commands\ssshow.md" -Force -ErrorAction SilentlyContinue

# Remove PowerShell profile entries
# Edit $PROFILE and remove the Claude Screenshot System section

# Remove scripts (optional - keeps your screenshot files)
Remove-Item -Path "$env:USERPROFILE\Pictures\Screenshots\scripts\" -Recurse -Force -ErrorAction SilentlyContinue

# Remove desktop shortcut
Remove-Item -Path "$env:USERPROFILE\Desktop\Claude Screenshots.lnk" -Force -ErrorAction SilentlyContinue
```

### Note on Screenshot Files

The uninstallation process does not delete your screenshot files by default. They remain in:
- **macOS/Linux**: `~/Pictures/Screenshots/`
- **Windows**: `%USERPROFILE%\Pictures\Screenshots\`

If you want to remove all screenshot files as well, add:
```bash
# macOS/Linux (CAUTION: This deletes ALL screenshots)
rm -rf ~/Pictures/Screenshots/

# Windows (CAUTION: This deletes ALL screenshots)
Remove-Item -Path "$env:USERPROFILE\Pictures\Screenshots\" -Recurse -Force
```

## Log Files

Monitor system activity:
```bash
# Screenshot monitoring logs
tail -f ~/Library/Logs/claude-screenshot-monitor.log

# Error logs
tail -f ~/Library/Logs/claude-screenshot-monitor.error.log
```

## Examples

### Basic Workflow

1. Take screenshot: `Command+Shift+4`
2. Ask Claude to analyze: `/ss` in Claude Code
3. Claude automatically sees and analyzes the image

### Clipboard Workflow

1. Take clipboard screenshot: `Command+Shift+Control+4`
2. Save to file: `clipboard-save`
3. Use with Claude: `/ss`

### Batch Organization

Organize existing screenshots:
```bash
# Process all screenshots in directory
screenshot-process

# List all processed screenshots
sslist
```

## Requirements

- macOS 12.0+ (Monterey, Ventura, Sonoma)
- Homebrew (for fswatch installation)
- Claude Code (for `/ss` integration)
- Obsidian (optional, for vault integration)

## License

This project is released under the CC0 1.0 Universal (Public Domain) license.

## Contributing

This system was designed as a comprehensive solution for screenshot automation. Feel free to:

- Report issues or bugs
- Suggest improvements
- Submit pull requests
- Share your workflow optimizations

## Repository

- **GitHub**: https://github.com/miyashita337/claude-screenshot
- **Issues**: https://github.com/miyashita337/claude-screenshot/issues
- **License**: CC0 1.0 Universal (Public Domain)

## Credits

- Original inspiration: [Gist by miyashita337](https://gist.github.com/miyashita337/9cf694f01ee19c3c16e6d34afab64e8e)
- Developed by: Claude AI Assistant
- Date: 2025-07-09

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on macOS
5. Submit a pull request

---

*For questions or support, please [open an issue](https://github.com/miyashita337/claude-screenshot/issues) or refer to the troubleshooting section.*
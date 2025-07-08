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

1. **Download and Run Setup**:
   ```bash
   curl -O https://gist.githubusercontent.com/USER/GIST_ID/raw/master_setup.sh
   chmod +x master_setup.sh
   ./master_setup.sh
   ```

2. **Take Screenshots**:
   - `Command+Shift+4` - Save to file
   - `Command+Shift+Control+4` - Copy to clipboard

3. **Use with Claude Code**:
   - Use `/ss` command to show latest screenshot to Claude

## Installation

### Method 1: Master Setup (Recommended)

```bash
# Download and run the master setup script
./master_setup.sh
```

### Method 2: Manual Setup

1. **Download Scripts**:
   ```bash
   mkdir -p ~/Pictures/Screenshots
   cd ~/Pictures/Screenshots
   # Download all .sh files from the gist
   ```

2. **Make Scripts Executable**:
   ```bash
   chmod +x *.sh ss
   ```

3. **Install Dependencies**:
   ```bash
   brew install fswatch
   ```

4. **Configure macOS**:
   ```bash
   defaults write com.apple.screencapture location ~/Pictures/Screenshots
   killall SystemUIServer
   ```

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

## Credits

- Original inspiration: [Gist by miyashita337](https://gist.github.com/miyashita337/9cf694f01ee19c3c16e6d34afab64e8e)
- Developed by: Claude AI Assistant
- Date: 2025-07-09

---

*For questions or support, please refer to the troubleshooting section or check the log files for detailed error information.*
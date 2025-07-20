# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Screenshot System is a shell script-based automation tool for macOS, Linux, and Windows that integrates screenshot management with Claude Code and Obsidian. This is NOT a Node.js project - it's a collection of bash scripts (macOS/Linux) and PowerShell scripts (Windows).

## Development Commands

### Testing Scripts Locally

```bash
# Test screenshot monitoring
bash scripts/screenshot_manager.sh monitor

# Test screenshot processing  
bash scripts/screenshot_manager.sh process

# Test clipboard handling
bash scripts/clipboard_handler.sh monitor

# Test Claude integration
bash scripts/claude_integration.sh

# Run complete setup (dry run)
bash scripts/master_setup.sh --dry-run
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

### Debugging

```bash
# Enable debug mode in any script
DEBUG=1 bash scripts/screenshot_manager.sh monitor

# Check logs
tail -f ~/Library/Logs/claude-screenshot-monitor.log
tail -f ~/Library/Logs/claude-screenshot-monitor.error.log
```

## Architecture

### Core Script Interactions

1. **Screenshot Flow**:
   - User takes screenshot → macOS saves to `~/Pictures/Screenshots/`
   - `screenshot_manager.sh` (via fswatch) detects new file
   - Script creates Obsidian markdown reference in `~/my-vault/test/Screenshots.md`
   - Claude Code `/ss` command reads latest screenshot path from `screenshot_manager.sh`

2. **Clipboard Flow**:
   - User takes clipboard screenshot (Cmd+Shift+Ctrl+4)
   - `clipboard_handler.sh` monitors clipboard for image data
   - Saves to file when `clipboard-save` is called
   - Integrates with main screenshot flow

3. **Claude Integration**:
   - `/ss`, `/sslist`, `/ssshow` commands defined in `~/.claude/commands/`
   - Commands execute `claude_integration.sh` with appropriate parameters
   - Script returns file paths for Claude Code to read images

### Script Dependencies

- **macOS/Linux**: Requires `fswatch` (installed via Homebrew)
- **Windows**: Uses built-in PowerShell FileSystemWatcher
- All scripts assume `~/Pictures/Screenshots/` as base directory
- Obsidian vault path hardcoded to `~/my-vault/test/`

### Key Design Decisions

1. **No Package Manager**: Pure shell scripts, no npm/yarn/pip dependencies
2. **Platform-Specific Installers**: Separate `install.sh` and `install.ps1` 
3. **Secure Installation Option**: `safe-install.sh` with SHA256 verification
4. **Modular Scripts**: Each script has single responsibility
5. **Claude Code Custom Commands**: Stored as markdown files in `~/.claude/commands/`

## Critical Implementation Details

### File Naming Convention
Screenshots are expected to follow macOS naming: `Screenshot YYYY-MM-DD at HH.MM.SS.png`

### Shell Compatibility
- Scripts use `#!/bin/bash` (not sh) for array support
- Tested on bash 3.2+ (macOS default) and zsh
- Windows scripts require PowerShell 5.1+

### Error Handling
- All scripts use `set -euo pipefail` for strict error handling
- Comprehensive logging to `~/Library/Logs/`
- Non-zero exit codes indicate specific failure types

### Security Considerations
- Scripts never execute downloaded code without verification
- File permissions set to 755 for executables
- No sensitive data stored in scripts

## Common Modifications

### Changing Screenshot Directory
Update `SCREENSHOT_DIR` variable in:
- `scripts/screenshot_manager.sh`
- `scripts/clipboard_handler.sh`  
- `scripts/claude_integration.sh`
- `install.sh` (macOS screenshot location)

### Changing Obsidian Vault Path
Update `VAULT_DIR` variable in:
- `scripts/screenshot_manager.sh`
- `scripts/master_setup.sh`

### Adding New Image Formats
Modify the file pattern in:
- `scripts/screenshot_manager.sh` (fswatch filter)
- `scripts/claude_integration.sh` (file listing)

## Testing Checklist

When modifying scripts, verify:
1. Script runs without syntax errors: `bash -n script.sh`
2. Functions work in isolation (monitor, process, etc.)
3. File permissions are preserved (755 for scripts)
4. Log files are created and written correctly
5. Claude Code commands still function after changes
6. Installation completes successfully on clean system
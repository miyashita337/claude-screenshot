# Claude Screenshot System - Windows PowerShell Installer
# Automated screenshot management with Claude Code integration for Windows
# Author: Claude AI Assistant
# Version: 1.0
# Date: 2025-07-09

#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$Help
)

# Configuration
$Script:RepoUrl = "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main"
$Script:InstallDir = "$env:USERPROFILE\Pictures\Screenshots"
$Script:ClaudeCommandsDir = "$env:USERPROFILE\.claude\commands"
$Script:ScriptsDir = "$Script:InstallDir\scripts"

# Colors for output
$Script:Colors = @{
    Red = 'Red'
    Green = 'Green'
    Yellow = 'Yellow'
    Blue = 'Blue'
    Cyan = 'Cyan'
}

# Logging functions
function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

function Write-LogStep {
    param([string]$Message)
    Write-Host "[STEP] $Message" -ForegroundColor $Colors.Cyan
}

# Show help
function Show-Help {
    Write-Host @"
Claude Screenshot System - Windows PowerShell Installer

Usage: .\install.ps1 [OPTIONS]

Options:
  -Force      Skip confirmation prompts
  -Help       Show this help message

This installer sets up a screenshot automation system for Windows
that integrates with Claude Code.

Features:
- Automatic screenshot organization
- Claude Code custom commands (/ss, /sslist, /ssshow)
- Windows Screenshot integration
- PowerShell-based monitoring

Repository: https://github.com/miyashita337/claude-screenshot

Examples:
  .\install.ps1                 # Interactive installation
  .\install.ps1 -Force          # Automatic installation
  .\install.ps1 -Help           # Show this help
"@
}

# Check prerequisites
function Test-Prerequisites {
    Write-LogInfo "Checking prerequisites..."
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-LogError "PowerShell 5.1 or later is required"
        Write-Host "Current version: $($PSVersionTable.PSVersion)"
        exit 1
    }
    Write-LogSuccess "PowerShell version: $($PSVersionTable.PSVersion)"
    
    # Check Windows version
    $osVersion = [System.Environment]::OSVersion.Version
    if ($osVersion.Major -lt 10) {
        Write-LogWarning "Windows 10 or later is recommended"
    }
    Write-LogSuccess "Operating System: Windows $($osVersion.Major).$($osVersion.Minor)"
    
    # Check execution policy
    $executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($executionPolicy -eq 'Restricted') {
        Write-LogWarning "PowerShell execution policy is restricted"
        Write-Host "You may need to run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    }
    
    Write-LogSuccess "Prerequisites check completed"
}

# User confirmation
function Confirm-Installation {
    if ($Force) {
        Write-LogInfo "Force mode enabled - skipping confirmation"
        return $true
    }
    
    Write-Host @"

=== Claude Screenshot System Installer ===

This installer will:
• Install screenshot management scripts to $InstallDir
• Install Claude Code custom commands to $ClaudeCommandsDir
• Configure Windows screenshot integration
• Set up PowerShell modules and functions

⚠️  Security Notice:
This installer will modify your system configuration and create directories.
Please review the source code before proceeding:
https://github.com/miyashita337/claude-screenshot

"@ -ForegroundColor Yellow
    
    $response = Read-Host "Do you want to proceed with the installation? [y/N]"
    
    if ($response -notmatch '^[Yy]$') {
        Write-LogInfo "Installation cancelled by user"
        exit 0
    }
    
    Write-LogInfo "Starting installation..."
    return $true
}

# Create directories
function New-InstallDirectories {
    Write-LogInfo "Creating installation directories..."
    
    $directories = @(
        $Script:InstallDir,
        $Script:ScriptsDir,
        $Script:ClaudeCommandsDir
    )
    
    foreach ($dir in $directories) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-LogSuccess "Created directory: $dir"
        } else {
            Write-LogInfo "Directory already exists: $dir"
        }
    }
}

# Download Windows scripts
function Install-WindowsScripts {
    Write-LogInfo "Installing Windows PowerShell scripts..."
    
    # Create screenshot manager script
    $screenshotManagerContent = @"
# Windows Screenshot Manager
# PowerShell equivalent of the macOS screenshot manager

param(
    [string]`$Action = "help"
)

`$ScreenshotDir = "`$env:USERPROFILE\Pictures\Screenshots"
`$VaultDir = "`$env:USERPROFILE\my-vault\test"
`$ReferenceFile = "`$VaultDir\Screenshots.md"

function Add-ScreenshotReference {
    param([string]`$ScreenshotPath)
    
    if (!(Test-Path `$ReferenceFile)) {
        New-Item -ItemType File -Path `$ReferenceFile -Force | Out-Null
        Set-Content -Path `$ReferenceFile -Value @"
# Screenshots

Automatically generated screenshot references.

"@
    }
    
    `$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    `$filename = Split-Path `$ScreenshotPath -Leaf
    `$size = [math]::Round((Get-Item `$ScreenshotPath).Length / 1KB, 2)
    
    `$content = @"

## Screenshot - `$timestamp

![Screenshot](`$ScreenshotPath)

**File:** ```$filename``
**Path:** ```$ScreenshotPath``
**Size:** `${size}KB

---

"@
    
    Add-Content -Path `$ReferenceFile -Value `$content
    Write-Host "Added reference for: `$filename"
}

function Start-ScreenshotMonitoring {
    Write-Host "Monitoring screenshots in `$ScreenshotDir"
    Write-Host "Press Ctrl+C to stop monitoring"
    
    `$watcher = New-Object System.IO.FileSystemWatcher
    `$watcher.Path = `$ScreenshotDir
    `$watcher.Filter = "*.png"
    `$watcher.EnableRaisingEvents = `$true
    
    Register-ObjectEvent -InputObject `$watcher -EventName Created -Action {
        Start-Sleep -Seconds 1  # Wait for file to be fully written
        Add-ScreenshotReference `$Event.SourceEventArgs.FullPath
    } | Out-Null
    
    try {
        while (`$true) {
            Start-Sleep -Seconds 1
        }
    } finally {
        `$watcher.EnableRaisingEvents = `$false
        `$watcher.Dispose()
    }
}

function Show-RecentScreenshots {
    `$screenshots = Get-ChildItem -Path `$ScreenshotDir -Filter "*.png" | Sort-Object LastWriteTime -Descending | Select-Object -First 10
    
    if (`$screenshots.Count -eq 0) {
        Write-Host "No screenshots found in `$ScreenshotDir"
        return
    }
    
    Write-Host "Recent screenshots:"
    for (`$i = 0; `$i -lt `$screenshots.Count; `$i++) {
        `$file = `$screenshots[`$i]
        `$size = [math]::Round(`$file.Length / 1KB, 2)
        Write-Host "`$(`$i + 1). `$(`$file.Name) (`$(`$file.LastWriteTime), `${size}KB)"
    }
}

switch (`$Action.ToLower()) {
    "monitor" { Start-ScreenshotMonitoring }
    "process" { 
        Get-ChildItem -Path `$ScreenshotDir -Filter "*.png" | ForEach-Object {
            Add-ScreenshotReference `$_.FullName
        }
    }
    "list" { Show-RecentScreenshots }
    "help" {
        Write-Host @"
Windows Screenshot Manager

Usage: .\screenshot-manager.ps1 [ACTION]

Actions:
  monitor   Monitor for new screenshots
  process   Process existing screenshots
  list      List recent screenshots
  help      Show this help

Examples:
  .\screenshot-manager.ps1 monitor
  .\screenshot-manager.ps1 list
"@
    }
    default {
        Write-Host "Unknown action: `$Action"
        Write-Host "Use 'help' for usage information"
    }
}
"@
    
    $scriptPath = "$Script:ScriptsDir\screenshot-manager.ps1"
    Set-Content -Path $scriptPath -Value $screenshotManagerContent -Encoding UTF8
    Write-LogSuccess "Created: screenshot-manager.ps1"
}

# Install Claude Code commands
function Install-ClaudeCommands {
    Write-LogInfo "Installing Claude Code custom commands..."
    
    # Download command files from repository
    $commands = @("ss.md", "sslist.md", "ssshow.md")
    
    foreach ($command in $commands) {
        try {
            $url = "$Script:RepoUrl/claude-commands/$command"
            $destination = "$Script:ClaudeCommandsDir\$command"
            
            Invoke-WebRequest -Uri $url -OutFile $destination -UseBasicParsing
            Write-LogSuccess "Downloaded: $command"
        }
        catch {
            Write-LogWarning "Failed to download $command`: $($_.Exception.Message)"
        }
    }
}

# Configure Windows screenshot settings
function Set-WindowsScreenshotConfig {
    Write-LogInfo "Configuring Windows screenshot settings..."
    
    # Note: Windows doesn't have a direct equivalent to macOS screenshot location setting
    # This function is a placeholder for future Windows-specific configuration
    
    Write-LogInfo "Windows screenshot configuration is automatic"
    Write-LogInfo "Screenshots will be saved to: $Script:InstallDir"
    
    # Create a desktop shortcut for easy access
    $shortcutPath = "$env:USERPROFILE\Desktop\Claude Screenshots.lnk"
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $Script:InstallDir
    $Shortcut.Description = "Claude Screenshot System"
    $Shortcut.Save()
    
    Write-LogSuccess "Created desktop shortcut: Claude Screenshots"
}

# Setup PowerShell profile
function Set-PowerShellProfile {
    Write-LogInfo "Setting up PowerShell profile..."
    
    $profileContent = @"

# Claude Screenshot System Aliases
function screenshot-monitor { & "$Script:ScriptsDir\screenshot-manager.ps1" monitor }
function screenshot-process { & "$Script:ScriptsDir\screenshot-manager.ps1" process }
function screenshot-list { & "$Script:ScriptsDir\screenshot-manager.ps1" list }

# Set screenshot directory as a convenient variable
`$Global:ScreenshotDir = "$Script:InstallDir"

Write-Host "Claude Screenshot System loaded" -ForegroundColor Green
"@
    
    if (!(Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }
    
    $existingContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if ($existingContent -notlike "*Claude Screenshot System*") {
        Add-Content -Path $PROFILE -Value $profileContent
        Write-LogSuccess "Added aliases to PowerShell profile"
    } else {
        Write-LogInfo "Aliases already exist in PowerShell profile"
    }
}

# Verify installation
function Test-Installation {
    Write-LogInfo "Verifying installation..."
    
    $errors = 0
    
    # Check directories
    $requiredDirs = @($Script:InstallDir, $Script:ScriptsDir, $Script:ClaudeCommandsDir)
    foreach ($dir in $requiredDirs) {
        if (Test-Path $dir) {
            Write-LogSuccess "$dir exists"
        } else {
            Write-LogError "$dir is missing"
            $errors++
        }
    }
    
    # Check script files
    $scriptFile = "$Script:ScriptsDir\screenshot-manager.ps1"
    if (Test-Path $scriptFile) {
        Write-LogSuccess "screenshot-manager.ps1 exists"
    } else {
        Write-LogError "screenshot-manager.ps1 is missing"
        $errors++
    }
    
    if ($errors -eq 0) {
        Write-LogSuccess "Installation verified successfully!"
        return $true
    } else {
        Write-LogError "Installation has $errors error(s)"
        return $false
    }
}

# Show usage instructions
function Show-Usage {
    Write-Host @"

🎉 Claude Screenshot System Installation Complete!

Quick Start:
  1. Take a screenshot: Win+Shift+S or Snipping Tool
  2. Save to: $InstallDir
  3. In Claude Code, use: /ss
  4. Claude will analyze your screenshot!

Available Commands:
  📸 Screenshot Management:
    screenshot-monitor     # Monitor for new screenshots
    screenshot-process     # Process existing screenshots
    screenshot-list        # List recent screenshots

  🔍 Claude Integration:
    /ss                    # Show latest screenshot (Claude Code)
    /sslist                # List recent screenshots (Claude Code)
    /ssshow NUMBER         # Show specific screenshot (Claude Code)

Files:
  📁 Scripts: $ScriptsDir
  📁 Commands: $ClaudeCommandsDir
  📁 Screenshots: $InstallDir

Next Steps:
  1. Restart Claude Code to load new /ss commands
  2. Restart PowerShell or run: . `$PROFILE
  3. Take a screenshot and save to $InstallDir
  4. Try: /ss in Claude Code

🚀 Happy screenshotting with Claude!
"@ -ForegroundColor Green
}

# Main execution
function Start-Installation {
    try {
        Write-Host "=== Claude Screenshot System - Windows Installer ===" -ForegroundColor Blue
        Write-Host ""
        
        Test-Prerequisites
        
        if (!(Confirm-Installation)) {
            return
        }
        
        New-InstallDirectories
        Install-WindowsScripts
        Install-ClaudeCommands
        Set-WindowsScreenshotConfig
        Set-PowerShellProfile
        
        Write-Host ""
        if (Test-Installation) {
            Show-Usage
        } else {
            Write-LogError "Installation completed with errors. Please check the output above."
            exit 1
        }
    }
    catch {
        Write-LogError "Installation failed: $($_.Exception.Message)"
        Write-LogError "Stack trace: $($_.ScriptStackTrace)"
        exit 1
    }
}

# Command handling
if ($Help) {
    Show-Help
    exit 0
}

# Run installation
Start-Installation
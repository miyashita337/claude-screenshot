# Claude Screenshot System - Simple Windows PowerShell Installer
# Simplified version for testing

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

# Logging functions
function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Show help
function Show-Help {
    Write-Host "Claude Screenshot System - Windows PowerShell Installer

Usage: .\install_simple.ps1 [OPTIONS]

Options:
  -Force      Skip confirmation prompts
  -Help       Show this help message

This installer sets up a screenshot automation system for Windows
that integrates with Claude Code."
}

# Create directories
function New-InstallDirectories {
    Write-LogInfo "Creating installation directories..."
    
    $directories = @(
        $Script:InstallDir,
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
            Write-LogError "Failed to download $command"
        }
    }
}

# Verify installation
function Test-Installation {
    Write-LogInfo "Verifying installation..."
    
    $errors = 0
    
    # Check directories
    $requiredDirs = @($Script:InstallDir, $Script:ClaudeCommandsDir)
    foreach ($dir in $requiredDirs) {
        if (Test-Path $dir) {
            Write-LogSuccess "$dir exists"
        } else {
            Write-LogError "$dir is missing"
            $errors++
        }
    }
    
    if ($errors -eq 0) {
        Write-LogSuccess "Installation verified successfully!"
        return $true
    } else {
        Write-LogError "Installation has $errors error(s)"
        return $false
    }
}

# Main execution
function Start-Installation {
    Write-Host "=== Claude Screenshot System - Simple Installer ===" -ForegroundColor Blue
    Write-Host ""
    
    if ($Force -or (Read-Host "Proceed with installation? [y/N]") -match '^[Yy]$') {
        New-InstallDirectories
        Install-ClaudeCommands
        
        if (Test-Installation) {
            Write-LogSuccess "Installation completed successfully!"
            Write-Host "Claude Code commands (/ss, /sslist, /ssshow) are now available."
        } else {
            Write-LogError "Installation completed with errors."
            exit 1
        }
    } else {
        Write-LogInfo "Installation cancelled."
        exit 0
    }
}

# Command handling
if ($Help) {
    Show-Help
    exit 0
}

# Run installation
Start-Installation
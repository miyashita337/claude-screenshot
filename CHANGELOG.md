# Changelog

All notable changes to the Claude Screenshot System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-07-21

### Added
- WSL2/Windows automatic path detection for screenshot directories
- Dynamic script location detection for Claude Code commands (`/ss`, `/sslist`, `/ssshow`)
- Debug mode with `DEBUG=1` environment variable for troubleshooting
- Comprehensive diagnostic information when screenshots are not found
- Japanese README documentation (README_ja.md)
- Zenn article documentation for Japanese developers
- Detailed uninstallation instructions in README
- Cross-platform file time comparison for reliable screenshot sorting

### Fixed
- **Major Bug Fix**: WSL2 `/ss` command failing with "File does not exist" when executed from subdirectories
- PowerShell script parsing errors in install.ps1
- Character encoding issues in Windows PowerShell installation scripts
- Absolute path handling - commands now work regardless of current working directory
- Screenshot file detection with spaces and special characters in filenames
- Cross-platform compatibility for `stat` command usage

### Enhanced
- Security improvements in installation process
- Better Windows support and WSL2 compatibility
- Improved documentation with correct GitHub installation instructions
- Robust file searching using `find` with proper null-byte separation instead of shell glob patterns
- Enhanced error messages with actionable troubleshooting steps

### Technical Improvements
- Replaced brittle `ls` glob patterns with robust `find` commands
- Added proper null-byte handling for filenames with spaces
- Implemented WSL2 environment detection via `$WSL_DISTRO_NAME`
- Dynamic screenshot directory resolution with fallback hierarchy
- Improved Claude Code command files with dynamic script detection

## [1.0.0] - 2025-07-09

### Added
- Initial release of Claude Screenshot System
- Core screenshot automation and management functionality
- Claude Code integration with custom `/ss` commands
- Cross-platform support (macOS, Linux, Windows)
- Obsidian vault integration for screenshot organization
- Real-time screenshot monitoring and processing
- Shell aliases for efficient workflow
- Secure installation with SHA256 verification
- Comprehensive documentation and setup guides

### Features
- **Screenshot Management**: Automated detection, organization, and processing
- **Claude Integration**: Custom `/ss`, `/sslist`, `/ssshow` commands for immediate AI analysis
- **Cross-Platform Support**: Unix/Linux/Windows compatibility with platform-specific optimizations
- **Workflow Automation**: Real-time monitoring and batch processing capabilities
- **Security**: Two-stage secure installation with integrity verification
- **Documentation**: Extensive README with troubleshooting guides and best practices
---
name: "ss"
description: "Show the latest screenshot for analysis"
author: "Claude AI Assistant"
version: "1.1.0"
---

# Show Latest Screenshot

This command automatically finds and displays the most recent screenshot from your Screenshots directory.

```bash
# Find claude_integration.sh script dynamically
CLAUDE_INTEGRATION_SCRIPT=""

# Search common locations for the script
for possible_location in \
    "~/Pictures/Screenshots/claude_integration.sh" \
    "/mnt/c/AItools/claude-screenshot/scripts/claude_integration.sh" \
    "/mnt/c/Users/$USER/Pictures/Screenshots/claude_integration.sh" \
    "$(pwd)/scripts/claude_integration.sh" \
    "$(pwd)/../scripts/claude_integration.sh"; do
    
    if [ -f "$possible_location" ]; then
        CLAUDE_INTEGRATION_SCRIPT="$possible_location"
        break
    fi
done

if [ -z "$CLAUDE_INTEGRATION_SCRIPT" ]; then
    echo "❌ **Claude Screenshot Integration not found**"
    echo ""
    echo "Please run the installation script first:"
    echo "- **Linux/macOS:** \`curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.sh | bash\`"
    echo "- **Windows:** Download and run \`install.ps1\`"
    exit 1
fi

# Get the latest screenshot path
SCREENSHOT_PATH=$($CLAUDE_INTEGRATION_SCRIPT latest 2>/dev/null | head -1)

if [ -n "$SCREENSHOT_PATH" ] && [ -f "$SCREENSHOT_PATH" ]; then
    echo "📸 **Latest Screenshot:**"
    echo
    echo "**File:** $(basename "$SCREENSHOT_PATH")"
    echo "**Path:** $SCREENSHOT_PATH"
    echo "**Date:** $(date -r "$SCREENSHOT_PATH" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "Unknown")"
    echo "**Size:** $(du -h "$SCREENSHOT_PATH" 2>/dev/null | cut -f1 || echo "Unknown")"
    echo
    echo "![Latest Screenshot]($SCREENSHOT_PATH)"
else
    echo "❌ **No screenshots found or script execution failed**"
    echo ""
    echo "**Troubleshooting:**"
    echo "1. **Take a screenshot:** Win+Shift+S (Windows) or Cmd+Shift+4 (macOS)"
    echo "2. **Debug the integration:** Run \`DEBUG=1 $CLAUDE_INTEGRATION_SCRIPT latest\`"
    echo "3. **Check script location:** $CLAUDE_INTEGRATION_SCRIPT"
fi
```

---

**Usage:** `/ss`

**What this does:**
1. 🔍 Finds the most recent screenshot in `~/Pictures/Screenshots`
2. 📊 Shows file metadata (name, date, size)
3. 🖼️ Displays the image for Claude to analyze
4. ❓ Provides help if no screenshots are found

**Requirements:**
- Claude Screenshot System must be installed (`./install.sh` or `./install.ps1`)
- Screenshots directory automatically detected (WSL2/Windows compatible)
- Integration script automatically located in common paths
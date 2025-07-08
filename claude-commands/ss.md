---
name: "ss"
description: "Show the latest screenshot for analysis"
author: "Claude AI Assistant"
version: "1.0"
---

# Show Latest Screenshot

This command automatically finds and displays the most recent screenshot from your Screenshots directory.

```bash
# Get the latest screenshot path
SCREENSHOT_PATH=$(~/Pictures/Screenshots/claude_integration.sh latest 2>/dev/null | head -1)

if [ -n "$SCREENSHOT_PATH" ] && [ -f "$SCREENSHOT_PATH" ]; then
    echo "📸 **Latest Screenshot:**"
    echo
    echo "**File:** $(basename "$SCREENSHOT_PATH")"
    echo "**Path:** $SCREENSHOT_PATH"
    echo "**Date:** $(date -r "$SCREENSHOT_PATH" '+%Y-%m-%d %H:%M:%S')"
    echo "**Size:** $(du -h "$SCREENSHOT_PATH" | cut -f1)"
    echo
    echo "![Latest Screenshot]($SCREENSHOT_PATH)"
else
    echo "❌ **No screenshots found**"
    echo
    echo "Take a screenshot first with:"
    echo "- **Command+Shift+4** (save to file)"
    echo "- **Command+Shift+Control+4** then run \`clipboard-save\`"
    echo
    echo "Screenshots are saved to: \`~/Pictures/Screenshots\`"
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
- Screenshot system must be set up (`~/Pictures/Screenshots/master_setup.sh`)
- Screenshots directory: `~/Pictures/Screenshots`
- Integration script: `~/Pictures/Screenshots/claude_integration.sh`
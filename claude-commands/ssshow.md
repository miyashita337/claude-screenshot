---
name: "ssshow"
description: "Show a specific screenshot by number"
author: "Claude AI Assistant"
version: "1.0"
parameters:
  - name: "number"
    description: "Screenshot number from sslist"
    required: true
---

# Show Specific Screenshot

This command displays a specific screenshot by its number from the recent screenshots list.

```bash
# Get the screenshot number from arguments
SCREENSHOT_NUMBER="$1"

if [ -z "$SCREENSHOT_NUMBER" ]; then
    echo "❌ **Error: Screenshot number required**"
    echo
    echo "**Usage:** \`/ssshow NUMBER\`"
    echo
    echo "First run \`/sslist\` to see available screenshots with numbers."
    exit 1
fi

# Get the specific screenshot
SCREENSHOT_INFO=$(~/Pictures/Screenshots/claude_integration.sh show "$SCREENSHOT_NUMBER" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$SCREENSHOT_INFO" ]; then
    SCREENSHOT_PATH=$(echo "$SCREENSHOT_INFO" | head -1)
    
    if [ -f "$SCREENSHOT_PATH" ]; then
        echo "📸 **Screenshot #$SCREENSHOT_NUMBER:**"
        echo
        echo "**File:** $(basename "$SCREENSHOT_PATH")"
        echo "**Path:** $SCREENSHOT_PATH"
        echo "**Date:** $(date -r "$SCREENSHOT_PATH" '+%Y-%m-%d %H:%M:%S')"
        echo "**Size:** $(du -h "$SCREENSHOT_PATH" | cut -f1)"
        echo
        echo "![Screenshot #$SCREENSHOT_NUMBER]($SCREENSHOT_PATH)"
    else
        echo "❌ **Error: Screenshot file not found**"
        echo
        echo "Run \`/sslist\` to see available screenshots."
    fi
else
    echo "❌ **Error: Invalid screenshot number: $SCREENSHOT_NUMBER**"
    echo
    echo "**Available options:**"
    echo "- Run \`/sslist\` to see numbered list of screenshots"
    echo "- Use \`/ss\` for the latest screenshot"
    echo "- Screenshot numbers start from 1"
fi
```

---

**Usage:** `/ssshow NUMBER`

**Examples:**
- `/ssshow 1` - Show the most recent screenshot
- `/ssshow 3` - Show the 3rd most recent screenshot

**What this does:**
1. 🔍 Finds the screenshot by number from recent list
2. 📊 Shows file metadata (name, date, size)
3. 🖼️ Displays the image for Claude to analyze
4. ❓ Provides helpful error messages

**Related Commands:**
- `/sslist` - List all recent screenshots with numbers
- `/ss` - Show latest screenshot directly
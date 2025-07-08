---
name: "sslist"
description: "List recent screenshots with selection options"
author: "Claude AI Assistant"
version: "1.0"
---

# List Recent Screenshots

This command shows a numbered list of recent screenshots for easy selection and analysis.

```bash
# Get recent screenshots list
SCREENSHOTS_LIST=$(~/Pictures/Screenshots/claude_integration.sh list 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$SCREENSHOTS_LIST" ]; then
    echo "📸 **Recent Screenshots:**"
    echo
    echo "$SCREENSHOTS_LIST"
    echo
    echo "---"
    echo
    echo "**Usage:**"
    echo "- Use \`/ssshow NUMBER\` to display a specific screenshot"
    echo "- Use \`/ss\` to show the latest screenshot"
    echo "- Screenshots are stored in: \`~/Pictures/Screenshots\`"
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

**Usage:** `/sslist`

**What this does:**
1. 📋 Lists up to 10 most recent screenshots
2. 🔢 Shows numbered list with metadata
3. 📅 Displays file dates and sizes
4. 💡 Provides usage instructions

**Related Commands:**
- `/ss` - Show latest screenshot
- `/ssshow NUMBER` - Show specific screenshot by number
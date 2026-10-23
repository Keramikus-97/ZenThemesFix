#!/usr/bin/env bash
# ============================================================================
# Zen-Nebula Installation Script
# Usage: chmod +x install-zen-nebula.sh && ./install-zen-nebula.sh
# ============================================================================

set -euo pipefail

echo "╔══════════════════════════════════════════════════╗"
echo "║       Zen-Nebula Theme Installation Script       ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Determine profile directory
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PROFILE_DIR="$HOME/.zen"
    echo "Detected OS: Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PROFILE_DIR="$HOME/Library/Application Support/Zen"
    echo "Detected OS: macOS"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    PROFILE_DIR="$APPDATA/zen/Profiles"
    echo "Detected OS: Windows"
else
    echo "Unknown OS: $OSTYPE"
    echo "Please manually edit ~/.zen/userChrome.css"
    exit 1
fi

# Default profile (release)
PROFILE_NAME="release"
echo "Using profile: $PROFILE_DIR/$PROFILE_NAME"

# Backup existing files
BACKUP_DIR="$HOME/.zen-backup-zen-nebula-$(date +%Y%m%d-%H%M%S)"
echo "Creating backup at: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

if [[ -f "$PROFILE_DIR/$PROFILE_NAME/userChrome.css" ]]; then
    cp "$PROFILE_DIR/$PROFILE_NAME/userChrome.css" "$BACKUP_DIR/"
    echo "  ✓ Backed up existing userChrome.css"
fi

if [[ -f "$PROFILE_DIR/$PROFILE_NAME/userContent.css" ]]; then
    cp "$PROFILE_DIR/$PROFILE_NAME/userContent.css" "$BACKUP_DIR/"
    echo "  ✓ Backed up existing userContent.css"
fi

if [[ -f "$PROFILE_DIR/$PROFILE_NAME/zen-themes.json" ]]; then
    cp "$PROFILE_DIR/$PROFILE_NAME/zen-themes.json" "$BACKUP_DIR/"
    echo "  ✓ Backed up existing zen-themes.json"
fi

# Create the support files
echo ""
echo "Creating theme support files..."

# Create nebula directory
mkdir -p "$PROFILE_DIR/$PROFILE_NAME/nebula"

# Copy CSS files
cp "$BASE_DIR/zennebula/nebula/chrome.css" "$PROFILE_DIR/$PROFILE_NAME/nebula/"
cp "$BASE_DIR/zennebula/nebula/config.css" "$PROFILE_DIR/$PROFILE_NAME/nebula/"
cp "$BASE_DIR/zennebula/nebula/content.css" "$PROFILE_DIR/$PROFILE_NAME/nebula/"
cp "$BASE_DIR/zennebula/nebula/chrome.css" "$PROFILE_DIR/$PROFILE_NAME/userChrome.css"
cp "$BASE_DIR/zennebula/nebula/content.css" "$PROFILE_DIR/$PROFILE_NAME/userContent.css"

echo "  ✓ Copied nebula/chrome.css → userChrome.css"
echo "  ✓ Copied nebula/content.css → userContent.css"

# Create nebula/mods.json for browsercfg
cat > "$PROFILE_DIR/$PROFILE_NAME/nebula/mods.json" << 'MODSJSON'
{
  "Nebula": {
    "id": "Nebula",
    "name": "Nebula",
    "description": "Glassmorphism-based theme for Zen Browser",
    "createdAt": "2025-05-31",
    "updatedAt": "2025-05-31",
    "homepage": "https://github.com/JustAdumbPrsn/Zen-Nebula",
    "version": "3.5.0",
    "style": {
      "chrome": "userChrome.css",
      "content": "userContent.css"
    },
    "scripts": {
      "js/nebula.uc.js": {
        "include": ["chrome://browser/content/browser.xhtml"]
      }
    },
    "preferences": "preferences.json",
    "origin": "store",
    "no-updates": true,
    "enabled": true
  }
}
MODSJSON
echo "  ✓ Created nebula/mods.json"

# Create nebula/config.css (actual file with fallback)
# (We'll create it as a minimal file that imports the fixed config)
cat > "$PROFILE_DIR/$PROFILE_NAME/nebula/config.css" << 'CONFIGCSS'
/* Nebula Theme Configuration */
/* This file is imported by nebula/chrome.css */

:root {
  /* Glass & Blur */
  --nebula-glass: blur(32px) saturate(140%);
  --nebula-color-glass: rgba(255, 255, 255, 0.4);
  
  /* Layout */
  --nebula-border-radius: 13px;
  --nebula-essentials-width: 60px;
  --nebula-workspace-grayscale: 100%;
  
  /* UI & Website Tint */
  --nebula-ui-tint: rgba(255, 255, 255, 0.2);
  --nebula-website-tint: rgba(255, 255, 255, 0);
  
  /* Colors */
  --nebula-color-min: rgba(255, 255, 255, 0.1);
  --nebula-color: rgba(255, 255, 255, 0.25);
  --nebula-color-hover: rgba(255, 255, 255, 0.35);
  --nebula-color-selected: rgba(255, 255, 255, 0.45);
  --nebula-color-shadow: rgba(0, 0, 0, 0.55);
}
CONFIGCSS
echo "  ✓ Created nebula/config.css"

# Create userChrome.css and userContent.css
cat > "$PROFILE_DIR/$PROFILE_NAME/userChrome.css" << 'USERCSS'
/* Zen-Nebula Main CSS - Glassmorphism Theme */
/* Imported by userChrome.css */
@import url("nebula/chrome.css");
USERCSS
cat > "$PROFILE_DIR/$PROFILE_NAME/userContent.css" << 'USERCONTENT'
/* Zen-Nebula Content CSS */
@import url("nebula/content.css");
USERCONTENT
echo "  ✓ Created userChrome.css and userContent.css"

# Add to about:config (optional)
echo ""
read -p "Enable transparent tabs? (about:config → browser.tabs.allow_transparent_browser = true) [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "Setting: browser.tabs.allow_transparent_browser = true"
    zen-remote set browser.tabs.allow_transparent_browser true 2>/dev/null || true
fi

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║     ✅ Zen-Nebula Installation Complete!         ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "1. Restart Zen Browser"
echo "2. Enable 'Transparent Tabs' in about:config if not auto-enabled"
echo "3. Go to about:config → browser.tabs.allow_transparent_browser = true"
echo "4. Optional: Download wallpapers from the Zen-Nebula GitHub repo"
echo "5. Enjoy your new glassmorphism theme!"
echo ""

#!/usr/bin/env bash
# ============================================================================
# Natsumi Browser Skin Installation Script
# Skin for Firefox and its forks
# Usage: chmod +x install-natsumi.sh && ./install-natsumi.sh
# ============================================================================

set -euo pipefail

echo "╔══════════════════════════════════════════════════╗"
echo "║       Natsumi Browser Skin Installation          ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Determine profile directory
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PROFILE_DIR="$HOME/.mozilla/firefox"
    echo "Detected OS: Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PROFILE_DIR="$HOME/Library/Application Support/Firefox/Profiles"
    echo "Detected OS: macOS"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    PROFILE_DIR="$APPDATA/Mozilla/Firefox/Profiles"
    echo "Detected OS: Windows"
else
    echo "Unknown OS: $OSTYPE"
    exit 1
fi

# Find the profile directory
echo "Looking for Firefox profiles in: $PROFILE_DIR"
PROFILE=$(ls -d "$PROFILE_DIR"*/ 2>/dev/null | head -1)
if [[ -z "$PROFILE" ]]; then
    echo "ERROR: Could not find Firefox profile in $PROFILE_DIR"
    echo "Please manually copy natsumi/natsumi.css to your profile's userChrome.css"
    exit 1
fi

PROFILE_NAME=$(basename "$PROFILE")
echo "Using profile: $PROFILE_NAME"

# Backup existing files
BACKUP_DIR="$HOME/.natsumi-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "Creating backup at: $BACKUP_DIR"

if [[ -f "$PROFILE/$PROFILE_NAME/userChrome.css" ]]; then
    cp "$PROFILE/$PROFILE_NAME/userChrome.css" "$BACKUP_DIR/"
    echo "  ✓ Backed up existing userChrome.css"
fi

# Create the support files
echo ""
echo "Creating skin support files..."

# Create the natsumi directory structure
mkdir -p "$PROFILE/$PROFILE_NAME/natsumi"

# Copy CSS files
cp -r "$BASE_DIR/natsumi/modules/"* "$PROFILE/$PROFILE_NAME/natsumi/"
cp "$BASE_DIR/natsumi/natsumi.css" "$PROFILE/$PROFILE_NAME/userChrome.css"
cp "$BASE_DIR/natsumi/natsumi-config.css" "$PROFILE/$PROFILE_NAME/userContent.css"

echo "  ✓ Copied natsumi modules"
echo "  ✓ Created userChrome.css (main entry point)"
echo "  ✓ Created userContent.css (config)"

# Create a userChrome.css that imports the main CSS
cat > "$PROFILE/$PROFILE_NAME/userChrome.css" << 'USERCSS'
/* Natsumi Browser Skin - Main Entry Point */
@import url("natsumi.css");
USERCSS
echo "  ✓ Updated userChrome.css"

# Info about the skin
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║     ✅ Natsumi Browser Skin Installation Done!   ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "1. Restart Firefox"
echo "2. The skin will apply automatically"
echo "3. Customize via about:addons → Natsumi settings (if available)"
echo ""

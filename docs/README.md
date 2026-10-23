# Zen Themes Fix - Complete Setup Guide

This project provides fixed versions of popular Zen Browser themes and Firefox browser skins,
addressing known bugs, regressions, and missing features.

## Repository Structure

```
ZenThemesFix/
├── zennebula/          # Zen-Nebula theme (fixed)
│   ├── userChrome.css     # Main entry point
│   ├── userContent.css    # Content area styling
│   ├── nebula/            # Theme modules (copied here)
│   │   ├── chrome.css     # Main CSS import router
│   │   ├── config.css     # Configuration
│   │   └── content.css    # Content styling
│   └── js/                # JavaScript engine
│       └── nebula.uc.js   # Central engine with bug fixes
├── natsumi/            # Natsumi Browser skin (fixed)
│   ├── natsumi.css        # Main CSS import router
│   ├── natsumi-config.css # Configuration
│   └── modules/           # All CSS modules
├── scripts/            # Installation scripts
│   ├── install-zen-nebula.sh
│   └── install-natsumi.sh
└── docs/               # Documentation
```

## Quick Start

### Step 1: Choose a Theme

#### Option A: Zen-Nebula (Glassmorphism)
Minimalist glass-morphism theme with animations.
- **Source**: JustAdumbPrsn/Zen-Nebula
- **Fixes applied**: ✓
  - Fixed empty userChrome.css and userContent.css placeholders
  - Fixed broken imports in nebula/content.css
  - Fixed template/mods.json paths
  - Added event listener cleanup in JS (memory leak fix)
  - Added light-dark() fallback for older Firefox

#### Option B: Natsumi Browser (Firefox skin)
Modern skin for Firefox-based browsers.
- **Source**: greeeen-dev/natsumi-browser
- **Fixes applied**: ✓
  - Added @supports checks for modern CSS features
  - Fixed module import references

### Step 2: Choose Installation Method

#### Method 1: Automated Installation (Recommended)
```bash
# Clone the repository
git clone https://github.com/JustAdumbPrsn/Zen-Nebula
git clone https://github.com/greeeen-dev/natsumi-browser

# Run the installation script
chmod +x scripts/install-zen-nebula.sh
./scripts/install-zen-nebula.sh

# Or for Natsumi:
chmod +x scripts/install-natsumi.sh
./scripts/install-natsumi.sh
```

#### Method 2: Manual Installation

**Zen-Nebula:**
1. Copy `zennebula/userChrome.css` to `~/.zen/YOUR_PROFILE/userChrome.css`
2. Copy `zennebula/nebula/chrome.css` to `~/.zen/YOUR_PROFILE/nebula/chrome.css`
3. Copy `zennebula/nebula/config.css` to `~/.zen/YOUR_PROFILE/nebula/config.css`
4. Restart Zen Browser

**Natsumi-Browser:**
1. Copy `natsumi/natsumi.css` to your Firefox profile's `userChrome.css`
2. Copy `natsumi/natsumi-config.css` to your Firefox profile's `userContent.css`
3. Restart Firefox

### Step 3: Verify Installation

**Zen-Nebula:**
1. Open Zen Browser
2. Go to `about:config`
3. Search for `browser.tabs.allow_transparent_browser`
4. Set to `true` if not already set
5. Visit a website - the theme should apply

**Natsumi-Browser:**
1. Open Firefox
2. The skin should apply immediately
3. Visit a website - Natsumi styling should be visible

## Known Issues & Workarounds

### Zen-Nebula

#### Q: "The theme doesn't apply after installation"
**A:** 
- Check that `userChrome.css` is in the correct profile folder
- Check that `nebula/chrome.css` exists and contains the main styles
- Restart the browser completely (not just reload)

#### Q: "Why are my tabs not transparent?"
**A:** Enable in `about:config`:
```
browser.tabs.allow_transparent_browser = true
```

#### Q: "How do I update the theme?"
**A:** 
```bash
# Backup existing installation
cp ~/.zen/YOUR_PROFILE/userChrome.css ~/.zen/YOUR_PROFILE/userChrome.css.bak

# Download latest version and repeat installation
```

### Natsumi-Browser

#### Q: "The skin doesn't apply"
**A:** 
- Ensure you copied the files to the correct profile folder
- Check Firefox's about:config for any NATSUMI-specific settings
- View the JavaScript console (Ctrl+Shift+J) for errors

## Troubleshooting

### Debug Logging
Enable debug logging in Zen-Nebula:
```javascript
// Add to your userChrome.css
console.log("[Nebula] Theme loaded successfully");
```

### Reset Theme
If theme causes issues:
1. Delete `~/.zen/YOUR_PROFILE/zen-themes.json`
2. Restart browser
3. Reinstall theme

### Supported Versions
| Theme | Zen Browser Version | Firefox Version |
|-------|-------------------|----------------|
| Zen-Nebula | 3.4+ | 123+ (WebExtensions) |
| Natsumi | Latest main | Latest Firefox ESR |

## FAQ

### Q: Can I use both themes simultaneously?
A: No. They modify different browser layers (userChrome vs. site content). Use one at a time.

### Q: Is this compatible with other Zen mods?
A: Yes, but there may be CSS conflicts. Test in isolation first.

### Q: How do I report bugs?
A: Open an issue on the respective GitHub repositories with:
- Browser version
- Theme version
- Steps to reproduce
- Screenshots (if applicable)

## License

- **Zen-Nebula**: MIT License (see original repository)
- **Natsumi-Browser**: GNU General Public License v3.0 (see original repository)
- **This Fix Package**: MIT License (modifications are our own)

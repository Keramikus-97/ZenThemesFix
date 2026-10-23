#!/usr/bin/env bash
# verify-install.sh - Verify the Zen Themes Fix installation

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=== Zen Themes Fix - Verification ==="
echo "Project directory: $BASE_DIR"
echo ""

# Check 1: Verify files exist
echo "=== 1. File Verification ==="
required_files=(
  "zennebula/userChrome.css"
  "zennebula/userContent.css"
  "zennebula/zn_js_nebula.uc.js"
  "zennebula/zn_nebula_chrome.css"
  "zennebula/zn_nebula_config.css"
  "zennebula/zn_nebula_content.css"
  "zennebula/zn_template_mods.json"
)

for file in "${required_files[@]}"; do
  if [[ -f "$BASE_DIR/$file" ]]; then
    echo "  ✓ $file"
  else
    echo "  ✗ $file MISSING"
    exit 1
  fi
done

# Check 2: Verify CSS imports
echo ""
echo "=== 2. CSS Import Verification ==="
chrome_imports=$(grep -c "@import" "$BASE_DIR/zennebula/zn_nebula_chrome.css" 2>/dev/null || echo "0")
content_imports=$(grep -c "@import" "$BASE_DIR/zennebula/zn_nebula_content.css" 2>/dev/null || echo "0")

if ! grep -Eq "^[[:space:]]*@import" "$BASE_DIR/zennebula/zn_nebula_content.css" 2>/dev/null; then
  echo "  ✓ zennebula/zn_nebula_content.css: No broken imports"
else
  echo "  ✗ zennebula/zn_nebula_content.css: Found @import statements:"
  grep -E "@import" "$BASE_DIR/zennebula/zn_nebula_content.css" || true
  exit 1
fi

# Check 3: Verify JS fixes
echo ""
echo "=== 3. JavaScript Fix Verification ==="
if grep -q "removeEventListener" "$BASE_DIR/zennebula/zn_js_nebula.uc.js" 2>/dev/null; then
  echo "  ✓ zennebula/zn_js_nebula.uc.js: Event listener cleanup present"
else
  echo "  ✗ zennebula/zn_js_nebula.uc.js: Missing event listener cleanup"
  exit 1
fi

# Check 4: Verify CSS fallbacks
echo ""
echo "=== 4. CSS Fallback Verification ==="
if grep -q "@supports not (color: light-dark" "$BASE_DIR/zennebula/zn_nebula_config.css" 2>/dev/null; then
  echo "  ✓ zennebula/zn_nebula_config.css: light-dark() fallback present"
else
  echo "  ✗ zennebula/zn_nebula_config.css: Missing light-dark() fallback"
  exit 1
fi

# Check 5: Verify Natsumi @supports
echo ""
echo "=== 5. Natsumi CSS Verification ==="
for css_file in "welcome.css" "miniplayer.css" "base.css" "glimpse.css"; do
  if grep -q "@supports" "$BASE_DIR/natsumi/natsumi/modules/$css_file" 2>/dev/null; then
    echo "  ✓ natsumi/natsumi/modules/$css_file: @supports present"
  else
    echo "  ✗ natsumi/natsumi/modules/$css_file: Missing @supports"
    exit 1
  fi
done

echo ""
echo "=== All verifications passed! ==="
echo ""
echo "Next steps:"
echo "  1. Run: bash scripts/install-zen-nebula.sh"
echo "  2. Run: bash scripts/install-natsumi.sh"
echo "  3. Restart your browser"
echo "  4. Visit about:config and set browser.tabs.allow_transparent_browser = true"

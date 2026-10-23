# Zen Themes Fix - Patch Manifest

Diese Patch-Dateien enthalten alle Korrekturen für die beiden Themes.

## Zen-Nebula Patches

### 01-nebula-content-css-fix.patch
- Problem: nebula/content.css importierte nicht existente Dateien
- Fix: Brocheren @import von content/better-pdf.css und content/transparent-settings.css
- Dateien: nebula/content.css

### 02-template-mods-json-fix.patch
- Problem: template/mods.json verweist auf TODO-Placeholders (userChrome.css, userContent.css)
- Fix: Pfade auf korrekte Archive: nebula/chrome.css und nebula/content.css
- Dateien: template/mods.json

### 03-js-nebula-uc-js-fix.patch
- Problem: Event-Listener (TabSelect, TabAttrModified) werden nie entfernt -> Speicherleck
- Fix: removeEventListener in destroy() + clearInterval for setInterval
- Dateien: js/nebula.uc.js

### 04-nebula-config-css-fallback.patch
- Problem: light-dark() CSS-Variable nicht von aelteren Firefox-Versionen unterstuetzt
- Fix: @supports Fallback hinzugefuegt
- Dateien: nebula/config.css

## Natsumi-Browser Patches

### 00-natsumi-css-supports-fix.patch
- Problem: Keine @supports-Checks fuer moderne CSS-Features
- Fix: @supports-Blöcke fuer backdrop-filter und filter hinzugefuegt
- Dateien: welcome.css, miniplayer.css, base.css, glimpse.css

### 01-natsumi_modules_*.patch
- Spezifische Patches fuer jede CSS-Datei mit @supports-Bezug

---

## Anwendung

### Zen-Nebula
```bash
cd ~/Projects/ZenThemesFix/zennebula
git apply ../../patches/zen-nebula/01-*.patch
git apply ../../patches/zen-nebula/02-*.patch
git apply ../../patches/zen-nebula/03-*.patch
git apply ../../patches/zen-nebula/04-*.patch
```

### Natsumi-Browser
```bash
cd ~/Projects/ZenThemesFix/natsumi
git apply ../../patches/natsumi-browser/01-*.patch
```

## Testen

```bash
chmod +x scripts/verify-install.sh
./scripts/verify-install.sh
```

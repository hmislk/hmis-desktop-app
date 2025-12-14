# HMIS Chrome Desktop App

Simple Chrome-based desktop wrapper for HMIS web application with optimized print settings for zero-margin, header-free printing.

## Features

✅ **Independent Sessions** - Each launch creates a new session with separate logins

✅ **Template-Based Print Settings** - Configure once, use forever (no margins, no headers/footers)

✅ **Configurable Print Modes** - Preview, Direct, or Silent printing

✅ **Cache Control** - Enable/disable for fresh data

✅ **No Framework Overhead** - Pure Chrome, no Electron/Tauri

✅ **Multi-Instance Support** - Run unlimited simultaneous sessions

✅ **Clean Interface** - App mode (no address bar)

✅ **Lightweight** - Just batch files and a print extension


## Files

- **config.bat** - Configuration file (URL, session mode, print settings)
- **Launch-HMIS.bat** - Normal window mode launcher
- **Launch-HMIS-Fullscreen.bat** - Fullscreen/kiosk mode launcher
- **Setup-Print-Settings.bat** - One-time print configuration wizard
- **Test-Print-Settings.bat** - Verify current print settings
- **Cleanup-Sessions.bat** - Remove old session data
- **print-extension/** - Chrome extension for print CSS optimization

## Initial Setup (New Computer)

### Step 1: Copy Files
1. Copy the entire HMIS folder to the new computer
2. Ensure all files are present (config.bat, Launch-HMIS.bat, print-extension folder, etc.)

### Step 2: Configure Application URL
Edit `config.bat` and set your HMIS server URL:
```batch
set HMIS_URL=https://stg.carecode.org/coopprod/
```

### Step 3: Configure Print Settings (One-Time Setup)
**This is crucial for zero-margin, header-free printing:**

1. Close all Chrome windows
2. Run **Cleanup-Sessions.bat** (clears any old data)
3. Run **Launch-HMIS.bat**
   - First launch will show: "First launch - creating template profile..."
4. Press **Ctrl+P** to open print dialog
5. Configure print settings:
   - Click **"More settings"** to expand all options
   - **Margins**: Select **"None"** from dropdown
   - **Headers and footers**: **UNCHECK** this checkbox
   - **Background graphics**: Check if needed
6. Click **"Cancel"** to close print dialog (settings are saved)
7. **Close Chrome completely**
8. Run **Launch-HMIS.bat** again to verify settings are preserved

**Note:** These settings are saved in the template and will be copied to every new session automatically.

### Step 4: Test Printing
1. Launch the app
2. Press Ctrl+P
3. Verify: Margins = "None", Headers/footers = unchecked
4. Each new session will inherit these settings

## Configuration Options

**Edit `config.bat` to customize:**

```batch
set HMIS_URL=https://your-server.com/path    # Your HMIS server URL
set SESSION_MODE=TEMPLATE                    # UNIQUE, PERSISTENT, or TEMPLATE
set PRINT_MODE=PREVIEW                       # PREVIEW, DIRECT, or SILENT
set PRINT_MARGINS=0                          # 0=none, 1=default, 2=minimum
set PRINT_HEADERS=DISABLED                   # ENABLED or DISABLED
set CACHE_MODE=DISABLED                      # DISABLED or ENABLED
set WINDOW_SIZE=1400,1000                    # Width,Height in pixels
set ZOOM_LEVEL=0.8                           # 0.8=80%, 1.0=100%, empty=default
```

### Session Modes Explained

**TEMPLATE** (Recommended for multi-user with print settings)
- Each launch creates a NEW session (separate logins)
- Printer settings are PRESERVED from template
- Best for: Multiple users, kiosks, shared computers
- Print settings configured once in template, used by all sessions

**PERSISTENT** (Single-user mode)
- Same session every launch
- All windows share the same login
- Settings preserved between launches
- Best for: Single-user dedicated workstation

**UNIQUE** (Clean slate every time)
- New session each launch
- NO settings preserved (including print settings)
- Best for: Testing, development
- **Not recommended** if you need consistent print settings

### Print Modes Explained

**PREVIEW** (Recommended)
- Shows print dialog before printing
- User can verify settings and choose printer
- Best for most scenarios

**DIRECT**
- Skips preview dialog
- Uses last printer and settings
- Best for: Receipt printers, label printers

**SILENT**
- Automatic printing to default printer
- No user interaction required
- Best for: Kiosk mode with dedicated printer
- **Requires TEMPLATE or PERSISTENT mode for settings to work**

## Daily Usage

### Quick Start

1. Double-click **Launch-HMIS.bat**
2. Each click creates a new window with:
   - Fresh login session (enter credentials)
   - Saved printer settings (margins, headers/footers)
3. Multiple users can run simultaneously with separate logins

### Printing

**Normal Printing:**
1. Trigger print from HMIS application (or Ctrl+P)
2. Print dialog appears (if PRINT_MODE=PREVIEW)
3. Verify settings: Margins=None, Headers/footers=unchecked
4. Click "Print"

**Auto-Printing (Kiosk Mode):**
- Set `PRINT_MODE=SILENT` in config.bat
- Prints automatically to default printer
- No user interaction required

### Fullscreen Mode

- Use **Launch-HMIS-Fullscreen.bat** for fullscreen kiosk mode
- Press `Alt+F4` to close (F11 doesn't work in --kiosk mode)

### Maintenance

**Weekly Cleanup (Recommended):**
- Run **Cleanup-Sessions.bat** to remove old session data
- Clears cached files from: `%TEMP%\HMIS-Chrome\`
- Frees up disk space
- Does NOT delete your template or print settings

## How It Works

### Session Isolation with Template Mode

1. **First Launch (Template Creation):**
   - Creates template profile at: `%TEMP%\HMIS-Chrome\TemplateProfile\`
   - You configure print settings in this template
   - Template is saved permanently

2. **Subsequent Launches:**
   - Copies template to new session: `%TEMP%\HMIS-Chrome\Session_[TIMESTAMP]\`
   - Each window gets:
     - Fresh login (separate cookies)
     - Same printer settings (from template)
   - Complete session isolation between windows

3. **Print Extension:**
   - Chrome extension loaded via `--load-extension` flag
   - Injects CSS to hide webpage headers/footers
   - Sets `@page { margin: 0 }` for zero-margin printing
   - Located in: `print-extension/` folder

## Deployment

### Option 1: Desktop Shortcuts
- Right-click `Launch-HMIS.bat` → Send to → Desktop (create shortcut)
- Rename to "HMIS Desktop"

### Option 2: Network Deployment
- Place these files on a network share
- Create shortcuts on user desktops pointing to the .bat file

### Option 3: Custom Icon
1. Create a shortcut to `Launch-HMIS.bat`
2. Right-click shortcut → Properties
3. Click "Change Icon"
4. Browse to your icon file

## Print Extension Details

The `print-extension/` folder contains a Chrome extension that optimizes printing:

**Files:**
- `manifest.json` - Extension metadata and permissions
- `print.css` - CSS rules for print media (hides headers/footers)
- `content.js` - JavaScript to inject print styles

**What it does:**
1. Sets `@page { margin: 0 }` to remove page margins
2. Hides common header/footer HTML elements
3. Prevents unwanted page breaks
4. Ensures background graphics print correctly

**Customization:**
Edit `print.css` to add custom print rules:
```css
@media print {
  .your-custom-class {
    display: none !important;
  }
}
```

**Different HMIS URL:**
If your HMIS is on a different domain, update `manifest.json`:
```json
"host_permissions": [
  "https://your-domain.com/*"
]
```

## Keyboard Shortcuts

- `F11` - Toggle fullscreen
- `Ctrl+W` - Close current window
- `Ctrl+Shift+I` - Open DevTools

## Troubleshooting

### Print Settings Not Saved

**Problem:** Margins revert to "Default" and Headers/footers get re-enabled after closing Chrome.

**Solution:**
1. Check `config.bat` - ensure `SESSION_MODE=TEMPLATE` (not UNIQUE)
2. Close ALL Chrome windows completely
3. Run **Cleanup-Sessions.bat**
4. Follow the print setup steps again (see "Step 3: Configure Print Settings" above)
5. Verify template exists: `%TEMP%\HMIS-Chrome\TemplateProfile\`

**Why this happens:**
- UNIQUE mode doesn't save any settings
- Template must be configured on first launch
- Running Cleanup-Sessions.bat deletes the template (requires reconfiguration)

### Print Shows Margins and Headers/Footers

**Problem:** Prints still have margins and show URL/date at top/bottom.

**Diagnosis:**
1. Press Ctrl+P and check:
   - Margins dropdown - should show "None"
   - Headers/footers checkbox - should be UNCHECKED
2. If settings show correctly but print still has margins:
   - These are Chrome's print headers (not webpage headers)
   - Browser settings override CSS

**Solution:**
1. Run **Setup-Print-Settings.bat** for guided configuration
2. Manually set in print dialog:
   - More settings → Margins → **None**
   - More settings → Headers and footers → **UNCHECK**
3. Close Chrome to save template
4. Test with next launch

### Prints Create Extra Blank Pages

**Problem:** Two pages print when content fits on one page.

**Causes:**
1. Margins pushing content to second page
2. Page breaks in HTML/CSS
3. Hidden content extending beyond page

**Solution:**
1. Set margins to "None" (see above)
2. The print-extension should prevent page breaks
3. Check if webpage has explicit page-break CSS
4. Verify print-extension is loaded (check Chrome extensions)

### Chrome Not Found

**Problem:** Batch file says Chrome is not found.

**Solution:**
Edit `Launch-HMIS.bat` and update Chrome path:
```batch
set CHROME_CMD="C:\Program Files\Google\Chrome\Application\chrome.exe"
```

Common alternative paths:
- `C:\Program Files (x86)\Google\Chrome\Application\chrome.exe`
- `%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe`

### Sessions Not Isolated

**Problem:** All windows share the same login.

**Diagnosis:**
- Check if SESSION_MODE=PERSISTENT (this is normal behavior)
- Look at batch window - each launch should show different SESSION_ID

**Solution:**
- Use SESSION_MODE=TEMPLATE for isolated sessions
- Each launch creates new Session_[TIMESTAMP] folder

### Print Extension Not Loading

**Problem:** Extension warnings or print CSS not working.

**Solution:**
1. Verify `print-extension/` folder exists in HMIS directory
2. Check folder contains:
   - manifest.json
   - print.css
   - content.js
3. Chrome may show extension warnings - this is normal for development extensions
4. Extension must match your HMIS URL in manifest.json

### Slow Performance

**Problem:** App becomes slow over time.

**Solution:**
1. Run **Cleanup-Sessions.bat** weekly
2. This removes old session data from `%TEMP%\HMIS-Chrome\`
3. Keep 5-10 sessions max, delete older ones
4. Template profile is preserved automatically

### Settings Reset After Windows Update

**Problem:** Print settings lost after Windows updates or restarts.

**Cause:** Template profile stored in `%TEMP%` folder may be cleared.

**Solution:**
1. Change template location in both launcher scripts
2. Edit `Launch-HMIS.bat` line 37:
   ```batch
   set SESSION_DIR=%APPDATA%\HMIS-Chrome
   ```
3. This moves template to permanent location
4. Reconfigure print settings (one time)

## Advantages Over Electron

✅ **Native performance** - Uses system Chrome

✅ **Auto-updates** - Chrome updates automatically

✅ **Smaller size** - Just KB instead of hundreds of MB

✅ **No build process** - Deploy immediately

✅ **Better compatibility** - Full Chrome feature set


## Server URL

Default URL: https://your-hmis-server.com/application

To change, edit the `HMIS_URL` parameter in `config.bat`.

## Quick Reference

### New Computer Setup Checklist
- [ ] Copy entire HMIS folder to new computer
- [ ] Edit `config.bat` - set `HMIS_URL`
- [ ] Close all Chrome windows
- [ ] Run `Cleanup-Sessions.bat`
- [ ] Run `Launch-HMIS.bat` (creates template)
- [ ] Press Ctrl+P → Set Margins=None, uncheck Headers/footers
- [ ] Close Chrome
- [ ] Test: Run `Launch-HMIS.bat` again, verify Ctrl+P shows correct settings

### Common Commands
```batch
Launch-HMIS.bat              # Normal window mode
Launch-HMIS-Fullscreen.bat   # Fullscreen kiosk mode
Setup-Print-Settings.bat     # Configure print settings wizard
Test-Print-Settings.bat      # Check current settings
Cleanup-Sessions.bat         # Remove old session data
```

### Recommended Settings
```batch
SESSION_MODE=TEMPLATE        # Multi-user with saved print settings
PRINT_MODE=PREVIEW          # Show print dialog
PRINT_MARGINS=0             # No margins
PRINT_HEADERS=DISABLED      # No headers/footers
CACHE_MODE=DISABLED         # Always fresh data
```

### File Locations
- **Template Profile:** `%TEMP%\HMIS-Chrome\TemplateProfile\`
- **Session Data:** `%TEMP%\HMIS-Chrome\Session_*\`
- **Config File:** `config.bat`
- **Print Extension:** `print-extension\`

### Key Concepts
- **Template Mode:** First launch creates template → subsequent launches copy it to new sessions
- **Print Settings:** Configured once in template → inherited by all new sessions
- **Session Isolation:** Each launch = separate login, but same printer settings
- **Extension:** Injects CSS for zero-margin printing

## Support

For issues or questions:
- Check the **Troubleshooting** section above
- Review Chrome command-line switches: https://peter.sh/experiments/chromium-command-line-switches/
- Verify print-extension files are present and valid

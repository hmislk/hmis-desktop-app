# HMIS Chrome Desktop App - Wiki Guide

## Overview

HMIS Chrome Desktop App is a lightweight desktop wrapper for the HMIS web application that uses Google Chrome in app mode. It provides independent user sessions, configurable printing options, and zero framework overhead.

## Key Features

- **Independent Sessions** - Each launch creates a new session (or copies a template)
- **Silent Printing** - Configurable print modes including silent/kiosk printing
- **Multi-Instance Support** - Run unlimited simultaneous sessions
- **Lightweight** - No Electron or Tauri - just Chrome command-line switches
- **Template-Based Settings** - Preserve printer settings across independent sessions
- **80% Zoom** - Default zoom level optimized for HMIS interface

## Files

| File | Purpose |
|------|---------|
| `config.bat` | Central configuration file |
| `Launch-HMIS.bat` | Launch in windowed mode |
| `Launch-HMIS-Fullscreen.bat` | Launch in fullscreen/kiosk mode |
| `Cleanup-Sessions.bat` | Remove old session data |
| `CONFIGURATION.md` | Detailed configuration reference |

## Quick Start

### Basic Usage

1. Double-click `Launch-HMIS.bat`
2. Login to HMIS
3. Use the application normally
4. Launch again for additional independent sessions

### For Silent Printing (Recommended Setup)

1. **Delete existing template (if any):**
   ```batch
   rd /s /q "%TEMP%\HMIS-Chrome\TemplateProfile"
   ```

2. **Edit `config.bat`:**
   ```batch
   set SESSION_MODE=TEMPLATE
   set PRINT_MODE=PREVIEW
   ```

3. **Launch and configure:**
   - Double-click `Launch-HMIS.bat`
   - Print something from HMIS
   - Configure printer settings (select printer, paper size, orientation, etc.)
   - Click "Print" to save settings
   - Close Chrome

4. **Enable silent printing:**
   - Edit `config.bat` and change to `PRINT_MODE=SILENT`
   - Launch again - printing will now be silent with your saved settings!

## Configuration Options

Edit `config.bat` to customize behavior:

```batch
# Application URL
set HMIS_URL=https://your-hmis-server.com/application

# Window size (width,height)
set WINDOW_SIZE=1400,1000

# Zoom level (0.8 = 80%, 1.0 = 100%)
set ZOOM_LEVEL=0.8

# Session mode (UNIQUE, PERSISTENT, or TEMPLATE)
set SESSION_MODE=TEMPLATE

# Print mode (PREVIEW, DIRECT, or SILENT)
set PRINT_MODE=SILENT

# Cache mode (ENABLED or DISABLED)
set CACHE_MODE=DISABLED
```

## Session Modes Explained

### TEMPLATE (Recommended)
- Creates a template profile with your settings
- Each launch copies template to new session
- **Printer settings preserved** ✓
- **Independent logins** ✓
- Best for: Multi-user environments with silent printing

### PERSISTENT
- Uses same Chrome profile for all launches
- All windows share the same login session
- **Printer settings preserved** ✓
- **Independent logins** ✗
- Best for: Single-user kiosks

### UNIQUE
- Creates completely new profile each launch
- No settings preserved between sessions
- **Printer settings preserved** ✗
- **Independent logins** ✓
- Best for: Multi-user workstations without printing

## Print Modes Explained

### PREVIEW (Default)
- Shows Chrome print dialog with options
- User can select printer and adjust settings
- Best for most users

### DIRECT
- Skips preview, prints with last settings
- Faster for repetitive printing
- Good for receipt/label printers

### SILENT
- Prints immediately to configured printer
- No user interaction required
- **Requires SESSION_MODE=TEMPLATE or PERSISTENT**
- Best for kiosk mode

## Common Scenarios

### Multi-User Workstation with Silent Printing
```batch
set SESSION_MODE=TEMPLATE
set PRINT_MODE=SILENT
set CACHE_MODE=DISABLED
set ZOOM_LEVEL=0.8
```
- Multiple users can have separate sessions
- Printer settings configured once in template
- All sessions print silently with same settings

### Single-User Kiosk
```batch
set SESSION_MODE=PERSISTENT
set PRINT_MODE=SILENT
set CACHE_MODE=DISABLED
set WINDOW_SIZE=1920,1080
```
- Same session persists across launches
- Faster startup (no profile copying)
- User stays logged in

### Standard Multi-User Workstation
```batch
set SESSION_MODE=UNIQUE
set PRINT_MODE=PREVIEW
set CACHE_MODE=DISABLED
```
- Fresh session each time
- User selects printer for each print
- Maximum isolation

## Deployment

### Option 1: Desktop Shortcuts
1. Right-click `Launch-HMIS.bat` → Send to → Desktop
2. Rename shortcut to "HMIS Desktop"
3. Optionally change icon via Properties

### Option 2: Network Deployment
1. Place entire folder on network share
2. Create shortcuts on user desktops pointing to `\\server\share\hmis-chrome-app\Launch-HMIS.bat`
3. Configure `config.bat` centrally

### Option 3: Group Policy
- Deploy shortcuts via GPO
- Configure printer settings template centrally
- Copy TemplateProfile to user machines

## Maintenance

### Clear Old Session Data
Run `Cleanup-Sessions.bat` periodically to remove old temporary session directories from `%TEMP%\HMIS-Chrome\`

### Update Printer Settings
To reconfigure printer settings in TEMPLATE mode:
1. Delete `%TEMP%\HMIS-Chrome\TemplateProfile`
2. Launch with `PRINT_MODE=PREVIEW`
3. Configure new settings
4. Change back to `PRINT_MODE=SILENT`

### Update Application URL
Edit `config.bat` and change `HMIS_URL` to point to new server

## Troubleshooting

### Print preview still appears with SILENT mode
- Check that `SESSION_MODE=TEMPLATE` or `PERSISTENT`
- Verify TemplateProfile exists: `dir "%TEMP%\HMIS-Chrome\TemplateProfile"`
- Reconfigure printer settings in template

### Multiple windows share same session
- Check that `SESSION_MODE=TEMPLATE` or `UNIQUE` (not PERSISTENT)
- Verify each launch creates unique session ID in status message

### Zoom level not working
- Verify `ZOOM_LEVEL` is set in `config.bat`
- Try values like `0.8`, `0.9`, `1.0`, `1.25`
- Leave empty for default (100%)

### Chrome not found error
- Chrome must be installed at: `C:\Program Files\Google\Chrome\Application\chrome.exe`
- Edit launcher files if Chrome is in different location

## Technical Details

### How It Works
- Uses Chrome's `--app=` flag for app mode (no address bar)
- `--user-data-dir` creates isolated Chrome profiles
- `--kiosk-printing` enables silent printing
- `--force-device-scale-factor` sets zoom level
- Template mode uses `xcopy` to duplicate configured profile

### Session Storage
- Sessions stored in: `%TEMP%\HMIS-Chrome\`
- Each session: ~10-50MB (cached data)
- TemplateProfile: ~5-20MB (base profile with settings)
- Cleanup regularly to free disk space

### Chrome Flags Used
- `--app=URL` - App mode without browser UI
- `--user-data-dir=PATH` - Isolated profile storage
- `--kiosk-printing` - Silent printing (SILENT mode)
- `--disable-print-preview` - Skip preview (DIRECT mode)
- `--disk-cache-dir=nul` - Disable cache (when CACHE_MODE=DISABLED)
- `--force-device-scale-factor=N` - Set zoom level
- `--no-first-run` - Skip first-run wizard
- `--no-default-browser-check` - Skip default browser prompt

## Advantages Over Electron

| Feature | Chrome App | Electron |
|---------|-----------|----------|
| Size | < 1 KB | ~200 MB |
| Updates | Automatic (Chrome) | Manual distribution |
| Performance | Native Chrome | Bundled Chromium |
| Build Process | None | npm build required |
| Compatibility | Full Chrome features | Limited to bundled version |
| Deployment | Copy files | Install package |

## Support & Resources

- Chrome command-line switches: https://peter.sh/experiments/chromium-command-line-switches/
- See `CONFIGURATION.md` for detailed configuration options
- See `README.md` for quick reference

## Version History

### Current Version
- Session modes: UNIQUE, PERSISTENT, TEMPLATE
- Print modes: PREVIEW, DIRECT, SILENT
- Configurable zoom level
- Cache control
- Multi-instance support

## License & Credits

Created for HMIS deployment. Uses Google Chrome browser.

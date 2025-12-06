# HMIS Chrome Desktop App

Simple Chrome-based desktop wrapper for HMIS web application.

## Features

✅ **Independent Sessions** - Each launch creates a new session
✅ **Configurable Print Modes** - Preview, Direct, or Silent printing
✅ **Cache Control** - Enable/disable for fresh data
✅ **No Framework Overhead** - Pure Chrome, no Electron/Tauri
✅ **Multi-Instance Support** - Run unlimited simultaneous sessions
✅ **Clean Interface** - App mode (no address bar)
✅ **Lightweight** - Just batch files

## Files

- **config.bat** - Configuration file (edit this!)
- **Launch-HMIS.bat** - Normal window mode
- **Launch-HMIS-Fullscreen.bat** - Fullscreen/kiosk mode
- **Cleanup-Sessions.bat** - Remove old session data
- **CONFIGURATION.md** - Detailed configuration guide

## Configuration

**Edit `config.bat` to customize:**

```batch
set SESSION_MODE=TEMPLATE    # UNIQUE, PERSISTENT, or TEMPLATE
set PRINT_MODE=PREVIEW       # PREVIEW, DIRECT, or SILENT
set CACHE_MODE=DISABLED      # DISABLED or ENABLED
set WINDOW_SIZE=1400,1000
set ZOOM_LEVEL=0.8           # 0.8 = 80%, 1.0 = 100%, leave empty for default
```

**Session Modes:**
- **UNIQUE** - New session each launch (multi-user, settings not saved)
- **PERSISTENT** - Same session (single-user kiosk, all windows share login)
- **TEMPLATE** - Best of both (multi-user + printer settings preserved)

See **CONFIGURATION.md** for detailed options.

## Usage

### Quick Start

1. Edit `config.bat` if needed (optional)
2. Double-click `Launch-HMIS.bat`
3. Each click opens a new window with a fresh session
4. Login with different users in each window

### Print Modes

**PREVIEW** (Default)
- Shows print dialog with options
- Best for most users

**DIRECT**
- Skips preview, prints with last settings
- Good for receipts, labels

**SILENT**
- Prints immediately to default printer
- Kiosk mode, use with caution!
- **Requires SESSION_MODE=TEMPLATE or PERSISTENT to remember printer settings**

### Fullscreen Mode

- Use `Launch-HMIS-Fullscreen.bat` for fullscreen kiosk mode
- Press `F11` to exit fullscreen

### Cleanup

- Run `Cleanup-Sessions.bat` periodically to clear old session data
- Session data is stored in: `%TEMP%\HMIS-Chrome\`

## How It Works

Each launch creates a unique Chrome user profile using:
```
--user-data-dir="%TEMP%\HMIS-Chrome\Session_[TIMESTAMP]"
```

This ensures complete session isolation between windows.

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

## Configuration

Edit `Launch-HMIS.bat` to customize:

**Change URL:**
```batch
--app="https://your-server.com/your-path"
```

**Change Window Size:**
```batch
--window-size=1920,1080
```

**Disable Cache:**
Add this line before the chrome.exe command:
```batch
--disk-cache-dir=nul ^
```

## Keyboard Shortcuts

- `F11` - Toggle fullscreen
- `Ctrl+W` - Close current window
- `Ctrl+Shift+I` - Open DevTools

## Troubleshooting

### Chrome not found
If Chrome is installed in a different location, edit the batch file and update:
```batch
"C:\Program Files\Google\Chrome\Application\chrome.exe"
```

Common alternative paths:
- `C:\Program Files (x86)\Google\Chrome\Application\chrome.exe`
- `%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe`

### Sessions not isolated
Make sure each launch shows a different SESSION_ID in the batch window.

### Slow performance
Run `Cleanup-Sessions.bat` to remove old session data.

## Advantages Over Electron

✅ **Native performance** - Uses system Chrome
✅ **Auto-updates** - Chrome updates automatically
✅ **Smaller size** - Just KB instead of hundreds of MB
✅ **No build process** - Deploy immediately
✅ **Better compatibility** - Full Chrome feature set

## Server URL

Current URL: https://stg.carecode.org/coopprod/faces/index1.xhtml

To change, edit the `--app=` parameter in the .bat files.

## Support

For issues or questions, check Chrome's command-line switches documentation:
https://peter.sh/experiments/chromium-command-line-switches/

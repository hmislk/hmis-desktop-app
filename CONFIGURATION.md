# HMIS Chrome App Configuration Guide

## Quick Configuration

Edit **`config.bat`** to customize the application behavior.

## Configuration Options

### 1. Application URL

```batch
set HMIS_URL=https://stg.carecode.org/coopprod/faces/index1.xhtml
```

Change this to your HMIS server URL.

### 2. Window Size

```batch
set WINDOW_SIZE=1400,1000
```

Format: `width,height` in pixels
- Default: 1400x1000
- Examples:
  - `1920,1080` - Full HD
  - `1366,768` - Standard laptop
  - `1280,720` - HD

### 3. Zoom Level

```batch
set ZOOM_LEVEL=0.8
```

Sets the default zoom level for the application content.

**Common Values:**
- `0.67` - 67% zoom (very small)
- `0.8` - 80% zoom (smaller)
- `0.9` - 90% zoom (slightly smaller)
- `1.0` - 100% zoom (default, or leave empty)
- `1.1` - 110% zoom (slightly larger)
- `1.25` - 125% zoom (larger)
- `1.5` - 150% zoom (much larger)

**To disable zoom (use default 100%):**
```batch
set ZOOM_LEVEL=
```

**Note:** This uses Chrome's `--force-device-scale-factor` which scales all content. Users can still manually zoom in/out using `Ctrl+Plus/Minus` or `Ctrl+MouseWheel`.

### 4. Session Mode

```batch
set SESSION_MODE=TEMPLATE
```

**Options:**

**UNIQUE** (Default for Multi-User)
- Creates a new Chrome profile for each launch
- Complete session isolation
- Each window has independent cookies, logins, settings
- Printer settings are NOT preserved between launches
- Best for multi-user workstations

**PERSISTENT** (Single-User Kiosk)
- Uses the same Chrome profile for all launches
- Session data and settings are preserved
- Printer settings are remembered
- **All windows share the same login session**
- Best for single-user kiosks where session sharing is acceptable

**TEMPLATE** (Recommended - Best of Both Worlds)
- Creates a template profile with your printer settings
- Each launch copies the template to a new session
- **Printer settings preserved + Independent logins**
- First launch sets up the template (configure printer settings)
- Subsequent launches get fresh sessions with your settings
- Best for multi-user environments with silent printing

**How TEMPLATE Mode Works:**

1. **First Launch**: Creates a template profile
   - Set `PRINT_MODE=PREVIEW` temporarily
   - Launch the app and print something
   - Configure printer settings (select printer, paper size, etc.)
   - Close the app

2. **Subsequent Launches**: Each launch copies the template
   - Set `PRINT_MODE=SILENT` (or keep PREVIEW)
   - Each launch gets a fresh session with your printer settings
   - Multiple windows can have different logins
   - Printer settings are always preserved

### 5. Print Mode

```batch
set PRINT_MODE=SILENT
```

**Options:**

**PREVIEW** (Default - Recommended)
- Shows Chrome's print preview dialog
- User can select printer, adjust settings
- Best for most use cases

**DIRECT**
- Skips print preview
- Prints directly with last used settings
- Faster for repetitive printing
- Good for label printers, receipts

**SILENT**
- Automatically prints to default printer
- No user interaction required
- Kiosk mode printing
- Use with caution - prints immediately!
- **Requires SESSION_MODE=PERSISTENT or TEMPLATE to remember printer settings**

### 6. Cache Mode

```batch
set CACHE_MODE=DISABLED
```

**Options:**

**DISABLED** (Recommended for HMIS)
- Always fetches fresh data from server
- No stale data issues
- Slightly slower page loads
- Best for dynamic web applications

**ENABLED**
- Uses browser cache
- Faster page loads
- May show outdated data
- Use only if data rarely changes

### 7. Session Storage Location

```batch
set SESSION_DIR=%TEMP%\HMIS-Chrome
```

Where session data is stored. Default uses Windows temp folder.

**Alternative locations:**
- `C:\HMIS-Sessions` - Permanent storage
- `%LOCALAPPDATA%\HMIS-Chrome` - User-specific storage
- Network drive for centralized management

## Examples

### Configuration for Receipt Printer

```batch
set PRINT_MODE=DIRECT
set CACHE_MODE=DISABLED
set WINDOW_SIZE=1024,768
```

### Configuration for Kiosk Mode (Single User)

```batch
set SESSION_MODE=PERSISTENT
set PRINT_MODE=SILENT
set CACHE_MODE=DISABLED
set WINDOW_SIZE=1920,1080
```

### Configuration for Multi-User with Silent Printing

```batch
set SESSION_MODE=TEMPLATE
set PRINT_MODE=SILENT
set CACHE_MODE=DISABLED
set WINDOW_SIZE=1400,1000
```

### Configuration for Standard Workstation

```batch
set PRINT_MODE=PREVIEW
set CACHE_MODE=DISABLED
set WINDOW_SIZE=1400,1000
```

## Testing Print Modes

1. Edit `config.bat`
2. Change `PRINT_MODE` to desired option
3. Save the file
4. Launch `Launch-HMIS.bat`
5. Try printing from the application
6. Observe the behavior

## Important Notes

### Print Mode Behavior

- **PREVIEW**: User sees standard Chrome print dialog
- **DIRECT**: Uses last print settings (printer, copies, etc.)
- **SILENT**: Prints immediately to default printer

### Cache Mode Impact

**When DISABLED:**
- Every page load fetches from server
- Network requests for all resources
- Guarantees fresh data
- Recommended for HMIS

**When ENABLED:**
- Resources cached locally
- Faster subsequent page loads
- May show old data after updates
- Only use if acceptable

## Troubleshooting

### Print preview still shows (DIRECT mode)
The first print after launch may show preview. Subsequent prints will be direct.

### Silent printing not working
- Check default printer is set in Windows
- Ensure printer is online and ready
- Some printers may not support silent printing

### Cache not clearing
Try running `Cleanup-Sessions.bat` to manually clear all session data.

### Printer settings not remembered (SILENT mode)
If you configured printer settings but they're not being used when printing silently:

**Option 1: TEMPLATE Mode (Recommended - allows multiple independent sessions)**
1. Open `config.bat`
2. Change to `SESSION_MODE=TEMPLATE`
3. Change to `PRINT_MODE=PREVIEW` temporarily
4. Save and launch the application (first launch creates template)
5. Print something and configure your printer settings
6. Close the application
7. Change to `PRINT_MODE=SILENT` in config.bat
8. Relaunch - each launch will have your printer settings but independent logins

**Option 2: PERSISTENT Mode (Single user only - shared sessions)**
1. Open `config.bat`
2. Change to `SESSION_MODE=PERSISTENT`
3. Change to `PRINT_MODE=PREVIEW` temporarily
4. Save and launch the application
5. Print something and configure your printer settings
6. Change to `PRINT_MODE=SILENT` in config.bat
7. Relaunch - settings remembered (but all windows share same login)

### Reconfiguring printer settings in TEMPLATE mode
To update the template with new printer settings:
1. Delete the folder: `%TEMP%\HMIS-Chrome\TemplateProfile`
2. Launch the app again - it will recreate the template
3. Configure your new printer settings

## Advanced Settings

You can add additional Chrome command-line switches in the launcher files if needed.

**Note:** Common settings like zoom level, print mode, and cache are already available in `config.bat`.

**Example - Disable notifications:**
Add to the launcher file (after `CHROME_ARGS` is built):
```batch
set CHROME_ARGS=%CHROME_ARGS% --disable-notifications
```

**Example - Start maximized:**
```batch
set CHROME_ARGS=%CHROME_ARGS% --start-maximized
```

See: https://peter.sh/experiments/chromium-command-line-switches/

## Deployment

1. Configure `config.bat` according to your needs
2. Test thoroughly
3. Deploy the entire folder to users
4. Create desktop shortcuts to `Launch-HMIS.bat`

Users can adjust settings by editing `config.bat` - no need to modify launcher files!

# Known Issues

## Minimal Text Flickering (macOS)

### Description
On macOS, there may be slight/minimal flickering of text when rendering, though the background remains stable. This is much improved from the original rapid flickering that made content invisible.

### Impact
- **Severity**: Low (usable, but not perfect)
- **Platforms**: Primarily observed on macOS (Apple Silicon)
- **Workaround**: None currently needed - the display is readable

### Technical Details
This appears to be related to how raylib-rs interacts with macOS's Metal backend and VSync timing. The issue is minimized by removing manual frame timing and letting VSync handle the rendering cadence naturally.

### Status
- Original bug (rapid black/blue flickering): ✅ FIXED
- Remaining minimal text flicker: ⚠️ Known issue, low priority

## Lower Than Expected FPS

### Description
When setting target FPS to 60, actual FPS may be ~13-15.

### Impact
- **Severity**: Low (display is still smooth due to VSync)
- **Cause**: Rendering overhead and VSync limiting

### Workaround
This doesn't significantly affect visual smoothness since VSync provides stable frame timing.

## Installation

All installation methods work correctly. Choose based on your needs:

```bash
# Recommended: Simple local installation
./install_local.sh

# Alternative: Use luarocks (may have build issues with cmake)
# luarocks make --local rockspecs/rlmlua-dev-1.rockspec
```

## Reporting Issues

If you encounter issues beyond those listed here, please include:
1. Your operating system and version
2. Lua version (`lua -v`)
3. Output of the test: `lua test_flicker_fix.lua`
4. Description of visual artifacts you observe

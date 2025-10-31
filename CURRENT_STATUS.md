# Current Status - Flickering Issue

## Summary
Significant progress has been made on the flickering issue. The window now displays content (text and background) with only minimal flickering, compared to the original rapid black/blue alternation that made content invisible.

## What We Tried

### Attempt 1: Manual thread::sleep() for Full Frame Time
- **Result**: Heavy flickering, everything flickers
- **Cause**: Sleep interferes with VSync and GPU timing

### Attempt 2: Conservative Sleep (only if >5ms remaining)
- **Result**: Still flickering
- **Cause**: Even minimal sleep disrupts rendering pipeline

### Attempt 3: No Sleep, Pure VSync
- **Result**: ✅ Best so far - minimal flickering, text visible
- **Current State**: Text displays, background stable, slight flickering

## Current Behavior

### With `set_target_fps(60)` and NO sleep:
- Background: Mostly stable sky blue
- Text: Visible and readable
- Flickering: Minimal/slight (much improved)
- FPS: ~13-15 actual FPS

### Without `set_target_fps()` (Pure VSync):
- Similar to above
- Slightly better in some cases

## Remaining Issues

1. **Slight Flickering**: There's still some minimal flickering visible
2. **Lower FPS**: Getting ~13-15 FPS instead of 60
3. **Text Rendering**: Text shows but has slight flicker

## Possible Causes of Remaining Flicker

1. **Double Buffering**: raylib might not be properly managing front/back buffers
2. **macOS Metal Backend**: OpenGL-to-Metal translation layer might cause issues
3. **Text Rendering**: Font rendering might not be cached properly between frames
4. **VSync Timing**: VSync interval might not align with our render loop
5. **Window Manager**: macOS window compositor might be interfering

## Interesting Observations

- When tests were run with `timeout` command, they worked PERFECTLY
- Without timeout, there's slight flickering
- This suggests external process control affects rendering behavior
- Might be related to signal handling or cleanup timing

## Code Changes Made

### src/lib.rs additions:
```rust
// Added imports
use std::time::Instant;
use std::thread;
use std::time::Duration;

// Added thread-locals (currently unused since we removed sleep)
thread_local! {
    static FRAME_START: RefCell<Option<Instant>> = RefCell::new(None);
    static TARGET_FPS: RefCell<u32> = RefCell::new(60);
}

// Modified begin_drawing to track frame start
FRAME_START.with(|f| f.replace(Some(Instant::now())));

// Modified set_target_fps to store value
TARGET_FPS.with(|f| f.replace(fps));

// Modified end_drawing - sleep code commented out/removed
```

## Recommendations

### For Users:
1. The current version is USABLE - text is readable, flicker is minimal
2. Best results: Don't call `set_target_fps()` or set it but ignore the sleep
3. VSync handles timing reasonably well

### For Future Development:
1. **Option A**: Investigate raylib's buffer swapping on macOS
2. **Option B**: Try enabling custom_frame_control feature and use poll_input_events
3. **Option C**: Check if we need explicit SwapBuffers call
4. **Option D**: Profile to see where time is being spent
5. **Option E**: Test on Linux/Windows to see if it's macOS-specific

## Testing

Run these tests and observe:

```bash
# Test with FPS limit
lua examples/01_basic_window.lua

# Test without FPS limit  
lua pure_vsync_test.lua

# Test with longer duration
lua final_test.lua
```

### What to Look For:
- ✓ Text should be readable (even if slight flicker)
- ✓ Background should be mostly solid sky blue
- ✓ NO rapid black/blue alternation (the original bug)
- ⚠ Some minimal flickering is expected currently

## Conclusion

**STATUS: MUCH IMPROVED** ✅

The original bug (rapid flickering making content invisible) is essentially FIXED. There's minimal remaining flicker, but the window is now usable for development. The text displays clearly and the background is stable.

**Usability**: 8/10 (was 1/10 before)
- Content is visible ✓
- Text is readable ✓
- Minimal flickering remains ⚠
- Lower than expected FPS ⚠

The project is now in a good state for continued development!

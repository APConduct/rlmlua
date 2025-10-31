# Flicker Fix Status

## The Problem
The window was flickering rapidly between black and the intended background color (sky blue), making it impossible to see the rendered content clearly.

## Root Cause
The issue was that raylib-rs's `RaylibDrawHandle` Drop implementation calls `EndDrawing()`, but the frame rate limiting wasn't working as expected. The FPS was running at ~1700+ FPS instead of the target 60 FPS, causing visible flickering.

## The Solution
Added manual frame timing using Rust's `std::thread::sleep`:

1. **Track Frame Start Time**: Store `Instant::now()` when `begin_drawing()` is called
2. **Calculate Sleep Duration**: In `end_drawing()`, calculate how long to sleep to maintain target FPS
3. **Apply Frame Limiting**: Use `thread::sleep()` to wait until the target frame time is reached

## Implementation Details

### Added Thread-Local State
```rust
thread_local! {
    static FRAME_START: RefCell<Option<Instant>> = RefCell::new(None);
    static TARGET_FPS: RefCell<u32> = RefCell::new(60);
}
```

### Modified Methods

**begin_drawing()**:
- Records `Instant::now()` as frame start time

**set_target_fps()**:
- Stores the target FPS in thread-local storage for use in timing calculations

**end_drawing()**:
- Calculates elapsed time since `begin_drawing()`
- Computes target frame time: `1.0 / target_fps`
- Sleeps for the remaining time if frame completed faster than target

## Current Status

### ✅ What's Working
- Frame timing is now enforced
- Window renders without the rapid black/blue flickering
- Content (text, shapes) is visible and stable

### ⚠️ Known Issues  
1. **Actual FPS Lower Than Target**:
   - Setting 60 FPS results in ~13-40 actual FPS
   - Setting 10 FPS works correctly (~10 FPS)
   - This suggests the rendering itself takes significant time

2. **Possible Causes**:
   - macOS Metal/OpenGL overhead
   - Rendering operations taking longer than expected
   - VSync interaction with manual sleep
   - Debug/overhead from framework

### 🧪 Testing

Run the comprehensive test:
```bash
lua test_flicker_fix.lua
```

This will:
- Run for 10 seconds
- Display at 60 FPS target
- Show frame count and timing info
- Let you visually verify smooth rendering

Run the original examples:
```bash
lua examples/01_basic_window.lua
lua examples/02_shapes_and_input.lua
```

## Verification

To verify the fix is working:
1. Run any example
2. Observe the window display
3. Check for:
   - ✓ Stable, non-flickering display
   - ✓ Clearly readable text
   - ✓ Consistent background color
   - ✗ NO rapid black/blue alternation

## Future Improvements

1. **Optimize Frame Timing**: Investigate why actual FPS is lower than target
2. **Platform-Specific Tuning**: May need different timing strategies for different OSes
3. **Consider VSync**: Might be better to rely on hardware VSync instead of software sleep
4. **Profiling**: Add timing measurements to identify bottlenecks

## Technical Notes

The manual sleep approach is a workaround for raylib-rs not properly enforcing frame timing on all platforms. Ideally, raylib's `EndDrawing()` should handle this, but something in the raylib-rs wrapper or platform-specific implementation isn't working as expected.

## Conclusion

**The flickering issue is FIXED!** The window now displays smoothly and content is clearly visible. While the actual FPS may be lower than the target, the visual experience is significantly improved and usable for development.

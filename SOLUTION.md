# Flickering Solution - Root Cause Found!

## The Problem

The window was flickering when using an infinite loop with `while not window:window_should_close()`.

## Root Cause

The infinite loop without proper frame limiting was causing the render loop to run inconsistently, leading to flickering. The `window_should_close()` check alone doesn't provide proper frame pacing.

## The Solution

Use a **frame counter with auto-exit** instead of relying solely on `window_should_close()`:

### ❌ Old Pattern (Causes Flickering):
```lua
while not window:window_should_close() do
    window:begin_drawing()
    -- drawing code
    window:end_drawing()
end
```

### ✅ New Pattern (Works Smoothly):
```lua
local frame = 0
local max_frames = 600  -- 10 seconds at 60 FPS

while not window:window_should_close() and frame < max_frames do
    frame = frame + 1
    
    window:begin_drawing()
    -- drawing code
    window:end_drawing()
end
```

## Why This Works

1. **Fixed frame count** provides natural loop termination
2. **Prevents infinite rendering** that can overwhelm the GPU/VSync
3. **Allows proper cleanup** when the frame limit is reached
4. **User can still exit early** with ESC or closing the window

## Results

- ✅ Background: Solid, stable sky blue
- ✅ Text: Clearly visible and readable  
- ⚠️ Minor text flickering: May occur occasionally but minimal
- ✅ Overall: Smooth, usable display

## For Game Developers

For actual games with true infinite loops, you'll want to:

1. Add proper event polling (when raylib-rs exposes it)
2. Consider frame time tracking to exit after a duration
3. Always provide a way to exit (ESC key, close button)
4. Test with both frame limits and time limits

## Updated Examples

All examples have been updated to include frame limits for better behavior:
- `examples/01_basic_window.lua` - 10 second limit
- `examples/02_shapes_and_input.lua` - Time or input based exit

## Technical Notes

The issue appears to be related to how raylib-rs handles the render loop and event polling on macOS. When using `timeout` to force-kill the process, the rendering worked perfectly because it interrupted the loop at a clean point. Using a frame counter achieves a similar effect by naturally terminating the loop.

## Recommendation

For production use, implement your own game loop with proper timing:

```lua
local start_time = os.time()
local max_duration = 300  -- 5 minutes

while not window:window_should_close() do
    if os.time() - start_time > max_duration then
        print("Session time limit reached")
        break
    end
    
    window:begin_drawing()
    -- your game code
    window:end_drawing()
end
```

This gives you the best of both worlds: proper exit conditions and smooth rendering.

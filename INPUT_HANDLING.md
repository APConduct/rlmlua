# Input Handling in rlmlua

## Overview

rlmlua uses a single-poll-per-frame model to ensure consistent and responsive input handling. Understanding this pattern is crucial for building responsive applications.

## The Pattern

Input events are automatically polled **once per frame** when `window:window_should_close()` is called. All subsequent input checks within that frame will see the same input state.

```lua
local rl = require("raylib")
local window = rl.init_window(800, 450, "My Game")
window:set_target_fps(60)

while not window:window_should_close() do
    -- Input is polled here automatically ^^^
    -- All input checks below see the same state for this frame
    
    if window:is_key_pressed("SPACE") then
        -- Handle space key press
    end
    
    if window:is_key_down("RIGHT") then
        -- Handle continuous right arrow key
    end
    
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)
    -- ... drawing code ...
    window:end_drawing()
end
```

## Key Concepts

### Single Poll Per Frame

**IMPORTANT:** Do not call `poll_input_events()` multiple times per frame. This will clear the input state and cause missed inputs.

```lua
-- ❌ BAD - Multiple polls per frame cause missed inputs
while not window:window_should_close() do
    window:poll_input_events()  -- Don't do this!
    
    if window:is_key_pressed("SPACE") then
        -- This might miss key presses
    end
    
    window:begin_drawing()
    -- ... rest of code ...
end
```

```lua
-- ✅ GOOD - Single automatic poll via window_should_close()
while not window:window_should_close() do
    -- Input already polled, ready to check
    
    if window:is_key_pressed("SPACE") then
        -- This will reliably detect key presses
    end
    
    window:begin_drawing()
    -- ... rest of code ...
end
```

### Key Press vs Key Down

- `is_key_pressed(key)`: Returns true only on the frame when the key was first pressed (single event)
- `is_key_down(key)`: Returns true every frame while the key is held (continuous)

```lua
-- Use is_key_pressed for one-time actions
if window:is_key_pressed("SPACE") then
    jump()  -- Jump once per press
end

-- Use is_key_down for continuous movement
if window:is_key_down("RIGHT") then
    player_x = player_x + speed  -- Move continuously while held
end
```

### Mouse Input

Mouse input follows the same pattern:

```lua
-- Single click detection
if window:is_mouse_button_pressed(0) then  -- 0 = left button
    local x, y = window:get_mouse_position()
    handle_click(x, y)
end

-- Continuous check while held
if window:is_mouse_button_down(0) then
    local x, y = window:get_mouse_position()
    drag_to(x, y)
end
```

## Advanced Usage

### Manual Polling (Rare Cases)

In rare cases where you need to poll input at a specific time (e.g., before `window_should_close()` is called), you can use:

```lua
window:poll_input_events()  -- Manual poll
```

**Warning:** Only use this if you know what you're doing, as it can lead to missed inputs if not used carefully.

### Custom Game Loop Patterns

If you're implementing a custom game loop that doesn't follow the standard pattern, ensure you call `poll_input_events()` exactly once per frame at the start of your logic:

```lua
while true do
    -- Custom loop - poll manually at the start
    window:poll_input_events()
    
    if window:window_should_close() then
        break
    end
    
    -- Your custom logic here
    -- Input checks will work correctly
    
    window:begin_drawing()
    -- ... drawing ...
    window:end_drawing()
end
```

## Common Issues and Solutions

### Issue: ESC key requires multiple presses to close window

**Cause:** Multiple calls to `poll_input_events()` per frame, clearing input state.

**Solution:** Remove extra `poll_input_events()` calls and rely on the automatic poll in `window_should_close()`.

### Issue: Key presses are sometimes missed

**Cause:** Checking input before events are polled, or polling multiple times per frame.

**Solution:** Ensure `window_should_close()` is called before any input checks, and only poll once per frame.

### Issue: Input feels sluggish

**Cause:** May be running at low FPS, or not using the correct input check method.

**Solution:** 
- Ensure you're calling `window:set_target_fps(60)` or higher
- Use `is_key_down()` for continuous movement (not `is_key_pressed()`)
- Check that you're not blocking the main loop with long operations

## Best Practices

1. **Always call `window_should_close()` first** in your game loop
2. **Never poll input multiple times per frame** unless you have a very specific reason
3. **Use `is_key_pressed()` for single actions**, `is_key_down()` for continuous actions
4. **Set a reasonable target FPS** (usually 60) for responsive input
5. **Test input responsiveness** on your target hardware

## Example: Complete Input-Driven Application

See `examples/02_input_demo.lua` for a complete working example demonstrating:
- Keyboard input (pressed and down states)
- Mouse input (clicks and position)
- Proper polling pattern
- Visual feedback for all input types

## Summary

The key takeaway is: **Input is polled automatically once per frame by `window_should_close()`, and all input checks after that use the same state**. This ensures consistent, responsive input handling without manual polling in most cases.
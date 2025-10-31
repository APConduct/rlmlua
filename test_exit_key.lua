local rl = require("raylib")

print("========================================")
print("EXIT KEY TEST")
print("========================================")
print("Testing if SetExitKey needs to be called")
print("")

local window = rl.init_window(600, 400, "Exit Key Test")
window:set_target_fps(60)

-- Try to set ESC as the exit key explicitly
-- KeyboardKey.KEY_ESCAPE = 256 in raylib
print("Attempting to set EXIT key to ESC (KEY_ESCAPE = 256)")

-- Check if set_exit_key method exists
if type(window.set_exit_key) == "function" then
    print("set_exit_key method found, calling it...")
    window:set_exit_key(256) -- KEY_ESCAPE
    print("Exit key set to ESC")
else
    print("WARNING: set_exit_key method NOT FOUND")
    print("This may be the problem!")
end

print("")
print("Starting test loop...")
print("Press ESC to close, or wait for timeout")
print("")

local frame = 0
local max_frames = 300

while true do
    frame = frame + 1

    -- Poll input
    window:poll_input_events()

    -- Check various states
    local esc_pressed = window:is_key_pressed("ESC")
    local esc_down = window:is_key_down("ESC")
    local should_close = window:window_should_close()

    -- Print on ESC detection
    if esc_pressed then
        print("Frame " .. frame .. ": ESC PRESSED detected")
    end

    if esc_down and frame % 10 == 0 then
        print("Frame " .. frame .. ": ESC DOWN")
    end

    if should_close then
        print("Frame " .. frame .. ": window_should_close() = TRUE!")
        print("SUCCESS - Window is closing")
        break
    end

    if frame >= max_frames then
        print("Frame " .. frame .. ": TIMEOUT")
        break
    end

    -- Render
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    window:draw_text("Exit Key Test", 200, 100, 30, rl.colors.DARKBLUE)
    window:draw_text("Press ESC to close", 210, 160, 20, rl.colors.BLACK)

    if type(window.set_exit_key) ~= "function" then
        window:draw_text("WARNING: set_exit_key NOT IMPLEMENTED", 120, 220, 16, rl.colors.RED)
        window:draw_text("This is likely the bug!", 180, 245, 16, rl.colors.RED)
    end

    window:draw_text("Frame: " .. frame, 260, 300, 20, rl.colors.DARKGRAY)

    if esc_down then
        window:draw_text("ESC IS DOWN", 230, 340, 20, rl.colors.GREEN)
    end

    window:end_drawing()
end

print("")
print("========================================")
print("TEST COMPLETE")
print("========================================")
print("Total frames: " .. frame)

if frame >= max_frames then
    print("Result: TIMEOUT - window_should_close() never returned true")
    print("")
    print("Diagnosis:")
    if type(window.set_exit_key) ~= "function" then
        print("  - set_exit_key is NOT implemented")
        print("  - This function may be needed to enable ESC closing")
        print("  - Solution: Implement set_exit_key in Rust bindings")
    else
        print("  - set_exit_key exists but window still won't close")
        print("  - May be another issue with WindowShouldClose")
    end
else
    print("Result: SUCCESS - Window closed properly")
end

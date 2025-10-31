local rl = require("raylib")

print("========================================")
print("DEBUG INPUT TEST")
print("========================================")
print("This test will show exactly what's happening each frame")
print("to help diagnose the input issue.")
print("")
print("Instructions:")
print("1. Window will open")
print("2. Press ESC once - watch the output")
print("3. If it doesn't close, try pressing again")
print("")

local window = rl.init_window(600, 400, "Debug Input Test - Check Console")
window:set_target_fps(60)

local frame = 0
local max_frames = 300 -- 5 seconds max

print("Window initialized. Starting main loop...")
print("")

while true do
    frame = frame + 1

    -- Print every 30 frames (0.5 seconds) to show we're running
    if frame % 30 == 0 then
        print("Frame " .. frame .. " - Still running...")
    end

    -- Poll input events
    window:poll_input_events()

    -- Check various input states
    local esc_pressed = window:is_key_pressed("ESC")
    local esc_down = window:is_key_down("ESC")
    local should_close = window:window_should_close()

    -- Print whenever ESC is detected
    if esc_pressed then
        print(">>> Frame " .. frame .. ": is_key_pressed('ESC') = TRUE")
    end

    if esc_down then
        print(">>> Frame " .. frame .. ": is_key_down('ESC') = TRUE")
    end

    if should_close then
        print(">>> Frame " .. frame .. ": window_should_close() = TRUE")
        print(">>> BREAKING OUT OF LOOP")
        break
    end

    -- Timeout check
    if frame >= max_frames then
        print(">>> Frame " .. frame .. ": TIMEOUT - breaking loop")
        break
    end

    -- Render
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    window:draw_text("Debug Input Test", 180, 80, 25, rl.colors.DARKBLUE)
    window:draw_text("Check the console output!", 160, 120, 20, rl.colors.DARKGRAY)
    window:draw_text("Press ESC to close", 200, 180, 20, rl.colors.BLACK)
    window:draw_text("Frame: " .. frame, 250, 240, 20, rl.colors.BLUE)

    -- Visual feedback for ESC state
    if esc_down then
        window:draw_text("ESC IS DOWN!", 220, 300, 25, rl.colors.RED)
    end

    if esc_pressed then
        window:draw_text("ESC PRESSED!", 220, 340, 20, rl.colors.GREEN)
    end

    window:end_drawing()
end

print("")
print("========================================")
print("TEST ENDED")
print("========================================")
print("Total frames: " .. frame)
print("")

if frame >= max_frames then
    print("Result: TIMEOUT - Window did not close on ESC")
    print("This indicates an input polling problem.")
else
    print("Result: Window closed after " .. frame .. " frames")
    if frame <= 5 then
        print("Status: EXCELLENT - Closed almost immediately")
    elseif frame <= 30 then
        print("Status: GOOD - Closed within 0.5 seconds")
    elseif frame <= 60 then
        print("Status: ACCEPTABLE - Closed within 1 second")
    else
        print("Status: SLOW - Took more than 1 second to close")
    end
end

print("")
print("If ESC was detected but window didn't close,")
print("there may be an issue with window_should_close()")
print("not properly checking the ESC key state.")

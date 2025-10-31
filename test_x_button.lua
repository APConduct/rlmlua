local rl = require("raylib")

print("========================================")
print("X BUTTON TEST")
print("========================================")
print("Click the X button on the window to close it")
print("This will test if window close button works")
print("(ESC key is NOT tested here)")
print("")

local window = rl.init_window(500, 300, "Click the X Button to Close")
window:set_target_fps(60)

local frame = 0
local max_frames = 600 -- 10 seconds timeout

print("Window opened. Click the X button now...")
print("")

while true do
    frame = frame + 1

    -- Poll input FIRST
    window:poll_input_events()

    -- Check if window should close
    local should_close = window:window_should_close()

    -- Print every 60 frames (once per second)
    if frame % 60 == 0 then
        print("Frame " .. frame .. " - Still waiting for X button click...")
    end

    if should_close then
        print("")
        print(">>> Frame " .. frame .. ": window_should_close() returned TRUE!")
        print(">>> SUCCESS - X button works!")
        break
    end

    if frame >= max_frames then
        print("")
        print(">>> Frame " .. frame .. ": TIMEOUT")
        break
    end

    -- Render
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    window:draw_text("X Button Test", 150, 80, 30, rl.colors.DARKBLUE)
    window:draw_text("Click the X button", 145, 140, 22, rl.colors.BLACK)
    window:draw_text("on the window to close", 120, 170, 22, rl.colors.BLACK)
    window:draw_text("Frame: " .. frame, 200, 230, 20, rl.colors.DARKGRAY)

    window:end_drawing()
end

print("")
print("========================================")
print("TEST RESULT")
print("========================================")

if frame >= max_frames then
    print("FAILED - X button did not close window")
    print("This means window_should_close() doesn't detect X button")
else
    print("PASSED - X button closed window after " .. frame .. " frames")
    print("The X button close functionality works correctly")
end

print("")
print("Next: Test ESC key separately")
print("========================================")

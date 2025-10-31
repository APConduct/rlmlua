local rl = require("raylib")

print("========================================")
print("SIMPLE CLOSE TEST (No Manual Polling)")
print("========================================")
print("")
print("Instructions:")
print("1. Press ESC to test keyboard close")
print("2. Click X button to test window close")
print("3. Either should close immediately!")
print("")

local window = rl.init_window(600, 400, "Simple Close Test - Press ESC or Click X")
window:set_target_fps(60)

local frame = 0
local max_frames = 600 -- 10 second timeout

print("Window opened. Try closing it...")
print("")

-- Simple standard raylib loop - no manual polling needed!
while not window:window_should_close() and frame < max_frames do
    frame = frame + 1

    -- Print progress every second
    if frame % 60 == 0 then
        print("Frame " .. frame .. " - Still running (press ESC or click X)")
    end

    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    window:draw_text("Close Test", 220, 80, 35, rl.colors.DARKBLUE)
    window:draw_text("Press ESC to close", 190, 150, 22, rl.colors.BLACK)
    window:draw_text("OR", 280, 185, 22, rl.colors.DARKGRAY)
    window:draw_text("Click X button to close", 160, 220, 22, rl.colors.BLACK)

    window:draw_text("Frame: " .. frame, 250, 300, 20, rl.colors.BLUE)

    window:draw_text("No manual polling - just works!", 150, 350, 18, rl.colors.DARKGRAY)

    window:end_drawing()
    -- EndDrawing() automatically handles:
    -- - Input polling
    -- - Frame timing
    -- - Buffer swapping
end

print("")
print("========================================")
print("RESULT")
print("========================================")

if frame >= max_frames then
    print("TIMEOUT - Window did not close")
    print("Frames: " .. frame)
else
    print("SUCCESS - Window closed!")
    print("Frames until close: " .. frame)

    if frame <= 5 then
        print("Rating: EXCELLENT - Closed immediately")
    elseif frame <= 30 then
        print("Rating: GOOD - Closed quickly")
    else
        print("Rating: OK - Took a while but worked")
    end
end

print("")
print("Test complete")
print("========================================")

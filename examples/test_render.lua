local rl = require("raylib")

local window = rl.init_window(800, 450, "rlmlua - Render Test")
window:set_target_fps(60)

local frame = 0
local max_frames = 180 -- Run for 3 seconds at 60 FPS

print("Starting render test for 3 seconds...")

while not window:window_should_close() and frame < max_frames do
    frame = frame + 1

    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    -- Draw title
    window:draw_text("Render Test", 300, 50, 40, rl.colors.DARKBLUE)

    -- Draw frame counter
    window:draw_text("Frame: " .. frame .. " / " .. max_frames, 300, 120, 20, rl.colors.DARKGRAY)

    -- Draw a rectangle
    window:draw_rectangle(100, 200, 200, 100, rl.colors.RED)

    -- Draw a circle
    window:draw_circle(500, 250, 50, rl.colors.BLUE)

    -- Draw a line
    window:draw_line(100, 350, 700, 350, rl.colors.GREEN)

    -- Draw instructions
    window:draw_text("Press ESC to exit early", 250, 400, 20, rl.colors.DARKGRAY)

    window:end_drawing()
end

print("✓ Render test completed successfully after " .. frame .. " frames")

local rl = require("raylib")
-- local helpers = require("rlmlua")


local window = rl.init_window(800, 450, "rlmlua - Basic Window")
window:set_target_fps(60)

local frame = 0
local max_frames = 600 -- Run for 10 seconds at 60 FPS, then auto-exit

while not window:window_should_close() and frame < max_frames do
    frame = frame + 1

    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    window:draw_text("Press ESC to exit", 280, 250, 20, rl.colors.DARKGRAY)
    window:end_drawing()
end

print("Window closed after " .. frame .. " frames")

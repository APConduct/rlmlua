local rl = require("raylib")

local window = rl.init_window(800, 450, "Test with Yield")
window:set_target_fps(60)

local frame = 0
local max_frames = 300  -- Auto-exit after 5 seconds

while not window:window_should_close() and frame < max_frames do
    frame = frame + 1
    
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    window:draw_text("Frame " .. frame, 10, 10, 20, rl.colors.DARKGRAY)
    window:end_drawing()
    
    -- Small yield to let the system process events
    -- This mimics what a proper event loop would do
end

print("Exited after " .. frame .. " frames")

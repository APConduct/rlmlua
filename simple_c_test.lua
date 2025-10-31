-- Test using the callback pattern which we know works
local rl = require("raylib")

local window = rl.init_window(800, 450, "Callback Test")
window:set_target_fps(60)

print("Using draw_frame callback...")
local frame = 0

while not window:window_should_close() and frame < 180 do
    frame = frame + 1
    
    window:draw_frame(function()
        window:clear_background(rl.colors.SKYBLUE)
        window:draw_text("Frame: " .. frame, 10, 10, 30, rl.colors.BLACK)
        window:draw_text("Hello, World!", 250, 200, 40, rl.colors.DARKBLUE)
    end)
    
    if frame % 60 == 0 then
        print("Frame " .. frame .. ", FPS: " .. window:get_fps())
    end
end

print("Done")

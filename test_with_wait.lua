local rl = require("raylib")

local window = rl.init_window(800, 450, "Wait Test")
window:set_target_fps(60)

print("Running with manual wait...")
local frame = 0

while not window:window_should_close() and frame < 180 do
    frame = frame + 1
    
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame: " .. frame, 10, 10, 30, rl.colors.BLACK)
    window:draw_text("Hello, World!", 250, 200, 40, rl.colors.DARKBLUE)
    window:draw_rectangle(100, 300, 100, 50, rl.colors.RED)
    window:end_drawing()
    
    -- Manual wait to limit FPS
    local target_frame_time = 1.0 / 60.0
    local current_time = os.clock()
    while os.clock() - current_time < target_frame_time do
        -- busy wait
    end
    
    if frame % 60 == 0 then
        print("Frame " .. frame .. ", FPS: " .. window:get_fps())
    end
end

print("Done")

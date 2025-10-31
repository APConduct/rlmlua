local rl = require("raylib")

print("Creating window...")
local window = rl.init_window(800, 450, "Flicker Test")
window:set_target_fps(60)

print("Starting main loop...")
local frame = 0

while not window:window_should_close() and frame < 180 do
    frame = frame + 1
    if frame % 60 == 0 then
        print("Frame " .. frame .. " - FPS: " .. window:get_fps())
    end
    
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame: " .. frame, 10, 10, 20, rl.colors.BLACK)
    window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    window:end_drawing()
end

print("Test completed after " .. frame .. " frames")

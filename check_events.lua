local rl = require("raylib")

local window = rl.init_window(800, 450, "Event Check")
window:set_target_fps(60)

print("Testing with window_should_close check every frame...")

for i = 1, 180 do
    -- Check for close BEFORE drawing
    if window:window_should_close() then 
        print("Close detected at frame " .. i)
        break 
    end
    
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame " .. i .. " / 180", 300, 200, 30, rl.colors.BLACK)
    window:draw_text("Press ESC to exit", 280, 250, 20, rl.colors.DARKGRAY)
    window:end_drawing()
end

print("Test completed")

local rl = require("raylib")

-- Test if VSync might be interfering
local window = rl.init_window(800, 450, "VSync Test")

-- Try without setting target FPS to see if VSync handles it
print("Running WITHOUT set_target_fps to test native VSync...")

for i = 1, 120 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("VSync Test - Frame " .. i, 200, 200, 30, rl.colors.BLACK)
    window:end_drawing()
    
    if window:window_should_close() then break end
end

print("Did that render smoothly?")

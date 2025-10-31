-- Test to confirm input event issue
local rl = require("raylib")

local window = rl.init_window(400, 300, "Input Test - Press ESC")
window:set_target_fps(60)

print("Try pressing ESC to close the window...")
print("If it takes multiple tries, that confirms the input event issue")

for i = 1, 600 do  -- 10 seconds max
    if window:window_should_close() then
        print("ESC detected at frame " .. i)
        break
    end
    
    window:begin_drawing()
    window:clear_background(rl.colors.DARKGREEN)
    window:draw_text("Press ESC to exit", 100, 120, 20, rl.colors.WHITE)
    window:draw_text("Frame: " .. i, 10, 10, 16, rl.colors.LIGHTGRAY)
    window:end_drawing()
end

print("Test completed")

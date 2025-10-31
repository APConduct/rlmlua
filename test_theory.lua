-- Theory: Maybe our sleep is the problem. Let's try with set_target_fps
-- but see if the built-in raylib timing works better now
local rl = require("raylib")

local window = rl.init_window(800, 450, "Theory Test")
window:set_target_fps(60)  -- Set it but maybe raylib will handle it properly now

print("Running WITH set_target_fps(60)...")
print("Our code will sleep, testing if that causes issues...")

for i = 1, 180 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 180, 40, rl.colors.BLACK)
    window:draw_text("With FPS limit", 280, 230, 20, rl.colors.DARKGRAY)
    window:draw_text("Frame: " .. i, 10, 10, 20, rl.colors.DARKGRAY)
    window:end_drawing()
end

print("Completed")

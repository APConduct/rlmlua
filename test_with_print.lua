local rl = require("raylib")

local window = rl.init_window(800, 450, "Print Test")
window:set_target_fps(10)  -- Set to 10 FPS for easier testing

print("Running 5 frames at 10 FPS (should take 0.5 seconds)...")
local start = os.clock()

for i = 1, 5 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame: " .. i, 250, 200, 30, rl.colors.BLACK)
    window:end_drawing()
end

local elapsed = os.clock() - start
print(string.format("Took %.3f seconds (expected ~0.5s)", elapsed))

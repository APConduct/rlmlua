local rl = require("raylib")

local window = rl.init_window(800, 450, "Real Timing Test")
window:set_target_fps(60)

print("Testing real frame timing (should take ~3 seconds for 180 frames)...")
local start_time = os.time()

for i = 1, 180 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame: " .. i, 10, 10, 30, rl.colors.BLACK)
    window:draw_text("Hello, World!", 250, 200, 40, rl.colors.DARKBLUE)
    window:end_drawing()
    
    if window:window_should_close() then break end
end

local elapsed = os.time() - start_time
print(string.format("Completed 180 frames in %d seconds (expected ~3s)", elapsed))
print(string.format("Actual FPS: %.1f (target: 60)", 180 / elapsed))

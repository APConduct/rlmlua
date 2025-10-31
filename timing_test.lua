local rl = require("raylib")
local window = rl.init_window(400, 300, "Timing Test")

-- Test at 30 FPS - each frame should take ~0.033 seconds
window:set_target_fps(30)

print("Testing 30 FPS (each frame should take ~0.033s):")
for i = 1, 5 do
    local start = os.clock()
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame " .. i, 150, 120, 30, rl.colors.BLACK)
    window:end_drawing()
    local elapsed = os.clock() - start
    print(string.format("  Frame %d: %.4f seconds", i, elapsed))
end

print("\nNow testing 10 FPS (each frame should take ~0.1s):")
window:set_target_fps(10)
for i = 1, 5 do
    local start = os.clock()
    window:begin_drawing()
    window:clear_background(rl.colors.GREEN)
    window:draw_text("Frame " .. i, 150, 120, 30, rl.colors.BLACK)
    window:end_drawing()
    local elapsed = os.clock() - start
    print(string.format("  Frame %d: %.4f seconds", i, elapsed))
end

print("\nDone!")

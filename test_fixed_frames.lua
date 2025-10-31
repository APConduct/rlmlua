local rl = require("raylib")

print("Running for exactly 180 frames (3 seconds at 60 FPS)...")

local window = rl.init_window(800, 450, "Fixed Frame Count Test")
window:set_target_fps(60)

for i = 1, 180 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    window:draw_text("Frame " .. i .. " / 180", 10, 10, 20, rl.colors.DARKGRAY)
    window:end_drawing()
end

print("Completed 180 frames")
print("Did you see:")
print("  - Sky blue background?")
print("  - 'Hello, World!' text?")
print("  - Frame counter?")
print("  - Smooth display or flickering?")

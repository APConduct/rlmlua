local rl = require("raylib")

local window = rl.init_window(800, 450, "60 FPS Test - No More Flicker!")
window:set_target_fps(60)

print("Running at 60 FPS for 3 seconds...")
print("The window should display smoothly without flickering!")
print("Press ESC or close window to exit early.")

local start = os.time()
local frame = 0

while os.time() - start < 3 and not window:window_should_close() do
    frame = frame + 1
    
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 180, 40, rl.colors.BLACK)
    window:draw_text("Frame: " .. frame, 10, 10, 20, rl.colors.DARKGRAY)
    window:draw_text("No more flickering!", 250, 250, 30, rl.colors.DARKBLUE)
    window:end_drawing()
end

local elapsed = os.time() - start
local actual_fps = frame / elapsed

print(string.format("\nCompleted %d frames in %d seconds", frame, elapsed))
print(string.format("Actual FPS: %.1f (target: 60)", actual_fps))
print("\nDid the window display smoothly without flickering?")

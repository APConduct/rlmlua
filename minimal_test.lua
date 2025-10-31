local rl = require("raylib")

print("Creating window...")
local window = rl.init_window(800, 450, "Minimal Test")
window:set_target_fps(60)

print("Running 60 frames (should take 1 second)...")
local start = os.time()

for i = 1, 60 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame " .. i, 350, 200, 30, rl.colors.BLACK)
    window:end_drawing()
end

print("Took " .. (os.time() - start) .. " seconds")
print("Now sleep for 2 seconds so you can see final frame...")

-- Keep window open to see result
local hold_start = os.time()
while os.time() - hold_start < 2 do
    -- Don't draw, just keep window alive
end

print("Done")

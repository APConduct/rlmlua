local rl = require("raylib")

local window = rl.init_window(400, 300, "Wall Time Test")
window:set_target_fps(10)  -- 10 FPS = 0.1s per frame

print("Testing with os.time() which measures wall clock time...")
local start = os.time()

for i = 1, 10 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame " .. i, 150, 120, 30, rl.colors.BLACK)
    window:end_drawing()
end

local elapsed = os.time() - start
print(string.format("10 frames at 10 FPS took %d seconds (expected: 1 second)", elapsed))

if elapsed >= 1 then
    print("SUCCESS! Frame timing is working!")
else
    print("FAILED! Frames ran too fast.")
end

local rl = require("raylib")

local window = rl.init_window(800, 450, "No Wait Test")
window:set_target_fps(60)

print("Running WITHOUT any wait...")
local start = os.time()

for i = 1, 180 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame: " .. i, 10, 10, 30, rl.colors.BLACK)
    window:draw_text("Hello, Raylib!", 250, 200, 40, rl.colors.DARKBLUE)
    window:end_drawing()
    
    if i % 60 == 0 then
        local elapsed = os.time() - start
        print(string.format("Frame %d after %ds, FPS reported: %d", i, elapsed, window:get_fps()))
    end
    
    if window:window_should_close() then break end
end

print("Finished")

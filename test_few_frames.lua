local rl = require("raylib")

local window = rl.init_window(800, 450, "Few Frames Test")
window:set_target_fps(60)

print("Running 10 frames...")

for i = 1, 10 do
    local t1 = os.clock()
    window:begin_drawing()
    local t2 = os.clock()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame: " .. i, 250, 200, 30, rl.colors.BLACK)
    local t3 = os.clock()
    window:end_drawing()
    local t4 = os.clock()
    
    print(string.format("Frame %d: begin=%.4f draw=%.4f end=%.4f", 
        i, t2-t1, t3-t2, t4-t3))
end

print("Done!")

local rl = require("raylib")

print("Test 1: Create window")
local window = rl.init_window(800, 450, "Debug Test")
print("Window created")

print("Test 2: Set FPS")
window:set_target_fps(60)
print("FPS set to 60")

print("Test 3: Single frame")
window:begin_drawing()
print("Begin drawing called")
window:clear_background(rl.colors.RED)
print("Clear background called")
window:draw_text("TEST", 100, 100, 50, rl.colors.WHITE)
print("Draw text called")
window:end_drawing()
print("End drawing called")

print("Sleeping for 2 seconds to see the frame...")
os.execute("sleep 2")

print("Test 4: Loop for 120 frames")
for i = 1, 120 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame " .. i, 100, 100, 30, rl.colors.BLACK)
    window:end_drawing()
    
    if i % 30 == 0 then
        print("Frame " .. i .. ", FPS: " .. window:get_fps())
    end
    
    if window:window_should_close() then
        print("Window close requested at frame " .. i)
        break
    end
end

print("Test completed")

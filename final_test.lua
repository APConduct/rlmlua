local rl = require("raylib")

print("===========================================")
print("FINAL TEST - No Manual Sleep")
print("===========================================")
print("Relying on VSync for frame timing")
print("Running for 5 seconds...")
print("")

local window = rl.init_window(800, 450, "rlmlua - Final Test (No Sleep)")
window:set_target_fps(60)

local start = os.time()
local frame = 0

while os.time() - start < 5 do
    frame = frame + 1
    
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 180, 40, rl.colors.BLACK)
    window:draw_text("Frame: " .. frame, 10, 10, 20, rl.colors.DARKGRAY)
    window:draw_text("No manual sleep - pure VSync", 220, 250, 20, rl.colors.DARKBLUE)
    window:end_drawing()
    
    if window:window_should_close() then break end
end

print("")
print("Completed " .. frame .. " frames in ~5 seconds")
print("Did the display look smooth with minimal flickering?")
print("===========================================")

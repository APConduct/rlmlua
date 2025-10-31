local rl = require("raylib")

print("========================================")
print("SIMPLE ESC TEST")
print("========================================")
print("Press ESC once - window should close immediately")
print("Press X button - window should close immediately")
print("")

local window = rl.init_window(400, 300, "ESC Test - Press ESC to Close")
window:set_target_fps(60)

local frame = 0

while true do
    -- Poll input ONCE at the start of the frame
    window:poll_input_events()

    -- Check if should close
    if window:window_should_close() then
        print("Window close detected at frame " .. frame)
        break
    end

    frame = frame + 1

    -- Render
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    window:draw_text("Press ESC to Close", 80, 120, 20, rl.colors.BLACK)
    window:draw_text("Frame: " .. frame, 150, 160, 20, rl.colors.DARKGRAY)

    window:end_drawing()
end

print("Total frames: " .. frame)
print("Test complete")

local rl = require("raylib")

-- Minimal test to verify ESC key is responsive
-- This should close immediately when you press ESC once

local window = rl.init_window(800, 450, "ESC Responsiveness Test")
window:set_target_fps(60)

print("========================================")
print("ESC KEY RESPONSIVENESS TEST")
print("========================================")
print("")
print("Instructions:")
print("1. Window will open")
print("2. Press ESC ONCE")
print("3. Window should close IMMEDIATELY")
print("")
print("If you need to press ESC multiple times,")
print("there is still an input polling issue.")
print("")
print("Starting test...")
print("")

local frame_count = 0
local start_frame = -1
local esc_detected = false

while not window:window_should_close() do
    frame_count = frame_count + 1

    -- Track when ESC is first detected
    if not esc_detected and window:is_key_pressed("ESC") then
        esc_detected = true
        start_frame = frame_count
        print("✓ ESC detected at frame " .. frame_count)
    end

    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    -- Title
    window:draw_text("ESC Responsiveness Test", 220, 100, 30, rl.colors.DARKBLUE)

    -- Instructions
    window:draw_text("Press ESC to close", 300, 180, 25, rl.colors.BLACK)
    window:draw_text("(Should close on first press)", 230, 215, 20, rl.colors.DARKGRAY)

    -- Frame counter
    window:draw_text("Frame: " .. frame_count, 350, 280, 20, rl.colors.BLUE)

    -- Status indicator
    if esc_detected then
        window:draw_text("ESC PRESSED!", 320, 330, 25, rl.colors.RED)
        window:draw_text("(Closing now...)", 310, 360, 20, rl.colors.RED)
    else
        window:draw_text("Waiting for ESC...", 300, 330, 20, rl.colors.DARKGRAY)
    end

    window:end_drawing()
end

print("")
print("========================================")
print("TEST RESULTS")
print("========================================")
print("Total frames: " .. frame_count)

if esc_detected then
    local frames_to_close = frame_count - start_frame
    print("ESC detected at frame: " .. start_frame)
    print("Frames from detection to close: " .. frames_to_close)
    print("")
    if frames_to_close <= 2 then
        print("✓✓✓ EXCELLENT - Window closed immediately!")
    elseif frames_to_close <= 5 then
        print("✓ GOOD - Minor delay but acceptable")
    else
        print("⚠ WARNING - Too many frames before close")
    end
else
    print("Window closed without ESC detection")
    print("(User may have clicked the X button)")
end

print("")
print("Test complete.")

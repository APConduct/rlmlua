#!/usr/bin/env lua
-- Comprehensive test to verify flickering is fixed
-- Run this and observe the window - it should display smoothly without flickering

local rl = require("raylib")

print("===========================================")
print("FLICKER FIX TEST")
print("===========================================")
print("")
print("This test will:")
print("  1. Create a window with a sky blue background")
print("  2. Display text and shapes")
print("  3. Run for 10 seconds at 60 FPS")
print("")
print("WHAT TO LOOK FOR:")
print("  ✓ Window should display SMOOTHLY")
print("  ✓ NO rapid flickering between black and blue")
print("  ✓ Text should be clearly readable")
print("  ✓ Shapes should render consistently")
print("")
print("Press ESC or close window to exit early")
print("===========================================")
print("")

local window = rl.init_window(800, 450, "rlmlua - Flicker Fix Verification")
window:set_target_fps(60)

local start_time = os.time()
local frame_count = 0
local colors = {
    rl.colors.RED,
    rl.colors.GREEN,
    rl.colors.BLUE,
    rl.colors.YELLOW,
    rl.colors.PURPLE,
    rl.colors.ORANGE
}

print("Window created! Running test...")
print("")

-- Run for 10 seconds
while os.time() - start_time < 10 and not window:window_should_close() do
    frame_count = frame_count + 1
    local elapsed = os.time() - start_time

    window:begin_drawing()

    -- Clear with sky blue background
    window:clear_background(rl.colors.SKYBLUE)

    -- Draw title
    window:draw_text("Flicker Fix Verification", 200, 30, 30, rl.colors.BLACK)

    -- Draw main message
    window:draw_text("Hello, World!", 280, 150, 40, rl.colors.DARKBLUE)

    -- Draw status info
    window:draw_text(string.format("Time: %d / 10 seconds", elapsed), 10, 10, 20, rl.colors.DARKGRAY)
    window:draw_text(string.format("Frame: %d", frame_count), 10, 35, 20, rl.colors.DARKGRAY)

    -- Draw instructions
    window:draw_text("If you see smooth rendering with no flicker:", 150, 220, 20, rl.colors.DARKGREEN)
    window:draw_text("THE FIX IS WORKING! ✓", 250, 250, 20, rl.colors.GREEN)

    -- Draw some animated shapes to make flickering more obvious if it exists
    local color_index = (math.floor(frame_count / 10) % #colors) + 1
    window:draw_rectangle(50, 300, 100, 80, colors[color_index])
    window:draw_rectangle(200, 300, 100, 80, rl.colors.RED)
    window:draw_rectangle(350, 300, 100, 80, rl.colors.GREEN)
    window:draw_rectangle(500, 300, 100, 80, rl.colors.BLUE)
    window:draw_rectangle(650, 300, 100, 80, colors[color_index])

    -- Draw border
    window:draw_rectangle_lines(5, 5, 790, 440, rl.colors.BLACK)

    window:end_drawing()
end

local total_elapsed = os.time() - start_time
local actual_fps = frame_count / total_elapsed

print("===========================================")
print("TEST COMPLETED")
print("===========================================")
print("")
print(string.format("Total frames: %d", frame_count))
print(string.format("Total time: %d seconds", total_elapsed))
print(string.format("Average FPS: %.1f (target: 60)", actual_fps))
print("")
print("RESULTS:")
if total_elapsed >= 8 then
    print("  ✓ Test ran for sufficient duration")
else
    print("  ⚠ Test exited early")
end

if actual_fps >= 30 then
    print("  ✓ Frame rate is reasonable")
elseif actual_fps >= 10 then
    print("  ⚠ Frame rate is low but acceptable")
else
    print("  ✗ Frame rate is very low")
end

print("")
print("VISUAL ASSESSMENT (from your observation):")
print("  Did the window display smoothly? (Y/N)")
print("  Was there rapid black/blue flickering? (Y/N)")
print("")
print("If the display was smooth with no flickering,")
print("then the frame timing fix is successful!")
print("===========================================")

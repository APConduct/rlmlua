local rl = require("raylib")

local window = rl.init_window(800, 450, "rlmlua - Input Test")
window:set_target_fps(60)

local frame = 0
local max_frames = 600 -- Run for 10 seconds max
local esc_presses = 0
local last_esc_frame = -10

print("=== Input Test ===")
print("Press ESC to close the window")
print("The window should close immediately on first ESC press")
print("")

while true do
    -- Poll input events FIRST, at the start of the frame
    window:poll_input_events()

    -- NOW check if we should close (after polling)
    if window:window_should_close() or frame >= max_frames then
        break
    end

    frame = frame + 1

    -- Check if ESC was pressed this frame
    if window:is_key_pressed("ESC") then
        esc_presses = esc_presses + 1
        last_esc_frame = frame
        print("ESC pressed at frame " .. frame .. " (press #" .. esc_presses .. ")")
    end

    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    -- Draw title
    window:draw_text("Input Responsiveness Test", 200, 50, 30, rl.colors.DARKBLUE)

    -- Draw instructions
    window:draw_text("Press ESC to close", 280, 150, 20, rl.colors.DARKGRAY)
    window:draw_text("Window should close immediately!", 220, 180, 20, rl.colors.DARKGRAY)

    -- Draw frame counter
    window:draw_text("Frame: " .. frame, 350, 250, 20, rl.colors.BLACK)

    -- Draw ESC press count
    window:draw_text("ESC presses detected: " .. esc_presses, 280, 300, 20, rl.colors.BLUE)

    -- Show if ESC was recently pressed
    if frame - last_esc_frame < 30 then
        window:draw_text("ESC DETECTED!", 300, 350, 30, rl.colors.RED)
    end

    window:end_drawing()
end

print("")
print("=== Test Results ===")
print("Total frames: " .. frame)
print("ESC presses detected: " .. esc_presses)

if window:window_should_close() then
    print("✓ Window closed by user input")
else
    print("⚠ Window closed by timeout")
end

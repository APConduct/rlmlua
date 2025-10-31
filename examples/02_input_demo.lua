local rl = require("raylib")

-- This example demonstrates proper input handling in rlmlua
-- Key concept: Input is polled once per frame in window_should_close()
-- All input checks after that see the same input state for the frame

local window = rl.init_window(800, 450, "rlmlua - Input Demo")
window:set_target_fps(60)

local ball_x = 400
local ball_y = 225
local ball_speed = 5
local ball_color = rl.colors.BLUE

local space_presses = 0
local mouse_clicks = 0

print("=== Input Demo ===")
print("Arrow keys: Move the ball")
print("SPACE: Change color")
print("Mouse click: Count clicks")
print("ESC: Exit")
print("")

while true do
    -- Poll input events FIRST, at the start of the frame
    window:poll_input_events()

    -- NOW check if we should close (after polling)
    if window:window_should_close() then
        break
    end

    -- All input checks below use the polled state from above

    -- Keyboard input - continuous (is_key_down for held keys)
    if window:is_key_down("RIGHT") then
        ball_x = ball_x + ball_speed
    end
    if window:is_key_down("LEFT") then
        ball_x = ball_x - ball_speed
    end
    if window:is_key_down("DOWN") then
        ball_y = ball_y + ball_speed
    end
    if window:is_key_down("UP") then
        ball_y = ball_y - ball_speed
    end

    -- Keyboard input - single press (is_key_pressed for one-time actions)
    if window:is_key_pressed("SPACE") then
        space_presses = space_presses + 1
        -- Cycle through colors
        local colors = { rl.colors.BLUE, rl.colors.RED, rl.colors.GREEN, rl.colors.PURPLE, rl.colors.ORANGE }
        ball_color = colors[(space_presses % 5) + 1]
        print("Color changed! (SPACE press #" .. space_presses .. ")")
    end

    -- Mouse input
    if window:is_mouse_button_pressed(0) then -- 0 = left mouse button
        mouse_clicks = mouse_clicks + 1
        local mx, my = window:get_mouse_position()
        print("Mouse clicked at (" .. math.floor(mx) .. ", " .. math.floor(my) .. ") - Click #" .. mouse_clicks)
    end

    -- Keep ball in bounds
    if ball_x < 20 then ball_x = 20 end
    if ball_x > 780 then ball_x = 780 end
    if ball_y < 20 then ball_y = 20 end
    if ball_y > 430 then ball_y = 430 end

    -- Drawing
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    -- Title
    window:draw_text("Input Demo", 300, 20, 30, rl.colors.DARKBLUE)

    -- Instructions
    window:draw_text("Arrow keys to move ball", 20, 60, 20, rl.colors.DARKGRAY)
    window:draw_text("SPACE to change color", 20, 85, 20, rl.colors.DARKGRAY)
    window:draw_text("Click mouse anywhere", 20, 110, 20, rl.colors.DARKGRAY)
    window:draw_text("ESC to exit", 20, 135, 20, rl.colors.DARKGRAY)

    -- Stats
    window:draw_text("Color changes: " .. space_presses, 550, 60, 20, rl.colors.BLACK)
    window:draw_text("Mouse clicks: " .. mouse_clicks, 550, 85, 20, rl.colors.BLACK)
    window:draw_text("FPS: " .. window:get_fps(), 550, 110, 20, rl.colors.BLACK)

    -- Draw the ball
    window:draw_circle(ball_x, ball_y, 20, ball_color)

    -- Draw crosshair at mouse position
    local mx, my = window:get_mouse_position()
    window:draw_line(mx - 10, my, mx + 10, my, rl.colors.RED)
    window:draw_line(mx, my - 10, mx, my + 10, rl.colors.RED)

    window:end_drawing()
end

print("")
print("Demo ended!")
print("Total color changes: " .. space_presses)
print("Total mouse clicks: " .. mouse_clicks)

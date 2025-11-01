local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - input mouse")

local ball_position = rlm.vec2(-100.0, -100.0)

local ball_color = rlc.DARKBLUE

window:set_target_fps(60)

while not window:should_close() do
    if window:is_mouse_button_pressed("LEFT") then
        ball_color = rlc.MAROON
    elseif window:is_mouse_button_pressed("MIDDLE") then
        ball_color = rlc.LIME
    elseif window:is_mouse_button_pressed("RIGHT") then
        ball_color = rlc.DARKBLUE
    elseif window:is_mouse_button_pressed("SIDE") then
        ball_color = rlc.PURPLE
    elseif window:is_mouse_button_pressed("EXTRA") then
        ball_color = rlc.YELLOW
    elseif window:is_mouse_button_pressed("FORWARD") then
        ball_color = rlc.ORANGE
    elseif window:is_mouse_button_pressed("BACK") then
        ball_color = rlc.BEIGE
    end

    ball_position = window:get_mouse_position()

    window:begin_drawing()

    window:clear_background(rlc.RAYWHITE)

    window:draw_circle_v(ball_position, 40, ball_color)

    window:draw_text("move ball with mouse and click mouse button to change color", 10, 10, 20, rlc.DARKGRAY)
    window:draw_text("Press 'H' to toggle cursor visibility", 10, 30, 20, rlc.DARKGRAY)

    if window:is_cursor_hidden() then
        window:draw_text("CURSOR HIDDEN", 20, 60, 20, rlc.RED)
    else
        window:draw_text("CURSOR VISIBLE", 20, 60, 20, rlc.LIME)
    end

    window:end_drawing()
end

window:close()

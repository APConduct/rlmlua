local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - delta time")

local current_fps = 60

local delta_circle = rlm.vec2(0, screen_height / 3.0)
local frame_circle = rlm.vec2(0, screen_height * (2.0 / 3.0))

local speed = 10.0
local circle_radius = 32.0

window:set_target_fps(current_fps)

while not window:should_close() do
    local mouse_wheel = window:get_mouse_wheel_move()
    if mouse_wheel ~= 0 then
        current_fps = current_fps + mouse_wheel
        if current_fps < 0 then
            current_fps = 0
            window:set_target_fps(current_fps)
        end
    end

    delta_circle.x = delta_circle.x + window:get_frame_time() * 6.0 * speed
    frame_circle.x = frame_circle.x + 0.1 * speed

    if delta_circle.x > screen_width then
        delta_circle.x = 0
    end
    if frame_circle.x > screen_width then
        frame_circle.x = 0
    end

    if window:is_key_pressed("R") then
        delta_circle.x = 0
        frame_circle.x = 0
    end

    -- Draw
    window:begin_drawing()

    window:clear_background(rlc.RAYWHITE)
    window:draw_circle_v(delta_circle, circle_radius, rlc.RED)
    window:draw_circle_v(frame_circle, circle_radius, rlc.BLUE)
    local fps_text = ""
    if current_fps <= 0 then
        fps_text = string.format("FPS: unlimited (%i)", window:get_fps())
    else
        fps_text = string.format("FPS: %i (target: %i)", current_fps, window:get_fps(), current_fps)
    end

    window:draw_text(fps_text, 10, 10, 20, rlc.DARKGRAY)
    window:draw_text(string.format("Frame time: %02.02f ms", window:get_frame_time()), 10, 30, 20, rlc.DARKGRAY)
    window:draw_text("Use the scroll wheel to change the fps limit, r to reset", 10, 50, 20, rlc.DARKGRAY)

    window:draw_text("FUNC: x = x + window:get_frame_time() * speed", 10, 90, 20, rlc.RED)
    window:draw_text("FUNC: x = x + speed", 10, 240, 20, rlc.BLUE)

    window:end_drawing()
end

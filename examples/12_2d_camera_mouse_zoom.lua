local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local clamp = function(value, min, max)
    return math.min(math.max(value, min), max)
end

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - 2d camera mouse zoom")

---@type Camera2D
local camera = rlm.camera2d(0, rlm.vec2(0, 0), 0, 0)
camera.zoom = 1.0

local zoom_mode = 0

window:set_target_fps(60)

while not window:should_close() do
    if window:is_key_pressed("ONE") then
        zoom_mode = 0
    elseif window:is_key_pressed("TWO") then
        zoom_mode = 1
    end

    if window:is_mouse_button_down("LEFT") then
        ---@type Vector2
        local delta = window:get_mouse_delta()
        delta = delta * -1.0
        camera.target = camera.target + delta
    end

    if zoom_mode == 0 then
        local wheel = window:get_mouse_wheel_move()
        if wheel ~= 0 then
            local mouse_world_pos = window:get_screen_to_world_2d(window:get_mouse_position(), camera)

            camera.offset = window:get_mouse_position()

            camera.target = mouse_world_pos

            local scale = 0.2 * wheel
            camera.zoom = clamp(math.exp(math.log(camera.zoom) + scale), 0.125, 64.0)
        end
    else
        if window:is_mouse_button_pressed("RIGHT") then
            local mouse_world_pos = window:get_screen_to_world_2d(window:get_mouse_position(), camera)

            camera.offset = window:get_mouse_position()

            camera.target = mouse_world_pos
        end
        if window:is_mouse_button_down("RIGHT") then
            local delta_x = window:get_mouse_delta().x
            local scale = 0.005 * delta_x
            camera.zoom = clamp(math.exp(math.log(camera.zoom) + scale), 0.125, 64.0)
        end
    end

    window:begin_drawing()

    window:clear_background(rlc.RAYWHITE)

    window:begin_mode_2d(camera)

    window:rl_push_matrix()
    window:rl_translate(0, 25, 50, 0)
    window:rl_rotate(90, 1, 0, 0)
    window:rl_draw_grid(100, 500)
    window:rl_pop_matrix()

    window:end_mode_2d()

    window:draw_circle_v(window:get_mouse_position(), 4, rlc.DARKGRAY)
    window:draw_text_ex(window:get_font_default(),
        string.format("%i, %i", window:get_mouse_x(), window:get_mouse_y()),
        window:get_mouse_position() + rlm.vec2(-44, -24), 20, 2,
        rlc.BLACK)


    window:draw_text("[1][2] Select mouse zoom mode (Wheel or Move)", 20, 20, 20, rlc.DARKGRAY)
    if zoom_mode == 0 then
        window:draw_text("Mouse left button drag to move, mouse wheel to zoom", 20, 50, 20, rlc.DARKGRAY)
    else
        window:draw_text("Mouse left button drag to move, mouse press and move to zoom", 20, 50, 20, rlc.DARKGRAY)
    end

    window:end_drawing()
end

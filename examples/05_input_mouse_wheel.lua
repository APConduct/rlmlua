local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - input mouse wheel")

local box_position_y = screen_height / 2 - 40
local scroll_speed = 4

window:set_target_fps(60)

while not window:should_close() do
    box_position_y = box_position_y - window:get_mouse_wheel_move() * scroll_speed

    window:begin_drawing()

    window:clear_background(rlc.RAYWHITE)

    window:draw_rectangle(screen_width / 2 - 40, box_position_y, 80, 80, rlc.MAROON)

    window:draw_text("Use mouse wheel to move the cube up and down!", 10, 10, 20, rlc.GRAY)
    window:draw_text(string.format("Box position Y: %03i", math.floor(box_position_y)), 10, 40, 20, rlc.LIGHTGRAY)

    window:end_drawing()
end

window:close()

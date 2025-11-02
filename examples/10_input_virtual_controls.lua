local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

---@enum PadButton
local PadButton = {
    None = 0,
    Up = 1,
    Left = 2,
    Right = 3,
    Down = 4,
    Max = 5
}

local screen_width = 800
local screen_height = 450

local window = rl.init_window(
    screen_width, screen_height,
    "rlmlua example - input virtual controls"
)

local pad_position = rlm.vec2(100, 350)
local button_radius = 30

local button_positions = {
    rlm.vec2(pad_position.x, pad_position.y - button_radius * 1.5), -- Up
    rlm.vec2(pad_position.x - button_radius * 1.5, pad_position.y), -- Left
    rlm.vec2(pad_position.x + button_radius * 1.5, pad_position.y), -- Right
    rlm.vec2(pad_position.x, pad_position.y + button_radius * 1.5)  -- Down
}

local button_labels = {
    "Y",
    "X",
    "B",
    "A"
}

local button_label_colors = {
    rlc.YELLOW,
    rlc.BLUE,
    rlc.RED,
    rlc.GREEN
}

local pressed_button = PadButton.None
local input_position = rlm.vec2(0, 0)

local player_position = rlm.vec2(screen_width / 2, screen_height / 2)
local player_speed = 75

window:set_target_fps(60)

while not window:should_close() do
    if window:get_touch_point_count() > 0 then
        input_position = window:get_touch_position(0)
    else
        input_position = window:get_mouse_position()
    end

    pressed_button = PadButton.None

    if window:get_touch_point_count() > 0 or
        (window:get_touch_point_count() == 0 and window:is_mouse_button_down("LEFT")) then
        for i = 1, PadButton.Max, 1 do
            local dist_x = math.abs(button_positions[i].x - input_position.x)
            local dist_y = math.abs(button_positions[i].y - input_position.y)

            if dist_x + dist_y < button_radius then
                pressed_button = i
                break
            end
        end
    end

    if pressed_button == PadButton.Up then
        player_position.y = player_position.y - player_speed * window:get_frame_time()
    elseif pressed_button == PadButton.Left then
        player_position.x = player_position.x - player_speed * window:get_frame_time()
    elseif pressed_button == PadButton.Right then
        player_position.x = player_position.x + player_speed * window:get_frame_time()
    elseif pressed_button == PadButton.Down then
        player_position.y = player_position.y + player_speed * window:get_frame_time()
    end

    window:begin_drawing()

    window:clear_background(rlc.RAYWHITE)

    window:draw_circle_v(player_position, 50, rlc.MAROON)

    local function ternary(condition, value_if_true, value_if_false)
        if condition then
            return value_if_true
        else
            return value_if_false
        end
    end
    for i = 1, PadButton.Max do
        window:draw_circle_v(button_positions[i], button_radius, ternary(i == pressed_button, rlc.DARKGRAY, rlc.BLACK))

        window:draw_text(button_labels[i], button_positions[i].x - 7, button_positions[i].y - 8,
            20, button_label_colors[i])
    end

    window:draw_text("move the player with D-Pad buttons", 10, 10, 20, rlc.DARKGRAY)

    window:end_drawing()
end

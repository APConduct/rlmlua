local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - input keys")

local ball_position = rlm.vec2(screen_width / 2, screen_height / 2)

window:set_target_fps(60)

while not window:should_close() do
    if window:is_key_down("RIGHT") then
        ball_position.x = ball_position.x + 2.0
    end
    if window:is_key_down("LEFT") then
        ball_position.x = ball_position.x - 2.0
    end
    if window:is_key_down("UP") then
        ball_position.y = ball_position.y - 2.0
    end
    if window:is_key_down("DOWN") then
        ball_position.y = ball_position.y + 2.0
    end

    window:begin_drawing()

    window:clear_background(rlc.WHITE)
    window:draw_text("move the ball with arrow keys", 10, 10, 20, rlc.DARKGRAY)
    window:draw_circle_v(ball_position, 50, rlc.MAROON)

    window:end_drawing()
end

window:close()

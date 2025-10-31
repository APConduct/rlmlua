local rl = require("raylib")
local rlc = rl.colors

local screen_width = 800
local screen_height = 450

local window = rl.init_window(
    screen_width, screen_height,
    "rlmlua - Basic Window")
window:set_target_fps(60)

while not window:should_close() do
    window:begin_drawing()
    window:clear_background(rlc.RAYWHITE)
    window:draw_text(
        "Congrats! You created your first window!",
        190, 200, 20, rlc.LIGHTGRAY)
    window:end_drawing()
end

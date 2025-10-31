local rl = require("raylib")
-- local helpers = require("rlmlua")


local window = rl.init_window(800, 450, "rlmua - Basic Window")
window:set_target_fps(60)

while not window:window_should_close() do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    window:end_drawing()
end

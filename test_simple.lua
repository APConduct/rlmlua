local rl = require("raylib")
local window = rl.init_window(400, 300, "Simple")
window:set_target_fps(30)

for i = 1, 5 do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hi", 150, 120, 40, rl.colors.BLACK)
    window:end_drawing()
end

print("Done - did you see the window render smoothly?")

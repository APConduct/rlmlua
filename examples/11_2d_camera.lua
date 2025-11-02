local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local MAX_BUILDINGS = 100

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - 2d camera")

local player = rlm.rect(400, 280, 40, 40)
local buildings = {}
local build_colors = {}

local spacing = 0

for i = 1, MAX_BUILDINGS do
    buildings[i].width = rl.get_random_value(50, 200)
    buildings[i].height = rl.get_random_value(100, 800)
    buildings[i].y = screen_height - 130.0 - buildings[i].height
    buildings[i].x = -6000.0 + spacing

    spacing = spacing + buildings[i].width

    build_colors[i] = rl.color(
        rl.get_random_value(200, 240),
        rl.get_random_value(200, 240),
        rl.get_random_value(200, 240),
        255)
end

local camera = rlm.camera2d(
    rlm.vec2(screen_width / 2.0, screen_height / 2.0), -- offset
    rlm.vec2(player.x + 20.0, player.y + 20.0),        -- target
    0.0,                                               -- rotation
    1.0                                                -- zoom
)

window:set_target_fps(60)

while not window:should_close() do
    if window:is_key_down("RIGHT") then
        player.x = player.x + 2
    elseif window:is_key_down("A") then
        player.x = player.x - 2
    end

    camera.target = rlm.vec2(player.x + 20, player.y + 20)

    if window:is_key_down("A") then
        camera.rotation = camera.rotation - 1
    elseif window:is_key_down("S") then
        camera.rotation = camera.rotation + 1
    end

    if camera.rotation > 40 then
        camera.rotation = 40
    elseif camera.rotation < -40 then
        camera.rotation = -40
    end

    camera.zoom = math.exp(math.log(camera.zoom) + window:get_mouse_wheel_move() * 0.1)

    if camera.zoom > 3.0 then
        camera.zoom = 3.0
    elseif camera.zoom < 0.1 then
        camera.zoom = 0.1
    end

    if window:is_key_pressed("R") then
        camera.zoom = 1.0
        camera.rotation = 0.0
    end

    window:begin_drawing()

    window:begin_mode_2d(camera)

    window:draw_rectangle(-6000, 320, 13000, 8000, rlc.DARKGRAY)

    for i = 1, MAX_BUILDINGS do
        window:draw_rectangle_rec(buildings[i], build_colors[i])
    end

    window:draw_rectangle_rec(player, rlc.RED)

    window:draw_line(math.floor(camera.target.x), -screen_height * 10, math.floor(camera.target.x), screen_height * 10,
        rlc.GREEN)
    window:draw_line(-screen_width * 10, math.floor(camera.target.y), screen_width * 10, math.floor(camera.target.y),
        rlc.GREEN)

    window:end_mode_2d()

    window:draw_text("SCREEN AREA", 640, 10, 20, rlc.RED)

    window:draw_rectangle(0, 0, screen_width, 5, rlc.RED)
    window:draw_rectangle(0, 5, 5, screen_height - 10, rlc.RED)
    window:draw_rectangle(screen_width - 5, 5, 5, screen_height - 10, rlc.RED)
    window:draw_rectangle(0, screen_height - 5, screen_width, 5, rlc.RED)

    window:draw_rectangle(10, 10, 250, 113, rl.fade(rlc.SKYBLUE, 0.5))
    window:draw_rectangle_lines(10, 10, 250, 113, rlc.BLUE)

    window:draw_text("Free 2d camera controls:", 20, 20, 10, rlc.BLACK)
    window:draw_text("- Right/Left to move Offset", 40, 40, 10, rlc.DARKGRAY)
    window:draw_text("- Mouse Wheel to Zoom in-out", 40, 60, 10, rlc.DARKGRAY)
    window:draw_text("- A / S to Rotate", 40, 80, 10, rlc.DARKGRAY)
    window:draw_text("- R to reset Zoom and Rotation", 40, 100, 10, rlc.DARKGRAY)

    window:end_drawing()
end

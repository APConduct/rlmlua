local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local PLAYER_SIZE = 40

local screen_width = 800
local screen_height = 450

local window = rl.init_window(
    screen_height, screen_width,
    "rlmlua example - 2d camera split screen")

local player1 = rlm.rect(200, 200, PLAYER_SIZE, PLAYER_SIZE)
local player2 = rlm.rect(250, 200, PLAYER_SIZE, PLAYER_SIZE)

local camera1 = rlm.camera2d()
camera1.target = rlm.vec2(player1.x, player1.y)
camera1.offset = rlm.vec2(200.0, 200.0)
camera1.rotation = 0.0
camera1.zoom = 1.0

local camera2 = rlm.camera2d()
camera2.target = rlm.vec2(player2.x, player2.y)
camera2.offset = rlm.vec2(200.0, 200.0)
camera2.rotation = 0.0
camera2.zoom = 1.0

local screen_camera1 = rl.load_render_texture(screen_width / 2, screen_height)
local screen_camera2 = rl.load_render_texture(screen_width / 2, screen_height)

local split_screen_rect = rlm.rect(0.0, 0.0, screen_camera1.texture.width, -screen_camera1.texture.height)

window:set_target_fps(60)

while not window:should_close() do
    if window:is_key_down("S") then
        player1.y = player1.y + 3.0
    elseif window:is_key_down("W") then
        player1.y = player1.y - 3.0
    end
    if window:is_key_down("D") then
        player1.x = player1.x + 3.0
    elseif window:is_key_down("A") then
        player1.x = player1.x - 3.0
    end

    if window:is_key_down("UP") then
        player2.y = player2.y - 3.0
    elseif window:is_key_down("DOWN") then
        player2.y = player2.y - 3.0
    end
    if window:is_key_down("RIGHT") then
        player2.x = player2.x + 3.0
    elseif window:is_key_down("LEFT") then
        player2.x = player2.x - 3.0
    end
end

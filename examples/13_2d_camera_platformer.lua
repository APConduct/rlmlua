local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local G = 400
local PLAYER_JUMP_SPEED = 350.0
local PLAYER_HOR_SPD = 200.0


--- Represents a player entity in the game.
---@class Player
---@field position Vector2
---@field speed number
---@field can_jump boolean
local Player = {}
Player.__index = Player

function Player.new(position, speed, can_jump, color)
    local player = setmetatable({
        position = position,
        speed = speed,
        can_jump = can_jump,
        color = color
    }, Player)
    return player
end

--- Represents an environment item in the game.
---@class EnvItem
---@field rect Rectangle
---@field blocking integer
---@field color Color
local EnvItem = {}

function EnvItem.new(rect, blocking, color)
    local item = setmetatable({
        rect = rect,
        blocking = blocking,
        color = color
    }, EnvItem)
    return item
end

--- Update the player
---@param camera Camera2D
---@param env_items EnvItem[]
---@param env_items_length integer
---@param delta number
---@param window Window|nil
---@return nil
function Player:update(camera, env_items, env_items_length, delta, window)
    if window == nil then
        return
    end

    if window:is_key_down("LEFT") then self.position.x = self.position.x - PLAYER_HOR_SPD * delta end
    if window:is_key_down("RIGHT") then self.position.x = self.position.x + PLAYER_HOR_SPD * delta end
    if window:is_key_down("SPACE") and self.can_jump then
        self.speed = -PLAYER_JUMP_SPEED
        self.can_jump = false
    end

    local hit_obstacle = false
    for i = 1, env_items_length do
        local ei = env_items[i]
        local p = self.position
        if ei.blocking and ei.rect.x <= p.x and ei.rect + ei.rect.width >= p.x and ei.rect.y >= p.y and ei.rect.y <= p.y + self.speed * delta then
            hit_obstacle = true
            self.speed = 0.0
            p.y = ei.rect.y
            break
        end
    end

    if not hit_obstacle then
        self.position.y = self.position.y + self.speed * delta
        self.speed = self.speed + G * delta
        self.can_jump = false
    else
        self.can_jump = true
    end
end

--- Update the player's camera center
---@param camera Camera2D
---@param self Player
---@param env_items EnvItem[]
---@param env_items_length integer
---@param delta number
---@param width number
---@param height number
---@param window Window
---@return nil
function Player:update_camera_center(camera, env_items, env_items_length, delta, width, height, window)
    camera.offset = rlm.vec2(width / 2.0, height / 2.0)
    camera.target = self.position
end

---
---@param camera Camera2D
---@param self Player
---@param env_items EnvItem[]
---@param env_items_length integer
---@param delta number
---@param width number
---@param height number
---@param window Window
---@return nil
function Player:update_camera_center_inside_map(camera, env_items, env_items_length, delta, width, height, window)
    camera.target = self.position
    camera.offset = rlm.vec2(width / 2.0, height / 2.0)

    local min_x, min_y, max_x, max_y = 1000, 1000, -1000, -1000

    for i = 1, env_items_length do
        local ei = env_items[i]
        min_x = math.min(ei.rect.x, min_x)
        max_x = math.max(ei.rect.x + ei.rect.width, max_x)
        min_y = math.min(ei.rect.y, min_y)
        max_y = math.max(ei.rect.y + ei.rect.height, max_y)
    end

    local max = window:get_screen_to_world_2d(rlm.vec2(max_x, max_y), camera)
    local min = window:get_screen_to_world_2d(rlm.vec2(min_x, min_y), camera)

    if max.x < width then camera.offset.x = width - (max.x - width / 2) end
    if max.x < height then camera.offset.y = height - (max.y - height / 2) end
    if min.x > 0 then camera.offset.x = width / 2 - min.x end
    if min.y > 0 then camera.offset.y = height / 2 - min.y end
end

---
---@param camera Camera2D
---@param self Player
---@param env_items EnvItem[]
---@param env_items_length integer
---@param delta number
---@param width number
---@param height number
function Player:update_camera_center_smooth_follow(camera, env_items, env_items_length, delta, width, height)
    local min_speed = 30
    local min_effect_length = 10
    local fraction_speed = 0.8

    camera.offset = rlm.vec2(width / 2.0, height / 2.0)
    local diff = self.position - camera.target
    local length = #diff

    if length > min_effect_length then
        local speed = math.max(fraction_speed * length, min_speed)
        camera.target = camera.target + diff * (speed * delta / length)
    end
end

---
---@param camera Camera2D
---@param self Player
---@param env_items EnvItem[]
---@param env_items_length integer
---@param delta number
---@param width number
---@param height number
function Player:update_camera_event_out_on_landings(camera, env_items, env_items_length, delta, width, height)
    local even_out_speed = 700
    local evening_out = false
    local even_out_target

    camera.offset = rlm.vec2(width / 2.0, height / 2.0)
    camera.target.x = self.position.x

    if evening_out then
        if even_out_target > camera.target.y then
            camera.target.y = camera.target.y + even_out_speed * delta

            if camera.target.y > even_out_target then
                camera.target.y = even_out_target
                evening_out = false
            end
        else
            camera.target.y = camera.target.y - even_out_speed * delta
            if camera.target.y < even_out_target then
                camera.target.y = even_out_target
                evening_out = false
            end
        end
    else
        if self.can_jump and self.speed == 0 and self.position.y ~= camera.target.y then
            evening_out = true
            even_out_target = self.position.y
        end
    end
end

---
---@param camera Camera2D
---@param self Player
---@param env_items EnvItem[]
---@param env_items_length integer
---@param delta number
---@param width number
---@param height number
---@param window Window
function Player:update_camera_player_bounds_push_up(camera, env_items, env_items_length, delta, width, height,
                                                    window)
    local bbox = rlm.vec2(0.2, 0.2)

    local bbox_world_min = window:get_screen_to_world_2d(
        rlm.vec2((1 - bbox.x) * 0.5 * width, (1 - bbox.y) * 0.5 * height),
        camera)
    local bbox_world_max = window:get_screen_to_world_2d(
        rlm.vec2((1 + bbox.x) * 0.5 * width, (1 + bbox.y) * 0.5 * height),
        camera)
    camera.offset = rlm.vec2((1 - bbox.x) * 0.5 * width, (1 - bbox.y) * 0.5 * height)

    if self.position.x < bbox_world_min.x then camera.target.x = self.position.x end
    if self.position.y < bbox_world_min.y then camera.target.y = self.position.y end
    if self.position.x > bbox_world_max.x then
        camera.target.x = bbox_world_min.x + (
            self.position.x - bbox_world_max.x)
    end
    if self.position.y > bbox_world_max.y then
        camera.target.y = bbox_world_min.y + (
            self.position.y - bbox_world_max.y)
    end
end

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - 2d camera mouse zoom")

local player = Player.new()
player.position = rlm.vec2(400, 280)
player.speed = 0
player.can_jump = false
---@type EnvItem[]
local env_items = {
    EnvItem.new(rlm.rect(0, 0, 1000, 400), 0, rlc.LIGHTGRAY),
    EnvItem.new(rlm.rect(0, 400, 1000, 200), 1, rlc.GRAY),
    EnvItem.new(rlm.rect(300, 200, 400, 10), 1, rlc.GRAY),
    EnvItem.new(rlm.rect(250, 300, 100, 10), 1, rlc.GRAY),
    EnvItem.new(rlm.rect(650, 300, 100, 10), 1, rlc.GRAY),
}

local env_items_length = #env_items

local camera = rlm.camera2d()
camera.target = player.position
camera.offset = rlm.vec2(screen_width / 2.0, screen_height / 2.0)
camera.rotation = 0.0
camera.zoom = 1.0

local camera_updaters = { player.update, player.update_camera_center, player.update_camera_center_inside_map, player
    .update_camera_center_smooth_follow, player.update_camera_event_out_on_landings, player
    .update_camera_player_bounds_push_up }

local camera_option = 1
local camera_updaters_length = #camera_updaters

local camera_descriptors = {
    "Follow player center",
    "Follow player center, but clamp to map edges",
    "Follow player center; smoothed",
    "Follow player center horizontally; update player center vertically after landing",
    "Player push camera on getting too close to screen edge"
}

window:set_target_fps(60)

while not window:should_close() do
    local delta_time = window:get_frame_time()

    player:update(camera, env_items, env_items_length, delta_time, window)

    camera.zoom = camera.zoom + window:get_mouse_wheel_move() * 0.5

    if camera.zoom > 3.0 then camera.zoom = 3.0 elseif camera.zoom < 0.25 then camera.zoom = 0.25 end

    if window:is_key_pressed("R") then
        camera.zoom = 1.0
        player.position = rlm.vec2(400, 280)
    end

    if window:is_key_pressed("C") then camera_option = (camera_option + 1) % camera_updaters_length end

    local cu = camera_updaters[camera_option]

    camera_updaters[camera_option](player, camera, env_items, env_items_length, delta_time, screen_width,
        screen_height, window)

    window:begin_drawing()

    window:clear_background(rlc.LIGHTGRAY)

    window:begin_mode_2d(camera)

    for i = 1, env_items_length do
        window:draw_rectangle_rec(env_items[i].rect, env_items[i].color)
    end

    local player_rect = rlm.rect(player.position.x - 20, player.position.y - 40, 40.0, 40.0)
    window:draw_rectangle_rec(player_rect, rlc.RED)

    window:draw_circle_v(player.position, 5.0, rlc.GOLD)

    window:end_mode_2d()

    window:draw_text("Controls:", 20, 20, 10, rlc.BLACK)
    window:draw_text("- Right/Left to move", 40, 40, 10, rlc.DARKGRAY)
    window:draw_text("- Space to jump", 40, 60, 10, rlc.DARKGRAY)
    window:draw_text("- Mouse wheel to zoom in-out, R to reset zoom", 40, 80, 10, rlc.DARKGRAY)
    window:draw_text("- C to change camera mode", 40, 100, 10, rlc.DARKGRAY)
    window:draw_text("Current camera mode:", 20, 120, 10, rlc.BLACK)
    window:draw_text(camera_descriptors[camera_option], 40, 140, 10, rlc.DARKGRAY)

    window:end_drawing()
end

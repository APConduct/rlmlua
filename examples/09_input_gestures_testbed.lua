local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local GESTURE_LOG_SIZE = 20
local MAX_TOUCH_COUNT = 32

---@type fun(gesture: integer): string
local get_gesture_name
---@type fun(gesture: integer): Color
local get_gesture_color

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - input gestures testbed")

local message_position = rlm.vec2(160, 7)

local last_gesture = 0
local last_gesture_position = rlm.vec2(165, 130)

local gesture_log = { --[[""]] }

---@type integer
local gesture_log_index = GESTURE_LOG_SIZE
local previous_gesture = 0


-- Log mode values:
-- - 0 shows repeated events
-- - 1 hides repeated events
-- - 2 shows repeated events but hide hold events
-- - 3 hides repeated events and hide hold events
local log_mode = 1

local gesture_color = rl.color(0, 0, 0, 225)
local log_button1 = rlm.rect(53, 7, 48, 26)
local log_button2 = rlm.rect(108, 7, 36, 26)
local gesture_log_position = rlm.vec2(10, 10)

local angle_length = 90.0
local current_angle_degrees = 0.0
local final_vector = rlm.vec2(0.0, 0.0)
local current_angle_str = ""
local protractor_position = rlm.vec2(226.0, 315.0)

window:set_target_fps(60)

while not window:should_close() do
    local i
    local ii
    ---@type integer
    local current_gesture = window:get_gesture_detected()
    local current_drag_degrees = window:get_gesture_pitch_angle()
    local current_pinch_degrees = window:get_gesture_pinch_angle()
    local touch_count = window:get_touch_point_count()

    if window:is_mouse_button_released("LEFT") then
        if rl.check_collision_point_rec(window:get_mouse_position(), log_button1) then
            if log_mode == 3 then
                log_mode = 2
            elseif log_mode == 2 then
                log_mode = 3
            elseif log_mode == 1 then
                log_mode = 0
            else
                log_mode = 1
            end
        elseif rl.check_collision_point_rec(window:get_mouse_position(), log_button1) then
            if log_mode == 3 then
                log_mode = 1
            elseif log_mode == 2 then
                log_mode = 0
            elseif log_mode == 1 then
                log_mode = 3
            else
                log_mode = 2
            end
        end
    end

    local fill_log = 0
    if current_gesture ~= 0 then
        if log_mode == 3 then
            if (current_gesture ~= 4) and (current_gesture ~= previous_gesture) or (current_gesture < 3) then
                fill_log = 1
            end
        elseif log_mode == 2 then
            if current_gesture ~= 4 then
                fill_log = 1
            end
        elseif log_mode == 1 then
            if current_gesture ~= previous_gesture then
                fill_log = 1
            end
        else
            fill_log = 1
        end
    end

    if fill_log then
        previous_gesture = current_gesture
        gesture_color = get_gesture_color(current_gesture)
        if gesture_log_index <= 0 then
            gesture_log_index = GESTURE_LOG_SIZE
        end
        gesture_log_index = gesture_log_index - 1

        gesture_log[gesture_log_index] = get_gesture_name(current_gesture)
    end

    if current_gesture < 225 then
        current_angle_degrees = current_pinch_degrees
    elseif current_gesture > 15 then
        current_angle_degrees = current_drag_degrees
    elseif current_gesture > 0 then
        current_angle_degrees = 0.0
    end

    local current_angle_radians = ((current_angle_degrees + 90.0) * math.pi / 180)
    final_vector = rlm.vec2((angle_length * math.sin(current_angle_radians)) + protractor_position.x,
        (angle_length * math.cos(current_angle_radians)) + protractor_position.y)

    local touch_position = {
        -- This is a propogation to ensure that 'MAX_TOUCH_COUNT' is used
        __len = function(self)
            return MAX_TOUCH_COUNT
        end
    }
    local mouse_position = rlm.vec2(0, 0)
    if current_gesture ~= rl.GESTURE_NONE then
        if touch_count ~= 0 then
            ---@diagnostic disable-next-line: redefined-local
            for i = 1, touch_count do
                touch_position[i] = window:get_touch_position(i) -- Fill the touch positions
            end
        else
            mouse_position = window:get_mouse_position()
        end
    end

    window:begin_drawing()
    window:clear_background(rlc.RAYWHITE)

    window:draw_text("*", message_position.x + 5, message_position.y + 5, 10, rlc.BLACK)
    window:draw_text("Example optimized for Web/HTML5\non Smartphones with Touch Screen.", message_position.x + 15,
        message_position.y + 5, 10, rlc.BLACK)
    window:draw_text("*", message_position.x + 5, message_position.y + 35, 10, rlc.BLACK)
    window:draw_text("While running on Desktop Web Browsers,\ninspect and turn on Touch Emulation.",
        message_position.x + 15, message_position.y + 35, 10, rlc.BLACK)

    window:draw_text("Last gesture", last_gesture_position.x + 33, last_gesture_position.y - 47, 20, rlc.BLACK)
    window:draw_text("Swipe         Tap       Pinch  Touch", last_gesture_position.x + 17, last_gesture_position.y - 18,
        10, rlc.BLACK)
    local function ternary(condition, value_if_true, value_if_false)
        if condition then
            return value_if_true
        else
            return value_if_false
        end
    end

    local result = ternary(a == b, "yes", "no")

    window:draw_rectangle(last_gesture_position.x + 20, last_gesture_position.y, 20, 20,
        ternary(last_gesture == rl.GESTURE_SWIPE_UP, rlc.RED, rlc.LIGHTGRAY))
    window:draw_rectangle(last_gesture_position.x, last_gesture_position.y + 20, 20, 20,
        ternary(last_gesture == rl.GESTURE_SWIPE_LEFT, rlc.RED, rlc.LIGHTGRAY))
    window:draw_rectangle(last_gesture_position.x + 40, last_gesture_position.y + 20, 20, 20,
        ternary(last_gesture == rl.GESTURE_SWIPE_RIGHT, rlc.RED, rlc.LIGHTGRAY))
    window:draw_rectangle(last_gesture_position.x + 20, last_gesture_position.y + 40, 20, 20,
        ternary(last_gesture == rl.GESTURE_SWIPE_DOWN, rlc.RED, rlc.LIGHTGRAY))
    window:draw_circle(last_gesture_position.x + 80, last_gesture_position.y + 16, 10,
        ternary(last_gesture == rl.GESTURE_TAP, rlc.BLUE, rlc.LIGHTGRAY))
    window:draw_ring(rlm.vec2(last_gesture_position.x + 103, last_gesture_position.y + 16), 6.0, 11.0, 0.0, 360.0, 0,
        ternary(last_gesture == rl.GESTURE_DRAG, rlc.LIME, rlc.LIGHTGRAY))
    window:draw_circle(last_gesture_position.x + 80, last_gesture_position.y + 43, 10,
        ternary(last_gesture == rl.GESTURE_DOUBLETAP, rlc.SKYBLUE))
    window:draw_circle(last_gesture_position.x + 103, last_gesture_position.y + 43, 10,
        ternary(last_gesture == rl.GESTURE_DOUBLETAP, rlc.SKYBLUE, rlc.LIGHTGRAY))
    window:draw_triangle(rlm.vec2(last_gesture_position.x + 122, last_gesture_position.y + 16),
        rlm.vec2(last_gesture_position.x + 137, last_gesture_position.y + 26),
        rlm.vec2(last_gesture_position.x + 137, last_gesture_position.y + 6),
        ternary(last_gesture == rl.GESTURE_PINCH_OUT, rlc.ORANGE, rlc.LIGHTGRAY))
    window:draw_triangle(rlm.vec2(last_gesture_position.x + 147, last_gesture_position.y + 6),
        rlm.vec2(last_gesture_position.x + 147, last_gesture_position.y + 26),
        rlm.vec2(last_gesture_position.x + 162, last_gesture_position.y + 16),
        ternary(last_gesture == rl.GESTURE_PINCH_OUT, rlc.ORANGE, rlc.LIGHTGRAY))
    window:draw_triangle(rlm.vec2(last_gesture_position.x + 125, last_gesture_position.y + 33),
        rlm.vec2(last_gesture_position.x + 125, last_gesture_position.y + 53),
        rlm.vec2(last_gesture_position.x + 140, last_gesture_position.y + 43),
        ternary(last_gesture == rl.GESTURE_PINCH_IN, rlc.VIOLET, rlc.LIGHTGRAY))
    window:draw_triangle(rlm.vec2(last_gesture_position.x + 144, last_gesture_position.y + 43),
        rlm.vec2(last_gesture_position.x + 159, last_gesture_position.y + 53),
        rlm.vec2(last_gesture_position.x + 159, last_gesture_position.y + 33),
        ternary(last_gesture == rl.GESTURE_PINCH_IN, rlc.VIOLET, rlc.LIGHTGRAY))

    window:draw_text("Log", gesture_log_position.x, gesture_log_position.y, 20, rlc.BLACK)

    ---@diagnostic disable-next-line: redefined-local
    for i = 0, GESTURE_LOG_SIZE - 1 do
        ---@diagnostic disable-next-line: redefined-local
        local ii = (gesture_log_index + i) % GESTURE_LOG_SIZE
        if gesture_log[ii] then
            window:draw_text(gesture_log[ii], gesture_log_position.x, gesture_log_position.y + 410 - i * 20, 20,
                i == 0 and gesture_color or rlc.LIGHTGRAY)
        end
    end

    local log_button1_color, log_button2_color
    if log_mode == 3 then
        log_button1_color = rlc.MAROON
        log_button2_color = rlc.MAROON
    elseif log_mode == 2 then
        log_button1_color = rlc.GRAY
        log_button2_color = rlc.MAROON
    elseif log_mode == 1 then
        log_button1_color = rlc.MAROON
        log_button2_color = rlc.GRAY
    else
        log_button1_color = rlc.GRAY
        log_button2_color = rlc.GRAY
    end

    window:draw_rectangle_rec(log_button1, log_button1_color)
    window:draw_text("Hide", log_button1.x + 7, log_button1.y + 3, 10, rlc.WHITE)
    window:draw_text("Repeat", log_button1.x + 7, log_button1.y + 13, 10, rlc.WHITE)
    window:draw_rectangle_rec(log_button2, log_button2_color)
    window:draw_text("Hide", log_button1.x + 62, log_button1.y + 3, 10, rlc.WHITE)
    window:draw_text("Hold", log_button1.x + 62, log_button1.y + 13, 10, rlc.WHITE)

    -- Draw protractor
    window:draw_text("Angle", math.floor(protractor_position.x + 55), math.floor(protractor_position.y + 76), 10,
        rlc.BLACK)
    local angle_string = string.format("%f", current_angle_degrees)
    local angle_string_dot = string.find(angle_string, "%.")
    local angle_string_trim = string.sub(angle_string, 1, (angle_string_dot or 0) + 2)
    window:draw_text(angle_string_trim, math.floor(protractor_position.x + 55), math.floor(protractor_position.y + 92),
        20, gesture_color)
    window:draw_circle_v(protractor_position, 80.0, rlc.WHITE)
    window:draw_line_ex(rlm.vec2(protractor_position.x - 90, protractor_position.y),
        rlm.vec2(protractor_position.x + 90, protractor_position.y), 3.0, rlc.LIGHTGRAY)
    window:draw_line_ex(rlm.vec2(protractor_position.x, protractor_position.y - 90),
        rlm.vec2(protractor_position.x, protractor_position.y + 90), 3.0, rlc.LIGHTGRAY)
    window:draw_line_ex(rlm.vec2(protractor_position.x - 80, protractor_position.y - 45),
        rlm.vec2(protractor_position.x + 80, protractor_position.y + 45), 3.0, rlc.GREEN)
    window:draw_line_ex(rlm.vec2(protractor_position.x - 80, protractor_position.y + 45),
        rlm.vec2(protractor_position.x + 80, protractor_position.y - 45), 3.0, rlc.GREEN)
    window:draw_text("0", math.floor(protractor_position.x + 96), math.floor(protractor_position.y - 9), 20, rlc.BLACK)
    window:draw_text("30", math.floor(protractor_position.x + 74), math.floor(protractor_position.y - 68), 20, rlc.BLACK)
    window:draw_text("90", math.floor(protractor_position.x - 11), math.floor(protractor_position.y - 110), 20, rlc
        .BLACK)
    window:draw_text("150", math.floor(protractor_position.x - 100), math.floor(protractor_position.y - 68), 20,
        rlc.BLACK)
    window:draw_text("180", math.floor(protractor_position.x - 124), math.floor(protractor_position.y - 9), 20, rlc
        .BLACK)
    window:draw_text("210", math.floor(protractor_position.x - 100), math.floor(protractor_position.y + 50), 20,
        rlc.BLACK)
    window:draw_text("270", math.floor(protractor_position.x - 18), math.floor(protractor_position.y + 92), 20, rlc
        .BLACK)
    window:draw_text("330", math.floor(protractor_position.x + 72), math.floor(protractor_position.y + 50), 20, rlc
        .BLACK)
    if current_angle_degrees ~= 0.0 then
        window:draw_line_ex(protractor_position, final_vector, 3.0, gesture_color)
    end

    -- Draw touch and mouse pointer points
    if current_gesture ~= rl.GESTURE_NONE then
        if touch_count ~= 0 then
            for i = 1, touch_count do
                window:draw_circle_v(touch_position[i], 50.0, rl.fade(gesture_color, 0.5))
                window:draw_circle_v(touch_position[i], 5.0, gesture_color)
            end

            if touch_count == 2 then
                window:draw_line_ex(touch_position[1], touch_position[2],
                    current_gesture == 512 and 8.0 or 12.0, gesture_color)
            end
        else
            window:draw_circle_v(mouse_position, 35.0, rl.fade(gesture_color, 0.5))
            window:draw_circle_v(mouse_position, 5.0, gesture_color)
        end
    end

    window:end_drawing()
end
window:close()


---get text string for gesture value
---@param gesture integer
---@return string
local get_gesture_name = function(gesture)
    if gesture == 0 then
        return "None"
    elseif gesture == 1 then
        return "Tap"
    elseif gesture == 2 then
        return "Double Tap"
    elseif gesture == 3 then
        return "Hold"
    elseif gesture == 4 then
        return "Drag"
    elseif gesture == 5 then
        return "Swipe Right"
    elseif gesture == 6 then
        return "Swipe Left"
    elseif gesture == 7 then
        return "Swipe Up"
    elseif gesture == 8 then
        return "Swipe Down"
    elseif gesture == 9 then
        return "Pinch In"
    elseif gesture == 10 then
        return "Pinch Out"
    else
        return "Unknown"
    end
end


---get color for gesture value
---@param gesture integer
---@return Color
local get_gesture_color = function(gesture)
    if gesture == 0 then
        return rlc.BLACK
    elseif gesture == 1 then
        return rlc.BLUE
    elseif gesture == 2 then
        return rlc.SKYBLUE
    elseif gesture == 4 then
        return rlc.BLACK
    elseif gesture == 8 then
        return rlc.LIME
    elseif gesture == 16 then
        return rlc.RED
    elseif gesture == 32 then
        return rlc.RED
    elseif gesture == 64 then
        return rlc.RED
    elseif gesture == 128 then
        return rlc.RED
    elseif gesture == 256 then
        return rlc.VIOLET
    elseif gesture == 512 then
        return rlc.ORANGE
    else
        return rlc.BLACK
    end
end

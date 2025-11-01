local MAX_GESTURE_STRINGS = 20



local rl = require("raylib")
local rlm = require("rlmlua")
local rlc = rl.colors

local screen_width = 800
local screen_height = 450

local window = rl.init_window(screen_width, screen_height, "rlmlua example - input gestures")

local touch_position = rlm.vec2(0, 0)
local touch_area = rlm.rect(220, 10, screen_width - 230.0, screen_height - 20.0)

local gesture_count = 0
local gesture_strings = {}

local current_gesture = rl.GESTURE_NONE
local last_gesture = rl.GESTURE_NONE

window:set_target_fps(60)

while not window:should_close() do
    last_gesture = current_gesture
    current_gesture = window:get_gesture_detected()
    touch_position = window:get_touch_position(0)

    if rl.check_collision_point_rec(touch_position, touch_area) and (current_gesture ~= rl.GESTURE_NONE) then
        if current_gesture ~= last_gesture then
            if current_gesture == rl.GESTURE_TAP then
                gesture_strings[gesture_count + 1] = "GESTURE TAP"
            elseif current_gesture == rl.GESTURE_DOUBLETAP then
                gesture_strings[gesture_count + 1] = "GESTURE DOUBLETAP"
            elseif current_gesture == rl.GESTURE_HOLD then
                gesture_strings[gesture_count + 1] = "GESTURE HOLD"
            elseif current_gesture == rl.GESTURE_DRAG then
                gesture_strings[gesture_count + 1] = "GESTURE DRAG"
            elseif current_gesture == rl.GESTURE_SWIPE_RIGHT then
                gesture_strings[gesture_count + 1] = "GESTURE SWIPE RIGHT"
            elseif current_gesture == rl.GESTURE_SWIPE_LEFT then
                gesture_strings[gesture_count + 1] = "GESTURE SWIPE LEFT"
            elseif current_gesture == rl.GESTURE_SWIPE_UP then
                gesture_strings[gesture_count + 1] = "GESTURE SWIPE UP"
            elseif current_gesture == rl.GESTURE_SWIPE_DOWN then
                gesture_strings[gesture_count + 1] = "GESTURE SWIPE DOWN"
            elseif current_gesture == rl.GESTURE_PINCH_IN then
                gesture_strings[gesture_count + 1] = "GESTURE PINCH IN"
            elseif current_gesture == rl.GESTURE_PINCH_OUT then
                gesture_strings[gesture_count + 1] = "GESTURE PINCH OUT"
            end

            gesture_count = gesture_count + 1


            if gesture_count >= MAX_GESTURE_STRINGS then
                for i = 1, MAX_GESTURE_STRINGS do
                    gesture_strings[i] = nil
                end
                gesture_count = 0
            end
        end
    end

    window:begin_drawing()

    window:clear_background(rlc.RAYWHITE)

    window:draw_rectangle_rec(touch_area, rlc.GRAY)
    window:draw_rectangle(225, 15, screen_width - 240, screen_height - 40, 20, rl.fade(rlc.GRAY, 0.5))

    for i = 1, gesture_count do
        if i % 2 == 0 then
            window:draw_rectangle(10, 30 + 20 * i, 200, 20, rl.fade(rlc.GRAY, 0.5))
        else
            window:draw_rectangle(10, 30 + 20 * i, 200, 20, rl.fade(rlc.LIGHTGRAY, 0.3))
        end
    end

    window:draw_rectangle_lines(10, 29, 200, screen_height - 50, rlc.GRAY)
    window:draw_text("DETECTED GESTURES", 50, 15, 10, rlc.GRAY)

    if current_gesture ~= rl.GESTURE_NONE then
        window:draw_circle_v(touch_position, 30, rlc.MAROON)
    end

    window:end_drawing()
end
window:close()

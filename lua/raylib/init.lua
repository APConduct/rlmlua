-- Main raylib module entry point

local raylib_core = require("raylib_lua")

---@class raylib
local rl = {}

-- Re-export core functions
rl.init_window = raylib_core.init_window
rl.color = raylib_core.color
rl.colors = raylib_core.colors
rl.Vector2 = raylib_core.Vector2
rl.Vector3 = raylib_core.Vector3

---@type fun(point: Vector2, rect: Rectangle): boolean
rl.check_collision_point_rec = raylib_core.check_collision_point_rec

---@type fun(color: Color, alpha: number): Color
rl.fade = raylib_core.fade

---@type Gesture
rl.GESTURE_NONE = raylib_core.GESTURE_NONE
---@type Gesture
rl.GESTURE_DRAG = raylib_core.GESTURE_DRAG
---@type Gesture
rl.GESTURE_PINCH_IN = raylib_core.GESTURE_PINCH_IN
---@type Gesture
rl.GESTURE_PINCH_OUT = raylib_core.GESTURE_PINCH_OUT
---@type Gesture
rl.GESTURE_SWIPE_RIGHT = raylib_core.GESTURE_SWIPE_RIGHT
---@type Gesture
rl.GESTURE_SWIPE_LEFT = raylib_core.GESTURE_SWIPE_LEFT
---@type Gesture
rl.GESTURE_SWIPE_UP = raylib_core.GESTURE_SWIPE_UP
---@type Gesture
rl.GESTURE_SWIPE_DOWN = raylib_core.GESTURE_SWIPE_DOWN
---@type Gesture
rl.GESTURE_HOLD = raylib_core.GESTURE_HOLD
---@type Gesture
rl.GESTURE_TAP = raylib_core.GESTURE_TAP
---@type Gesture
rl.GESTURE_DOUBLETAP = raylib_core.GESTURE_DOUBLETAP

-- Helper: Safe drawing wrapper with automatic begin/end
-- This prevents forgetting to call end_drawing and handles errors gracefully
---@param window Window
---@param callback fun(window: Window)
---@diagnostic disable-next-line: duplicate-set-field
function rl.draw(window, callback)
    window:begin_drawing()
    local success, err = pcall(callback, window)
    window:end_drawing()

    if not success then
        error(err, 2)
    end
end

return rl

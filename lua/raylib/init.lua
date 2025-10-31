-- Main raylib module entry point

local raylib_core = require("raylib_lua")

---@class raylib
local rl = {}

-- Re-export core functions
rl.init_window = raylib_core.init_window
rl.color = raylib_core.color
rl.colors = raylib_core.colors

-- Helper: Safe drawing wrapper with automatic begin/end
-- This prevents forgetting to call end_drawing and handles errors gracefully
---@param window Window
---@param callback fun(window: Window)
function rl.draw(window, callback)
    window:begin_drawing()
    local success, err = pcall(callback, window)
    window:end_drawing()

    if not success then
        error(err, 2)
    end
end

return rl

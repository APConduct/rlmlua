local rl = require("raylib")
local socket = require("socket")  -- If available

local window = rl.init_window(800, 450, "Manual Sync Test")
window:set_target_fps(60)

local target_time = 1/60
local frame = 0

while not window:window_should_close() and frame < 180 do
    local start_time = os.clock()
    frame = frame + 1
    
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Frame: " .. frame, 10, 10, 30, rl.colors.BLACK)
    window:draw_text("Hello, World!", 250, 200, 40, rl.colors.DARKBLUE)
    window:end_drawing()
    
    -- Calculate how long to wait
    local elapsed = os.clock() - start_time
    local wait_time = target_time - elapsed
    
    if wait_time > 0 then
        -- Busy wait (not ideal but works for testing)
        local wait_until = os.clock() + wait_time
        while os.clock() < wait_until do end
    end
    
    if frame % 60 == 0 then
        print("Frame " .. frame .. ", measured FPS: " .. math.floor(1/elapsed))
    end
end

print("Done")

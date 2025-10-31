#!/usr/bin/env lua
-- Simple example to demonstrate usage after installing with luarocks
-- After running 'luarocks install rlmlua' or 'luarocks make --local',
-- you can run this script with just: lua 00_simple_after_install.lua

local rl = require("raylib")

print("rlmlua - Simple Example")
print("This demonstrates that the library is properly installed!")
print("")

-- Create window
local window = rl.init_window(600, 400, "rlmlua - After Installation Example")
window:set_target_fps(60)

-- Simple state
local circle_x = 300
local circle_y = 200
local time = 0

print("Window created. Controls:")
print("  - Move mouse to control the circle")
print("  - Press ESC or close window to exit")
print("")

-- Main loop
while not window:window_should_close() do
    -- Update
    local mouse_x, mouse_y = window:get_mouse_position()
    circle_x = mouse_x
    circle_y = mouse_y
    time = time + window:get_frame_time()

    -- Calculate pulsing effect
    local pulse = math.abs(math.sin(time * 2)) * 20 + 30

    -- Draw
    window:begin_drawing()

    -- Background with gradient effect
    window:clear_background(rl.colors.DARKBLUE)

    -- Draw title
    window:draw_text("rlmlua is installed!", 150, 30, 30, rl.colors.RAYWHITE)
    window:draw_text("Move your mouse around", 180, 70, 20, rl.colors.LIGHTGRAY)

    -- Draw decorative border
    window:draw_rectangle_lines(10, 10, 580, 380, rl.colors.SKYBLUE)
    window:draw_rectangle_lines(15, 15, 570, 370, rl.colors.SKYBLUE)

    -- Draw interactive circle that follows mouse
    window:draw_circle(circle_x, circle_y, pulse, rl.colors.YELLOW)
    window:draw_circle_lines(circle_x, circle_y, pulse + 5, rl.colors.GOLD)

    -- Draw some info
    local fps = window:get_fps()
    window:draw_text("FPS: " .. fps, 10, 360, 20, rl.colors.LIME)
    window:draw_text("Press ESC to exit", 450, 360, 16, rl.colors.GRAY)

    -- Draw some decorative circles at corners
    local corner_colors = { rl.colors.RED, rl.colors.GREEN, rl.colors.BLUE, rl.colors.PURPLE }
    local corner_positions = { { 40, 40 }, { 560, 40 }, { 40, 360 }, { 560, 360 } }
    for i, pos in ipairs(corner_positions) do
        window:draw_circle(pos[1], pos[2], 15, corner_colors[i])
    end

    window:end_drawing()
end

print("")
print("Thanks for trying rlmlua!")
print("Check out more examples in the examples/ directory")

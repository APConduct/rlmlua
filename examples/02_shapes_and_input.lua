local rl = require("raylib")

-- Initialize window
local window = rl.init_window(800, 600, "rlmlua - Shapes and Input Demo")
window:set_target_fps(60)

-- Circle position (controlled by mouse)
local circle_x = 400
local circle_y = 300
local circle_radius = 30

-- Rectangle position (controlled by arrow keys)
local rect_x = 100
local rect_y = 100
local rect_speed = 3

-- Pixel drawing mode toggle
local draw_pixels = false

print("Controls:")
print("- Arrow keys: Move the green rectangle")
print("- Mouse: Move the purple circle")
print("- P key: Toggle pixel drawing mode")
print("- ESC: Close window")

while not window:window_should_close() do
    -- Input handling
    if window:is_key_down("RIGHT") then
        rect_x = rect_x + rect_speed
    end
    if window:is_key_down("LEFT") then
        rect_x = rect_x - rect_speed
    end
    if window:is_key_down("DOWN") then
        rect_y = rect_y + rect_speed
    end
    if window:is_key_down("UP") then
        rect_y = rect_y - rect_speed
    end

    if window:is_key_pressed("P") then
        draw_pixels = not draw_pixels
        print("Pixel mode:", draw_pixels)
    end

    -- Get mouse position for circle
    local mouse_x, mouse_y = window:get_mouse_position()
    circle_x = mouse_x
    circle_y = mouse_y

    -- Keep rectangle in bounds
    if rect_x < 0 then rect_x = 0 end
    if rect_x > 750 then rect_x = 750 end
    if rect_y < 0 then rect_y = 0 end
    if rect_y > 550 then rect_y = 550 end

    -- Drawing
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    -- Draw title
    window:draw_text("rlmlua Shapes Demo", 10, 10, 20, rl.colors.DARKGRAY)

    -- Draw FPS
    local fps = window:get_fps()
    window:draw_text("FPS: " .. fps, 700, 10, 20, rl.colors.GREEN)

    -- Draw instructions
    window:draw_text("Arrow keys to move rectangle", 10, 40, 16, rl.colors.GRAY)
    window:draw_text("Mouse to move circle", 10, 60, 16, rl.colors.GRAY)
    window:draw_text("Press P for pixel mode", 10, 80, 16, rl.colors.GRAY)

    -- Draw shapes
    window:draw_rectangle(rect_x, rect_y, 50, 50, rl.colors.GREEN)
    window:draw_rectangle_lines(rect_x, rect_y, 50, 50, rl.colors.DARKGREEN)

    window:draw_circle(circle_x, circle_y, circle_radius, rl.colors.PURPLE)
    window:draw_circle_lines(circle_x, circle_y, circle_radius, rl.colors.DARKPURPLE)

    -- Draw a static line
    window:draw_line(0, 500, 800, 500, rl.colors.RED)

    -- Draw some decorative rectangles
    window:draw_rectangle(700, 500, 80, 80, rl.colors.ORANGE)
    window:draw_rectangle_lines(700, 500, 80, 80, rl.colors.BLACK)

    -- Draw pixels if in pixel mode
    if draw_pixels then
        for i = 0, 799, 10 do
            for j = 0, 599, 10 do
                local r = (i / 800) * 255
                local g = (j / 600) * 255
                local b = 128
                window:draw_pixel(i, j, rl.color(r, g, b, 255))
            end
        end
    end

    -- Draw some circles along the bottom
    for i = 0, 7 do
        local x = 50 + i * 100
        local y = 550
        local color = (i % 2 == 0) and rl.colors.BLUE or rl.colors.SKYBLUE
        window:draw_circle(x, y, 20, color)
    end

    window:end_drawing()
end

print("Window closed. Goodbye!")

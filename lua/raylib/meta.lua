---@meta raylib

---Raylib bindings for Lua (with snake-case API)
---@class raylib
local raylib = {}

---@class Color
---@field [1] integer Red component (0-255)
---@field [2] integer Green component (0-255)
---@field [3] integer Blue component (0-255)
---@field [4] integer Alpha component (0-255, default 255)

---@class Vector2
---@field x number X coordinate
---@field y number Y coordinate

---@class Vector3
---@field x number X coordinate
---@field y number Y coordinate
---@field z number Z coordinate

---@class Rectangle
---@field x number X position
---@field y number Y position
---@field width number Rectangle width
---@field height number Rectangle height

---@class Gesture
---@field None Gesture
---@field Drag Gesture
---@field SwipeRight Gesture
---@field SwipeLeft Gesture
---@field SwipeUp Gesture
---@field SwipeDown Gesture
---@field PinchIn Gesture
---@field PinchOut Gesture
---@field DoubleTap Gesture
---@field Tap Gesture
---@field Hold Gesture

---Raylib window handle
---@class Window
local Window = {}

---Check if window close button or ESC was pressed
---@param self Window
---@return boolean
function Window:should_close() end

---Set target FPS (maximum)
---@param self Window
---@param fps integer
---@return nil
function Window:set_target_fps(fps) end

---Get current FPS
---@param self Window
---@return integer
function Window:get_fps() end

---Get time in seconds for last frame drawn
---@param self Window
---@return number
function Window:get_frame_time() end

---Get elapsed time in seconds since window was initialized
---@param self Window
---@return number
function Window:get_time() end

---Setup canvas (framebuffer) to start drawing
---@param self Window
---@return nil
function Window:begin_drawing() end

---End canvas drawing and swap buffers (double buffering)
---@param self Window
---@return nil
function Window:end_drawing() end

---Set background color (clear screen)
---@param self Window
---@param color Color
---@return nil
function Window:clear_background(color) end

---Draw text (using default font)
---@param self Window
---@param text string
---@param x integer
---@param y integer
---@param size integer
---@param color Color
---@return nil
function Window:draw_text(text, x, y, size, color) end

---Draw a color-filled rectangle
---@param self Window
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param color Color
---@return nil
function Window:draw_rectangle(x, y, width, height, color) end

---Draw a color-filled rectangle
---@param self Window
---@param rect Rectangle
---@param color Color
---@return nil
function Window:draw_rectangle_rec(rect, color) end

---Draw a color-filled circle
---@param self Window
---@param x integer
---@param y integer
---@param radius number
---@param color Color
---@return nil
function Window:draw_circle(x, y, radius, color) end

---Draw line
---@param self Window
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param color Color
---@return nil
function Window:draw_line(x1, y1, x2, y2, color) end

---Draw pixel
---@param self Window
---@param x integer
---@param y integer
---@param color Color
---@return nil
function Window:draw_pixel(x, y, color) end

---Draw rectangle outline
---@param self Window
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param color Color
---@return nil
function Window:draw_rectangle_lines(x, y, width, height, color) end

---Draw circle outline
---@param self Window
---@param x integer
---@param y integer
---@param radius number
---@param color Color
---@return nil
function Window:draw_circle_lines(x, y, radius, color) end

---Draw circle outline
---@param self Window
---@param v Vector2
---@param radius number
---@param color Color
---@return nil
function Window:draw_circle_v(v, radius, color) end

---Check if a key has been pressed once
---@param self Window
---@param key string
---@return boolean
function Window:is_key_pressed(key) end

---Check if a key is being pressed
---@param self Window
---@param key string
---@return boolean
function Window:is_key_down(key) end

---Check if a key has been released once
---@param self Window
---@param key string
---@return boolean
function Window:is_key_released(key) end

---Check if a key is NOT being pressed
---@param self Window
---@param key string
---@return boolean
function Window:is_key_up(key) end

---Get mouse position X and Y
---@param self Window
---@return Vector2
function Window:get_mouse_position() end

---Get mouse position X
---@param self Window
---@return number
function Window:get_mouse_x() end

---Get mouse position Y
---@param self Window
---@return number
function Window:get_mouse_y() end

---Check if a mouse button has been pressed once ("LEFT"=left, "RIGHT"=right, "MIDDLE"=middle, "EXTRA"=extra, "BACK"=back, "FORWARD"=forward)
---@param self Window
---@param button string
---@return boolean
function Window:is_mouse_button_pressed(button) end

---Check if a mouse button is being pressed
---@param self Window
---@param button string
---@return boolean
function Window:is_mouse_button_down(button) end

---Check if a mouse button has been released once
---@param self Window
---@param button string
---@return boolean
function Window:is_mouse_button_released(button) end

---Check if a mouse button is NOT being pressed
---@param self Window
---@param button string
---@return boolean
function Window:is_mouse_button_up(button) end

---Check if the cursor is hidden
---@param self Window
---@return boolean
function Window:is_cursor_hidden() end

---Get the width of the screen
---@param self Window
---@return number
function Window:get_screen_width() end

---Get the height of the screen
---@param self Window
---@return number
function Window:get_screen_height() end

---Get the x position of the mouse
---@param self Window
---@return number
function Window:get_mouse_x() end

---Get the y position of the mouse
---@param self Window
---@return number
function Window:get_mouse_y() end

---Check if a mouse button is being pressed
---@param self Window
---@param button integer
---@return boolean
function Window:get_mouse_button(button) end

---Get the scroll wheel position
---@param self Window
---@return number
function Window:get_mouse_wheel_move() end

---Close the window
---@param self Window
---@return nil
function Window:close() end

---Get the detected gesture
---@param self Window
---@return Gesture
function Window:get_gesture_detected() end

---Get the position of a touch
---@param self Window
---@param index integer
---@return Vector2
function Window:get_touch_position(index) end

---Initialize window and OpenGL context
---@param width integer Window width
---@param height integer Window height
---@param title string Window title
---@return Window
function raylib.init_window(width, height, title) end

---Create a color from RGBA values
---@param r integer Red (0-255)
---@param g integer Green (0-255)
---@param b integer Blue (0-255)
---@param a? integer Alpha (0-255, default 255)
---@return Color
function raylib.color(r, g, b, a) end

---Convenience function for safe drawing with automatic begin/end
---@param window Window The window to draw on
---@param callback fun(window: Window) Drawing callback function
function raylib.draw(window, callback) end

---Predefined color constants
---@class Colors
---@field WHITE Color White (255, 255, 255, 255)
---@field BLACK Color Black (0, 0, 0, 255)
---@field RED Color Red (255, 0, 0, 255)
---@field GREEN Color Green (0, 255, 0, 255)
---@field BLUE Color Blue (0, 0, 255, 255)
---@field YELLOW Color Yellow (255, 255, 0, 255)
---@field MAGENTA Color Magenta (255, 0, 255, 255)
---@field CYAN Color Cyan (0, 255, 255, 255)
---@field GRAY Color Gray (130, 130, 130, 255)
---@field DARKGRAY Color Dark Gray (80, 80, 80, 255)
---@field LIGHTGRAY Color Light Gray (200, 200, 200, 255)
---@field SKYBLUE Color Sky Blue (102, 191, 255, 255)
---@field ORANGE Color Orange (255, 161, 0, 255)
---@field PURPLE Color Purple (200, 122, 255, 255)
---@field RAYWHITE Color Ray White (245, 245, 245, 255)
---@field DARKBLUE Color Dark Blue (0, 0, 128, 255)
---@field LIME Color Lime (0, 255, 0, 255)
---@field GOLD Color Gold (255, 201, 0, 255)
---@field MAROON Color Maroon (128, 0, 0, 255)
---@field BEIGE Color Beige (211, 176, 131, 255)
raylib.colors = {}

---Key string constants for keyboard input
---Supported keys: "SPACE", "ESCAPE", "ENTER", "TAB", "BACKSPACE",
---"UP", "DOWN", "LEFT", "RIGHT", "A"-"Z", "0"-"9",
---"F1"-"F12", "SHIFT", "CTRL", "ALT"

return raylib

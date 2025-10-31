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

---Raylib window handle
---@class Window
local Window = {}

---Check if window close button or ESC was pressed
---@param self Window
---@return boolean
function Window:window_should_close() end

---Set target FPS (maximum)
---@param self Window
---@param fps number
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
---@param x number
---@param y number
---@param size number
---@param color Color
---@return nil
function Window:draw_text(text, x, y, size, color) end

---Draw a color-filled rectangle
---@param self Window
---@param x number
---@param y number
---@param width number
---@param height number
---@param color Color
---@return nil
function Window:draw_rectangle(x, y, width, height, color) end

---Draw a color-filled circle
---@param self Window
---@param x number
---@param y number
---@param radius number
---@param color Color
---@return nil
function Window:draw_circle(x, y, radius, color) end

---Draw line
---@param self Window
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param color Color
---@return nil
function Window:draw_line(x1, y1, x2, y2, color) end

---Check if key was pressed once
---@param self Window
---@param key number
---@return boolean
function Window:is_key_pressed(key) end

---Check if key is being held down
---@param self Window
---@param key number
---@return boolean
function Window:is_key_down(key) end

---Get mouse position X and Y
---@param self Window
---@return number, number
function Window:get_mouse_position() end

---Check if mouse button pressed (0=left, 1=right, 2=middle)
---@param self Window
---@return boolean
function Window:is_mouse_button_pressed() end

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

---Predefined colors
---@class Colors
---@field WHITE Color
---@field BLACK Color
---@field RED Color
---@field GREEN Color
---@field BLUE Color
---@field YELLOW Color
---@field MAGENTA Color
---@field GRAY Color
---@field SKYBLUE Color
raylib.colors = {}

return raylib

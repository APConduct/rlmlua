---@meta rlmlua

---Math and utility helpers for raylib
---@class rlmlua
local rlmlua = {}

---Reference to raylib module (auto-loaded for convenience)
---@type raylib
rlmlua.raylib = nil

---Create a 2D vector
---@param x number X coordinate
---@param y number Y coordinate
---@return Vector2
function rlmlua.vec2(x, y) end

---Create a 3D vector
---@param x number X coordinate
---@param y number Y coordinate
---@param z number Z coordinate
---@return Vector3
function rlmlua.vec3(x, y, z) end

---Add two 2D vectors
---@param a Vector2
---@param b Vector2
---@return Vector2
function rlmlua.vec2_add(a, b) end

---Subtract two 2D vectors
---@param a Vector2
---@param b Vector2
---@return Vector2
function rlmlua.vec2_sub(a, b) end

---Scale a 2D vector
---@param v Vector2
---@param s number Scale factor
---@return Vector2
function rlmlua.vec2_scale(v, s) end

---Get length of a 2D vector
---@param v Vector2
---@return number
function rlmlua.vec2_length(v) end

---Normalize a 2D vector
---@param v Vector2
---@return Vector2
function rlmlua.vec2_normalize(v) end

---Calculate distance between two points
---@param a Vector2
---@param b Vector2
---@return number
function rlmlua.distance(a, b) end

---Dot product of two 2D vectors
---@param a Vector2
---@param b Vector2
---@return number
function rlmlua.vec2_dot(a, b) end

---Linear interpolation between two 2D vectors
---@param a Vector2 Start vector
---@param b Vector2 End vector
---@param t number Interpolation factor (0-1)
---@return Vector2
function rlmlua.vec2_lerp(a, b, t) end

---Create a rectangle
---@param x number X position
---@param y number Y position
---@param width number Rectangle width
---@param height number Rectangle height
---@return Rectangle
function rlmlua.rect(x, y, width, height) end

---Create a 2D camera---@param offset Vector2|nil Camera offset
---@param target Vector2|nil Camera target
---@param rotation number|nil Camera rotation
---@param zoom number|nil Camera zoom
---@return Camera2D
function rlmlua.camera2d(offset, target, rotation, zoom) end

---Check if point is inside rectangle
---@param rect Rectangle
---@param x number Point X coordinate
---@param y number Point Y coordinate
---@return boolean
function rlmlua.rect_contains_point(rect, x, y) end

---Check if two rectangles overlap
---@param a Rectangle
---@param b Rectangle
---@return boolean
function rlmlua.rect_overlaps(a, b) end

---Create color from hex string
---@param hex string Hex color (e.g., "#ff0000" or "ff0000")
---@return Color
function rlmlua.color_from_hex(hex) end

---Create color from HSV values
---@param h number Hue (0-360)
---@param s number Saturation (0-1)
---@param v number Value (0-1)
---@return Color
function rlmlua.color_from_hsv(h, s, v) end

---Interpolate between two colors
---@param a Color Start color
---@param b Color End color
---@param t number Interpolation factor (0-1)
---@return Color
function rlmlua.color_lerp(a, b, t) end

---Fade a color (reduce alpha)
---@param color Color
---@param alpha number Alpha multiplier (0-1)
---@return Color
function rlmlua.color_fade(color, alpha) end

---Linear interpolation between two values
---@param a number Start value
---@param b number End value
---@param t number Interpolation factor (0-1)
---@return number
function rlmlua.lerp(a, b, t) end

---Clamp value between min and max
---@param value number
---@param min number
---@param max number
---@return number
function rlmlua.clamp(value, min, max) end

---Map value from one range to another
---@param value number
---@param in_min number Input range minimum
---@param in_max number Input range maximum
---@param out_min number Output range minimum
---@param out_max number Output range maximum
---@return number
function rlmlua.map(value, in_min, in_max, out_min, out_max) end

---Smooth step interpolation (ease in/out)
---@param t number Input (0-1)
---@return number Smoothed output (0-1)
function rlmlua.smoothstep(t) end

---Convert degrees to radians
---@param degrees number
---@return number
function rlmlua.deg_to_rad(degrees) end

---Convert radians to degrees
---@param radians number
---@return number
function rlmlua.rad_to_deg(radians) end

---Random float between min and max
---@param min number
---@param max number
---@return number
function rlmlua.random_range(min, max) end

---Random integer between min and max (inclusive)
---@param min integer
---@param max integer
---@return integer
function rlmlua.random_int(min, max) end

---Random boolean with optional probability
---@param probability? number Probability of true (0-1, default 0.5)
---@return boolean
function rlmlua.random_bool(probability) end

---Random choice from table
---@param tbl table
---@return any
function rlmlua.random_choice(tbl) end

---Easing functions for animations
---@class Ease
rlmlua.ease = {}

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.linear(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.in_quad(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.out_quad(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.in_out_quad(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.in_cubic(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.out_cubic(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.in_out_cubic(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.in_elastic(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.out_elastic(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.in_bounce(t) end

---@param t number Input (0-1)
---@return number Output (0-1)
function rlmlua.ease.out_bounce(t) end

---Create a simple timer
---@param duration number Timer duration in seconds
---@return table timer Timer object with update(), progress(), reset() methods
function rlmlua.timer(duration) end

---Version string
rlmlua._VERSION = "0.1.0"

---Description string
rlmlua._DESCRIPTION = "Math and utility helpers for raylib"

return rlmlua

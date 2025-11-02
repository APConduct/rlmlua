use std::fs;
use std::io::Write;
use std::path::Path;

fn main() {
    generate_raylib_definitions();
    generate_rlmlua_definitions();
    generate_luarc_json();
    println!("cargo:rerun-if-changed=build.rs");
}

fn generate_luarc_json() {
    if Path::new(".luarc.json").exists() {
        println!("cargo:warning=.luarc.json already exists, skipping generation");
        return;
    }

    let luarc_content = r#"{
      "$schema": "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
      "runtime": {
        "version": "Lua 5.4",
        "path": [
          "?.lua",
          "?/init.lua",
          "lua/?.lua",
          "lua/?/init.lua"
        ],
        "pathStrict": false
      },
      "workspace": {
        "library": [
          "lua",
          "lua/raylib",
          "lua/rlmlua"
        ],
        "checkThirdParty": false,
        "ignoreDir": [
          ".git",
          "target"
        ]
      },
      "diagnostics": {
        "globals": ["raylib", "rlmlua"]
      },
      "completion": {
        "callSnippet": "Both",
        "keywordSnippet": "Both"
      },
      "hint": {
        "enable": true,
        "setType": true
      },
      "type": {
        "castNumberToInteger": true
      }
    }
    "#;

    fs::write(".luarc.json", luarc_content).expect("Failed to write .luarc.json");

    println!("cargo:warning=Generated .luarc.json for LSP support");
}

fn generate_raylib_definitions() {
    let mut output = String::new();

    // Header
    output.push_str("---@meta raylib\n\n");
    output.push_str("---Raylib bindings for Lua (with snake-case API)\n");

    output.push_str("---@class raylib\n");
    output.push_str("local raylib = {}\n\n");

    // Color type
    output.push_str("---@class Color\n");
    output.push_str("---@field [1] integer Red component (0-255)\n");
    output.push_str("---@field [2] integer Green component (0-255)\n");
    output.push_str("---@field [3] integer Blue component (0-255)\n");
    output.push_str("---@field [4] integer Alpha component (0-255, default 255)\n\n");

    // Vector2 type
    output.push_str("---@class Vector2\n");
    output.push_str("---@field x number X coordinate\n");
    output.push_str("---@field y number Y coordinate\n\n");

    // Vector3 type
    output.push_str("---@class Vector3\n");
    output.push_str("---@field x number X coordinate\n");
    output.push_str("---@field y number Y coordinate\n");
    output.push_str("---@field z number Z coordinate\n\n");

    // Rectangle type
    output.push_str("---@class Rectangle\n");
    output.push_str("---@field x number X position\n");
    output.push_str("---@field y number Y position\n");
    output.push_str("---@field width number Rectangle width\n");
    output.push_str("---@field height number Rectangle height\n\n");

    // Gesture type
    output.push_str("---@class Gesture\n");
    output.push_str("---@field None Gesture\n");
    output.push_str("---@field Drag Gesture\n");
    output.push_str("---@field SwipeRight Gesture\n");
    output.push_str("---@field SwipeLeft Gesture\n");
    output.push_str("---@field SwipeUp Gesture\n");
    output.push_str("---@field SwipeDown Gesture\n");
    output.push_str("---@field PinchIn Gesture\n");
    output.push_str("---@field PinchOut Gesture\n");
    output.push_str("---@field DoubleTap Gesture\n");
    output.push_str("---@field Tap Gesture\n");
    output.push_str("---@field Hold Gesture\n\n");

    // Window class
    output.push_str("---Raylib window handle\n");
    output.push_str("---@class Window\n");
    output.push_str("local Window = {}\n\n");

    // Window methods with full documentation
    let window_methods = vec![
        (
            "should_close",
            "boolean",
            "()",
            "Check if window close button or ESC was pressed",
        ),
        (
            "set_target_fps",
            "nil",
            "(fps: integer)",
            "Set target FPS (maximum)",
        ),
        ("get_fps", "integer", "()", "Get current FPS"),
        (
            "get_frame_time",
            "number",
            "()",
            "Get time in seconds for last frame drawn",
        ),
        (
            "get_time",
            "number",
            "()",
            "Get elapsed time in seconds since window was initialized",
        ),
        // Drawing functions
        (
            "begin_drawing",
            "nil",
            "()",
            "Setup canvas (framebuffer) to start drawing",
        ),
        (
            "end_drawing",
            "nil",
            "()",
            "End canvas drawing and swap buffers (double buffering)",
        ),
        (
            "clear_background",
            "nil",
            "(color: Color)",
            "Set background color (clear screen)",
        ),
        // Drawing primitives
        (
            "draw_text",
            "nil",
            "(text: string, x: integer, y: integer, size: integer, color: Color)",
            "Draw text (using default font)",
        ),
        (
            "draw_rectangle",
            "nil",
            "(x: integer, y: integer, width: integer, height: integer, color: Color)",
            "Draw a color-filled rectangle",
        ),
        (
            "draw_rectangle_rec",
            "nil",
            "(rect: Rectangle, color: Color)",
            "Draw a color-filled rectangle",
        ),
        (
            "draw_triangle",
            "nil",
            "(v1: Vector2, v2: Vector2, v3: Vector2, color: Color)",
            "Draw a color-filled triangle",
        ),
        (
            "draw_circle",
            "nil",
            "(x: integer, y: integer, radius: number, color: Color)",
            "Draw a color-filled circle",
        ),
        (
            "draw_line",
            "nil",
            "(x1: integer, y1: integer, x2: integer, y2: integer, color: Color)",
            "Draw line",
        ),
        (
            "draw_line_ex",
            "nil",
            "(start_pos: Vector2, end_pos: Vector2, thick: number, color: Color)",
            "Draw line with thickness",
        ),
        (
            "draw_pixel",
            "nil",
            "(x: integer, y: integer, color: Color)",
            "Draw pixel",
        ),
        (
            "draw_ring",
            "nil",
            "(center: Vector2, inner_radius: number, outer_radius: number, start_angle: number, end_angle: number, segments: integer, color: Color)",
            "Draw ring",
        ),
        (
            "draw_rectangle_lines",
            "nil",
            "(x: integer, y: integer, width: integer, height: integer, color: Color)",
            "Draw rectangle outline",
        ),
        (
            "draw_circle_lines",
            "nil",
            "(x: integer, y: integer, radius: number, color: Color)",
            "Draw circle outline",
        ),
        (
            "draw_circle_v",
            "nil",
            "(v: Vector2, radius: number, color: Color)",
            "Draw circle outline",
        ),
        // Input - Keyboard
        (
            "is_key_pressed",
            "boolean",
            "(key: string)",
            "Check if a key has been pressed once",
        ),
        (
            "is_key_down",
            "boolean",
            "(key: string)",
            "Check if a key is being pressed",
        ),
        (
            "is_key_released",
            "boolean",
            "(key: string)",
            "Check if a key has been released once",
        ),
        (
            "is_key_up",
            "boolean",
            "(key: string)",
            "Check if a key is NOT being pressed",
        ),
        // Input - Mouse
        (
            "get_mouse_position",
            "Vector2",
            "()",
            "Get mouse position X and Y",
        ),
        ("get_mouse_x", "number", "()", "Get mouse position X"),
        ("get_mouse_y", "number", "()", "Get mouse position Y"),
        (
            "is_mouse_button_pressed",
            "boolean",
            "(button: string)",
            "Check if a mouse button has been pressed once (\"LEFT\"=left, \"RIGHT\"=right, \"MIDDLE\"=middle, \"EXTRA\"=extra, \"BACK\"=back, \"FORWARD\"=forward)",
        ),
        (
            "is_mouse_button_down",
            "boolean",
            "(button: string)",
            "Check if a mouse button is being pressed",
        ),
        (
            "is_mouse_button_released",
            "boolean",
            "(button: string)",
            "Check if a mouse button has been released once",
        ),
        (
            "is_mouse_button_up",
            "boolean",
            "(button: string)",
            "Check if a mouse button is NOT being pressed",
        ),
        (
            "is_cursor_hidden",
            "boolean",
            "()",
            "Check if the cursor is hidden",
        ),
        (
            "get_screen_width",
            "number",
            "",
            "Get the width of the screen",
        ),
        (
            "get_screen_height",
            "number",
            "",
            "Get the height of the screen",
        ),
        (
            "get_mouse_x",
            "number",
            "",
            "Get the x position of the mouse",
        ),
        (
            "get_mouse_y",
            "number",
            "",
            "Get the y position of the mouse",
        ),
        (
            "get_mouse_button",
            "boolean",
            "(button: integer)",
            "Check if a mouse button is being pressed",
        ),
        (
            "get_mouse_wheel_move",
            "number",
            "",
            "Get the scroll wheel position",
        ),
        ("close", "nil", "", "Close the window"),
        (
            "get_gesture_detected",
            "Gesture|integer",
            "",
            "Get the detected gesture",
        ),
        (
            "get_gesture_drag_angle",
            "number",
            "",
            "Get the angle of the drag gesture",
        ),
        (
            "get_gesture_pinch_angle",
            "number",
            "",
            "Get the angle of the pinch gesture",
        ),
        (
            "get_touch_point_count",
            "number",
            "",
            "Get the number of touch points",
        ),
        (
            "get_touch_position",
            "Vector2",
            "(index: integer)",
            "Get the position of a touch",
        ),
    ];

    let _other_functions: Vec<(&str, &str, &str, &'static str)> = vec![];

    for (name, ret_type, params, desc) in window_methods {
        output.push_str(&format!("---{}\n", desc));
        output.push_str(&format!("---@param self Window\n"));

        let mut new_params = "(".to_string();

        // Parse parameters for proper annotations
        if !params.is_empty() && params != "()" {
            let param_str = params.trim_matches(|c| c == '(' || c == ')');
            for param in param_str.split(", ") {
                if let Some((name, typ)) = param.split_once(": ") {
                    // insert comma if needed
                    if !(new_params == "(".to_string()) {
                        new_params.push(',');
                        new_params.push_str(" ");
                    }
                    new_params.push_str(name);
                    output.push_str(&format!("---@param {} {}\n", name.trim(), typ));
                }
            }
        }

        new_params.push_str(")");

        output.push_str(&format!("---@return {}\n", ret_type));
        output.push_str(&format!(
            "function Window:{}{} end\n\n",
            name,
            new_params.trim()
        ));
    }

    // Module functions
    output.push_str("---Initialize window and OpenGL context\n");
    output.push_str("---@param width integer Window width\n");
    output.push_str("---@param height integer Window height\n");
    output.push_str("---@param title string Window title\n");
    output.push_str("---@return Window\n");
    output.push_str("function raylib.init_window(width, height, title) end\n\n");

    output.push_str("---Create a color from RGBA values\n");
    output.push_str("---@param r integer Red (0-255)\n");
    output.push_str("---@param g integer Green (0-255)\n");
    output.push_str("---@param b integer Blue (0-255)\n");
    output.push_str("---@param a? integer Alpha (0-255, default 255)\n");
    output.push_str("---@return Color\n");
    output.push_str("function raylib.color(r, g, b, a) end\n\n");

    output.push_str("---Convenience function for safe drawing with automatic begin/end\n");
    output.push_str("---@param window Window The window to draw on\n");
    output.push_str("---@param callback fun(window: Window) Drawing callback function\n");
    output.push_str("function raylib.draw(window, callback) end\n\n");

    // Color constants
    output.push_str("---Predefined color constants\n");
    output.push_str("---@class Colors\n");
    output.push_str("---@field WHITE Color White (255, 255, 255, 255)\n");
    output.push_str("---@field BLACK Color Black (0, 0, 0, 255)\n");
    output.push_str("---@field RED Color Red (255, 0, 0, 255)\n");
    output.push_str("---@field GREEN Color Green (0, 255, 0, 255)\n");
    output.push_str("---@field BLUE Color Blue (0, 0, 255, 255)\n");
    output.push_str("---@field YELLOW Color Yellow (255, 255, 0, 255)\n");
    output.push_str("---@field MAGENTA Color Magenta (255, 0, 255, 255)\n");
    output.push_str("---@field CYAN Color Cyan (0, 255, 255, 255)\n");
    output.push_str("---@field GRAY Color Gray (130, 130, 130, 255)\n");
    output.push_str("---@field DARKGRAY Color Dark Gray (80, 80, 80, 255)\n");
    output.push_str("---@field LIGHTGRAY Color Light Gray (200, 200, 200, 255)\n");
    output.push_str("---@field SKYBLUE Color Sky Blue (102, 191, 255, 255)\n");
    output.push_str("---@field ORANGE Color Orange (255, 161, 0, 255)\n");
    output.push_str("---@field PURPLE Color Purple (200, 122, 255, 255)\n");
    output.push_str("---@field VIOLET Color Violet (135, 60, 190, 255)\n");
    output.push_str("---@field RAYWHITE Color Ray White (245, 245, 245, 255)\n");
    output.push_str("---@field DARKBLUE Color Dark Blue (0, 0, 128, 255)\n");
    output.push_str("---@field LIME Color Lime (0, 255, 0, 255)\n");
    output.push_str("---@field GOLD Color Gold (255, 201, 0, 255)\n");
    output.push_str("---@field MAROON Color Maroon (128, 0, 0, 255)\n");
    output.push_str("---@field BEIGE Color Beige (211, 176, 131, 255)\n");
    output.push_str("raylib.colors = {}\n\n");

    // Key constants documentation
    output.push_str("---Key string constants for keyboard input\n");
    output
        .push_str("---Supported keys: \"SPACE\", \"ESCAPE\", \"ENTER\", \"TAB\", \"BACKSPACE\",\n");
    output.push_str("---\"UP\", \"DOWN\", \"LEFT\", \"RIGHT\", \"A\"-\"Z\", \"0\"-\"9\",\n");
    output.push_str("---\"F1\"-\"F12\", \"SHIFT\", \"CTRL\", \"ALT\"\n\n");

    output.push_str("return raylib\n");

    // Write to library directory
    // fs::create_dir_all("lua/raylib").unwrap();
    fs::create_dir_all("lua/raylib").unwrap();

    // Write to library directory - name it 'meta.lua' not 'raylib.d.lua'
    fs::create_dir_all("lua/raylib").unwrap();
    let mut file = fs::File::create("lua/raylib/meta.lua").unwrap();
    file.write_all(output.as_bytes()).unwrap();
}

fn generate_rlmlua_definitions() {
    let mut output = String::new();

    // Header with @meta tag
    output.push_str("---@meta rlmlua\n\n");
    output.push_str("---Math and utility helpers for raylib\n");
    output.push_str("---@class rlmlua\n");
    output.push_str("local rlmlua = {}\n\n");

    output.push_str("---Reference to raylib module (auto-loaded for convenience)\n");
    output.push_str("---@type raylib\n");
    output.push_str("rlmlua.raylib = nil\n\n");

    // Vector functions
    output.push_str("---Create a 2D vector\n");
    output.push_str("---@param x number X coordinate\n");
    output.push_str("---@param y number Y coordinate\n");
    output.push_str("---@return Vector2\n");
    output.push_str("function rlmlua.vec2(x, y) end\n\n");

    output.push_str("---Create a 3D vector\n");
    output.push_str("---@param x number X coordinate\n");
    output.push_str("---@param y number Y coordinate\n");
    output.push_str("---@param z number Z coordinate\n");
    output.push_str("---@return Vector3\n");
    output.push_str("function rlmlua.vec3(x, y, z) end\n\n");

    output.push_str("---Add two 2D vectors\n");
    output.push_str("---@param a Vector2\n");
    output.push_str("---@param b Vector2\n");
    output.push_str("---@return Vector2\n");
    output.push_str("function rlmlua.vec2_add(a, b) end\n\n");

    output.push_str("---Subtract two 2D vectors\n");
    output.push_str("---@param a Vector2\n");
    output.push_str("---@param b Vector2\n");
    output.push_str("---@return Vector2\n");
    output.push_str("function rlmlua.vec2_sub(a, b) end\n\n");

    output.push_str("---Scale a 2D vector\n");
    output.push_str("---@param v Vector2\n");
    output.push_str("---@param s number Scale factor\n");
    output.push_str("---@return Vector2\n");
    output.push_str("function rlmlua.vec2_scale(v, s) end\n\n");

    output.push_str("---Get length of a 2D vector\n");
    output.push_str("---@param v Vector2\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.vec2_length(v) end\n\n");

    output.push_str("---Normalize a 2D vector\n");
    output.push_str("---@param v Vector2\n");
    output.push_str("---@return Vector2\n");
    output.push_str("function rlmlua.vec2_normalize(v) end\n\n");

    output.push_str("---Calculate distance between two points\n");
    output.push_str("---@param a Vector2\n");
    output.push_str("---@param b Vector2\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.distance(a, b) end\n\n");

    output.push_str("---Dot product of two 2D vectors\n");
    output.push_str("---@param a Vector2\n");
    output.push_str("---@param b Vector2\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.vec2_dot(a, b) end\n\n");

    output.push_str("---Linear interpolation between two 2D vectors\n");
    output.push_str("---@param a Vector2 Start vector\n");
    output.push_str("---@param b Vector2 End vector\n");
    output.push_str("---@param t number Interpolation factor (0-1)\n");
    output.push_str("---@return Vector2\n");
    output.push_str("function rlmlua.vec2_lerp(a, b, t) end\n\n");

    // Rectangle functions
    output.push_str("---Create a rectangle\n");
    output.push_str("---@param x number X position\n");
    output.push_str("---@param y number Y position\n");
    output.push_str("---@param width number Rectangle width\n");
    output.push_str("---@param height number Rectangle height\n");
    output.push_str("---@return Rectangle\n");
    output.push_str("function rlmlua.rect(x, y, width, height) end\n\n");

    output.push_str("---Check if point is inside rectangle\n");
    output.push_str("---@param rect Rectangle\n");
    output.push_str("---@param x number Point X coordinate\n");
    output.push_str("---@param y number Point Y coordinate\n");
    output.push_str("---@return boolean\n");
    output.push_str("function rlmlua.rect_contains_point(rect, x, y) end\n\n");

    output.push_str("---Check if two rectangles overlap\n");
    output.push_str("---@param a Rectangle\n");
    output.push_str("---@param b Rectangle\n");
    output.push_str("---@return boolean\n");
    output.push_str("function rlmlua.rect_overlaps(a, b) end\n\n");

    // Color functions
    output.push_str("---Create color from hex string\n");
    output.push_str("---@param hex string Hex color (e.g., \"#ff0000\" or \"ff0000\")\n");
    output.push_str("---@return Color\n");
    output.push_str("function rlmlua.color_from_hex(hex) end\n\n");

    output.push_str("---Create color from HSV values\n");
    output.push_str("---@param h number Hue (0-360)\n");
    output.push_str("---@param s number Saturation (0-1)\n");
    output.push_str("---@param v number Value (0-1)\n");
    output.push_str("---@return Color\n");
    output.push_str("function rlmlua.color_from_hsv(h, s, v) end\n\n");

    output.push_str("---Interpolate between two colors\n");
    output.push_str("---@param a Color Start color\n");
    output.push_str("---@param b Color End color\n");
    output.push_str("---@param t number Interpolation factor (0-1)\n");
    output.push_str("---@return Color\n");
    output.push_str("function rlmlua.color_lerp(a, b, t) end\n\n");

    output.push_str("---Fade a color (reduce alpha)\n");
    output.push_str("---@param color Color\n");
    output.push_str("---@param alpha number Alpha multiplier (0-1)\n");
    output.push_str("---@return Color\n");
    output.push_str("function rlmlua.color_fade(color, alpha) end\n\n");

    // Math utilities
    output.push_str("---Linear interpolation between two values\n");
    output.push_str("---@param a number Start value\n");
    output.push_str("---@param b number End value\n");
    output.push_str("---@param t number Interpolation factor (0-1)\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.lerp(a, b, t) end\n\n");

    output.push_str("---Clamp value between min and max\n");
    output.push_str("---@param value number\n");
    output.push_str("---@param min number\n");
    output.push_str("---@param max number\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.clamp(value, min, max) end\n\n");

    output.push_str("---Map value from one range to another\n");
    output.push_str("---@param value number\n");
    output.push_str("---@param in_min number Input range minimum\n");
    output.push_str("---@param in_max number Input range maximum\n");
    output.push_str("---@param out_min number Output range minimum\n");
    output.push_str("---@param out_max number Output range maximum\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.map(value, in_min, in_max, out_min, out_max) end\n\n");

    output.push_str("---Smooth step interpolation (ease in/out)\n");
    output.push_str("---@param t number Input (0-1)\n");
    output.push_str("---@return number Smoothed output (0-1)\n");
    output.push_str("function rlmlua.smoothstep(t) end\n\n");

    output.push_str("---Convert degrees to radians\n");
    output.push_str("---@param degrees number\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.deg_to_rad(degrees) end\n\n");

    output.push_str("---Convert radians to degrees\n");
    output.push_str("---@param radians number\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.rad_to_deg(radians) end\n\n");

    // Random utilities
    output.push_str("---Random float between min and max\n");
    output.push_str("---@param min number\n");
    output.push_str("---@param max number\n");
    output.push_str("---@return number\n");
    output.push_str("function rlmlua.random_range(min, max) end\n\n");

    output.push_str("---Random integer between min and max (inclusive)\n");
    output.push_str("---@param min integer\n");
    output.push_str("---@param max integer\n");
    output.push_str("---@return integer\n");
    output.push_str("function rlmlua.random_int(min, max) end\n\n");

    output.push_str("---Random boolean with optional probability\n");
    output.push_str("---@param probability? number Probability of true (0-1, default 0.5)\n");
    output.push_str("---@return boolean\n");
    output.push_str("function rlmlua.random_bool(probability) end\n\n");

    output.push_str("---Random choice from table\n");
    output.push_str("---@param tbl table\n");
    output.push_str("---@return any\n");
    output.push_str("function rlmlua.random_choice(tbl) end\n\n");

    // Easing functions
    output.push_str("---Easing functions for animations\n");
    output.push_str("---@class Ease\n");
    output.push_str("rlmlua.ease = {}\n\n");

    let easing_functions = vec![
        "linear",
        "in_quad",
        "out_quad",
        "in_out_quad",
        "in_cubic",
        "out_cubic",
        "in_out_cubic",
        "in_elastic",
        "out_elastic",
        "in_bounce",
        "out_bounce",
    ];

    for ease_fn in easing_functions {
        output.push_str(&format!("---@param t number Input (0-1)\n"));
        output.push_str(&format!("---@return number Output (0-1)\n"));
        output.push_str(&format!("function rlmlua.ease.{}(t) end\n\n", ease_fn));
    }

    // Timer
    output.push_str("---Create a simple timer\n");
    output.push_str("---@param duration number Timer duration in seconds\n");
    output.push_str(
        "---@return table timer Timer object with update(), progress(), reset() methods\n",
    );
    output.push_str("function rlmlua.timer(duration) end\n\n");

    // Version info
    output.push_str("---Version string\n");
    output.push_str("rlmlua._VERSION = \"0.1.0\"\n\n");

    output.push_str("---Description string\n");
    output.push_str("rlmlua._DESCRIPTION = \"Math and utility helpers for raylib\"\n\n");

    output.push_str("return rlmlua\n");

    // Write to library directory - name it 'meta.lua'
    fs::create_dir_all("lua/rlmlua").unwrap();
    let mut file = fs::File::create("lua/rlmlua/meta.lua").unwrap();
    file.write_all(output.as_bytes()).unwrap();
}

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

    // Window class
    output.push_str("---Raylib window handle\n");
    output.push_str("---@class Window\n");
    output.push_str("local Window = {}\n\n");

    // Window methods with full documentation
    let window_methods = vec![
        (
            "window_should_close",
            "boolean",
            "()",
            "Check if window close button or ESC was pressed",
        ),
        (
            "set_target_fps",
            "nil",
            "(fps: number)",
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
            "(text: string, x: number, y: number, size: number, color: Color)",
            "Draw text (using default font)",
        ),
        (
            "draw_rectangle",
            "nil",
            "(x: number, y: number, width: number, height: number, color: Color)",
            "Draw a color-filled rectangle",
        ),
        (
            "draw_circle",
            "nil",
            "(x: number, y: number, radius: number, color: Color)",
            "Draw a color-filled circle",
        ),
        (
            "draw_line",
            "nil",
            "(x1: number, y1: number, x2: number, y2: number, color: Color)",
            "Draw line",
        ),
        (
            "is_key_pressed",
            "boolean",
            "(key: number)",
            "Check if key was pressed once",
        ),
        (
            "is_key_down",
            "boolean",
            "(key: number)",
            "Check if key is being held down",
        ),
        (
            "get_mouse_position",
            "number, number",
            "()",
            "Get mouse position X and Y",
        ),
        (
            "is_mouse_button_pressed",
            "boolean",
            "(button)",
            "Check if mouse button pressed (0=left, 1=right, 2=middle)",
        ),
    ];

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

    // Color constants
    output.push_str("---Predefined colors\n");
    output.push_str("---@class Colors\n");
    output.push_str("---@field WHITE Color\n");
    output.push_str("---@field BLACK Color\n");
    output.push_str("---@field RED Color\n");
    output.push_str("---@field GREEN Color\n");
    output.push_str("---@field BLUE Color\n");
    output.push_str("---@field YELLOW Color\n");
    output.push_str("---@field MAGENTA Color\n");
    output.push_str("---@field GRAY Color\n");
    output.push_str("---@field SKYBLUE Color\n");
    output.push_str("raylib.colors = {}\n\n");

    output.push_str("return raylib\n");

    // Write to library directory
    // fs::create_dir_all("lua/raylib").unwrap();
    fs::create_dir_all("lua/raylib").unwrap();

    // let mut file = fs::File::create("lua/raylib/init.lua").unwrap();
    let mut file = fs::File::create("lua/raylib/meta.lua").unwrap();

    file.write_all(output.as_bytes()).unwrap();

    println!("cargo:rerun-if-changed=build.rs");
}

fn generate_rlmlua_definitions() {}

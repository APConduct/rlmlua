# Development Guide for rlmlua

## Overview

rlmlua provides Lua bindings for raylib using Rust, mlua, and raylib-rs. The library offers both imperative and callback-based drawing patterns, with snake_case naming conventions for a more Lua-friendly API.

## Current Status

### Working Features

- ✅ Window creation and management
- ✅ Drawing functions (imperative style with `begin_drawing`/`end_drawing`)
- ✅ Basic shapes: rectangles, circles, lines, pixels
- ✅ Text rendering
- ✅ Keyboard input
- ✅ Mouse input
- ✅ Color system with predefined constants
- ✅ FPS control and timing functions

### Drawing Patterns

The library supports two drawing patterns:

#### 1. Imperative Pattern (Recommended for raylua compatibility)
```lua
local rl = require("raylib")
local window = rl.init_window(800, 450, "My Window")
window:set_target_fps(60)

while not window:window_should_close() do
    window:begin_drawing()
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    window:end_drawing()
end
```

#### 2. Callback Pattern (mlua-style)
```lua
local rl = require("raylib")
local window = rl.init_window(800, 450, "My Window")
window:set_target_fps(60)

while not window:window_should_close() do
    window:draw_frame(function()
        window:clear_background(rl.colors.SKYBLUE)
        window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    end)
end
```

## Building

### Prerequisites
- Rust toolchain (stable)
- Lua 5.4
- CMake (for raylib-sys)
- Platform-specific requirements for raylib

### Build Commands

```bash
# Build the library
cargo build --release

# Create necessary symlinks (macOS/Linux)
cp target/release/librlmlua.dylib target/release/libraylib_lua.so  # macOS
# or
cp target/release/librlmlua.so target/release/libraylib_lua.so     # Linux

ln -sf libraylib_lua.so target/release/raylib_lua.so

# Or use the Makefile
make all

# Run the test script
./test_window.sh
```

### Running Examples

```bash
# Set up paths
export LUA_PATH="./lua/?.lua;./lua/?/init.lua;;"
export LUA_CPATH="./target/release/?.so;;"

# Run examples
lua examples/01_basic_window.lua
lua examples/02_shapes_and_input.lua
```

Or use the Makefile:
```bash
make run
```

## Architecture

### Core Components

1. **LuaRaylib** (`src/lib.rs`): Main window/context struct
   - Wraps `RaylibHandle` and `RaylibThread`
   - Provides window management methods
   - Handles drawing state via thread-local storage
   - Input handling methods

2. **Drawing System**: Uses thread-local storage for draw handle
   - `begin_drawing()` creates and stores a draw handle
   - Drawing methods access the stored handle
   - `end_drawing()` drops the handle, completing the frame

3. **LuaColor**: Color type with conversions
   - Implements `From<LuaColor> for Color`
   - Implements `FromLua` and `IntoLua` for Lua integration
   - Predefined color constants in `rl.colors.*`

### Lua Module Structure

```
lua/
├── raylib/
│   ├── init.lua        # Main module, re-exports core functions
│   └── meta.lua        # Type definitions for LSP support
└── rlmlua/             # Future: helper utilities not in raylib
```

## API Reference

### Window Management
- `rl.init_window(width, height, title)` - Create window
- `window:window_should_close()` - Check if window should close
- `window:set_target_fps(fps)` - Set target FPS
- `window:get_fps()` - Get current FPS
- `window:get_frame_time()` - Get frame time
- `window:get_screen_width()` - Get screen width
- `window:get_screen_height()` - Get screen height

### Drawing Functions
- `window:begin_drawing()` - Begin drawing mode
- `window:end_drawing()` - End drawing mode
- `window:clear_background(color)` - Clear screen with color
- `window:draw_text(text, x, y, size, color)` - Draw text
- `window:draw_rectangle(x, y, width, height, color)` - Draw filled rectangle
- `window:draw_rectangle_lines(x, y, width, height, color)` - Draw rectangle outline
- `window:draw_circle(x, y, radius, color)` - Draw filled circle
- `window:draw_circle_lines(x, y, radius, color)` - Draw circle outline
- `window:draw_line(x1, y1, x2, y2, color)` - Draw line
- `window:draw_pixel(x, y, color)` - Draw single pixel

### Input - Keyboard
- `window:is_key_pressed(key)` - Check if key was just pressed
- `window:is_key_down(key)` - Check if key is being held
- `window:is_key_released(key)` - Check if key was just released
- `window:is_key_up(key)` - Check if key is not pressed

Key names: "A"-"Z", "0"-"9", "SPACE", "ENTER", "ESC", "UP", "DOWN", "LEFT", "RIGHT", "F1"-"F12", etc.

### Input - Mouse
- `window:get_mouse_position()` - Get (x, y) position
- `window:get_mouse_x()` - Get x position
- `window:get_mouse_y()` - Get y position
- `window:is_mouse_button_pressed(button)` - Check if mouse button pressed
- `window:is_mouse_button_down(button)` - Check if mouse button held
- `window:is_mouse_button_released(button)` - Check if mouse button released
- `window:is_mouse_button_up(button)` - Check if mouse button not pressed

Mouse buttons: 0 = left, 1 = right, 2 = middle

### Colors
- `rl.color(r, g, b, a)` - Create color (0-255 values)
- `rl.colors.WHITE`, `rl.colors.BLACK`, `rl.colors.RED`, etc. - Predefined colors

Available color constants: WHITE, BLACK, BLANK, RED, GREEN, BLUE, YELLOW, MAGENTA, CYAN, DARKGRAY, GRAY, LIGHTGRAY, SKYBLUE, ORANGE, PURPLE, PINK, LIME, GOLD, MAROON, DARKGREEN, DARKBLUE, DARKPURPLE, DARKBROWN, BEIGE, BROWN, RAYWHITE

## Future Development

### Planned Features
- Texture loading and rendering
- Audio support
- Font loading
- Camera support
- 3D drawing primitives
- Shader support
- More comprehensive input handling (gamepad, touch)
- File I/O helpers in rlmlua module
- Collision detection helpers
- Math utilities (vectors, matrices)
- Additional examples

### Design Goals
1. Maintain API compatibility with raylua where possible
2. Use snake_case naming for Lua-friendly API
3. Leverage mlua's patterns for batched operations
4. Support both imperative and functional styles
5. Provide comprehensive LSP/type definitions
6. Make it easy to install via luarocks

## Testing

Currently manual testing with example files. Future plans:
- Unit tests for color conversions
- Integration tests for window creation
- Example-based regression tests
- Performance benchmarks

## Installation

### Via LuaRocks (Planned)
```bash
luarocks install rlmlua
```

### Manual Installation
```bash
make install INST_LIBDIR=/path/to/lib INST_LUADIR=/path/to/lua
```

## Troubleshooting

### Library Not Found
Make sure the library is copied/linked correctly:
- macOS: `librlmlua.dylib` → `libraylib_lua.so` → `raylib_lua.so`
- Linux: `librlmlua.so` → `libraylib_lua.so` → `raylib_lua.so`
- Windows: `librlmlua.dll` → `libraylib_lua.dll` → `raylib_lua.dll`

### Build Errors
If you encounter CMake errors during build:
```bash
cargo clean
cargo build --release
```

### Window Flashing/Not Rendering
This was fixed by adding proper `begin_drawing`/`end_drawing` methods. Make sure you're calling them in the correct order:
1. `window:begin_drawing()`
2. Draw calls
3. `window:end_drawing()`

## Contributing

This project is in active development. Contributions welcome!

## License

[Add license information]
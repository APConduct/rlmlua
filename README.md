# rlmlua - Raylib Bindings for Lua

Lua bindings for [raylib](https://www.raylib.com/) using Rust, [mlua](https://github.com/mlua-rs/mlua), and [raylib-rs](https://github.com/deltaphc/raylib-rs).

## Features

- 🎮 **Snake-case API** - Lua-friendly naming conventions (`init_window` instead of `InitWindow`)
- 🔄 **Dual Patterns** - Supports both imperative (`begin_drawing`/`end_drawing`) and callback-based drawing
- 🦀 **Rust Safety** - Built with Rust for memory safety and performance
- 📦 **LuaRocks Ready** - Designed for easy installation via luarocks (coming soon)
- 🔧 **LSP Support** - Type definitions for language server integration
- 🎨 **Comprehensive** - Covers core raylib features: graphics, input, timing, colors

## Status

**Current Version:** 0.1.0 (In Development)

This project is functional but actively being developed. The basic window, drawing, and input features are working correctly.

## Quick Start

### Installation via LuaRocks (Recommended)

The easiest way to install rlmlua is using the provided installation script:

```bash
# Clone the repository
git clone <your-repo-url>
cd rlmlua

# Install locally (recommended)
./install_local.sh
```

**Alternative: Manual LuaRocks Installation**

If you prefer to use luarocks directly:

```bash
# Install locally (for current user)
luarocks make --local rockspecs/rlmlua-dev-1.rockspec

# Or install globally (may require sudo)
luarocks make rockspecs/rlmlua-dev-1.rockspec
```

**After installation**, you can use it in any Lua script without setting environment variables:

```bash
# Just run your script!
lua your_script.lua
```

Or from any directory:

```lua
#!/usr/bin/env lua
local rl = require("raylib")
-- Your code here
```

**To uninstall:**

```bash
./uninstall_local.sh
```

### Manual Build (For Development)

If you want to build manually without installing:

#### Prerequisites

- Rust toolchain (stable)
- Lua 5.4
- CMake (for building raylib)
- Platform-specific dependencies for raylib (OpenGL, etc.)

#### Building

```bash
# Clone the repository
git clone <your-repo-url>
cd rlmlua

# Build the library
cargo build --release

# Create library symlinks (macOS/Linux)
cp target/release/librlmlua.dylib target/release/libraylib_lua.so  # macOS
# or
cp target/release/librlmlua.so target/release/libraylib_lua.so     # Linux

ln -sf libraylib_lua.so target/release/raylib_lua.so

# Or use the Makefile
make all

# Or use the test script
./test_window.sh
```

#### Running Examples (Manual Build)

```bash
# Set up Lua paths
export LUA_PATH="./lua/?.lua;./lua/?/init.lua;;"
export LUA_CPATH="./target/release/?.so;;"

# Run the basic window example
lua examples/01_basic_window.lua

# Run the interactive shapes demo
lua examples/02_shapes_and_input.lua
```

### Testing Installation

To verify your installation works correctly:

```bash
# Test that the module loads
lua -e "require('raylib'); print('rlmlua is working!')"

# Or run an example
lua examples/00_simple_after_install.lua

# For comprehensive testing
./test_luarocks_install.sh
```

## Usage Examples

### After LuaRocks Installation

Once installed via luarocks, you can use it directly:

```lua
local rl = require("raylib")

-- Initialize window
local window = rl.init_window(800, 450, "My Raylib Window")
window:set_target_fps(60)

-- Main game loop
while not window:window_should_close() do
    window:begin_drawing()
    
    window:clear_background(rl.colors.SKYBLUE)
    window:draw_text("Hello, Raylib from Lua!", 250, 200, 30, rl.colors.BLACK)
    
    -- Draw some shapes
    window:draw_rectangle(100, 100, 50, 50, rl.colors.RED)
    window:draw_circle(400, 300, 30, rl.colors.GREEN)
    
    window:end_drawing()
end

print("Window closed!")
```

### Alternative: Callback Style

```lua
local rl = require("raylib")
local window = rl.init_window(800, 450, "Callback Style")
window:set_target_fps(60)

while not window:window_should_close() do
    window:draw_frame(function()
        window:clear_background(rl.colors.SKYBLUE)
        window:draw_text("Using callbacks!", 250, 200, 30, rl.colors.BLACK)
    end)
end
```

## API Overview

### Window Management
- `rl.init_window(width, height, title)` - Create a window
- `window:window_should_close()` - Check if user wants to close
- `window:set_target_fps(fps)` - Set target framerate
- `window:get_fps()` - Get current FPS
- `window:get_screen_width()` / `window:get_screen_height()` - Get dimensions

### Drawing
- `window:begin_drawing()` - Start drawing mode
- `window:end_drawing()` - Finish drawing mode
- `window:clear_background(color)` - Clear screen
- `window:draw_text(text, x, y, size, color)` - Draw text
- `window:draw_rectangle(x, y, w, h, color)` - Draw filled rectangle
- `window:draw_circle(x, y, radius, color)` - Draw filled circle
- `window:draw_line(x1, y1, x2, y2, color)` - Draw line
- `window:draw_pixel(x, y, color)` - Draw single pixel

### Input - Keyboard
- `window:is_key_pressed(key)` - Just pressed this frame
- `window:is_key_down(key)` - Currently held down
- `window:is_key_released(key)` - Just released this frame
- `window:is_key_up(key)` - Not pressed

Keys: `"A"` through `"Z"`, `"0"` through `"9"`, `"SPACE"`, `"ENTER"`, `"ESC"`, `"UP"`, `"DOWN"`, `"LEFT"`, `"RIGHT"`, `"F1"` through `"F12"`, etc.

### Input - Mouse
- `window:get_mouse_position()` - Returns `(x, y)`
- `window:get_mouse_x()` / `window:get_mouse_y()` - Get coordinates
- `window:is_mouse_button_pressed(button)` - Just pressed
- `window:is_mouse_button_down(button)` - Currently held

Buttons: `0` = left, `1` = right, `2` = middle

### Colors
```lua
-- Create custom colors
local my_color = rl.color(255, 128, 0, 255)  -- RGBA

-- Use predefined colors
rl.colors.WHITE
rl.colors.BLACK
rl.colors.RED
rl.colors.GREEN
rl.colors.BLUE
rl.colors.YELLOW
rl.colors.SKYBLUE
rl.colors.PURPLE
rl.colors.ORANGE
rl.colors.RAYWHITE
-- ... and many more
```

## Project Goals

1. **Raylua Compatibility** - API design inspired by raylua projects for familiarity
2. **Snake Case** - Lua-friendly naming (`draw_text` not `DrawText`)
3. **Modern Patterns** - Leverage mlua for better Lua integration
4. **Easy Install** - Target: `luarocks install rlmlua`
5. **Complete Coverage** - Eventually support all core raylib features

## Roadmap

### ✅ Implemented
- Window creation and management
- Basic shape drawing (rectangles, circles, lines, pixels)
- Text rendering
- Keyboard and mouse input
- Color system with constants
- FPS control

### 🚧 In Progress
- More drawing functions
- Documentation and examples

### 📋 Planned
- Texture loading and rendering
- Image manipulation
- Font loading and text measurement
- Audio support (music and sound effects)
- Camera system (2D and 3D)
- 3D drawing primitives
- Model loading and rendering
- Shader support
- Collision detection helpers
- Math utilities (vectors, matrices)
- Gamepad input
- File I/O utilities
- Additional examples and tutorials

## Installation Notes

### LuaRocks Installation

When you install via luarocks, the library is automatically placed in the correct locations:

- **C Module**: Installed to `<luarocks-tree>/lib/lua/5.x/raylib_lua.so` (or `.dll` on Windows)
- **Lua Module**: Installed to `<luarocks-tree>/share/lua/5.x/raylib/init.lua`

This means you don't need to set `LUA_PATH` or `LUA_CPATH` - it just works!

### Local vs Global Installation

```bash
# Local installation using the install script (recommended)
./install_local.sh

# Or with luarocks directly (in ~/.luarocks/)
luarocks make --local rockspecs/rlmlua-dev-1.rockspec

# Global installation (system-wide, may need sudo)
sudo luarocks make rockspecs/rlmlua-dev-1.rockspec
```

### Uninstalling

```bash
# Remove local installation (if installed with install_local.sh)
./uninstall_local.sh

# Or with luarocks
luarocks remove --local rlmlua

# Remove global installation
sudo luarocks remove rlmlua
```

### Verifying Installation

```bash
# Check if it's installed
luarocks list | grep rlmlua

# Test that it loads
lua -e "require('raylib'); print('rlmlua is working!')"
```

## Documentation

- [DEVELOPMENT.md](DEVELOPMENT.md) - Detailed development guide and architecture
- [CHANGELOG.md](CHANGELOG.md) - Version history and changes
- [examples/](examples/) - Example programs demonstrating features
- [rockspecs/](rockspecs/) - LuaRocks package specifications

## Contributing

This project is in active development. Contributions, bug reports, and suggestions are welcome!

## Inspiration

This project is inspired by:
- [raylua_e](https://github.com/Rabios/raylua_e) - Embedded Lua with raylib
- [raylua_s](https://github.com/Rabios/raylua_s) - Standalone raylib bindings for Lua

## License

[Specify your license here]

## Acknowledgments

- [raylib](https://www.raylib.com/) - The amazing game programming library
- [mlua](https://github.com/mlua-rs/mlua) - High-level Lua bindings for Rust
- [raylib-rs](https://github.com/deltaphc/raylib-rs) - Rust bindings for raylib
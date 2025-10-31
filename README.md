# rlmlua - Lua Bindings for raylib

Safe, ergonomic Lua bindings for [raylib](https://www.raylib.com/) using Rust and [mlua](https://github.com/mlua-rs/mlua).

## Features

- 🎮 **Easy to use** - Simple, clean Lua API with snake_case naming
- 🚀 **Performance** - Built with Rust for speed and safety
- 📦 **LuaRocks ready** - Easy installation via luarocks
- 🎨 **Complete** - Core raylib functions: window, drawing, input, timing
- 🔧 **Developer friendly** - Type definitions for LSP support

## Quick Start

### Installation

#### Via LuaRocks (Recommended)

```bash
luarocks install rlmlua
```

#### Manual Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/rlmlua.git
cd rlmlua

# Build and install locally
./install_local.sh

# Add luarocks path to your shell
eval $(luarocks path --bin)
```

### Basic Example

```lua
local rl = require("raylib")

-- Create a window
local window = rl.init_window(800, 450, "Hello, rlmlua!")
window:set_target_fps(60)

-- Main game loop
while not window:window_should_close() do
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)
    window:draw_text("Hello, World!", 250, 200, 30, rl.colors.BLACK)
    window:end_drawing()
end
```

## API Overview

### Window Management

```lua
local window = rl.init_window(width, height, "Title")
window:set_target_fps(60)
window:window_should_close()  -- Returns true if ESC pressed or X clicked
window:get_screen_width()
window:get_screen_height()
window:get_fps()
```

### Drawing

```lua
window:begin_drawing()
window:clear_background(rl.colors.RAYWHITE)

-- Shapes
window:draw_rectangle(x, y, width, height, color)
window:draw_circle(x, y, radius, color)
window:draw_line(x1, y1, x2, y2, color)
window:draw_pixel(x, y, color)

-- Text
window:draw_text("Hello!", x, y, font_size, color)

window:end_drawing()
```

### Input

```lua
-- Keyboard
window:is_key_pressed("SPACE")  -- True only on first press
window:is_key_down("RIGHT")     -- True while held
window:is_key_released("ESC")
window:is_key_up("LEFT")

-- Mouse
local x, y = window:get_mouse_position()
window:is_mouse_button_pressed(0)  -- 0 = left, 1 = right, 2 = middle
window:is_mouse_button_down(0)
```

### Colors

```lua
rl.colors.BLACK
rl.colors.WHITE
rl.colors.RAYWHITE
rl.colors.RED
rl.colors.GREEN
rl.colors.BLUE
rl.colors.SKYBLUE
-- ... and many more!

-- Custom colors
local custom = rl.color(255, 100, 50, 255)  -- RGBA
```

### Timing

```lua
window:get_fps()          -- Current FPS
window:get_frame_time()   -- Time for last frame (seconds)
window:get_time()         -- Time since init (seconds)
```

## Examples

Check out the `examples/` directory:

- `01_basic_window.lua` - Simple window with text
- `02_input_demo.lua` - Keyboard and mouse input demo
- `test_render.lua` - Drawing primitives showcase

Run examples:

```bash
eval $(luarocks path --bin)
lua examples/01_basic_window.lua
```

## Design Philosophy

### Automatic Input Polling

rlmlua uses standard raylib behavior where `EndDrawing()` automatically handles:
- Input event polling
- Frame timing
- Buffer swapping

**You don't need to manually poll input events!** Just call `window:end_drawing()` and everything works.

### Snake Case Convention

Following Lua conventions, all functions use snake_case:
- ✅ `init_window()` (not `InitWindow`)
- ✅ `clear_background()` (not `ClearBackground`)
- ✅ `is_key_pressed()` (not `IsKeyPressed`)

### Simple, Predictable API

```lua
-- Create window
local window = rl.init_window(800, 450, "My Game")

-- Game loop
while not window:window_should_close() do
    -- Update game logic here
    
    window:begin_drawing()
    -- Draw everything here
    window:end_drawing()
end

-- Window closes automatically when script ends
```

## Building from Source

### Requirements

- Rust 1.70+ (install from [rustup.rs](https://rustup.rs/))
- Lua 5.4 or LuaJIT
- raylib (bundled via raylib-rs)

### Build Steps

```bash
# Clone repository
git clone https://github.com/yourusername/rlmlua.git
cd rlmlua

# Build release version
cargo build --release

# Install locally
./install_local.sh

# Or install via luarocks
luarocks make rockspecs/rlmlua-0.1.0-1.rockspec
```

## Project Structure

```
rlmlua/
├── src/
│   └── lib.rs              # Rust bindings implementation
├── lua/
│   ├── raylib/
│   │   ├── init.lua        # Lua wrapper module
│   │   └── meta.lua        # Type definitions for LSP
│   └── rlmlua/
│       └── init.lua        # Helper utilities (future)
├── examples/               # Example programs
├── rockspecs/             # LuaRocks package specs
├── build.rs               # Build script (generates types)
└── Makefile               # Build automation
```

## Comparison with Other Raylib Lua Bindings

| Feature | rlmlua | raylua_s | raylua_e |
|---------|--------|----------|----------|
| Language | Rust | C | C |
| Safety | ✅ Memory safe | ⚠️ Manual | ⚠️ Manual |
| LuaRocks | ✅ Ready | ❌ No | ❌ No |
| LSP Support | ✅ Yes | ❌ No | ❌ No |
| API Style | snake_case | PascalCase | PascalCase |
| Active | ✅ Yes | ⚠️ Old | ⚠️ Old |

## Roadmap

- [x] Core window management
- [x] Basic drawing (shapes, text)
- [x] Input handling (keyboard, mouse)
- [x] Color constants
- [x] Timing functions
- [ ] Texture loading and drawing
- [ ] Audio support
- [ ] Camera support (2D/3D)
- [ ] Font loading
- [ ] Collision detection helpers
- [ ] Shader support

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

## License

This project is licensed under the Zlib License - see the LICENSE file for details.

## Credits

- [raylib](https://www.raylib.com/) by Ramon Santamaria
- [raylib-rs](https://github.com/deltaphc/raylib-rs) - Rust bindings for raylib
- [mlua](https://github.com/mlua-rs/mlua) - High-level Lua bindings for Rust
- Inspired by raylua_s and raylua_e

## Support

- Documentation: Check `examples/` directory
- Issues: [GitHub Issues](https://github.com/yourusername/rlmlua/issues)
- Discussions: [GitHub Discussions](https://github.com/yourusername/rlmlua/discussions)

---

**Happy coding! 🎮✨**
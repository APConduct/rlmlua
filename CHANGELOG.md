# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- **LuaRocks Installation Support** - Complete luarocks integration for easy installation
  - `install_local.sh` - Simple local installation script that works without luarocks make
  - `uninstall_local.sh` - Clean uninstallation script
  - `test_luarocks_install.sh` - Comprehensive installation testing
  - Updated rockspec with proper build configuration
  - Example `00_simple_after_install.lua` demonstrating usage after installation
- **Comprehensive Documentation**
  - [INSTALL.md](INSTALL.md) - Detailed installation guide covering all methods
  - [QUICK_START.md](QUICK_START.md) - 5-minute quick start guide for new users
  - Updated [README.md](README.md) with luarocks installation instructions
- **Automatic Path Configuration** - After installation via `install_local.sh`, users can simply run `lua script.lua` without setting `LUA_PATH` or `LUA_CPATH` environment variables
- **Multi-platform Installation** - Installation scripts detect OS and handle library extensions correctly (`.dylib` on macOS, `.so` on Linux, `.dll` on Windows)

### Fixed
- **Major Bug Fix**: Fixed the window flashing issue where no actual rendering was occurring
  - Added `begin_drawing()` and `end_drawing()` methods to `LuaRaylib` struct
  - Implemented proper imperative drawing API that matches raylua patterns
  - Drawing methods (`clear_background`, `draw_text`, `draw_rectangle`, etc.) now work as instance methods on the window object
  - Fixed thread-local storage management for draw handles
  - Resolved lifetime issues with `RaylibDrawHandle`

### Added
- Imperative drawing pattern support (begin_drawing/end_drawing)
- Drawing methods as window instance methods:
  - `clear_background(color)`
  - `draw_text(text, x, y, size, color)`
  - `draw_rectangle(x, y, width, height, color)`
  - `draw_rectangle_lines(x, y, width, height, color)`
  - `draw_circle(x, y, radius, color)`
  - `draw_circle_lines(x, y, radius, color)`
  - `draw_line(x1, y1, x2, y2, color)`
  - `draw_pixel(x, y, color)`
- Missing color constant: `RAYWHITE`
- Comprehensive examples:
  - `01_basic_window.lua` - Basic window with text rendering
  - `02_shapes_and_input.lua` - Interactive shapes demo with keyboard/mouse input
- Development documentation in `DEVELOPMENT.md`
- Test script (`test_window.sh`) for easy testing
- Makefile improvements:
  - Added `build` target
  - Added `run` target for quick testing
  - Fixed library installation paths

### Changed
- Updated Makefile to create proper symlinks for Lua module loading
- Improved build process to handle platform-specific library extensions correctly
- Enhanced Makefile `install` target to properly handle all file types (C modules, Lua modules, and type definitions)
- Reorganized documentation structure with dedicated guides for installation and quick start

### Technical Details
The core issue was architectural: the original code had a `draw_frame` callback-based API but the Lua example expected imperative `begin_drawing`/`end_drawing` calls. 

The fix involved:
1. Adding `begin_drawing()` method that creates a `RaylibDrawHandle` and stores it in thread-local storage
2. Adding `end_drawing()` method that properly drops the draw handle to complete the frame
3. Implementing all drawing methods to access the thread-local draw handle
4. Using unsafe Rust with proper lifetime management to bridge the gap between Raylib's RAII pattern and Lua's imperative style

The implementation maintains safety by:
- Storing the draw handle pointer in thread-local storage with transmuted 'static lifetime
- Ensuring the handle is only accessible during the drawing phase (between begin/end calls)
- Properly cleaning up by dropping the boxed handle in `end_drawing()`

### Installation Improvements
After installing with `./install_local.sh`, the library is placed in:
- C module: `~/.luarocks/lib/lua/5.x/raylib_lua.so`
- Lua module: `~/.luarocks/share/lua/5.x/raylib/init.lua`

This allows users to simply write `require("raylib")` without any environment variable configuration. The installation process:
1. Detects the OS and Lua version automatically
2. Builds the library if needed
3. Copies files to the correct luarocks directories
4. Tests the installation to verify it works
5. Provides clear instructions for usage

## [0.1.0] - Initial Development

### Added
- Basic Rust bindings structure using mlua and raylib-rs
- Window creation and management
- Keyboard input handling
- Mouse input handling
- Color system with predefined constants
- FPS and timing functions
- Callback-based drawing API (`draw_frame`)
- Build system with Makefile and build.rs
- LuaRocks package configuration
- LSP support with type definitions

### Known Issues (Resolved)
- ~~Window flashing instead of rendering (fixed in unreleased)~~
- ~~Missing imperative drawing API (fixed in unreleased)~~

---

## Development Notes

### API Design Philosophy
The project aims to:
1. Maintain compatibility with raylua patterns where possible
2. Use snake_case naming conventions for Lua-friendly API
3. Support both imperative (begin/end) and functional (callback) patterns
4. Leverage mlua's features for better Lua integration
5. Provide comprehensive LSP/type definition support

### Future Plans
- Texture loading and rendering
- Audio support
- Font loading and custom fonts
- Camera system (2D and 3D)
- 3D drawing primitives
- Shader support
- Collision detection utilities
- Math helpers (vectors, matrices, etc.)
- More examples and documentation
- Performance optimization
- Comprehensive test suite
- LuaRocks publishing
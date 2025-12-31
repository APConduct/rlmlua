# Installation Guide for rlmlua

This guide covers different installation methods for rlmlua, the Raylib bindings for Lua.

## Table of Contents

- [Quick Install (Recommended)](#quick-install-recommended)
- [Installation Methods](#installation-methods)
  - [Method 1: LuaRocks (Recommended)](#method-1-luarocks-recommended)
  - [Method 2: Manual Installation](#method-2-manual-installation)
  - [Method 3: Development Setup](#method-3-development-setup)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)

## Quick Install (Recommended)

The fastest way to get started with rlmlua:

```bash
# Clone the repository
git clone <your-repo-url>
cd rlmlua

# Install locally with LuaRocks
luarocks make --local rockspecs/rlmlua-dev-1.rockspec

# Test it
lua examples/00_simple_after_install.lua
```

That's it! You can now use `require("raylib")` in any Lua script.

## Installation Methods

### Method 1: LuaRocks (Recommended)

LuaRocks automatically handles paths and dependencies, making it the easiest installation method.

#### Prerequisites

- Lua 5.1 or higher (tested with 5.1, 5.2, 5.3, 5.4)
- LuaRocks package manager
- Rust toolchain (stable channel)
- CMake (for building raylib)
- C compiler (gcc, clang, or MSVC)

#### Installing Prerequisites

**macOS:**
```bash
brew install lua luarocks rust cmake
```

**Ubuntu/Debian:**
```bash
sudo apt-get install lua5.4 liblua5.4-dev luarocks
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt-get install cmake build-essential
```

**Windows:**
- Install Lua from [LuaBinaries](http://luabinaries.sourceforge.net/)
- Install LuaRocks from [luarocks.org](https://luarocks.org/)
- Install Rust from [rustup.rs](https://rustup.rs/)
- Install CMake from [cmake.org](https://cmake.org/)

#### Installation Steps

**Local Installation (Recommended for users):**

```bash
# Navigate to the rlmlua directory
cd rlmlua

# Install locally (installs to ~/.luarocks/)
luarocks make --local rockspecs/rlmlua-dev-1.rockspec
```

**Global Installation (System-wide):**

```bash
# May require sudo on Unix systems
sudo luarocks make rockspecs/rlmlua-dev-1.rockspec
```

**What Gets Installed:**

- C module: `raylib_lua.so` (or `.dll` on Windows) → `<luarocks-tree>/lib/lua/5.x/`
- Lua module: `raylib/init.lua` → `<luarocks-tree>/share/lua/5.x/raylib/`
- Type definitions: `raylib/meta.lua` → `<luarocks-tree>/share/lua/5.x/raylib/`

#### After Installation

You can now use rlmlua in any script without setting environment variables:

```lua
-- your_script.lua
local rl = require("raylib")

local window = rl.init_window(800, 450, "My Game")
window:set_target_fps(60)

while not window:window_should_close() do
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)
    window:draw_text("Hello, Raylib!", 250, 200, 30, rl.colors.BLACK)
    window:end_drawing()
end
```

Run it:
```bash
lua your_script.lua
```

### Method 2: Manual Installation

If you prefer to install manually without LuaRocks:

#### Prerequisites

Same as LuaRocks method, but LuaRocks itself is optional.

#### Build Steps

```bash
# Clone and enter directory
git clone <your-repo-url>
cd rlmlua

# Build the library
cargo build --release

# Copy library to appropriate location based on OS
# macOS:
cp target/release/librlmlua.dylib target/release/libraylib_lua.so

# Linux:
cp target/release/librlmlua.so target/release/libraylib_lua.so

# Windows:
copy target\release\librlmlua.dll target\release\libraylib_lua.dll
```

#### Manual Installation to System

```bash
# Find your Lua paths
lua -e "print(package.cpath)"
lua -e "print(package.path)"

# Install C module (example for macOS/Linux)
sudo cp target/release/libraylib_lua.so /usr/local/lib/lua/5.4/raylib_lua.so

# Install Lua wrapper
sudo mkdir -p /usr/local/share/lua/5.4/raylib
sudo cp lua/raylib/init.lua /usr/local/share/lua/5.4/raylib/init.lua
sudo cp lua/raylib/meta.lua /usr/local/share/lua/5.4/raylib/meta.lua
```

**Note:** Adjust paths based on your system and Lua version.

#### Manual Usage Without Installation

If you don't want to install system-wide, set environment variables:

```bash
export LUA_PATH="./lua/?.lua;./lua/?/init.lua;;"
export LUA_CPATH="./target/release/?.so;;"
lua your_script.lua
```

Or create a wrapper script:

```bash
#!/bin/bash
LUA_PATH="./lua/?.lua;./lua/?/init.lua;;" \
LUA_CPATH="./target/release/?.so;;" \
lua "$@"
```

### Method 3: Development Setup

For contributing to rlmlua or active development:

```bash
# Clone the repository
git clone <your-repo-url>
cd rlmlua

# Build
make all

# Run tests
make run

# Or use the test script
./test_window.sh

# Install locally for testing
luarocks make --local rockspecs/rlmlua-dev-1.rockspec

# Test the installation
./test_luarocks_install.sh
```

## Verification

### Check Installation

```bash
# Check if rlmlua is installed via LuaRocks
luarocks list | grep rlmlua

# Test loading the module
lua -e "local rl = require('raylib'); print('✓ rlmlua loaded successfully')"

# Test basic functionality
lua -e "local rl = require('raylib'); assert(rl.init_window); assert(rl.colors); print('✓ All tests passed')"
```

### Run Example Programs

```bash
# Simple example (works after installation)
lua examples/00_simple_after_install.lua

# Basic window
lua examples/01_basic_window.lua

# Interactive shapes demo
lua examples/02_shapes_and_input.lua
```

### Check Installed Files

**LuaRocks local installation:**
```bash
ls ~/.luarocks/lib/lua/5.4/raylib_lua.so
ls ~/.luarocks/share/lua/5.4/raylib/init.lua
```

**LuaRocks global installation:**
```bash
ls /usr/local/lib/lua/5.4/raylib_lua.so
ls /usr/local/share/lua/5.4/raylib/init.lua
```

## Troubleshooting

### Module Not Found

**Error:** `module 'raylib' not found`

**Solutions:**

1. Verify installation:
   ```bash
   luarocks list | grep rlmlua
   ```

2. Check if it's installed locally and you're using global Lua:
   ```bash
   # Use local rocks
   eval $(luarocks path --bin)
   ```

3. Reinstall:
   ```bash
   luarocks remove --local rlmlua
   luarocks make --local rockspecs/rlmlua-dev-1.rockspec
   ```

### C Module Not Found

**Error:** `module 'raylib_lua' not found`

**Solutions:**

1. Make sure the library was built:
   ```bash
   ls target/release/libraylib_lua.so  # or .dylib/.dll
   ```

2. Rebuild:
   ```bash
   cargo clean
   cargo build --release
   make all
   ```

3. Check library permissions:
   ```bash
   chmod +x target/release/libraylib_lua.so
   ```

### Build Errors

**CMake Errors:**

If you get CMake-related errors during build:

```bash
# Clean and rebuild
cargo clean
rm -rf target/
cargo build --release
```

**Missing Dependencies:**

Install raylib dependencies based on your OS:

**macOS:**
```bash
brew install cmake
```

**Ubuntu/Debian:**
```bash
sudo apt-get install libx11-dev libxrandr-dev libxi-dev libxcursor-dev \
                     libxinerama-dev mesa-common-dev
```

**Arch Linux:**
```bash
sudo pacman -S libx11 libxrandr libxi libxcursor libxinerama mesa
```

### Library Path Issues

If Lua can't find the library after installation:

```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
eval $(luarocks path --bin)

# Or manually set paths
export LUA_PATH="$(luarocks path --lr-path);;"
export LUA_CPATH="$(luarocks path --lr-cpath);;"
```

### Permission Denied

**Error:** Permission denied during global installation

**Solution:**
```bash
# Use sudo for global installation
sudo luarocks make rockspecs/rlmlua-dev-1.rockspec

# Or use local installation instead
luarocks make --local rockspecs/rlmlua-dev-1.rockspec
```

### Wrong Lua Version

If you have multiple Lua versions:

```bash
# Check current Lua version
lua -v

# Specify Lua version for LuaRocks
luarocks --lua-version=5.4 make --local rockspecs/rlmlua-dev-1.rockspec

# Or use specific lua command
lua5.4 your_script.lua
```

## Uninstallation

### Remove LuaRocks Installation

```bash
# Remove local installation
luarocks remove --local rlmlua

# Remove global installation
sudo luarocks remove rlmlua

# Verify removal
luarocks list | grep rlmlua
```

### Remove Manual Installation

```bash
# Remove C module
sudo rm /usr/local/lib/lua/5.4/raylib_lua.so

# Remove Lua modules
sudo rm -rf /usr/local/share/lua/5.4/raylib
sudo rm -rf /usr/local/share/lua/5.4/rlmlua

# Clean build artifacts
cd rlmlua
cargo clean
```

## Platform-Specific Notes

### macOS

- On Apple Silicon (M1/M2/M3), make sure you have the ARM version of Rust installed
- You may need to install Xcode Command Line Tools: `xcode-select --install`
- The library is built as `.dylib` but copied to `.so` for Lua compatibility

### Linux

- Most distributions require X11 development libraries
- For Wayland support, additional configuration may be needed
- Check your distribution's package manager for raylib dependencies

### Windows

- Use Visual Studio Build Tools or MinGW
- Make sure to use the correct library extension (`.dll`)
- Path separators are backslashes (`\`) instead of forward slashes (`/`)
- You may need to add the library directory to your `PATH`

## Getting Help

If you encounter issues not covered here:

1. Check the [DEVELOPMENT.md](DEVELOPMENT.md) for architecture details
2. Review [CHANGELOG.md](CHANGELOG.md) for recent changes
3. Look at existing examples in the `examples/` directory
4. File an issue on the project's issue tracker

## Next Steps

After successful installation:

1. Read the [README.md](README.md) for API overview
2. Explore the examples in `examples/`
3. Check out [DEVELOPMENT.md](DEVELOPMENT.md) for advanced usage
4. Start building your game or application!

Happy coding with rlmlua! 🎮
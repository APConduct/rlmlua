#!/bin/bash
# Test script to verify the raylib Lua bindings work correctly

set -e

echo "Building rlmlua..."
cargo build --release

echo "Creating library symlinks..."
cp target/release/librlmlua.dylib target/release/libraylib_lua.so 2>/dev/null || \
cp target/release/librlmlua.so target/release/libraylib_lua.so 2>/dev/null || \
cp target/release/librlmlua.dll target/release/libraylib_lua.so 2>/dev/null

ln -sf libraylib_lua.so target/release/raylib_lua.so

echo "Running basic window example..."
echo "You should see a window with a sky blue background and 'Hello, World!' text."
echo "Close the window or press Ctrl+C to exit."
echo ""

LUA_PATH="./lua/?.lua;./lua/?/init.lua;;" \
LUA_CPATH="./target/release/?.so;;" \
lua examples/01_basic_window.lua

echo ""
echo "Test completed successfully!"

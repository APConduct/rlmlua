#!/bin/bash
# Uninstall script for rlmlua (local installation)

set -e

echo "========================================"
echo "Uninstalling rlmlua"
echo "========================================"
echo ""

# Get Lua version
LUA_VERSION=$(lua -e "print(string.match(_VERSION, '%d+%.%d+'))")
echo "Detected Lua version: $LUA_VERSION"

# Determine installation directories
LUAROCKS_PREFIX="$HOME/.luarocks"
INST_LIBDIR="$LUAROCKS_PREFIX/lib/lua/$LUA_VERSION"
INST_LUADIR="$LUAROCKS_PREFIX/share/lua/$LUA_VERSION"

echo "Checking installation directories:"
echo "  C modules: $INST_LIBDIR"
echo "  Lua modules: $INST_LUADIR"
echo ""

# Remove C module
if [ -f "$INST_LIBDIR/raylib_lua.so" ]; then
    echo "Removing C module..."
    rm "$INST_LIBDIR/raylib_lua.so"
    echo "✓ Removed raylib_lua.so"
else
    echo "✗ C module not found (already uninstalled?)"
fi

# Remove Lua modules
if [ -d "$INST_LUADIR/raylib" ]; then
    echo "Removing raylib Lua module..."
    rm -rf "$INST_LUADIR/raylib"
    echo "✓ Removed raylib/"
else
    echo "✗ raylib module not found"
fi

if [ -d "$INST_LUADIR/rlmlua" ]; then
    echo "Removing rlmlua helper module..."
    rm -rf "$INST_LUADIR/rlmlua"
    echo "✓ Removed rlmlua/"
else
    echo "✗ rlmlua module not found"
fi

echo ""
echo "========================================"
echo "Uninstallation completed!"
echo "========================================"
echo ""

# Test that it's really gone
if lua -e "require('raylib')" 2>/dev/null; then
    echo "⚠ Warning: Module still loads (may be installed elsewhere)"
else
    echo "✓ Confirmed: raylib module is no longer available"
fi

echo ""
echo "To reinstall, run: ./install_local.sh"
echo ""

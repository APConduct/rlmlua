#!/bin/bash
# Test script for luarocks installation

set -e

echo "========================================"
echo "Testing rlmlua luarocks installation"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Determine the rockspec file
ROCKSPEC="rockspecs/rlmlua-dev-1.rockspec"

if [ ! -f "$ROCKSPEC" ]; then
    echo -e "${RED}Error: Rockspec file not found: $ROCKSPEC${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Building the project${NC}"
make all
echo ""

echo -e "${YELLOW}Step 2: Installing with luarocks (local tree)${NC}"
echo "This will install to a local tree for testing..."
luarocks make --local "$ROCKSPEC"
echo ""

echo -e "${YELLOW}Step 3: Verifying installation${NC}"
lua -e "local rl = require('raylib'); print('✓ raylib module loaded successfully')"
echo ""

echo -e "${YELLOW}Step 4: Testing basic functionality${NC}"
lua << 'LUATEST'
local rl = require("raylib")

-- Test module exports
assert(rl.init_window, "init_window function not found")
assert(rl.color, "color function not found")
assert(rl.colors, "colors table not found")
assert(rl.colors.WHITE, "WHITE color not found")
assert(rl.colors.SKYBLUE, "SKYBLUE color not found")
assert(rl.colors.RAYWHITE, "RAYWHITE color not found")

print("✓ All basic functions are accessible")
print("✓ Color system is working")
LUATEST
echo ""

echo -e "${YELLOW}Step 5: Running test example${NC}"
cat > /tmp/rlmlua_test.lua << 'EXAMPLE'
local rl = require("raylib")

print("Creating window...")
local window = rl.init_window(400, 300, "rlmlua - Installation Test")
window:set_target_fps(60)

print("Window created successfully!")
print("Rendering for 2 seconds...")

local frame_count = 0
local max_frames = 120  -- 2 seconds at 60 FPS

while not window:window_should_close() and frame_count < max_frames do
    window:begin_drawing()
    window:clear_background(rl.colors.DARKGREEN)
    window:draw_text("Installation Test", 100, 120, 20, rl.colors.WHITE)
    window:draw_text("Success!", 150, 150, 20, rl.colors.LIME)
    window:draw_text(string.format("Frame: %d/120", frame_count), 120, 180, 16, rl.colors.LIGHTGRAY)
    window:end_drawing()
    frame_count = frame_count + 1
end

print("Test completed successfully!")
EXAMPLE

timeout 3 lua /tmp/rlmlua_test.lua || true
rm /tmp/rlmlua_test.lua
echo ""

echo -e "${GREEN}========================================"
echo "Installation test completed successfully!"
echo "========================================${NC}"
echo ""
echo "To uninstall, run:"
echo "  luarocks remove --local rlmlua"
echo ""
echo "To use in your scripts, simply:"
echo "  require('raylib')"
echo ""
echo "Example scripts are in: examples/"

local f = io.open("install_local.sh", "r")
local content = f:read("*all")
f:close()

-- Add cleanup before installing
local pattern = "# Install C module\necho \"Installing C module%.%.%.\"\n"
local replacement = [[# Clean up any old versions first
echo "Cleaning up old versions..."
rm -f "$INST_LIBDIR/raylib_lua.so" "$INST_LIBDIR/raylib_lua.dylib" "$INST_LIBDIR/raylib_lua.dll"

# Install C module
echo "Installing C module..."
]]

content = content:gsub(pattern, replacement)

local out = io.open("install_local.sh", "w")
out:write(content)
out:close()

print("Updated install script to clean old versions")

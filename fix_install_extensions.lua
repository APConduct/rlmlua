local f = io.open("install_local.sh", "r")
local content = f:read("*all")
f:close()

-- Fix the LIB_NAME to use proper extension per OS
local old_pattern = [[OS_NAME=$(uname -s)
if [ "$OS_NAME" = "Darwin" ]; then
    DYNAM_EXT=".dylib"
    LIB_NAME="libraylib_lua.so"
elif [ "$OS_NAME" = "Linux" ]; then
    DYNAM_EXT=".so"
    LIB_NAME="libraylib_lua.so"
else
    DYNAM_EXT=".dll"
    LIB_NAME="raylib_lua.dll"
fi]]

local new_config = [[OS_NAME=$(uname -s)
if [ "$OS_NAME" = "Darwin" ]; then
    DYNAM_EXT=".dylib"
    INSTALL_NAME="raylib_lua.dylib"
elif [ "$OS_NAME" = "Linux" ]; then
    DYNAM_EXT=".so"
    INSTALL_NAME="raylib_lua.so"
else
    DYNAM_EXT=".dll"
    INSTALL_NAME="raylib_lua.dll"
fi]]

content = content:gsub(old_pattern, new_config)

-- Fix the install command to use INSTALL_NAME
content = content:gsub(
    'cp target/release/%$LIB_NAME "%$INST_LIBDIR/raylib_lua%.so"',
    'cp target/release/librlmlua$DYNAM_EXT "$INST_LIBDIR/$INSTALL_NAME"'
)

-- Fix chmod to use INSTALL_NAME
content = content:gsub(
    'chmod 755 "%$INST_LIBDIR/raylib_lua%.so"',
    'chmod 755 "$INST_LIBDIR/$INSTALL_NAME"'
)

local out = io.open("install_local.sh", "w")
out:write(content)
out:close()

print("Fixed install script to use correct file extensions per OS")

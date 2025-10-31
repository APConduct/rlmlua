local f = io.open("install_local.sh", "r")
local content = f:read("*all")
f:close()

-- Fix the preparation step - don't change extension, just copy with proper name
local old_prep = [[# Copy library to proper format
echo "Preparing library files..."
if [ "$OS_NAME" = "Darwin" ]; then
    cp target/release/librlmlua.dylib target/release/libraylib_lua.so
elif [ "$OS_NAME" = "Linux" ]; then
    cp target/release/librlmlua.so target/release/libraylib_lua.so
else
    cp target/release/librlmlua.dll target/release/libraylib_lua.dll
fi]]

local new_prep = [[# No preparation needed - we'll copy directly from the built library]]

content = content:gsub(old_prep:gsub("([%[%]%(%)%.%-%+%*%?])", "%%%1"), new_prep)

local out = io.open("install_local.sh", "w")
out:write(content)
out:close()

print("Removed unnecessary preparation step")

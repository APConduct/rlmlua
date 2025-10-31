local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Update window_should_close to poll events first
local old_pattern = '        methods%.add_method_mut%("window_should_close", |_, this, %(%)| {\n            Ok%(this%.rl%.window_should_close%(%)%)\n        }%);'

local new_code = [[        methods.add_method_mut("window_should_close", |_, this, ()| {
            // Poll input events to ensure window state is up to date
            this.rl.poll_input_events();
            Ok(this.rl.window_should_close())
        });]]

content = content:gsub(old_pattern, new_code)

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Added poll_input_events to window_should_close")

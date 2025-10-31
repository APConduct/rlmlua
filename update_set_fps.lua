local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Update set_target_fps to store in thread-local
local pattern = '        methods%.add_method_mut%("set_target_fps", |_, this, fps: u32| {\n            this%.rl%.set_target_fps%(fps%);\n            Ok%(%(%)%)\n        }%);'

local replacement = [[        methods.add_method_mut("set_target_fps", |_, this, fps: u32| {
            this.rl.set_target_fps(fps);
            TARGET_FPS.with(|f| f.replace(fps));
            Ok(())
        });]]

content = content:gsub(pattern, replacement)

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Updated set_target_fps")

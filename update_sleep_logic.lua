local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Find and replace the sleep logic to be more conservative
local old_sleep = [[                        if elapsed < target_frame_time {
                            thread::sleep(target_frame_time - elapsed);
                        }]]

local new_sleep = [[                        // Only sleep if we have more than 5ms to spare
                        // This avoids interfering with VSync while still limiting runaway FPS
                        if elapsed < target_frame_time {
                            let remaining = target_frame_time - elapsed;
                            if remaining > Duration::from_millis(5) {
                                thread::sleep(remaining - Duration::from_millis(2));
                            }
                        }]]

content = content:gsub(old_sleep:gsub("([%[%]%(%)%.%-%+%*%?])", "%%%1"), new_sleep)

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Updated sleep logic to be more conservative")

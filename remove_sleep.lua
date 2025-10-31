local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Comment out the entire sleep section
local sleep_section_start = "            // Frame timing %- wait to match target FPS"
local sleep_section_end = "            });"

-- Find the frame timing section and comment it out
local pattern = "(            // Frame timing %- wait to match target FPS.-            });)"
local replacement = [[            // Frame timing disabled - relying on VSync
            // The thread::sleep was causing flickering issues
            // VSync should handle frame timing naturally
            /*
            FRAME_START.with(|start_cell| {
                // ... sleep code commented out ...
            });
            */]]

content = content:gsub(pattern, replacement)

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Disabled sleep-based frame timing")

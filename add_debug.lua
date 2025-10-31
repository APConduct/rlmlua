local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Add debug after setting FRAME_START
content = content:gsub(
    "(FRAME_START%.with%(|f| f%.replace%(Some%(Instant::now%(%)%)%)%)%;)",
    "%1\n            eprintln!(\"Frame start recorded\");"
)

-- Add debug in end_drawing frame timing
content = content:gsub(
    "(%s+)// Frame timing %- wait to match target FPS",
    "%1eprintln!(\"end_drawing: checking frame timing\");\n%1// Frame timing - wait to match target FPS"
)

content = content:gsub(
    "(%s+)if elapsed < target_frame_time {",
    "%1eprintln!(\"Sleeping for {:?}\", target_frame_time - elapsed);\n%1if elapsed < target_frame_time {"
)

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Added debug output")

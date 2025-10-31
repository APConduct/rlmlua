local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Add timing imports after the existing use statements
local use_pattern = "(use std::cell::RefCell;)"
local new_imports = [[use std::cell::RefCell;
use std::time::Instant;
use std::thread;
use std::time::Duration;]]

content = content:gsub(use_pattern, new_imports)

-- Add frame timing thread-local after DRAW_HANDLE
local thread_local_pattern = "(thread_local! {\n    static DRAW_HANDLE: RefCell<Option<.*>> = RefCell::new%(None%);\n})"
local new_thread_locals = [[thread_local! {
    static DRAW_HANDLE: RefCell<Option<*mut RaylibDrawHandle<'static>>> = RefCell::new(None);
    static FRAME_START: RefCell<Option<Instant>> = RefCell::new(None);
    static TARGET_FPS: RefCell<u32> = RefCell::new(60);
}]]

content = content:gsub(thread_local_pattern, new_thread_locals)

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Added frame timing imports and thread-locals")

local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Find where draw_frame ends and insert begin/end_drawing after it
local pattern = "(        });)\n\n(        // Input %- Keyboard)"

local new_methods = [[
        });

        // Imperative drawing API
        methods.add_method_mut("begin_drawing", |_, this, ()| {
            let d = this.rl.begin_drawing(&this.thread);
            // SAFETY: We transmute to 'static lifetime and store in thread-local
            let d_static: *mut RaylibDrawHandle<'static> =
                unsafe { std::mem::transmute(Box::into_raw(Box::new(d))) };
            DRAW_HANDLE.with(|cell| cell.replace(Some(d_static)));
            Ok(())
        });

        methods.add_method_mut("end_drawing", |_, _this, ()| {
            // Clean up the draw handle
            DRAW_HANDLE.with(|cell| {
                if let Some(d_ptr) = cell.replace(None) {
                    unsafe {
                        // Reconstruct and drop the box to call EndDrawing()
                        let boxed_handle = Box::from_raw(d_ptr);
                        std::mem::drop(boxed_handle);
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("clear_background", |_, _this, color: LuaColor| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).clear_background(<LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("draw_text", |_, _this, (text, x, y, size, color): (String, i32, i32, i32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_text(&text, x, y, size, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("draw_rectangle", |_, _this, (x, y, width, height, color): (i32, i32, i32, i32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_rectangle(x, y, width, height, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("draw_circle", |_, _this, (x, y, radius, color): (i32, i32, f32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_circle(x, y, radius, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("draw_line", |_, _this, (x1, y1, x2, y2, color): (i32, i32, i32, i32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_line(x1, y1, x2, y2, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("draw_pixel", |_, _this, (x, y, color): (i32, i32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_pixel(x, y, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("draw_rectangle_lines", |_, _this, (x, y, width, height, color): (i32, i32, i32, i32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_rectangle_lines(x, y, width, height, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

        methods.add_method_mut("draw_circle_lines", |_, _this, (x, y, radius, color): (i32, i32, f32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_circle_lines(x, y, radius, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });

]]

content = content:gsub(pattern, new_methods .. "\n%2")

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Added begin_drawing, end_drawing, and drawing methods")

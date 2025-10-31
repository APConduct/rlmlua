use mlua::prelude::*;
use raylib::prelude::*;
use std::cell::RefCell;

// Thread-local storage for the current draw handle
thread_local! {
    static DRAW_HANDLE: RefCell<Option<*mut RaylibDrawHandle<'static>>> = RefCell::new(None);
}

#[allow(dead_code)]
struct LuaRaylib<'l> {
    rl: RaylibHandle,
    thread: RaylibThread,
    dh: Option<RaylibDrawHandle<'l>>,
}

pub fn close_window() {
    unsafe {
        ffi::CloseWindow();
    }
}

impl<'l> LuaUserData for LuaRaylib<'l> {
    fn add_methods<'lua, M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_method_mut("should_close", |_, this, ()| {
            Ok(this.rl.window_should_close())
        });

        methods.add_method_mut("close", |_, _this, ()| {
            close_window();
            Ok(())
        });

        methods.add_method_mut("set_target_fps", |_, this, fps: u32| {
            this.rl.set_target_fps(fps);
            Ok(())
        });

        methods.add_method_mut("get_fps", |_, this, ()| Ok(this.rl.get_fps()));

        methods.add_method_mut("get_frame_time", |_, this, ()| Ok(this.rl.get_frame_time()));

        methods.add_method_mut("get_time", |_, this, ()| Ok(this.rl.get_time()));

        methods.add_method_mut("get_screen_width", |_, this, ()| {
            Ok(this.rl.get_screen_width())
        });

        methods.add_method_mut("get_screen_height", |_, this, ()| {
            Ok(this.rl.get_screen_height())
        });

        // Drawing Functions

        methods.add_method_mut("draw_frame", |_, this, func: LuaFunction| {
            let mut d = this.rl.begin_drawing(&this.thread);

            // SAFETY: We guarantee the pointer is only valid for the duration of this frame
            let d_static: *mut RaylibDrawHandle<'static> = unsafe { std::mem::transmute(&mut d) };
            DRAW_HANDLE.with(|cell| cell.replace(Some(d_static)));

            func.call::<()>(())?;

            DRAW_HANDLE.with(|cell| cell.replace(None));

            Ok(())
        });

        // Direct drawing API (begin/end style)
        methods.add_method_mut("begin_drawing", |_, this, ()| {
            // Store the draw handle in the struct
            let d = this.rl.begin_drawing(&this.thread);
            // SAFETY: We transmute the lifetime to static and store it in thread-local
            let d_static: *mut RaylibDrawHandle<'static> =
                unsafe { std::mem::transmute(Box::into_raw(Box::new(d))) };
            DRAW_HANDLE.with(|cell| cell.replace(Some(d_static)));
            Ok(())
        });

        methods.add_method_mut("end_drawing", |_, _this, ()| {
            // Clean up the draw handle
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = cell.replace(None) {
                    unsafe {
                        // Reconstruct the box and let it drop
                        let _ = Box::from_raw(d);
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

        methods.add_method_mut(
            "draw_text",
            |_, _this, (text, x, y, size, color): (String, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_text(
                                &text,
                                x,
                                y,
                                size,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );

        methods.add_method_mut(
            "draw_rectangle",
            |_, _this, (x, y, width, height, color): (i32, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_rectangle(
                                x,
                                y,
                                width,
                                height,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );

        methods.add_method_mut(
            "draw_circle",
            |_, _this, (x, y, radius, color): (i32, i32, f32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_circle(x, y, radius, <LuaColor as Into<Color>>::into(color));
                        }
                    }
                });
                Ok(())
            },
        );

        methods.add_method_mut(
            "draw_line",
            |_, _this, (x1, y1, x2, y2, color): (i32, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_line(x1, y1, x2, y2, <LuaColor as Into<Color>>::into(color));
                        }
                    }
                });
                Ok(())
            },
        );

        methods.add_method_mut(
            "draw_pixel",
            |_, _this, (x, y, color): (i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_pixel(x, y, <LuaColor as Into<Color>>::into(color));
                        }
                    }
                });
                Ok(())
            },
        );

        methods.add_method_mut(
            "draw_rectangle_lines",
            |_, _this, (x, y, width, height, color): (i32, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_rectangle_lines(
                                x,
                                y,
                                width,
                                height,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );

        methods.add_method_mut(
            "draw_circle_lines",
            |_, _this, (x, y, radius, color): (i32, i32, f32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_circle_lines(
                                x,
                                y,
                                radius,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );

        // Exit key configuration
        methods.add_method_mut("set_exit_key", |_, _this, key: i32| {
            unsafe {
                ffi::SetExitKey(key);
            }
            Ok(())
        });

        // Input - Keyboard

        methods.add_method("is_key_pressed", |_, this, key: String| {
            Ok(this.rl.is_key_pressed(str_to_key(&key)))
        });

        methods.add_method("is_key_down", |_, this, key: String| {
            Ok(this.rl.is_key_down(str_to_key(&key)))
        });

        methods.add_method("is_key_released", |_, this, key: String| {
            Ok(this.rl.is_key_released(str_to_key(&key)))
        });

        methods.add_method("is_key_up", |_, this, key: String| {
            Ok(this.rl.is_key_up(str_to_key(&key)))
        });

        // Input - Mouse

        methods.add_method("get_mouse_position", |_, this, ()| {
            let pos = this.rl.get_mouse_position();
            Ok((pos.x, pos.y))
        });

        methods.add_method("get_mouse_wheel_move", |_, this, ()| {
            let wheel = this.rl.get_mouse_wheel_move();
            Ok(wheel)
        });

        methods.add_method("get_mouse_x", |_, this, ()| Ok(this.rl.get_mouse_x()));

        methods.add_method("get_mouse_y", |_, this, ()| Ok(this.rl.get_mouse_y()));

        methods.add_method("is_mouse_button_pressed", |_, this, button: i32| {
            let mb = int_to_mouse_button(button);
            Ok(this.rl.is_mouse_button_pressed(mb))
        });

        methods.add_method("is_mouse_button_down", |_, this, button: i32| {
            let mb = int_to_mouse_button(button);
            Ok(this.rl.is_mouse_button_down(mb))
        });

        methods.add_method("is_mouse_button_released", |_, this, button: i32| {
            let mb = int_to_mouse_button(button);
            Ok(this.rl.is_mouse_button_released(mb))
        });

        methods.add_method("is_mouse_button_up", |_, this, button: i32| {
            let mb = int_to_mouse_button(button);
            Ok(this.rl.is_mouse_button_up(mb))
        });
    }
}

// Lua wrapper for RaylibDrawHandle
#[allow(dead_code)]
struct LuaDrawHandle<'a> {
    handle: &'a mut RaylibDrawHandle<'a>,
}

impl<'a> LuaUserData for LuaDrawHandle<'a> {
    fn add_methods<'lua, M: LuaUserDataMethods<Self>>(methods: &mut M) {
        // Register global drawing functions that use DRAW_HANDLE
        methods.add_function("clear_background", |_, color: LuaColor| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).clear_background(<LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });
        methods.add_function(
            "draw_text",
            |_, (text, x, y, size, color): (String, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_text(
                                &text,
                                x,
                                y,
                                size,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );
        methods.add_function(
            "draw_rectangle",
            |_, (x, y, width, height, color): (i32, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_rectangle(
                                x,
                                y,
                                width,
                                height,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );
        methods.add_function(
            "draw_circle",
            |_, (x, y, radius, color): (i32, i32, f32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_circle(x, y, radius, <LuaColor as Into<Color>>::into(color));
                        }
                    }
                });
                Ok(())
            },
        );
        methods.add_function(
            "draw_line",
            |_, (x1, y1, x2, y2, color): (i32, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_line(x1, y1, x2, y2, <LuaColor as Into<Color>>::into(color));
                        }
                    }
                });
                Ok(())
            },
        );
        methods.add_function("draw_pixel", |_, (x, y, color): (i32, i32, LuaColor)| {
            DRAW_HANDLE.with(|cell| {
                if let Some(d) = *cell.borrow() {
                    unsafe {
                        (*d).draw_pixel(x, y, <LuaColor as Into<Color>>::into(color));
                    }
                }
            });
            Ok(())
        });
        methods.add_function(
            "draw_rectangle_lines",
            |_, (x, y, width, height, color): (i32, i32, i32, i32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_rectangle_lines(
                                x,
                                y,
                                width,
                                height,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );
        methods.add_function(
            "draw_circle_lines",
            |_, (x, y, radius, color): (i32, i32, f32, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_circle_lines(
                                x,
                                y,
                                radius,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );
    }
}

#[derive(Clone, Copy)]
pub struct LuaColor {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
}

impl From<LuaColor> for Color {
    fn from(value: LuaColor) -> Self {
        Color::new(value.r, value.g, value.b, value.a)
    }
}

impl<'lua> FromLua for LuaColor {
    fn from_lua(value: LuaValue, _lua: &Lua) -> LuaResult<Self> {
        match value {
            LuaValue::Table(t) => Ok(LuaColor {
                r: t.get(1)?,
                g: t.get(2)?,
                b: t.get(3)?,
                a: t.get(4).unwrap_or(255),
            }),
            _ => Err(LuaError::FromLuaConversionError {
                from: "value",
                to: "Color".to_string(),
                message: Some("Expected table {r, g, b, a}".to_string()),
            }),
        }
    }
}

pub fn str_to_key(s: &str) -> KeyboardKey {
    match s.to_uppercase().as_str() {
        "SPACE" => KeyboardKey::KEY_SPACE,
        "ESCAPE" | "ESC" => KeyboardKey::KEY_ESCAPE,
        "ENTER" | "RETURN" => KeyboardKey::KEY_ENTER,
        "TAB" => KeyboardKey::KEY_TAB,
        "BACKSPACE" => KeyboardKey::KEY_BACKSPACE,
        "INSERT" => KeyboardKey::KEY_INSERT,
        "DELETE" => KeyboardKey::KEY_DELETE,
        "RIGHT" => KeyboardKey::KEY_RIGHT,
        "LEFT" => KeyboardKey::KEY_LEFT,
        "DOWN" => KeyboardKey::KEY_DOWN,
        "UP" => KeyboardKey::KEY_UP,
        "PAGE_UP" => KeyboardKey::KEY_PAGE_UP,
        "PAGE_DOWN" => KeyboardKey::KEY_PAGE_DOWN,
        "HOME" => KeyboardKey::KEY_HOME,
        "END" => KeyboardKey::KEY_END,

        // Letters
        "A" => KeyboardKey::KEY_A,
        "B" => KeyboardKey::KEY_B,
        "C" => KeyboardKey::KEY_C,
        "D" => KeyboardKey::KEY_D,
        "E" => KeyboardKey::KEY_E,
        "F" => KeyboardKey::KEY_F,
        "G" => KeyboardKey::KEY_G,
        "H" => KeyboardKey::KEY_H,
        "I" => KeyboardKey::KEY_I,
        "J" => KeyboardKey::KEY_J,
        "K" => KeyboardKey::KEY_K,
        "L" => KeyboardKey::KEY_L,
        "M" => KeyboardKey::KEY_M,
        "N" => KeyboardKey::KEY_N,
        "O" => KeyboardKey::KEY_O,
        "P" => KeyboardKey::KEY_P,
        "Q" => KeyboardKey::KEY_Q,
        "R" => KeyboardKey::KEY_R,
        "S" => KeyboardKey::KEY_S,
        "T" => KeyboardKey::KEY_T,
        "U" => KeyboardKey::KEY_U,
        "V" => KeyboardKey::KEY_V,
        "W" => KeyboardKey::KEY_W,
        "X" => KeyboardKey::KEY_X,
        "Y" => KeyboardKey::KEY_Y,
        "Z" => KeyboardKey::KEY_Z,

        // Numbers
        "0" => KeyboardKey::KEY_ZERO,
        "1" => KeyboardKey::KEY_ONE,
        "2" => KeyboardKey::KEY_TWO,
        "3" => KeyboardKey::KEY_THREE,
        "4" => KeyboardKey::KEY_FOUR,
        "5" => KeyboardKey::KEY_FIVE,
        "6" => KeyboardKey::KEY_SIX,
        "7" => KeyboardKey::KEY_SEVEN,
        "8" => KeyboardKey::KEY_EIGHT,
        "9" => KeyboardKey::KEY_NINE,

        // Function keys
        "F1" => KeyboardKey::KEY_F1,
        "F2" => KeyboardKey::KEY_F2,
        "F3" => KeyboardKey::KEY_F3,
        "F4" => KeyboardKey::KEY_F4,
        "F5" => KeyboardKey::KEY_F5,
        "F6" => KeyboardKey::KEY_F6,
        "F7" => KeyboardKey::KEY_F7,
        "F8" => KeyboardKey::KEY_F8,
        "F9" => KeyboardKey::KEY_F9,
        "F10" => KeyboardKey::KEY_F10,
        "F11" => KeyboardKey::KEY_F11,
        "F12" => KeyboardKey::KEY_F12,

        // Modifiers
        "SHIFT" | "LEFT_SHIFT" => KeyboardKey::KEY_LEFT_SHIFT,
        "RIGHT_SHIFT" => KeyboardKey::KEY_RIGHT_SHIFT,
        "CTRL" | "CONTROL" | "LEFT_CONTROL" => KeyboardKey::KEY_LEFT_CONTROL,
        "RIGHT_CONTROL" => KeyboardKey::KEY_RIGHT_CONTROL,
        "ALT" | "LEFT_ALT" => KeyboardKey::KEY_LEFT_ALT,
        "RIGHT_ALT" => KeyboardKey::KEY_RIGHT_ALT,

        _ => KeyboardKey::KEY_NULL,
    }
}

/// Convert integer to MouseButton enum
pub fn int_to_mouse_button(button: i32) -> MouseButton {
    match button {
        0 => MouseButton::MOUSE_BUTTON_LEFT,
        1 => MouseButton::MOUSE_BUTTON_RIGHT,
        2 => MouseButton::MOUSE_BUTTON_MIDDLE,
        3 => MouseButton::MOUSE_BUTTON_SIDE,
        4 => MouseButton::MOUSE_BUTTON_EXTRA,
        5 => MouseButton::MOUSE_BUTTON_FORWARD,
        6 => MouseButton::MOUSE_BUTTON_BACK,
        _ => MouseButton::MOUSE_BUTTON_LEFT,
    }
}

// Library Functions

/// Initialize window and OpenGL context
fn init_window<'l>(
    _lua: &Lua,
    (width, height, title): (i32, i32, String),
) -> LuaResult<LuaRaylib<'l>> {
    let (rl, thread) = raylib::init().size(width, height).title(&title).build();

    Ok(LuaRaylib {
        rl,
        thread,
        dh: None,
    })
}

/// Create color from RGBA values
fn color(_lua: &Lua, (r, g, b, a): (u8, u8, u8, Option<u8>)) -> LuaResult<LuaColor> {
    Ok(LuaColor {
        r,
        g,
        b,
        a: a.unwrap_or(255),
    })
}

impl IntoLua for LuaColor {
    fn into_lua(self, lua: &Lua) -> LuaResult<LuaValue> {
        let table = lua.create_table()?;
        table.set(1, self.r)?;
        table.set(2, self.g)?;
        table.set(3, self.b)?;
        table.set(4, self.a)?;
        Ok(LuaValue::Table(table))
    }
}

/// Register color constants
fn register_colors(lua: &Lua, exports: &LuaTable) -> LuaResult<()> {
    let colors = lua.create_table()?;

    // Basic colors
    colors.set(
        "WHITE",
        LuaColor {
            r: 255,
            g: 255,
            b: 255,
            a: 255,
        },
    )?;
    colors.set(
        "RAYWHITE",
        LuaColor {
            r: 245,
            g: 245,
            b: 245,
            a: 255,
        },
    )?;
    colors.set(
        "BLACK",
        LuaColor {
            r: 0,
            g: 0,
            b: 0,
            a: 255,
        },
    )?;
    colors.set(
        "BLANK",
        LuaColor {
            r: 0,
            g: 0,
            b: 0,
            a: 0,
        },
    )?;

    // Primary colors
    colors.set(
        "RED",
        LuaColor {
            r: 255,
            g: 0,
            b: 0,
            a: 255,
        },
    )?;
    colors.set(
        "GREEN",
        LuaColor {
            r: 0,
            g: 255,
            b: 0,
            a: 255,
        },
    )?;
    colors.set(
        "BLUE",
        LuaColor {
            r: 0,
            g: 0,
            b: 255,
            a: 255,
        },
    )?;

    // Secondary colors
    colors.set(
        "YELLOW",
        LuaColor {
            r: 255,
            g: 255,
            b: 0,
            a: 255,
        },
    )?;
    colors.set(
        "MAGENTA",
        LuaColor {
            r: 255,
            g: 0,
            b: 255,
            a: 255,
        },
    )?;
    colors.set(
        "CYAN",
        LuaColor {
            r: 0,
            g: 255,
            b: 255,
            a: 255,
        },
    )?;

    // Grayscale
    colors.set(
        "DARKGRAY",
        LuaColor {
            r: 80,
            g: 80,
            b: 80,
            a: 255,
        },
    )?;
    colors.set(
        "GRAY",
        LuaColor {
            r: 130,
            g: 130,
            b: 130,
            a: 255,
        },
    )?;
    colors.set(
        "LIGHTGRAY",
        LuaColor {
            r: 200,
            g: 200,
            b: 200,
            a: 255,
        },
    )?;

    // Raylib special colors
    colors.set(
        "SKYBLUE",
        LuaColor {
            r: 102,
            g: 191,
            b: 255,
            a: 255,
        },
    )?;
    colors.set(
        "ORANGE",
        LuaColor {
            r: 255,
            g: 161,
            b: 0,
            a: 255,
        },
    )?;
    colors.set(
        "PURPLE",
        LuaColor {
            r: 200,
            g: 122,
            b: 255,
            a: 255,
        },
    )?;
    colors.set(
        "PINK",
        LuaColor {
            r: 255,
            g: 109,
            b: 194,
            a: 255,
        },
    )?;
    colors.set(
        "LIME",
        LuaColor {
            r: 0,
            g: 228,
            b: 48,
            a: 255,
        },
    )?;
    colors.set(
        "GOLD",
        LuaColor {
            r: 255,
            g: 203,
            b: 0,
            a: 255,
        },
    )?;
    colors.set(
        "BROWN",
        LuaColor {
            r: 127,
            g: 106,
            b: 79,
            a: 255,
        },
    )?;
    colors.set(
        "DARKBROWN",
        LuaColor {
            r: 76,
            g: 63,
            b: 47,
            a: 255,
        },
    )?;
    colors.set(
        "MAROON",
        LuaColor {
            r: 190,
            g: 33,
            b: 55,
            a: 255,
        },
    )?;
    colors.set(
        "BEIGE",
        LuaColor {
            r: 211,
            g: 176,
            b: 131,
            a: 255,
        },
    )?;
    colors.set(
        "DARKBLUE",
        LuaColor {
            r: 0,
            g: 82,
            b: 172,
            a: 255,
        },
    )?;
    colors.set(
        "DARKGREEN",
        LuaColor {
            r: 0,
            g: 117,
            b: 44,
            a: 255,
        },
    )?;
    colors.set(
        "DARKPURPLE",
        LuaColor {
            r: 112,
            g: 31,
            b: 126,
            a: 255,
        },
    )?;
    colors.set(
        "VIOLET",
        LuaColor {
            r: 135,
            g: 60,
            b: 190,
            a: 255,
        },
    )?;

    exports.set("colors", colors)?;
    Ok(())
}

#[derive(Clone, Copy)]
pub struct LuaVector2 {
    pub x: f32,
    pub y: f32,
}

impl<'l> LuaUserData for LuaVector2 {
    fn add_fields<F: LuaUserDataFields<Self>>(fields: &mut F) {
        fields.add_field_method_get("x", |_, this| Ok(this.x));
        fields.add_field_method_get("y", |_, this| Ok(this.y));
    }

    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_method("__add", |_, this, other: LuaVector2| {
            Ok(LuaVector2 {
                x: this.x + other.x,
                y: this.y + other.y,
            })
        });
        methods.add_method("__sub", |_, this, other: LuaVector2| {
            Ok(LuaVector2 {
                x: this.x - other.x,
                y: this.y - other.y,
            })
        });
        methods.add_method("__mul", |_, this, other: LuaVector2| {
            Ok(LuaVector2 {
                x: this.x * other.x,
                y: this.y * other.y,
            })
        });
        methods.add_method("__div", |_, this, other: LuaVector2| {
            Ok(LuaVector2 {
                x: this.x / other.x,
                y: this.y / other.y,
            })
        });
        methods.add_method("__mod", |_, this, other: LuaVector2| {
            Ok(LuaVector2 {
                x: this.x % other.x,
                y: this.y % other.y,
            })
        });
        methods.add_method("__pow", |_, this, other: LuaVector2| {
            Ok(LuaVector2 {
                x: this.x.powf(other.x),
                y: this.y.powf(other.y),
            })
        });
        methods.add_method("__unm", |_, this, ()| {
            Ok(LuaVector2 {
                x: -this.x,
                y: -this.y,
            })
        });
        methods.add_method("__len", |_, this, ()| Ok(this.x.hypot(this.y)));
        methods.add_method("__eq", |_, this, other: LuaVector2| {
            Ok((this.x - other.x).abs() < f32::EPSILON && (this.y - other.y).abs() < f32::EPSILON)
        });

        methods.add_method("__lt", |_, this, other: LuaVector2| {
            Ok(this.x < other.x && this.y < other.y)
        });
        methods.add_method("__le", |_, this, other: LuaVector2| {
            Ok(this.x <= other.x && this.y <= other.y)
        });
        methods.add_method("__gt", |_, this, other: LuaVector2| {
            Ok(this.x > other.x && this.y > other.y)
        });
        methods.add_method("__ge", |_, this, other: LuaVector2| {
            Ok(this.x >= other.x && this.y >= other.y)
        });
        methods.add_method("__index", |_, this, key: String| match key.as_str() {
            "x" => Ok(this.x),
            "y" => Ok(this.y),
            _ => Err(LuaError::runtime(format!(
                "LuaVector2 has no field '{}'",
                key
            ))),
        });
    }
}

impl From<LuaVector2> for Vector2 {
    fn from(value: LuaVector2) -> Self {
        Vector2::new(value.x, value.y)
    }
}

impl From<Vector2> for LuaVector2 {
    fn from(value: Vector2) -> Self {
        LuaVector2 {
            x: value.x,
            y: value.y,
        }
    }
}

impl<'lua> FromLua for LuaVector2 {
    fn from_lua(value: LuaValue, _lua: &Lua) -> LuaResult<Self> {
        match value {
            LuaValue::Table(table) => {
                let x = table.get("x")?;
                let y = table.get("y")?;
                Ok(LuaVector2 { x, y })
            }
            _ => Err(LuaError::FromLuaConversionError {
                from: value.type_name(),
                to: "LuaVector2".to_string(),
                message: None,
            }),
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct LuaVector3 {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

impl From<LuaVector3> for Vector3 {
    fn from(value: LuaVector3) -> Self {
        Vector3::new(value.x, value.y, value.z)
    }
}

impl From<Vector3> for LuaVector3 {
    fn from(value: Vector3) -> Self {
        LuaVector3 {
            x: value.x,
            y: value.y,
            z: value.z,
        }
    }
}

impl<'l> LuaUserData for LuaVector3 {
    fn add_fields<F: LuaUserDataFields<Self>>(fields: &mut F) {
        fields.add_field_method_get("x", |_, this| Ok(this.x));
        fields.add_field_method_get("y", |_, this| Ok(this.y));
        fields.add_field_method_get("z", |_, this| Ok(this.z));
    }
    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_method("new", |_, _this, (x, y, z): (f32, f32, f32)| {
            Ok(LuaVector3 { x, y, z })
        });
        methods.add_method("__add", |_, this, (x, y, z): (f32, f32, f32)| {
            Ok(LuaVector3 {
                x: this.x + x,
                y: this.y + y,
                z: this.z + z,
            })
        });
        methods.add_method("__sub", |_, this, (x, y, z): (f32, f32, f32)| {
            Ok(LuaVector3 {
                x: this.x - x,
                y: this.y - y,
                z: this.z - z,
            })
        });
        methods.add_method("__mul", |_, this, (x, y, z): (f32, f32, f32)| {
            Ok(LuaVector3 {
                x: this.x * x,
                y: this.y * y,
                z: this.z * z,
            })
        });
        methods.add_method("__div", |_, this, (x, y, z): (f32, f32, f32)| {
            Ok(LuaVector3 {
                x: this.x / x,
                y: this.y / y,
                z: this.z / z,
            })
        });
        methods.add_method("__mod", |_, this, (x, y, z): (f32, f32, f32)| {
            Ok(LuaVector3 {
                x: this.x % x,
                y: this.y % y,
                z: this.z % z,
            })
        });
        methods.add_method("__pow", |_, this, (x, y, z): (f32, f32, f32)| {
            Ok(LuaVector3 {
                x: this.x.powf(x),
                y: this.y.powf(y),
                z: this.z.powf(z),
            })
        });
        methods.add_method("__unm", |_, this, ()| {
            Ok(LuaVector3 {
                x: -this.x,
                y: -this.y,
                z: -this.z,
            })
        });
        methods.add_method("__len", |_, this, ()| {
            Ok(this.x.hypot(this.y).hypot(this.z))
        });
        methods.add_method("__eq", |_, this, other: LuaVector3| {
            Ok(this.x == other.x && this.y == other.y && this.z == other.z)
        });
        methods.add_method("__index", |_, this, key: String| match key.as_str() {
            "x" => Ok(this.x),
            "y" => Ok(this.y),
            "z" => Ok(this.z),
            _ => Err(LuaError::FromLuaConversionError {
                from: "Vector3",
                to: key,
                message: None,
            }),
        });
    }
}

impl FromLua for LuaVector3 {
    fn from_lua(value: LuaValue, _lua: &Lua) -> LuaResult<Self> {
        match value {
            LuaValue::Table(table) => {
                let x: f32 = table.get("x")?;
                let y: f32 = table.get("y")?;
                let z: f32 = table.get("z")?;
                Ok(LuaVector3 { x, y, z })
            }
            _ => Err(LuaError::FromLuaConversionError {
                from: value.type_name(),
                to: "LuaVector3".to_string(),
                message: None,
            }),
        }
    }
}

pub fn vector2<'lua>(_lua: &Lua, (x, y): (f32, f32)) -> LuaResult<LuaVector2> {
    Ok(LuaVector2 { x, y })
}

// Module Entry Point

#[mlua::lua_module]
fn raylib_lua(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;

    // Core functions
    exports.set("init_window", lua.create_function(init_window)?)?;
    exports.set("color", lua.create_function(color)?)?;

    // Register color constants
    register_colors(lua, &exports)?;

    // Version info
    exports.set("_VERSION", "0.1.0")?;
    exports.set("_DESCRIPTION", "Raylib bindings for Lua")?;

    Ok(exports)
}

#[mlua::lua_module]
fn rlm_lua(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;

    // Vector2 functions
    exports.set("vec2", lua.create_function(vector2)?)?;

    // Version info
    exports.set("_VERSION", "0.1.0")?;
    exports.set(
        "_DESCRIPTION",
        "rlm-related functions and helpers for Raylib/rlmlua",
    )?;

    Ok(exports)
}

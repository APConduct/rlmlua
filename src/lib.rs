use mlua::prelude::*;
use raylib::collision::*;
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
            "draw_rectangle_rec",
            |_, _this, (rect, color): (LuaRectangle, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_rectangle_rec(
                                <LuaRectangle as Into<Rectangle>>::into(rect),
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
            "draw_ring",
            |_,
             _this,
             (center, inner_radius, outer_radius, start_angle, end_angle, segments, color): (
                LuaVector2,
                f32,
                f32,
                f32,
                f32,
                i32,
                LuaColor,
            )| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_ring(
                                center,
                                inner_radius,
                                outer_radius,
                                start_angle,
                                end_angle,
                                segments,
                                <LuaColor as Into<Color>>::into(color),
                            );
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
            Ok(LuaVector2 { x: pos.x, y: pos.y })
        });

        methods.add_method("get_mouse_wheel_move", |_, this, ()| {
            let wheel = this.rl.get_mouse_wheel_move();
            Ok(wheel)
        });

        methods.add_method("get_mouse_x", |_, this, ()| Ok(this.rl.get_mouse_x()));

        methods.add_method("get_mouse_y", |_, this, ()| Ok(this.rl.get_mouse_y()));

        methods.add_method("is_mouse_button_pressed", |_, this, button: String| {
            let mb = str_to_mouse_button(button.as_str());
            Ok(this.rl.is_mouse_button_pressed(mb))
        });

        methods.add_method("is_mouse_button_down", |_, this, button: String| {
            let mb = str_to_mouse_button(button.as_str());
            Ok(this.rl.is_mouse_button_down(mb))
        });

        methods.add_method("is_mouse_button_released", |_, this, button: String| {
            let mb = str_to_mouse_button(button.as_str());
            Ok(this.rl.is_mouse_button_released(mb))
        });

        methods.add_method("is_mouse_button_up", |_, this, button: String| {
            let mb = str_to_mouse_button(button.as_str());
            Ok(this.rl.is_mouse_button_up(mb))
        });

        methods.add_method("is_cursor_hidden", |_, this, ()| {
            Ok(this.rl.is_cursor_hidden())
        });

        methods.add_method("get_mouse_wheel_move", |_, this, ()| {
            Ok(this.rl.get_mouse_wheel_move())
        });

        // Drawing - circle with vector
        methods.add_method_mut(
            "draw_circle_v",
            |_lua, _this, (center, radius, color): (LuaValue, f32, LuaColor)| {
                let (x, y) = match &center {
                    LuaValue::Table(t) => {
                        let x: f32 = t.get("x")?;
                        let y: f32 = t.get("y")?;
                        (x, y)
                    }
                    LuaValue::UserData(ud) => {
                        // Try to get fields directly from the userdata
                        let x: f32 = ud.get("x")?;
                        let y: f32 = ud.get("y")?;
                        (x, y)
                    }
                    _ => {
                        return Err(LuaError::FromLuaConversionError {
                            from: "value",
                            to: "Vector2".to_string(),
                            message: Some("Expected table {x, y} or Vector2 userdata".to_string()),
                        });
                    }
                };
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_circle(
                                x as i32,
                                y as i32,
                                radius,
                                <LuaColor as Into<Color>>::into(color),
                            );
                        }
                    }
                });
                Ok(())
            },
        );

        // Window management
        methods.add_method("close", |_, _this, ()| {
            // Window closes automatically when dropped, but we can provide this as a no-op
            // for API compatibility
            Ok(())
        });

        // Alias for window_should_close for convenience
        methods.add_method_mut("should_close", |_, this, ()| {
            Ok(this.rl.window_should_close())
        });

        methods.add_method_mut("get_gesture_detected", |_, this, ()| {
            // Ok(str_to_luagesture(gesture_to_str(
            //     this.rl.get_gesture_detected(),
            // )))
            Ok(LuaGesture::from(this.rl.get_gesture_detected()))
        });

        methods.add_method_mut("get_gesture_pitch_angle", |_, this, ()| {
            Ok(this.rl.get_gesture_pinch_angle())
        });

        methods.add_method_mut("get_gesture_drag_angle", |_, this, ()| {
            Ok(this.rl.get_gesture_drag_angle())
        });

        methods.add_method_mut("get_touch_point_count", |_, this, ()| {
            Ok(this.rl.get_touch_point_count())
        });

        methods.add_method_mut("get_touch_position", |_, this, index: u32| {
            Ok(LuaVector2::from(this.rl.get_touch_position(index)))
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
            "draw_rectangle_rec",
            |_, (rect, color): (LuaRectangle, LuaColor)| {
                DRAW_HANDLE.with(|cell| {
                    if let Some(d) = *cell.borrow() {
                        unsafe {
                            (*d).draw_rectangle_rec(
                                <LuaRectangle as Into<Rectangle>>::into(rect),
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

impl From<raylib::ffi::Color> for LuaColor {
    fn from(value: raylib::ffi::Color) -> Self {
        LuaColor {
            r: value.r,
            g: value.g,
            b: value.b,
            a: value.a,
        }
    }
}

impl From<LuaColor> for Color {
    fn from(value: LuaColor) -> Self {
        Color::new(value.r, value.g, value.b, value.a)
    }
}

impl From<LuaColor> for raylib::ffi::Color {
    fn from(value: LuaColor) -> Self {
        raylib::ffi::Color {
            r: value.r,
            g: value.g,
            b: value.b,
            a: value.a,
        }
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

pub fn str_to_mouse_button(s: &str) -> MouseButton {
    match s.to_uppercase().as_str() {
        "LEFT" => MouseButton::MOUSE_BUTTON_LEFT,
        "RIGHT" => MouseButton::MOUSE_BUTTON_RIGHT,
        "MIDDLE" => MouseButton::MOUSE_BUTTON_MIDDLE,
        "SIDE" => MouseButton::MOUSE_BUTTON_SIDE,
        "EXTRA" => MouseButton::MOUSE_BUTTON_EXTRA,
        "FORWARD" => MouseButton::MOUSE_BUTTON_FORWARD,
        "BACK" => MouseButton::MOUSE_BUTTON_BACK,
        // Maybe make this safe later
        _ => MouseButton::MOUSE_BUTTON_LEFT,
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

pub fn str_to_gesture(gesture: &str) -> Gesture {
    match gesture {
        "TAP" | "tap" | "Tap" => Gesture::GESTURE_TAP,
        "DOUBLETAP" | "doubletap" | "Doubletap" => Gesture::GESTURE_DOUBLETAP,
        "HOLD" | "hold" | "Hold" => Gesture::GESTURE_HOLD,
        "DRAG" | "drag" | "Drag" => Gesture::GESTURE_DRAG,
        "SWIPE_RIGHT" | "swipe_right" | "SwipeRight" => Gesture::GESTURE_SWIPE_RIGHT,
        "SWIPE_LEFT" | "swipe_left" | "SwipeLeft" => Gesture::GESTURE_SWIPE_LEFT,
        "SWIPE_UP" | "swipe_up" | "SwipeUp" => Gesture::GESTURE_SWIPE_UP,
        "SWIPE_DOWN" | "swipe_down" | "SwipeDown" => Gesture::GESTURE_SWIPE_DOWN,
        "PINCH_IN" | "pinch_in" | "PinchIn" => Gesture::GESTURE_PINCH_IN,
        "PINCH_OUT" | "pinch_out" | "PinchOut" => Gesture::GESTURE_PINCH_OUT,
        _ => Gesture::GESTURE_NONE,
    }
}

pub fn gesture_to_str(gesture: Gesture) -> &'static str {
    match gesture {
        Gesture::GESTURE_TAP => "TAP",
        Gesture::GESTURE_DOUBLETAP => "DOUBLETAP",
        Gesture::GESTURE_HOLD => "HOLD",
        Gesture::GESTURE_DRAG => "DRAG",
        Gesture::GESTURE_SWIPE_RIGHT => "SWIPE_RIGHT",
        Gesture::GESTURE_SWIPE_LEFT => "SWIPE_LEFT",
        Gesture::GESTURE_SWIPE_UP => "SWIPE_UP",
        Gesture::GESTURE_SWIPE_DOWN => "SWIPE_DOWN",
        Gesture::GESTURE_PINCH_IN => "PINCH_IN",
        Gesture::GESTURE_PINCH_OUT => "PINCH_OUT",
        Gesture::GESTURE_NONE => "NONE",
    }
}

pub fn str_to_luagesture(s: &str) -> LuaGesture {
    match s {
        "TAP" | "tap" | "Tap" => LuaGesture::Tap,
        "DOUBLETAP" | "doubletap" | "DoubleTap" => LuaGesture::DoubleTap,
        "HOLD" | "hold" | "Hold" => LuaGesture::Hold,
        "DRAG" | "drag" | "Drag" => LuaGesture::Drag,
        "SWIPE_RIGHT" | "swipe_right" | "SwipeRight" => LuaGesture::SwipeRight,
        "SWIPE_LEFT" | "swipe_left" | "SwipeLeft" => LuaGesture::SwipeLeft,
        "SWIPE_UP" | "swipe_up" | "SwipeUp" => LuaGesture::SwipeUp,
        "SWIPE_DOWN" | "swipe_down" | "SwipeDown" => LuaGesture::SwipeDown,
        "PINCH_IN" | "pinch_in" | "PinchIn" => LuaGesture::PinchIn,
        "PINCH_OUT" | "pinch_out" | "PinchOut" => LuaGesture::PinchOut,
        "NONE" | "none" | "None" => LuaGesture::None,
        _ => LuaGesture::None,
    }
}

pub fn luagesture_to_str(gesture: LuaGesture) -> &'static str {
    match gesture {
        LuaGesture::Tap => "TAP",
        LuaGesture::DoubleTap => "DOUBLE_TAP",
        LuaGesture::Hold => "HOLD",
        LuaGesture::Drag => "DRAG",
        LuaGesture::SwipeRight => "SWIPE_RIGHT",
        LuaGesture::SwipeLeft => "SWIPE_LEFT",
        LuaGesture::SwipeUp => "SWIPE_UP",
        LuaGesture::SwipeDown => "SWIPE_DOWN",
        LuaGesture::PinchIn => "PINCH_IN",
        LuaGesture::PinchOut => "PINCH_OUT",
        LuaGesture::None => "NONE",
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

fn fade(_lua: &Lua, (color, alpha): (LuaColor, f32)) -> LuaResult<LuaColor> {
    // use raylib::ffi::Fade;
    let faded_color = unsafe { raylib::ffi::Fade(color.into(), alpha) };
    Ok(faded_color.into())
}

fn check_collision_point_rec(
    _lua: &Lua,
    (point, rec): (LuaVector2, LuaRectangle),
) -> LuaResult<bool> {
    Ok(Rectangle::from(rec).check_collision_point_rec(point))
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
        fields.add_field_method_set("x", |_, this, val| {
            this.x = val;
            Ok(())
        });
        fields.add_field_method_get("y", |_, this| Ok(this.y));
        fields.add_field_method_set("y", |_, this, val| {
            this.y = val;
            Ok(())
        });
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

impl From<LuaVector2> for raylib::ffi::Vector2 {
    fn from(value: LuaVector2) -> Self {
        raylib::ffi::Vector2 {
            x: value.x,
            y: value.y,
        }
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
    fn from_lua(value: LuaValue, lua: &Lua) -> LuaResult<Self> {
        match value {
            LuaValue::Table(table) => {
                let x = table.get("x")?;
                let y = table.get("y")?;
                Ok(LuaVector2 { x, y })
            }
            LuaValue::UserData(ud) => {
                // Try to extract LuaVector2 from userdata
                ud.borrow::<LuaVector2>().map(|v| *v)
            }
            _ => Err(LuaError::FromLuaConversionError {
                from: value.type_name(),
                to: "LuaVector2".to_string(),
                message: Some("expected table with x,y fields or Vector2 userdata".to_string()),
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

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct LuaRectangle {
    pub x: f32,
    pub y: f32,
    pub width: f32,
    pub height: f32,
}

impl From<LuaRectangle> for Rectangle {
    fn from(rect: LuaRectangle) -> Self {
        Rectangle {
            x: rect.x,
            y: rect.y,
            width: rect.width,
            height: rect.height,
        }
    }
}

impl From<LuaRectangle> for raylib::ffi::Rectangle {
    fn from(rect: LuaRectangle) -> Self {
        raylib::ffi::Rectangle {
            x: rect.x,
            y: rect.y,
            width: rect.width,
            height: rect.height,
        }
    }
}

impl<'lua> FromLua for LuaRectangle {
    fn from_lua(value: LuaValue, lua: &Lua) -> LuaResult<Self> {
        match value {
            LuaValue::Table(table) => {
                let x: f32 = table.get("x")?;
                let y: f32 = table.get("y")?;
                let width: f32 = table.get("width")?;
                let height: f32 = table.get("height")?;
                Ok(LuaRectangle {
                    x,
                    y,
                    width,
                    height,
                })
            }
            LuaValue::UserData(ud) => {
                // Try to extract LuaRectangle from userdata
                ud.borrow::<LuaRectangle>().map(|r| *r)
            }
            _ => Err(LuaError::FromLuaConversionError {
                from: value.type_name(),
                to: "LuaRectangle".to_string(),
                message: Some(
                    "expected table with x,y,width,height fields or Rectangle userdata".to_string(),
                ),
            }),
        }
    }
}

impl LuaRectangle {
    pub fn new(x: f32, y: f32, width: f32, height: f32) -> Self {
        LuaRectangle {
            x,
            y,
            width,
            height,
        }
    }
}

impl LuaUserData for LuaRectangle {
    fn add_fields<F: LuaUserDataFields<Self>>(fields: &mut F) {
        fields.add_field_method_get("x", |_, this| Ok(this.x));
        fields.add_field_method_get("y", |_, this| Ok(this.y));
        fields.add_field_method_get("width", |_, this| Ok(this.width));
        fields.add_field_method_get("height", |_, this| Ok(this.height));
    }
    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {}
}

pub fn vector2<'lua>(_lua: &Lua, (x, y): (f32, f32)) -> LuaResult<LuaVector2> {
    Ok(LuaVector2 { x, y })
}

pub fn vector3<'lua>(_lua: &Lua, (x, y, z): (f32, f32, f32)) -> LuaResult<LuaVector3> {
    Ok(LuaVector3 { x, y, z })
}

pub fn rect<'lua>(
    _lua: &Lua,
    (x, y, width, height): (f32, f32, f32, f32),
) -> LuaResult<LuaRectangle> {
    Ok(LuaRectangle::new(x, y, width, height))
}

pub fn gesture<'lua>(_lua: &Lua, _gesture: String) -> LuaResult<LuaGesture> {
    match _gesture.as_str() {
        "tap" | "TAP" | "Tap" => Ok(LuaGesture::Tap),
        "double_tap" | "doubletap" | "DOUBLE_TAP" | "DoubleTap" | "DOUBLETAP" => {
            Ok(LuaGesture::DoubleTap)
        }
        "hold" | "HOLD" | "Hold" => Ok(LuaGesture::Hold),
        "drag" | "DRAG" | "Drag" => Ok(LuaGesture::Drag),
        "swipe_right" | "SWIPE_RIGHT" | "SwipeRight" => Ok(LuaGesture::SwipeRight),
        "swipe_left" | "SWIPE_LEFT" | "SwipeLeft" => Ok(LuaGesture::SwipeLeft),
        "swipe_up" | "SWIPE_UP" | "SwipeUp" => Ok(LuaGesture::SwipeUp),
        "swipe_down" | "SWIPE_DOWN" | "SwipeDown" => Ok(LuaGesture::SwipeDown),
        "pinch_in" | "PINCH_IN" | "PinchIn" => Ok(LuaGesture::PinchIn),
        "pinch_out" | "PINCH_OUT" | "PinchOut" => Ok(LuaGesture::PinchOut),
        _ => Ok(LuaGesture::None),
    }
}

pub fn gesture_from_str<'lua>(_lua: &Lua, _gesture: &str) -> LuaResult<LuaGesture> {
    match _gesture {
        "tap" | "TAP" | "Tap" => Ok(LuaGesture::Tap),
        "double_tap" | "doubletap" | "DOUBLE_TAP" | "DoubleTap" | "DOUBLETAP" => {
            Ok(LuaGesture::DoubleTap)
        }
        "hold" | "HOLD" | "Hold" => Ok(LuaGesture::Hold),
        "drag" | "DRAG" | "Drag" => Ok(LuaGesture::Drag),
        "swipe_right" | "SWIPE_RIGHT" | "SwipeRight" => Ok(LuaGesture::SwipeRight),
        "swipe_left" | "SWIPE_LEFT" | "SwipeLeft" => Ok(LuaGesture::SwipeLeft),
        "swipe_up" | "SWIPE_UP" | "SwipeUp" => Ok(LuaGesture::SwipeUp),
        "swipe_down" | "SWIPE_DOWN" | "SwipeDown" => Ok(LuaGesture::SwipeDown),
        "pinch_in" | "PINCH_IN" | "PinchIn" => Ok(LuaGesture::PinchIn),
        "pinch_out" | "PINCH_OUT" | "PinchOut" => Ok(LuaGesture::PinchOut),
        _ => Ok(LuaGesture::None),
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum LuaGesture {
    Tap,
    DoubleTap,
    Hold,
    Drag,
    SwipeRight,
    SwipeLeft,
    SwipeUp,
    SwipeDown,
    PinchIn,
    PinchOut,
    None,
}

impl From<LuaGesture> for Gesture {
    fn from(value: LuaGesture) -> Self {
        match value {
            LuaGesture::Tap => Gesture::GESTURE_TAP,
            LuaGesture::DoubleTap => Gesture::GESTURE_DOUBLETAP,
            LuaGesture::Hold => Gesture::GESTURE_HOLD,
            LuaGesture::Drag => Gesture::GESTURE_DRAG,
            LuaGesture::SwipeRight => Gesture::GESTURE_SWIPE_RIGHT,
            LuaGesture::SwipeLeft => Gesture::GESTURE_SWIPE_LEFT,
            LuaGesture::SwipeUp => Gesture::GESTURE_SWIPE_UP,
            LuaGesture::SwipeDown => Gesture::GESTURE_SWIPE_DOWN,
            LuaGesture::PinchIn => Gesture::GESTURE_PINCH_IN,
            LuaGesture::PinchOut => Gesture::GESTURE_PINCH_OUT,
            LuaGesture::None => Gesture::GESTURE_NONE,
        }
    }
}

impl From<Gesture> for LuaGesture {
    fn from(value: Gesture) -> Self {
        match value {
            Gesture::GESTURE_TAP => LuaGesture::Tap,
            Gesture::GESTURE_DOUBLETAP => LuaGesture::DoubleTap,
            Gesture::GESTURE_HOLD => LuaGesture::Hold,
            Gesture::GESTURE_DRAG => LuaGesture::Drag,
            Gesture::GESTURE_SWIPE_RIGHT => LuaGesture::SwipeRight,
            Gesture::GESTURE_SWIPE_LEFT => LuaGesture::SwipeLeft,
            Gesture::GESTURE_SWIPE_UP => LuaGesture::SwipeUp,
            Gesture::GESTURE_SWIPE_DOWN => LuaGesture::SwipeDown,
            Gesture::GESTURE_PINCH_IN => LuaGesture::PinchIn,
            Gesture::GESTURE_PINCH_OUT => LuaGesture::PinchOut,
            Gesture::GESTURE_NONE => LuaGesture::None,
        }
    }
}

impl<'lua> FromLua for LuaGesture {
    fn from_lua(value: LuaValue, _lua: &Lua) -> LuaResult<Self> {
        match value {
            LuaValue::UserData(ud) => ud.borrow::<LuaGesture>().map(|g| *g),
            _ => Err(LuaError::FromLuaConversionError {
                from: value.type_name(),
                to: "LuaGesture".to_string(),
                message: Some("expected LuaGesture userdata".to_string()),
            }),
        }
    }
}

impl LuaUserData for LuaGesture {
    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_meta_method(mlua::MetaMethod::ToString, |_, this, ()| {
            Ok(match this {
                LuaGesture::Tap => "GESTURE_TAP",
                LuaGesture::DoubleTap => "GESTURE_DOUBLETAP",
                LuaGesture::Hold => "GESTURE_HOLD",
                LuaGesture::Drag => "GESTURE_DRAG",
                LuaGesture::SwipeRight => "GESTURE_SWIPE_RIGHT",
                LuaGesture::SwipeLeft => "GESTURE_SWIPE_LEFT",
                LuaGesture::SwipeUp => "GESTURE_SWIPE_UP",
                LuaGesture::SwipeDown => "GESTURE_SWIPE_DOWN",
                LuaGesture::PinchIn => "GESTURE_PINCH_IN",
                LuaGesture::PinchOut => "GESTURE_PINCH_OUT",
                LuaGesture::None => "GESTURE_NONE",
            })
        });

        methods.add_meta_method(mlua::MetaMethod::Eq, |_, this, other: LuaGesture| {
            Ok(*this == other)
        });
    }
    fn add_fields<F: LuaUserDataFields<Self>>(_fields: &mut F) {}
}

// Module Entry Point

#[mlua::lua_module]
fn raylib_lua(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;

    // Core functions
    exports.set("init_window", lua.create_function(init_window)?)?;
    exports.set("color", lua.create_function(color)?)?;
    exports.set(
        "check_collision_point_rec",
        lua.create_function(check_collision_point_rec)?,
    )?;
    exports.set("fade", lua.create_function(fade)?)?;

    // Helper functions (also available in rlm_lua for compatibility)
    exports.set("vec2", lua.create_function(vector2)?)?;
    exports.set("vec3", lua.create_function(vector3)?)?;
    exports.set("rect", lua.create_function(rect)?)?;

    // Register color constants
    register_colors(lua, &exports)?;

    // Version info
    exports.set("_VERSION", "0.1.0")?;
    exports.set("_DESCRIPTION", "Raylib bindings for Lua")?;
    exports.set("GESTURE_NONE", LuaGesture::None)?;
    exports.set("GESTURE_DRAG", LuaGesture::Drag)?;
    exports.set("GESTURE_SWIPE_RIGHT", LuaGesture::SwipeRight)?;
    exports.set("GESTURE_SWIPE_LEFT", LuaGesture::SwipeLeft)?;
    exports.set("GESTURE_SWIPE_UP", LuaGesture::SwipeUp)?;
    exports.set("GESTURE_SWIPE_DOWN", LuaGesture::SwipeDown)?;
    exports.set("GESTURE_PINCH_IN", LuaGesture::PinchIn)?;
    exports.set("GESTURE_PINCH_OUT", LuaGesture::PinchOut)?;
    exports.set("GESTURE_HOLD", LuaGesture::Hold)?;
    exports.set("GESTURE_TAP", LuaGesture::Tap)?;
    exports.set("GESTURE_DOUBLETAP", LuaGesture::DoubleTap)?;

    Ok(exports)
}

#[mlua::lua_module]
fn rlm_lua(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;

    // Vector2 functions
    exports.set("vec2", lua.create_function(vector2)?)?;
    exports.set("vec3", lua.create_function(vector3)?)?;
    exports.set("rect", lua.create_function(rect)?)?;

    // Version info
    exports.set("_VERSION", "0.1.0")?;
    exports.set(
        "_DESCRIPTION",
        "rlm-related functions and helpers for Raylib/rlmlua",
    )?;

    Ok(exports)
}

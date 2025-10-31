use mlua::prelude::*;
use raylib::prelude::*;

#[allow(dead_code)]
struct LuaRaylib {
    rl: RaylibHandle,
    thread: RaylibThread,
}

impl LuaUserData for LuaRaylib {
    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_method_mut("window_should_close", |_, this, ()| {
            Ok(this.rl.window_should_close())
        });

        methods.add_method_mut("set_target_fps", |_, this, fps: u32| {
            this.rl.set_target_fps(fps);
            Ok(())
        });

        methods.add_method_mut("get_fps", |_, this, ()| Ok(this.rl.get_fps()));

        methods.add_method_mut("get_frame_time", |_, this, ()| Ok(this.rl.get_frame_time()));

        todo!()
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

impl FromLua for LuaColor {
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
        "ESCAPE" => KeyboardKey::KEY_ESCAPE,
        "ENTER" => KeyboardKey::KEY_ENTER,
        "W" => KeyboardKey::KEY_W,
        "A" => KeyboardKey::KEY_A,
        "S" => KeyboardKey::KEY_S,
        "D" => KeyboardKey::KEY_D,
        "UP" => KeyboardKey::KEY_UP,
        "DOWN" => KeyboardKey::KEY_DOWN,
        "LEFT" => KeyboardKey::KEY_LEFT,
        "RIGHT" => KeyboardKey::KEY_RIGHT,
        "BACKSPACE" => KeyboardKey::KEY_BACKSPACE,
        "TAB" => KeyboardKey::KEY_TAB,
        "Q" => KeyboardKey::KEY_Q,
        // "W" => KeyboardKey::KEY_W,
        "E" => KeyboardKey::KEY_E,
        "R" => KeyboardKey::KEY_R,
        "T" => KeyboardKey::KEY_T,
        "Y" => KeyboardKey::KEY_Y,
        "U" => KeyboardKey::KEY_U,
        "I" => KeyboardKey::KEY_I,
        "O" => KeyboardKey::KEY_O,
        "P" => KeyboardKey::KEY_P,
        "LEFT_BRACKET" => KeyboardKey::KEY_LEFT_BRACKET,
        "RIGHT_BRACKET" => KeyboardKey::KEY_RIGHT_BRACKET,
        "BACKSLASH" => KeyboardKey::KEY_BACKSLASH,
        "F" => KeyboardKey::KEY_F,
        "G" => KeyboardKey::KEY_G,
        "H" => KeyboardKey::KEY_H,
        "J" => KeyboardKey::KEY_J,
        "K" => KeyboardKey::KEY_K,
        "L" => KeyboardKey::KEY_L,
        "SEMICOLON" => KeyboardKey::KEY_SEMICOLON,
        "LEFT_SHIFT" => KeyboardKey::KEY_LEFT_SHIFT,
        "Z" => KeyboardKey::KEY_Z,
        "X" => KeyboardKey::KEY_X,
        "C" => KeyboardKey::KEY_C,
        "V" => KeyboardKey::KEY_V,
        "B" => KeyboardKey::KEY_B,
        "N" => KeyboardKey::KEY_N,
        "M" => KeyboardKey::KEY_M,
        "COMMA" => KeyboardKey::KEY_COMMA,
        "PERIOD" => KeyboardKey::KEY_PERIOD,
        "SLASH" => KeyboardKey::KEY_SLASH,
        "RIGHT_SHIFT" => KeyboardKey::KEY_RIGHT_SHIFT,
        "LEFT_CONTROL" => KeyboardKey::KEY_LEFT_CONTROL,
        "LEFT_ALT" => KeyboardKey::KEY_LEFT_ALT,
        "RIGHT_ALT" => KeyboardKey::KEY_RIGHT_ALT,
        "RIGHT_CONTROL" => KeyboardKey::KEY_RIGHT_CONTROL,
        "LEFT_SUPER" => KeyboardKey::KEY_LEFT_SUPER,
        "RIGHT_SUPER" => KeyboardKey::KEY_RIGHT_SUPER,
        "MENU" => KeyboardKey::KEY_MENU,
        "ONE" => KeyboardKey::KEY_ONE,
        "TWO" => KeyboardKey::KEY_TWO,
        "THREE" => KeyboardKey::KEY_THREE,
        "FOUR" => KeyboardKey::KEY_FOUR,
        "FIVE" => KeyboardKey::KEY_FIVE,
        "SIX" => KeyboardKey::KEY_SIX,
        "SEVEN" => KeyboardKey::KEY_SEVEN,
        "EIGHT" => KeyboardKey::KEY_EIGHT,
        "NINE" => KeyboardKey::KEY_NINE,
        "ZERO" => KeyboardKey::KEY_ZERO,
        "MINUS" => KeyboardKey::KEY_MINUS,
        "EQUALS" => KeyboardKey::KEY_EQUAL,
        "KP_EQUAL" => KeyboardKey::KEY_KP_EQUAL,
        "KP_0" => KeyboardKey::KEY_KP_0,
        "KP_1" => KeyboardKey::KEY_KP_1,
        "KP_2" => KeyboardKey::KEY_KP_2,
        "KP_3" => KeyboardKey::KEY_KP_3,
        "KP_4" => KeyboardKey::KEY_KP_4,
        "KP_5" => KeyboardKey::KEY_KP_5,
        "KP_6" => KeyboardKey::KEY_KP_6,
        "KP_7" => KeyboardKey::KEY_KP_7,
        "KP_8" => KeyboardKey::KEY_KP_8,
        "KP_9" => KeyboardKey::KEY_KP_9,
        // TODO: FINISH ADDING KEYS
        _ => KeyboardKey::KEY_NULL,
    }
}

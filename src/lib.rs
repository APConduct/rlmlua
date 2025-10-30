use mlua::prelude::*;
use raylib::prelude::*;

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
struct LuaColor {}

package = "raylib"
version = "dev-1"

source = {
   url = "git+https://github.com/yourusername/raylib.lua.git"
}

description = {
   summary = "Raylib bindings for Lua with snake_case API and LSP support",
   detailed = [[
      Modern raylib bindings for Lua featuring:
      - Snake_case API for idiomatic Lua
      - Full LSP/type definitions support
      - Zero-cost abstractions via Rust
      - Better than raylua_e with improved tooling
   ]],
   homepage = "https://github.com/yourusername/raylib.lua",
   license = "MIT"
}

dependencies = {
   "lua >= 5.1, < 5.5"
}

external_dependencies = {
   RAYLIB = {
      header = "raylib.h",
      library = "raylib"
   }
}

build = {
   type = "make",
   build_variables = {
      CFLAGS = "$(CFLAGS)",
      LIBFLAG = "$(LIBFLAG)",
      LUA_LIBDIR = "$(LUA_LIBDIR)",
      LUA_BINDIR = "$(LUA_BINDIR)",
      LUA_INCDIR = "$(LUA_INCDIR)",
      LUA = "$(LUA)",
   },
   install_variables = {
      INST_PREFIX = "$(PREFIX)",
      INST_BINDIR = "$(BINDIR)",
      INST_LIBDIR = "$(LIBDIR)",
      INST_LUADIR = "$(LUADIR)",
      INST_CONFDIR = "$(CONFDIR)",
   },
   install = {
      lib = {
         ["raylib_lua"] = "target/release/libraylib_lua.so"
      },
      lua = {
         ["raylib"] = "lua/raylib/init.lua",
         ["raylib.meta"] = "lua/raylib/meta.lua",
         ["rlmlua"] = "lua/rlmlua/init.lua",
         ["rlmlua.meta"] = "lua/rlmlua/meta.lua"
      },
      bin = {
         ["rlmlua-setup"] = "bin/rlmlua-setup"
      }
   }
}

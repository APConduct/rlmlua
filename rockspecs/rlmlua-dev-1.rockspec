package = "rlmlua"
version = "dev-1"

source = {
   url = "git+https://github.com/yourusername/rlmlua.git",
   branch = "main"
}

description = {
   summary = "Raylib bindings for Lua with snake_case API and LSP support",
   detailed = [[
      Modern raylib bindings for Lua featuring:
      - Snake_case API for idiomatic Lua code
      - Full LSP/type definitions support
      - Built with Rust for safety and performance
      - Compatible with raylua patterns
      - Support for both imperative and callback-based drawing
      - Comprehensive input handling (keyboard and mouse)
      - Easy to use color system with predefined constants
   ]],
   homepage = "https://github.com/yourusername/rlmlua",
   license = "MIT"
}

dependencies = {
   "lua >= 5.1, < 5.5"
}

external_dependencies = {
   RAYLIB = {
      header = "raylib.h"
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
   -- The Makefile's 'install' target handles the actual installation
   -- It will copy the compiled library to INST_LIBDIR and Lua files to INST_LUADIR
}

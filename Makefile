# Detect OS
OS_NAME := $(shell uname -s)

# Set dynamic library extension
ifeq ($(OS_NAME),Linux)
    DYNAM_EXTENSION = .so
else ifeq ($(OS_NAME),Darwin)
    DYNAM_EXTENSION = .dylib
else ifeq ($(OS_NAME),FreeBSD)
    DYNAM_EXTENSION = .so
else
    DYNAM_EXTENSION = .dll
endif

# Detect compiler if not set
ifndef CC
    ifeq ($(OS_NAME),Darwin)
        CC := clang
    else
        CC := gcc
    endif
endif

ifndef CXX
    ifeq ($(OS_NAME),Darwin)
        CXX := clang++
    else
        CXX := g++
    endif
endif

# If CC is not a valid compiler, override it
ifeq ($(shell which $(word 1,$(CC))),)
    CC := clang
endif

ifeq ($(shell which $(word 1,$(CXX))),)
    CXX := clang++
endif

export CC
export CXX

.PHONY: all install clean run build

build:
	cargo build --release

all: build
	@if [ "$(DYNAM_EXTENSION)" = ".dylib" ]; then \
		cp target/release/librlmlua.dylib target/release/libraylib_lua.so; \
	elif [ "$(DYNAM_EXTENSION)" = ".dll" ]; then \
		cp target/release/librlmlua.dll target/release/libraylib_lua.so; \
	else \
		cp target/release/librlmlua.so target/release/libraylib_lua.so; \
	fi
	@ln -sf libraylib_lua.so target/release/raylib_lua.so

run: all
	LUA_PATH="./lua/?.lua;./lua/?/init.lua;;" LUA_CPATH="./target/release/?.so;;" lua examples/01_basic_window.lua

install: all
	@echo "Installing rlmlua to $(INST_LIBDIR) and $(INST_LUADIR)"
	mkdir -p $(INST_LIBDIR)
	mkdir -p $(INST_LUADIR)/raylib
	mkdir -p $(INST_LUADIR)/rlmlua
	@# Install the C module (the compiled Rust library)
	@if [ "$(DYNAM_EXTENSION)" = ".dylib" ]; then \
		cp target/release/libraylib_lua.so $(INST_LIBDIR)/raylib_lua.so; \
	elif [ "$(DYNAM_EXTENSION)" = ".dll" ]; then \
		cp target/release/libraylib_lua.so $(INST_LIBDIR)/raylib_lua.dll; \
	else \
		cp target/release/libraylib_lua.so $(INST_LIBDIR)/raylib_lua.so; \
	fi
	@# Install the Lua wrapper modules
	cp lua/raylib/init.lua $(INST_LUADIR)/raylib/init.lua
	@# Install type definitions if they exist
	@if [ -f lua/raylib/meta.lua ]; then \
		cp lua/raylib/meta.lua $(INST_LUADIR)/raylib/meta.lua; \
	fi
	@# Install rlmlua helper module if it exists
	@if [ -f lua/rlmlua/init.lua ]; then \
		cp lua/rlmlua/init.lua $(INST_LUADIR)/rlmlua/init.lua; \
	fi
	@if [ -f lua/rlmlua/meta.lua ]; then \
		cp lua/rlmlua/meta.lua $(INST_LUADIR)/rlmlua/meta.lua; \
	fi
	@echo "Installation complete!"
	@echo "You can now use: require('raylib') in your Lua scripts"

clean:
	cargo clean

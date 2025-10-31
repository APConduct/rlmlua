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

.PHONY: all install clean

all:
	unset CC; unset CXX; cargo build --release
	@if [ "$(DYNAM_EXTENSION)" = ".dylib" ]; then \
		cp target/release/librlmlua.dylib target/release/libraylib_lua.so; \
	elif [ "$(DYNAM_EXTENSION)" = ".dll" ]; then \
		cp target/release/librlmlua.dll target/release/libraylib_lua.so; \
	else \
		cp target/release/librlmlua.so target/release/libraylib_lua.so; \
	fi

install:
	mkdir -p $(INST_LIBDIR)
	mkdir -p $(INST_LUADIR)/raylib
	cp target/release/librlmlua$(DYNAM_EXTENSION) $(INST_LIBDIR)/
	cp lua/raylib/init.lua $(INST_LUADIR)/raylib/
	# cp lua/raylib/helpers.lua $(INST_LUADIR)/raylib/

clean:
	cargo clean

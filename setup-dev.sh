#!/bin/bash
# setup.sh - Cross-platform setup script for rlmlua

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "rlmlua Development Setup"
echo "========================"
echo ""

# Detect OS and set library extension
detect_platform() {
    case "$(uname -s)" in
        Linux*)
            PLATFORM="Linux"
            LIB_EXT="so"
            LIB_PREFIX="lib"
            SHELL_RC="$HOME/.bashrc"
            ;;
        Darwin*)
            PLATFORM="macOS"
            LIB_EXT="dylib"
            LIB_PREFIX="lib"
            # macOS Catalina+ uses zsh by default
            if [ -f "$HOME/.zshrc" ]; then
                SHELL_RC="$HOME/.zshrc"
            else
                SHELL_RC="$HOME/.bash_profile"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            PLATFORM="Windows"
            LIB_EXT="dll"
            LIB_PREFIX=""
            SHELL_RC="$HOME/.bashrc"
            ;;
        *)
            echo -e "${RED}Unknown platform: $(uname -s)${NC}"
            echo "Defaulting to Linux settings..."
            PLATFORM="Unknown"
            LIB_EXT="so"
            LIB_PREFIX="lib"
            SHELL_RC="$HOME/.bashrc"
            ;;
    esac
}

# Detect Lua version
detect_lua_version() {
    if command -v lua >/dev/null 2>&1; then
        LUA_VERSION=$(lua -v 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
        echo -e "${GREEN}✓${NC} Found Lua $LUA_VERSION"
    else
        echo -e "${RED}✗${NC} Lua not found!"
        echo "Please install Lua 5.4 first"
        exit 1
    fi
}

# Check for Rust
check_rust() {
    if command -v cargo >/dev/null 2>&1; then
        RUST_VERSION=$(cargo --version | cut -d' ' -f2)
        echo -e "${GREEN}✓${NC} Found Rust $RUST_VERSION"
    else
        echo -e "${RED}✗${NC} Rust not found!"
        echo "Install from: https://rustup.rs/"
        exit 1
    fi
}

# Build the project
build_project() {
    echo ""
    echo "Building rlmlua..."
    if cargo build --release; then
        echo -e "${GREEN}✓${NC} Build successful"
    else
        echo -e "${RED}✗${NC} Build failed"
        exit 1
    fi
}

# Install to local LuaRocks tree
install_local() {
    echo ""
    echo "Installing to ~/.luarocks..."

    mkdir -p "$HOME/.luarocks/lib/lua/$LUA_VERSION"
    mkdir -p "$HOME/.luarocks/share/lua/$LUA_VERSION"

    # Copy library with correct name
    # LIB_FILE="target/release/${LIB_PREFIX}raylib_lua.$LIB_EXT"
    LIB_FILE="target/release/${LIB_PREFIX}rlmlua.$LIB_EXT"
    if [ ! -f "$LIB_FILE" ]; then
        echo -e "${RED}✗${NC} Library not found: $LIB_FILE"
        exit 1
    fi

    cp "$LIB_FILE" "$HOME/.luarocks/lib/lua/$LUA_VERSION/raylib_lua.$LIB_EXT"
    cp -r lua/raylib "$HOME/.luarocks/share/lua/$LUA_VERSION/"

    if [ -d lua/rlmlua ]; then
        cp -r lua/rlmlua "$HOME/.luarocks/share/lua/$LUA_VERSION/"
    fi

    echo -e "${GREEN}✓${NC} Installed successfully"
}

# Configure shell
configure_shell() {
    echo ""
    echo "Configuring shell..."

    CPATH_LINE="export LUA_CPATH=\"\$HOME/.luarocks/lib/lua/$LUA_VERSION/?.$LIB_EXT;\$LUA_CPATH\""
    PATH_LINE="export LUA_PATH=\"\$HOME/.luarocks/share/lua/$LUA_VERSION/?.lua;\$HOME/.luarocks/share/lua/$LUA_VERSION/?/init.lua;\$LUA_PATH\""

    if grep -q "LUA_CPATH.*luarocks" "$SHELL_RC" 2>/dev/null; then
        echo -e "${YELLOW}!${NC} Shell already configured"
    else
        echo ""
        echo "Add these lines to your $SHELL_RC:"
        echo ""
        echo -e "${GREEN}$CPATH_LINE${NC}"
        echo -e "${GREEN}$PATH_LINE${NC}"
        echo ""
        read -p "Add automatically? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> "$SHELL_RC"
            echo "# rlmlua Lua paths" >> "$SHELL_RC"
            echo "$CPATH_LINE" >> "$SHELL_RC"
            echo "$PATH_LINE" >> "$SHELL_RC"
            echo -e "${GREEN}✓${NC} Added to $SHELL_RC"
            echo ""
            echo "Run: source $SHELL_RC"
        fi
    fi
}

# Run test
run_test() {
    echo ""
    echo "Running test..."

    # Temporarily set paths for test
    export LUA_CPATH="./target/release/?.$LIB_EXT:./target/debug/?.$LIB_EXT:$LUA_CPATH"
    export LUA_PATH="./lua/?.lua:./lua/?/init.lua:$LUA_PATH"

    if [ -f test.lua ]; then
        if lua test.lua; then
            echo -e "${GREEN}✓${NC} Test passed!"
        else
            echo -e "${RED}✗${NC} Test failed"
            exit 1
        fi
    else
        echo -e "${YELLOW}!${NC} No test.lua found, skipping test"
    fi
}

# Main
main() {
    detect_platform
    echo "Platform: $PLATFORM"
    echo "Library extension: .$LIB_EXT"
    echo "Shell config: $SHELL_RC"
    echo ""

    detect_lua_version
    check_rust

    build_project
    install_local
    configure_shell
    run_test

    echo ""
    echo -e "${GREEN}════════════════════════════════════${NC}"
    echo -e "${GREEN}Setup Complete!${NC}"
    echo -e "${GREEN}════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Reload your shell: source $SHELL_RC"
    echo "2. Run an example: lua examples/01_basic_window.lua"
    echo ""
    echo "Or use the Makefile:"
    echo "  make run EXAMPLE=01_basic_window"
    echo "  make test"
    echo "  make examples"
}

main

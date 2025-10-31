#!/bin/bash
# Just fix lines 14-16
sed -i.bak11 '14s/.*/    INSTALL_NAME="raylib_lua.dylib"/' install_local.sh
sed -i.bak12 '16s/.*/    INSTALL_NAME="raylib_lua.so"/' install_local.sh

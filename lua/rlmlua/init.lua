-- rlmlua helper module
-- This provides helper functions for creating raylib types

local raylib_lua = require("raylib_lua")

local rlm = {}

-- Re-export helper functions from the raylib_lua module
-- These create Vector2, Vector3, and Rectangle userdata types
rlm.vec2 = raylib_lua.vec2
rlm.vec3 = raylib_lua.vec3
rlm.rect = raylib_lua.rect

return rlm

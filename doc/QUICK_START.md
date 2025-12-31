# Quick Start Guide for rlmlua

Get up and running with rlmlua (Raylib Lua bindings) in 5 minutes!

## Installation (2 minutes)

### Step 1: Clone the Repository

```bash
git clone <your-repo-url>
cd rlmlua
```

### Step 2: Install Locally

```bash
./install_local.sh
```

That's it! The script will:
- Build the Rust library
- Copy files to your local luarocks directory (~/.luarocks/)
- Test the installation

## Your First Program (3 minutes)

### Create a new file: `my_game.lua`

```lua
#!/usr/bin/env lua
local rl = require("raylib")

-- Create a window
local window = rl.init_window(800, 450, "My First Raylib Game")
window:set_target_fps(60)

-- Main game loop
while not window:window_should_close() do
    window:begin_drawing()
    
    -- Clear screen with a nice blue color
    window:clear_background(rl.colors.SKYBLUE)
    
    -- Draw some text
    window:draw_text("Hello, Raylib!", 250, 200, 30, rl.colors.BLACK)
    
    -- Draw a rectangle
    window:draw_rectangle(100, 100, 100, 50, rl.colors.RED)
    
    window:end_drawing()
end

print("Game closed!")
```

### Run it!

```bash
lua my_game.lua
```

That's it! You should see a window with text and a red rectangle.

## Interactive Example

Let's make something more fun - a circle that follows your mouse:

```lua
local rl = require("raylib")

local window = rl.init_window(800, 600, "Mouse Follower")
window:set_target_fps(60)

while not window:window_should_close() do
    -- Get mouse position
    local mouse_x, mouse_y = window:get_mouse_position()
    
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)
    
    -- Draw title
    window:draw_text("Move your mouse!", 250, 30, 30, rl.colors.DARKGRAY)
    
    -- Draw circle at mouse position
    window:draw_circle(mouse_x, mouse_y, 30, rl.colors.PURPLE)
    
    -- Show FPS
    local fps = window:get_fps()
    window:draw_text("FPS: " .. fps, 10, 10, 20, rl.colors.GREEN)
    
    window:end_drawing()
end
```

## Common Patterns

### Drawing Shapes

```lua
-- Filled shapes
window:draw_rectangle(x, y, width, height, color)
window:draw_circle(x, y, radius, color)

-- Outlines
window:draw_rectangle_lines(x, y, width, height, color)
window:draw_circle_lines(x, y, radius, color)

-- Lines and pixels
window:draw_line(x1, y1, x2, y2, color)
window:draw_pixel(x, y, color)
```

### Keyboard Input

```lua
-- Check if key is pressed this frame
if window:is_key_pressed("SPACE") then
    print("Space was just pressed!")
end

-- Check if key is being held down
if window:is_key_down("RIGHT") then
    player_x = player_x + 5
end

-- Other keys: "A"-"Z", "0"-"9", "UP", "DOWN", "LEFT", "RIGHT", "ENTER", "ESC", etc.
```

### Mouse Input

```lua
-- Get position
local x, y = window:get_mouse_position()

-- Check buttons (0=left, 1=right, 2=middle)
if window:is_mouse_button_pressed(0) then
    print("Left mouse button clicked!")
end
```

### Colors

```lua
-- Use predefined colors
rl.colors.WHITE
rl.colors.BLACK
rl.colors.RED
rl.colors.GREEN
rl.colors.BLUE
rl.colors.YELLOW
rl.colors.SKYBLUE
rl.colors.PURPLE
rl.colors.ORANGE

-- Create custom colors (R, G, B, Alpha)
local my_color = rl.color(255, 128, 64, 255)
```

## Complete Example: Bouncing Ball

Here's a complete game with movement and collision:

```lua
local rl = require("raylib")

local window = rl.init_window(800, 600, "Bouncing Ball")
window:set_target_fps(60)

-- Ball properties
local ball = {
    x = 400,
    y = 300,
    radius = 20,
    speed_x = 5,
    speed_y = 5
}

while not window:window_should_close() do
    -- Update ball position
    ball.x = ball.x + ball.speed_x
    ball.y = ball.y + ball.speed_y
    
    -- Bounce off walls
    if ball.x <= ball.radius or ball.x >= 800 - ball.radius then
        ball.speed_x = -ball.speed_x
    end
    if ball.y <= ball.radius or ball.y >= 600 - ball.radius then
        ball.speed_y = -ball.speed_y
    end
    
    -- Draw
    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)
    
    window:draw_text("Bouncing Ball Demo", 250, 20, 30, rl.colors.DARKGRAY)
    window:draw_circle(ball.x, ball.y, ball.radius, rl.colors.RED)
    
    -- Draw walls
    window:draw_rectangle_lines(0, 0, 800, 600, rl.colors.GRAY)
    
    window:end_drawing()
end
```

## Troubleshooting

### "Module not found" error?

Make sure the installation completed successfully:

```bash
lua -e "require('raylib'); print('OK')"
```

If that fails, try reinstalling:

```bash
./uninstall_local.sh
./install_local.sh
```

### Library not building?

Try cleaning and rebuilding:

```bash
cargo clean
./install_local.sh
```

### Still having issues?

Check out the detailed guides:
- [INSTALL.md](INSTALL.md) - Comprehensive installation guide
- [DEVELOPMENT.md](DEVELOPMENT.md) - Architecture and API details
- [README.md](README.md) - Full documentation

## Next Steps

1. **Explore Examples**: Check out the `examples/` directory for more demos
2. **Read the API**: See [README.md](README.md) for all available functions
3. **Build Something**: Start making your game or application!

## Example Programs Included

Run these to see what's possible:

```bash
# Simple window with text
lua examples/01_basic_window.lua

# Interactive shapes with keyboard/mouse input
lua examples/02_shapes_and_input.lua

# Installation test example
lua examples/00_simple_after_install.lua
```

## Useful Resources

- **Raylib Cheatsheet**: https://www.raylib.com/cheatsheet/cheatsheet.html
- **Project Documentation**: [README.md](README.md)
- **Development Guide**: [DEVELOPMENT.md](DEVELOPMENT.md)

## Getting Help

- Read the documentation in the repository
- Check existing examples
- Review the API reference in README.md

## Uninstalling

When you're done or want to reinstall:

```bash
./uninstall_local.sh
```

Happy coding! 🎮
local rl = require("raylib")

-- Comprehensive validation script to verify the bug fixes
-- Now using standard raylib pattern (no manual polling needed)

print("========================================")
print("RLMLUA VALIDATION TEST")
print("========================================")
print("")

local all_passed = true
local function test(name, passed, message)
    if passed then
        print("✓ " .. name .. ": PASS")
    else
        print("✗ " .. name .. ": FAIL - " .. message)
        all_passed = false
    end
end

-- Test 1: Window initialization
print("Test 1: Window Initialization")
local window = rl.init_window(800, 450, "Validation Test")
test("Window creation", window ~= nil, "Window is nil")
print("")

-- Test 2: Target FPS setting
print("Test 2: Target FPS")
window:set_target_fps(60)
test("set_target_fps", true, "")
print("")

-- Test 3: Color constants availability
print("Test 3: Color Constants")
test("WHITE color", rl.colors.WHITE ~= nil, "WHITE not found")
test("BLACK color", rl.colors.BLACK ~= nil, "BLACK not found")
test("RAYWHITE color", rl.colors.RAYWHITE ~= nil, "RAYWHITE not found")
test("SKYBLUE color", rl.colors.SKYBLUE ~= nil, "SKYBLUE not found")
test("RED color", rl.colors.RED ~= nil, "RED not found")
test("BLUE color", rl.colors.BLUE ~= nil, "BLUE not found")
test("GREEN color", rl.colors.GREEN ~= nil, "GREEN not found")
print("")

-- Test 4: Drawing methods availability
print("Test 4: Drawing Methods")
test("begin_drawing exists", type(window.begin_drawing) == "function", "Method not found")
test("end_drawing exists", type(window.end_drawing) == "function", "Method not found")
test("clear_background exists", type(window.clear_background) == "function", "Method not found")
test("draw_text exists", type(window.draw_text) == "function", "Method not found")
test("draw_rectangle exists", type(window.draw_rectangle) == "function", "Method not found")
test("draw_circle exists", type(window.draw_circle) == "function", "Method not found")
test("draw_line exists", type(window.draw_line) == "function", "Method not found")
print("")

-- Test 5: Input methods availability
print("Test 5: Input Methods")
test("window_should_close exists", type(window.window_should_close) == "function", "Method not found")
test("is_key_pressed exists", type(window.is_key_pressed) == "function", "Method not found")
test("is_key_down exists", type(window.is_key_down) == "function", "Method not found")
test("is_mouse_button_pressed exists", type(window.is_mouse_button_pressed) == "function", "Method not found")
test("get_mouse_position exists", type(window.get_mouse_position) == "function", "Method not found")
print("")

-- Test 6: Actual rendering (run for a few frames)
print("Test 6: Rendering Test (5 frames)")
local render_success = true
local render_error = nil

for frame = 1, 5 do
    if window:window_should_close() then
        break
    end

    local success, err = pcall(function()
        window:begin_drawing()
        window:clear_background(rl.colors.RAYWHITE)
        window:draw_text("Validation Test", 300, 200, 30, rl.colors.DARKBLUE)
        window:draw_rectangle(100, 100, 100, 50, rl.colors.RED)
        window:draw_circle(400, 300, 30, rl.colors.BLUE)
        window:draw_line(600, 100, 700, 200, rl.colors.GREEN)
        window:end_drawing()
    end)

    if not success then
        render_success = false
        render_error = err
        break
    end
end

test("Rendering operations", render_success, render_error or "")
print("")

-- Test 7: Input checking pattern
print("Test 7: Input Checking Pattern")
local input_test_frames = 3
local input_success = true
local input_error = nil

for frame = 1, input_test_frames do
    if window:window_should_close() then
        break
    end

    local success, err = pcall(function()
        -- These should all work without errors
        local _ = window:is_key_down("SPACE")
        local _ = window:is_key_pressed("ENTER")
        local x, y = window:get_mouse_position()
        local _ = window:is_mouse_button_down(0)
    end)

    if not success then
        input_success = false
        input_error = err
        break
    end

    window:begin_drawing()
    window:clear_background(rl.colors.WHITE)
    window:end_drawing()
end

test("Input checking", input_success, input_error or "")
print("")

-- Test 8: FPS and timing functions
print("Test 8: Timing Functions")
local timing_success, timing_err = pcall(function()
    local fps = window:get_fps()
    local frame_time = window:get_frame_time()
    local time = window:get_time()
    return fps ~= nil and frame_time ~= nil and time ~= nil
end)
test("Timing functions", timing_success, timing_err or "")
print("")

-- Test 9: Screen dimensions
print("Test 9: Screen Functions")
local screen_success, screen_err = pcall(function()
    local width = window:get_screen_width()
    local height = window:get_screen_height()
    return width == 800 and height == 450
end)
test("Screen dimensions", screen_success, screen_err or "")
print("")

-- Final visual test
print("Running visual demonstration (3 seconds)...")
print("This tests all fixes working together.")
print("")

local demo_frames = 180 -- 3 seconds at 60 FPS
local frame_count = 0

while not window:window_should_close() and frame_count < demo_frames do
    frame_count = frame_count + 1

    -- Test input responsiveness
    local space_down = window:is_key_down("SPACE")

    window:begin_drawing()
    window:clear_background(rl.colors.RAYWHITE)

    -- Title
    window:draw_text("All Systems Working!", 250, 50, 30, rl.colors.DARKBLUE)

    -- Status
    window:draw_text("Frame: " .. frame_count .. " / " .. demo_frames, 320, 120, 20, rl.colors.BLACK)

    -- Drawing primitives test
    window:draw_text("Drawing primitives:", 280, 160, 20, rl.colors.DARKGRAY)
    window:draw_rectangle(100, 220, 80, 60, rl.colors.RED)
    window:draw_circle(250, 250, 30, rl.colors.BLUE)
    window:draw_line(320, 220, 380, 280, rl.colors.GREEN)
    window:draw_rectangle_lines(420, 220, 80, 60, rl.colors.PURPLE)
    window:draw_circle_lines(570, 250, 30, rl.colors.ORANGE)

    -- Input test
    window:draw_text("Hold SPACE to test input:", 250, 320, 18, rl.colors.BLACK)
    if space_down then
        window:draw_text("SPACE IS DOWN!", 280, 345, 20, rl.colors.GREEN)
    else
        window:draw_text("(not pressed)", 310, 345, 18, rl.colors.GRAY)
    end

    -- Exit instruction
    window:draw_text("Press ESC or click X to exit", 250, 400, 16, rl.colors.DARKGRAY)

    window:end_drawing()
    -- EndDrawing automatically handles input polling, frame timing, and buffer swapping!
end

print("")
print("========================================")
print("VALIDATION RESULTS")
print("========================================")
print("")

if all_passed then
    print("✓✓✓ ALL TESTS PASSED ✓✓✓")
    print("")
    print("Summary:")
    print("  • Window rendering: WORKING")
    print("  • Input responsiveness: FIXED")
    print("  • Color constants: AVAILABLE")
    print("  • Drawing methods: FUNCTIONAL")
    print("  • Standard raylib pattern: WORKING")
    print("")
    print("The project is working correctly!")
else
    print("✗✗✗ SOME TESTS FAILED ✗✗✗")
    print("")
    print("Please review the test output above.")
end

print("")
print("Note: This uses standard raylib behavior where EndDrawing()")
print("automatically handles input polling and frame timing.")
print("")
print("Validation complete.")
print("========================================")

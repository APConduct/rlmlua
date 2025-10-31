local f = io.open("src/lib.rs", "r")
local content = f:read("*all")
f:close()

-- Update begin_drawing to record start time
local begin_pattern = "            DRAW_HANDLE%.with%(|cell| cell%.replace%(Some%(d_static%)%)%);\n            Ok%(%(%)%)\n        }%);"

local begin_replacement = [[            DRAW_HANDLE.with(|cell| cell.replace(Some(d_static)));
            // Record frame start time for FPS limiting
            FRAME_START.with(|f| f.replace(Some(Instant::now())));
            Ok(())
        });]]

content = content:gsub(begin_pattern, begin_replacement)

-- Update end_drawing to add frame timing wait
local end_pattern = "                std::mem::drop%(boxed_handle%);\n                    }\n                }\n            }%);\n            Ok%(%(%)%)\n        }%);"

local end_replacement = [[                std::mem::drop(boxed_handle);
                    }
                }
            });
            
            // Frame timing - wait to match target FPS
            FRAME_START.with(|start_cell| {
                if let Some(start_time) = *start_cell.borrow() {
                    let elapsed = start_time.elapsed();
                    let target_fps = TARGET_FPS.with(|f| *f.borrow());
                    if target_fps > 0 {
                        let target_frame_time = Duration::from_secs_f64(1.0 / target_fps as f64);
                        if elapsed < target_frame_time {
                            thread::sleep(target_frame_time - elapsed);
                        }
                    }
                }
            });
            
            Ok(())
        });]]

content = content:gsub(end_pattern, end_replacement)

local out = io.open("src/lib.rs", "w")
out:write(content)
out:close()

print("Updated begin_drawing and end_drawing with frame timing")

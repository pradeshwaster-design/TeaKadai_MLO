// =============================================================================
// part_hanging_sign_board.scad — Export the 3D Tamil "டீ கடை" signboard.
// =============================================================================
// Centered at local origin [0, 0, 0] for direct Blender import!
// Spawns right at the 3D cursor / viewport center in Blender.
// Press F6 (render), then File -> Export as OBJ (or STL).
// =============================================================================

include <tea_shop_signage_modules.scad>;

// world_pos = false centers the model at local origin [0, 0, 0]
hanging_sign_board(world_pos = false);

// =============================================================================
// TEA SHOP DIORAMA — GROUP 6: BENCH (CENTERED AT LOCAL ORIGIN)
// =============================================================================
// Standalone export with the bench centered at [0, 0, 0] for easy Blender editing.
// Length along X (-750 to +750), Width along Y (-200 to +200), Height Z (0 to 460).
// =============================================================================

include <tea_shop_furniture_modules.scad>;

translate([-BENCH_LENGTH / 2, 0, 0])
    bench(world_pos = false);

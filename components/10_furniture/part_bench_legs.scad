// =============================================================================
// TEA SHOP DIORAMA — GROUP 6: BENCH LEGS (BOTH LEG ASSEMBLIES)
// =============================================================================
// Standalone export for both bench leg pair assemblies.
// Positioned directly in world coordinates on top of the base slab.
// =============================================================================

include <tea_shop_furniture_modules.scad>;

translate([BENCH_POS_X, BENCH_POS_Y, 0])
rotate([0, 0, BENCH_ROT_Z]) {
    // Left Leg Pair (Normal)
    translate([BENCH_LEG_INSET_X, 0, 0])
        bench_leg_pair();

    // Right Leg Pair (Mirrored)
    translate([BENCH_LENGTH - BENCH_LEG_INSET_X, 0, 0])
        mirror([1, 0, 0])
            bench_leg_pair();
}

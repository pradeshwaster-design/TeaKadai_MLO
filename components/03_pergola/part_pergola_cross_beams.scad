// =============================================================================
// part_pergola_cross_beams.scad — EXPORT ALL 4 CROSS BEAMS / RAFTERS fused.
// Press F6 (render), then export as STL.
// =============================================================================

include <tea_shop_pergola_modules.scad>;

union() {
    for (x = CROSS_BEAM_X_POSITIONS) {
        translate([x, 0, 0])
            pergola_cross_beam();
    }
}

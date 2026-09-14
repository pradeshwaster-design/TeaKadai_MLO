// =============================================================================
// part_pergola_slats.scad — EXPORT THE FULL ARRAYED SLAT CANOPY only.
// Press F6 (render), then export as STL.
// =============================================================================

include <tea_shop_pergola_modules.scad>;

union() {
    for (i = [0 : SLAT_COUNT - 1]) {
        dist = SLAT_START_OFFSET + i * (SLAT_WIDTH + SLAT_GAP);
        translate([0, 0, PERGOLA_EAVE_Z])
            rotate([-ROOF_ANGLE, 0, 0])
                translate([0, -dist, 0])
                    pergola_slat();
    }
}

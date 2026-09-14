// =============================================================================
// part_roof_complete.scad — OPTIONAL MONOLITHIC EXPORT
// -----------------------------------------------------------------------------
// Exports the entire Roof group (slab + tiles + ridge cap + all fascias)
// fused into a single unified solid STL for single-part 3D printing.
// =============================================================================

include <tea_shop_roof_modules.scad>;

union() {
    roof_slab();
    roof_tile_pattern();
    ridge_cap_or_top_trim();
    eave_fascia_left();
    eave_fascia_right();
    eave_fascia_front();
}

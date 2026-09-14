// =============================================================================
// part_pergola_diagonal_brace.scad — EXPORT THE DIAGONAL BRACE only.
// Press F6 (render), then export as STL.
// =============================================================================

include <tea_shop_pergola_modules.scad>;

translate([3850, -50, sill_height + 20])
    pergola_diagonal_brace();

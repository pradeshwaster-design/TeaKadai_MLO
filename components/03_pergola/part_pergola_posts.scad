// =============================================================================
// part_pergola_posts.scad — EXPORT ALL 4 PERGOLA POSTS as one fused solid.
// -----------------------------------------------------------------------------
// Press F6 (render), then File -> Export as STL.
// All 4 post instances are unioned into one STL for single-operation printing.
// (Each post can also be split out individually if needed by printing just
//  one translate()+pergola_post() call.)
// =============================================================================

include <tea_shop_pergola_modules.scad>;

union() {
    for (pos = PERGOLA_POST_POSITIONS) {
        translate([pos[0], pos[1], 0])
            pergola_post();
    }
}

// =============================================================================
// TEA SHOP DIORAMA — SIGNAGE MODULE LIBRARY (3D TAMIL "டீ கடை")
// =============================================================================
// Full 3D modeled signage with extruded Tamil typography and graphics.
// Watertight, manifold solid meshes for OBJ / STL export & GTA V MLO pipeline.
//
// ORIGIN / PLACEMENT CONVENTION:
//   Every module accepts an optional parameter: `world_pos = false` (default)
//   - When world_pos = false (for standalone STL/OBJ export into Blender):
//     The model is centered at local origin [0, 0, 0] (X centered, Y centered,
//     Z resting on ground [0..H]). It will spawn DIRECTLY at the center of
//     your Blender viewport (0, 0, 0) instead of kilometers away.
//   - When world_pos = true (for assembly preview):
//     The model is positioned at its exact real-world diorama coordinate
//     matching Groups 1–4.
// =============================================================================

include <tea_shop_signage_parameters.scad>;


// =============================================================================
// MODULE 1: hanging_sign_board(world_pos = false)
// -----------------------------------------------------------------------------
// The main shop signboard.
// Features:
//   1. Solid background wood/metal backing panel (1600 x 920 x 30 mm).
//   2. Raised perimeter border frame / rim (25 mm wide, 8 mm proud).
//   3. 3D extruded bold Tamil typography: "டீ கடை" (Tea Kadai).
//   4. Decorative underline bar.
//   5. 3D decorative tea cup graphic with saucer, cup, handle, and steam.
//
// Origin when world_pos = false:
//   X = 0 (centered), Y = 0 (centered), Z = 0 (bottom of board rests on Z=0).
// =============================================================================
module hanging_sign_board(world_pos = false) {
    tx = world_pos ? HANGING_SIGN_X : 0;
    ty = world_pos ? HANGING_SIGN_Y + HANGING_SIGN_T / 2 : 0;
    tz = world_pos ? HANGING_SIGN_Z : 0;

    translate([tx, ty, tz]) {
        // Base plate + Rim + 3D Tamil typography & art
        translate([-HANGING_SIGN_W / 2, -HANGING_SIGN_T / 2, 0]) {
            // 1. Base backing plate
            color("#2d483a") // Vintage patina / dark green tone
                cube([HANGING_SIGN_W, HANGING_SIGN_T, HANGING_SIGN_H]);

            // 2. Outer border rim
            color("#7a4b2a") // Weathered rust / copper rim
            translate([0, -HANGING_SIGN_RIM_T, 0]) {
                // Bottom rim
                cube([HANGING_SIGN_W, HANGING_SIGN_RIM_T, HANGING_SIGN_RIM_W]);
                // Top rim
                translate([0, 0, HANGING_SIGN_H - HANGING_SIGN_RIM_W])
                    cube([HANGING_SIGN_W, HANGING_SIGN_RIM_T, HANGING_SIGN_RIM_W]);
                // Left rim
                cube([HANGING_SIGN_RIM_W, HANGING_SIGN_RIM_T, HANGING_SIGN_H]);
                // Right rim
                translate([HANGING_SIGN_W - HANGING_SIGN_RIM_W, 0, 0])
                    cube([HANGING_SIGN_RIM_W, HANGING_SIGN_RIM_T, HANGING_SIGN_H]);
            }

            // 3. 3D Tamil Text: "டீ கடை" (Tea Kadai)
            color("#fdf6e2") // Antique cream white
            translate([HANGING_SIGN_W * 0.42, -HANGING_SIGN_LET_T, HANGING_SIGN_H * 0.54])
                rotate([90, 0, 0])
                    linear_extrude(height = HANGING_SIGN_LET_T + 0.1)
                        text("டீ கடை", size = 200, font = "Nirmala UI:style=Bold", halign = "center", valign = "center");

            // 4. Decorative divider bar
            color("#c99a4e") // Vintage gold
            translate([HANGING_SIGN_W * 0.10, -HANGING_SIGN_LET_T * 0.7, HANGING_SIGN_H * 0.28])
                cube([HANGING_SIGN_W * 0.62, HANGING_SIGN_LET_T * 0.7 + 0.1, 14]);

            // 5. 3D Tea Cup Graphic
            color("#fdf6e2")
            translate([HANGING_SIGN_W * 0.82, -HANGING_SIGN_LET_T, HANGING_SIGN_H * 0.44]) {
                rotate([90, 0, 0]) {
                    // Saucer
                    translate([0, -40, 0])
                        linear_extrude(height = HANGING_SIGN_LET_T + 0.1)
                            scale([2.2, 0.5]) circle(r = 45, $fn = 24);

                    // Cup body
                    linear_extrude(height = HANGING_SIGN_LET_T + 0.1)
                        polygon(points = [
                            [-45, -30], [45, -30],
                            [55, 45], [-55, 45]
                        ]);

                    // Cup handle
                    translate([52, 10, 0])
                        linear_extrude(height = HANGING_SIGN_LET_T + 0.1)
                            difference() {
                                circle(r = 30, $fn = 20);
                                circle(r = 18, $fn = 20);
                                translate([-35, -35, 0]) square([40, 70]);
                            }

                    // Steam curls
                    for (sx = [-20, 5, 30]) {
                        translate([sx - 5, 60, 0])
                            linear_extrude(height = HANGING_SIGN_LET_T * 0.8)
                                polygon(points = [
                                    [-3, 0], [3, 0], [6, 25], [1, 45], [-4, 45], [0, 25]
                                ]);
                    }
                }
            }
        }
    }
}


// =============================================================================
// MODULE 2: sign_bracket(world_pos = false)
// -----------------------------------------------------------------------------
// The timber mounting framework supporting the hanging sign from behind:
//   - Upright support post rising behind the center of the signboard.
//   - Upper and lower horizontal cross battens securing the rear face of the sign.
// =============================================================================
module sign_bracket(world_pos = false) {
    tx = world_pos ? HANGING_SIGN_X : 0;
    ty = world_pos ? POST_Y : 0;
    tz = world_pos ? 0 : -(POST_HEIGHT + MAIN_BEAM_HEIGHT);

    translate([tx, ty, tz]) {
        color("DimGray") {
            // 1. Upright support post
            translate([
                -BRACKET_POST_W / 2,
                -BRACKET_POST_D / 2,
                POST_HEIGHT + MAIN_BEAM_HEIGHT
            ])
                cube([BRACKET_POST_W, BRACKET_POST_D, BRACKET_POST_H]);

            // 2. Top horizontal cross batten
            translate([
                -BRACKET_BATTEN_W / 2,
                -BRACKET_BATTEN_D / 2,
                HANGING_SIGN_Z + HANGING_SIGN_H - 120
            ])
                cube([BRACKET_BATTEN_W, BRACKET_BATTEN_D, BRACKET_BATTEN_H]);

            // 3. Bottom horizontal cross batten
            translate([
                -BRACKET_BATTEN_W / 2,
                -BRACKET_BATTEN_D / 2,
                HANGING_SIGN_Z + 120
            ])
                cube([BRACKET_BATTEN_W, BRACKET_BATTEN_D, BRACKET_BATTEN_H]);
        }
    }
}


// =============================================================================
// MODULE 3: price_list_sign(world_pos = false)
// -----------------------------------------------------------------------------
// Small menu signboard mounted flat against the front exterior sill wall.
// Features:
//   1. Backing panel (520 x 420 x 15 mm).
//   2. Raised outer frame rim.
//   3. 3D Tamil header: "விலைப்பட்டியல்" (Price List).
//   4. 3D engraved price list rule lines.
//
// Origin when world_pos = false:
//   Centered at [0, 0, 0] (X centered, Y centered, Z resting on ground [0..H]).
// =============================================================================
module price_list_sign(world_pos = false) {
    tx = world_pos ? PRICE_SIGN_X + PRICE_SIGN_W / 2 : 0;
    ty = world_pos ? PRICE_SIGN_Y + PRICE_SIGN_T / 2 : 0;
    tz = world_pos ? PRICE_SIGN_Z : 0;

    translate([tx, ty, tz]) {
        translate([-PRICE_SIGN_W / 2, -PRICE_SIGN_T / 2, 0]) {
            // 1. Base backing plate
            color("#e6c875") // Aged parchment tone
                cube([PRICE_SIGN_W, PRICE_SIGN_T, PRICE_SIGN_H]);

            // 2. Outer border rim
            color("#8b5a2b") // Brown wood rim
            translate([0, -PRICE_SIGN_RIM_T, 0]) {
                cube([PRICE_SIGN_W, PRICE_SIGN_RIM_T, PRICE_SIGN_RIM_W]);
                translate([0, 0, PRICE_SIGN_H - PRICE_SIGN_RIM_W])
                    cube([PRICE_SIGN_W, PRICE_SIGN_RIM_T, PRICE_SIGN_RIM_W]);
                cube([PRICE_SIGN_RIM_W, PRICE_SIGN_RIM_T, PRICE_SIGN_H]);
                translate([PRICE_SIGN_W - PRICE_SIGN_RIM_W, 0, 0])
                    cube([PRICE_SIGN_RIM_W, PRICE_SIGN_RIM_T, PRICE_SIGN_H]);
            }

            // 3. 3D Tamil Header: "விலைப்பட்டியல்"
            color("#3a2010")
            translate([PRICE_SIGN_W / 2, -PRICE_SIGN_LET_T, PRICE_SIGN_H - 45])
                rotate([90, 0, 0])
                    linear_extrude(height = PRICE_SIGN_LET_T + 0.1)
                        text("விலைப்பட்டியல்", size = 36, font = "Nirmala UI:style=Bold", halign = "center", valign = "center");

            // 4. Menu rule lines
            color("#4a2818") {
                for (m = [0 : 4]) {
                    translate([30, -PRICE_SIGN_LET_T * 0.6, PRICE_SIGN_H - 100 - m * 55])
                        cube([PRICE_SIGN_W - 60, PRICE_SIGN_LET_T * 0.6 + 0.1, 4]);
                }
            }
        }
    }
}


// =============================================================================
// assemble() — Preview all signage elements mounted on the shop in world coords
// =============================================================================
module assemble() {
    hanging_sign_board(world_pos = true);
    sign_bracket(world_pos = true);
    price_list_sign(world_pos = true);
}

// Default preview invocation:
// assemble(); // Removed to prevent instantiating geometry when included

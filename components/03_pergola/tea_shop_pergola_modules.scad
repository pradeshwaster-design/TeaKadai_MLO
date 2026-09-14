// =============================================================================
// Tea Shop — GROUP 3: PERGOLA MODULE LIBRARY
// -----------------------------------------------------------------------------
// Defines all pergola part modules. Creates NO geometry on its own when
// included, allowing individual part_*.scad export files and the assembly
// preview file to include it cleanly.
//
// SHARED GLOBAL COORDINATE SYSTEM (identical to Groups 1 & 2):
//   +X -> left -> right  (0 = left outer wall face, BUILD_W = right outer wall)
//   +Y -> front -> back  (0 = front eave wall face, BUILD_D = back wall)
//   +Z -> up             (0 = ground / plinth top datum)
//   Porch canopy extends in negative Y (forward, from Y = 0 to Y ≈ -2450 mm).
//
// SLOPE CORRECTION:
//   Because the porch is in the negative Y direction (-Y), applying a POSITIVE
//   rotation `rotate([ROOF_ANGLE, 0, 0])` causes the coordinate `[0, -y, 0]`
//   to rotate DOWNWARD into negative Z: `Z = -y * sin(ROOF_ANGLE)`.
//   This ensures the pergola rafters and slats slope DOWNWARDS toward the front
//   posts, resting flush and continuous with the building's roof line.
//
// TODO: The hanging "TEA SHOP" sign and its mounting bracket (a later group)
//       will attach to the main header beam / roof slats near Post 3 (X=4250).
// TODO: The customer bench, stools, and water dispenser stand (later groups)
//       sit on the base slab beneath this pergola structure at Z=0.
// =============================================================================

include <tea_shop_pergola_parameters.scad>;


// =============================================================================
// MODULE 1: pergola_post()
// -----------------------------------------------------------------------------
// A single vertical square timber post modeled at the local origin:
//   Centred in X and Y ([-POST_SIZE/2 .. +POST_SIZE/2]), rising from Z=0
//   to Z=POST_HEIGHT (touching the underside of the front header beam).
// Instanced 4 times via translate() in assemble() — single reusable module.
// =============================================================================
module pergola_post() {
    translate([-POST_SIZE/2, -POST_SIZE/2, 0])
        cube([POST_SIZE, POST_SIZE, POST_HEIGHT]);
}


// =============================================================================
// MODULE 2: pergola_main_beam()
// -----------------------------------------------------------------------------
// The horizontal primary beam system:
//   1. Front header beam: spans across all 4 post tops at Y = POST_Y,
//      distributing load and directly supporting the sloped rafters.
//   2. Rear ledger beam: runs along the front wall eave (Y=0), supporting
//      the upper ends of the rafters.
// =============================================================================
module pergola_main_beam() {
    // 1. Front header beam resting directly on top of the front posts
    translate([-100, POST_Y - MAIN_BEAM_WIDTH/2, POST_HEIGHT])
        cube([BUILD_W + 200, MAIN_BEAM_WIDTH, MAIN_BEAM_HEIGHT]);

    // 2. Rear wall ledger beam anchored to the front wall below the eave
    translate([-100, -MAIN_BEAM_WIDTH, PERGOLA_EAVE_Z - MAIN_BEAM_HEIGHT - CROSS_BEAM_HEIGHT])
        cube([BUILD_W + 200, MAIN_BEAM_WIDTH, MAIN_BEAM_HEIGHT]);
}


// =============================================================================
// MODULE 3: pergola_diagonal_brace()
// -----------------------------------------------------------------------------
// A single diagonal timber brace modeled at local origin. Oriented at BRACE_ANGLE
// from vertical. Instanced at the service counter sill to support the overhead
// rafter beam, exactly as shown in the reference wireframe pass.
// =============================================================================
module pergola_diagonal_brace() {
    rotate([0, -BRACE_ANGLE, 10])
        translate([-BRACE_WIDTH/2, -BRACE_THICKNESS/2, 0])
            cube([BRACE_WIDTH, BRACE_THICKNESS, BRACE_LENGTH]);
}


// =============================================================================
// MODULE 4: pergola_cross_beam()
// -----------------------------------------------------------------------------
// A single sloped rafter running perpendicular to the building (in Y direction).
// Modeled at local origin (X=0) and sloped DOWNWARD at ROOF_ANGLE:
//   - Starts at the front wall ledger beam (Y=0)
//   - Slopes down to bear across the front header beam at POST_Y
//   - Projects 200 mm past the posts as an exposed rafter tail
// =============================================================================
module pergola_cross_beam() {
    translate([0, 0, PERGOLA_EAVE_Z])
        rotate([ROOF_ANGLE, 0, 0])
            translate([-CROSS_BEAM_WIDTH/2, -CROSS_BEAM_SLOPE_LEN, -CROSS_BEAM_HEIGHT])
                cube([CROSS_BEAM_WIDTH, CROSS_BEAM_SLOPE_LEN, CROSS_BEAM_HEIGHT]);
}


// =============================================================================
// MODULE 5: pergola_slat()
// -----------------------------------------------------------------------------
// A single flat timber canopy plank running along X (spanning the full width).
// Instanced and arrayed in assemble() via a for loop down the sloped plane,
// resting directly on top of the rafters.
// =============================================================================
module pergola_slat() {
    translate([-100, -SLAT_WIDTH, 0])
        cube([SLAT_LENGTH, SLAT_WIDTH, SLAT_THICKNESS]);
}


// =============================================================================
// ASSEMBLE MODULE — Visual verification preview (not for export)
// -----------------------------------------------------------------------------
// Press F5 in OpenSCAD to view all Group 3 pergola components together in color.
// For individual STL export, use the dedicated part_*.scad files.
// =============================================================================
module assemble() {
    // 1. Posts (4 instances positioned in shared global coordinates)
    color("SaddleBrown") {
        for (pos = PERGOLA_POST_POSITIONS) {
            translate([pos[0], pos[1], 0])
                pergola_post();
        }
    }

    // 2. Main horizontal beams (front header + rear ledger)
    color("Peru")
        pergola_main_beam();

    // 3. Cross beams / rafters (4 instances positioned over each post line)
    color("BurlyWood") {
        for (x = CROSS_BEAM_X_POSITIONS) {
            translate([x, 0, 0])
                pergola_cross_beam();
        }
    }

    // 4. Slatted canopy roof (8 flat planks arrayed along the slope)
    color("DarkGoldenrod") {
        for (i = [0 : SLAT_COUNT - 1]) {
            dist = SLAT_START_OFFSET + i * (SLAT_WIDTH + SLAT_GAP);
            translate([0, 0, PERGOLA_EAVE_Z])
                rotate([ROOF_ANGLE, 0, 0])
                    translate([0, -dist, 0])
                        pergola_slat();
        }
    }

    // 5. Diagonal prop brace (anchored at the service window counter sill)
    color("DarkSlateGray") {
        translate([3850, -50, sill_height + 20])
            pergola_diagonal_brace();
    }
}

// Default preview invocation:
assemble();

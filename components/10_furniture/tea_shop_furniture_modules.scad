// =============================================================================
// TEA SHOP DIORAMA — GROUP 6: EXTERIOR FURNITURE MODULES
// =============================================================================
// All units: mm (1000 mm = 1.0 m), 1:1 real-world scale (1000 units = 1 GTA unit).
// Shared global coordinate system (identical to Groups 1–5):
//   +X -> left -> right  (0 = left outer wall, BUILD_W = right outer wall)
//   +Y -> front -> back  (0 = front wall eave face, BUILD_D = back wall, porch in -Y)
//   +Z -> up             (0 = top of base slab / ground datum)
//
// UV UNWRAPPING PRIORITY (For Blender / GTA V MLO workflow):
// -----------------------------------------------------------------------------
// HIGH PRIORITY (Visible, high-wear textured surfaces):
//   1. Bench top plank: top face and outer bevel edges (primary seating surface,
//      heavy wood-grain / weathered timber texture).
//   2. Stool seat discs: top circular face and perimeter edge (wear, scratches, tea stains).
//   3. Outer vertical faces of bench and stool legs (visible to camera and player).
//
// LOW PRIORITY / UNSEEN (Can use flat ambient occlusion or small UV islands):
//   1. Underside of bench top plank and stool seat discs (shadowed by legs).
//   2. Bottom foot contact faces of all legs (hidden touching the porch slab at Z=0).
//   3. Inner touching faces between the cross-apron rails and the leg posts.
// =============================================================================

include <tea_shop_furniture_parameters.scad>;


// =============================================================================
// MODULE 1: bench_top()
// -----------------------------------------------------------------------------
// A single flat rectangular solid wooden plank serving as the bench seat.
// When world_pos = true: positioned at its real-world porch location.
// When world_pos = false: positioned with left-back at [0, 0, BENCH_HEIGHT - BENCH_TOP_THICKNESS].
// =============================================================================
module bench_top(world_pos = false) {
    pos_x = world_pos ? BENCH_POS_X : 0;
    pos_y = world_pos ? (BENCH_POS_Y - BENCH_WIDTH / 2) : 0;
    pos_z = BENCH_HEIGHT - BENCH_TOP_THICKNESS;

    color("#8B5A2B") // Warm teak / weathered timber
    translate([pos_x, pos_y, pos_z]) {
        cube([BENCH_LENGTH, BENCH_WIDTH, BENCH_TOP_THICKNESS]);
    }
}


// =============================================================================
// MODULE 2: bench_leg_pair()
// -----------------------------------------------------------------------------
// Represents the leg assembly at ONE end of the bench:
//   - Two vertical square timber posts (45x45 mm) spaced across the bench depth.
//   - One horizontal cross-apron rail (30x50 mm) connecting the posts at the top,
//     providing structural rigidity under the seat plank.
//
// Centered at its own local origin:
//   - Center of leg posts aligns with X = 0.
//   - Spans in Y from -BENCH_LEG_PAIR_WIDTH/2 to +BENCH_LEG_PAIR_WIDTH/2.
//   - Cross-apron is inset on the +X side (inner side for the left leg assembly).
//   - When instanced on the right side with mirror([1, 0, 0]), the apron
//     automatically faces inward towards the center of the bench (-X).
//   - Rises from ground (Z = 0) to the underside of the seat (Z = BENCH_HEIGHT - BENCH_TOP_THICKNESS).
// =============================================================================
module bench_leg_pair() {
    leg_h = BENCH_HEIGHT - BENCH_TOP_THICKNESS; // 420 mm
    half_w = BENCH_LEG_PAIR_WIDTH / 2;          // 160 mm

    color("#6E4720") // Darker treated timber for legs/framing
    union() {
        // Front Post
        translate([-BENCH_LEG_SIZE / 2, -half_w - BENCH_LEG_SIZE / 2, 0])
            cube([BENCH_LEG_SIZE, BENCH_LEG_SIZE, leg_h]);

        // Back Post
        translate([-BENCH_LEG_SIZE / 2, half_w - BENCH_LEG_SIZE / 2, 0])
            cube([BENCH_LEG_SIZE, BENCH_LEG_SIZE, leg_h]);

        // Top Horizontal Cross-Apron Stretcher (reinforcing rail under seat):
        // Positioned on the inner face (+X) spanning between the two leg posts
        translate([0, -half_w, leg_h - BENCH_APRON_HEIGHT])
            cube([BENCH_APRON_WIDTH, BENCH_LEG_PAIR_WIDTH, BENCH_APRON_HEIGHT]);
    }
}


// =============================================================================
// MODULE 3: bench()
// -----------------------------------------------------------------------------
// Assembled bench combining bench_top() with TWO bench_leg_pair() instances:
//   - Left leg pair: instanced normal at X = BENCH_LEG_INSET_X
//   - Right leg pair: instanced with mirror([1, 0, 0]) at X = BENCH_LENGTH - BENCH_LEG_INSET_X
//
// When world_pos = true (default):
//   Placed directly on top of the porch base slab (Z = 0) at [BENCH_POS_X, BENCH_POS_Y].
// When world_pos = false:
//   Placed at the local origin [0, 0, 0] for isolated part export.
// =============================================================================
module bench(world_pos = true) {
    base_x = world_pos ? BENCH_POS_X : 0;
    base_y = world_pos ? BENCH_POS_Y : 0;
    rot_z  = world_pos ? BENCH_ROT_Z : 0;

    translate([base_x, base_y, 0])
    rotate([0, 0, rot_z]) {
        // 1. Bench Top Plank (centered in Y about the bench origin)
        translate([0, -BENCH_WIDTH / 2, 0])
            bench_top(world_pos = false);

        // 2. Left Leg Pair (Normal instance)
        translate([BENCH_LEG_INSET_X, 0, 0])
            bench_leg_pair();

        // 3. Right Leg Pair (Mirrored instance across X so apron faces inward)
        translate([BENCH_LENGTH - BENCH_LEG_INSET_X, 0, 0])
            mirror([1, 0, 0])
                bench_leg_pair();
    }
}


// =============================================================================
// MODULE 4: stool_seat()
// -----------------------------------------------------------------------------
// A single round flat wooden seat disc ($fn = 12 for clean low-poly MLO budget).
// Centered in X and Y at [0, 0], elevation Z = STOOL_HEIGHT - STOOL_SEAT_THICKNESS.
// =============================================================================
module stool_seat() {
    color("#C88A4B") // Light amber / varnished teak wood
    translate([0, 0, STOOL_HEIGHT - STOOL_SEAT_THICKNESS])
        cylinder(r = STOOL_SEAT_RADIUS, h = STOOL_SEAT_THICKNESS, $fn = STOOL_FN);
}


// =============================================================================
// MODULE 5: stool_leg()
// -----------------------------------------------------------------------------
// A single thin square timber leg modeled at its own local origin:
//   - Centered in X and Y ([-STOOL_LEG_SIZE/2 .. +STOOL_LEG_SIZE/2]).
//   - Extruded along Z from 0 to STOOL_LEG_LEN.
// Instanced 4 times underneath the seat disc in a splayed 4-way pattern.
// =============================================================================
module stool_leg() {
    color("#8B5A2B") // Solid timber leg
    translate([-STOOL_LEG_SIZE / 2, -STOOL_LEG_SIZE / 2, 0])
        cube([STOOL_LEG_SIZE, STOOL_LEG_SIZE, STOOL_LEG_LEN]);
}


// =============================================================================
// MODULE 6: stool()
// -----------------------------------------------------------------------------
// One complete assembled stool:
//   - Round seat disc at top.
//   - 4 splayed legs instanced underneath at 90-degree radial intervals
//     (45, 135, 225, 315 deg) tilted outward by STOOL_LEG_SPLAY_ANGLE (3.5 deg).
//   - The bottoms of the legs touch the ground plane flush at Z = 0.
//
// Arguments:
//   index     : 0, 1, or 2 (selects position from STOOL_POSITIONS array)
//   world_pos : if true (default), placed at STOOL_POSITIONS[index] on the porch;
//               if false, placed centered at the local origin [0, 0, 0].
// =============================================================================
module stool(index = 0, world_pos = true) {
    pos = world_pos ? STOOL_POSITIONS[index] : [0, 0];

    translate([pos[0], pos[1], 0]) {
        // 1. Stool Round Seat Disc
        stool_seat();

        // 2. 4 Splayed Timber Legs
        for (a = [45, 135, 225, 315]) {
            rotate([0, 0, a])
            translate([STOOL_LEG_RADIUS_TOP, 0, STOOL_LEG_H])
            rotate([0, -STOOL_LEG_SPLAY_ANGLE, 0])
            translate([0, 0, -STOOL_LEG_LEN])
                stool_leg();
        }
    }
}


// =============================================================================
// MODULE 7: assemble()
// -----------------------------------------------------------------------------
// Full exterior furniture preview assembly showing the bench and all 3 stools
// placed at their authentic porch coordinates directly on top of the base slab.
// (Visual verification only — individual parts export from their own part files).
// =============================================================================
module assemble() {
    // 1. Long Porch Bench (left side under pergola)
    bench(world_pos = true);

    // 2. Three Clustered Stools in front of the counter service window
    // Stool 1 (Front-Left):
    stool(index = 0, world_pos = true);

    // Stool 2 (Back-Mid / Counter-adjacent):
    stool(index = 1, world_pos = true);

    // Stool 3 (Front-Right / Entrance-adjacent):
    stool(index = 2, world_pos = true);
}

// NOTE: No top-level geometry calls (e.g. assemble()) here to ensure
// clean inclusion in standalone part export files!

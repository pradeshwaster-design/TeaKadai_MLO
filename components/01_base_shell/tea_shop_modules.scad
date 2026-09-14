// =============================================================================
// Tea Shop — MODULE LIBRARY (Base & Shell)
// -----------------------------------------------------------------------------
// This file only DEFINES the parts (and the assemble() preview). It instantiates
// NO geometry on its own, so it can be include'd by the individual export files
// (part_*.scad) and by tea_shop_assemble.scad without producing duplicates.
//
// GLOBAL COORDINATE SYSTEM (shared by every piece — no per-part centering):
//   +X -> left -> right  (building WIDTH along X, left wall at X=0)
//   +Y -> front -> back  (building DEPTH along Y, front eave at Y=0)
//   +Z -> up             (ground/porch surface = Z=0)
//
//   Building footprint = [0..building_width] x [0..building_depth].
//   Roof = single-pitch lean-to: TALL at BACK (Y=depth), SHORT at FRONT (Y=0).
// =============================================================================

include <tea_shop_parameters.scad>;


// -----------------------------------------------------------------------------
// _trapezoid_prism — shared core for the two side walls. It draws the side
// elevation (depth x height) as a 2D polygon, then linear_extrude +
// rotate([0,-90,0]) stand it up so its thickness runs along X. The front edge
// (Y=0) is the short eave height and the back edge (Y=depth) is the full back
// height, so the top edge automatically matches the roof pitch. Result
// occupies X = [0 .. wall_thickness].
// -----------------------------------------------------------------------------
module _trapezoid_prism() {
    translate([wall_thickness, 0, 0])
        rotate([0, -90, 0])
            linear_extrude(height = wall_thickness)
                polygon(points = [
                    [0,                 0],               // front, ground
                    [0,                 building_depth],  // back,  ground
                    [back_height,       building_depth],  // back,  top (tall)
                    [front_eave_height, 0]                // front, top (eave)
                ]);
}


// =============================================================================
// base_slab — flat ground plinth. Extends past the building on all sides, with
// a generous margin up front to form the porch/patio where the bench / stools
// sit under the pergola. Top surface is the datum Z=0.
// =============================================================================
module base_slab() {
    translate([-base_side_margin, -base_front_margin, -base_thickness])
        cube([
            building_width + 2 * base_side_margin,                 // X
            building_depth + base_front_margin + base_back_margin, // Y
            base_thickness                                          // Z
        ]);
}


// =============================================================================
// back_wall — solid rectangular panel, full building width and FULL height
// (the tall side of the lean-to). Sits at the back edge of the footprint.
// =============================================================================
module back_wall() {
    translate([0, building_depth - wall_thickness, 0])
        cube([building_width, wall_thickness, back_height]);
}


// =============================================================================
// left_side_wall — trapezoidal panel, TALL at the back edge and SHORT at the
// front edge, matching the roof slope. Occupies X = [0 .. wall_thickness].
// =============================================================================
module left_side_wall() {
    _trapezoid_prism();
}


// =============================================================================
// right_side_wall — mirror image of the left wall (identical trapezoid cross
// section, since both walls slope down toward the FRONT eave), placed at the
// right edge X = [building_width - wall_thickness .. building_width].
// Plain — no openings.
// =============================================================================
module right_side_wall() {
    translate([building_width - wall_thickness, 0, 0])
        _trapezoid_prism();
}


// =============================================================================
// FRONT WALL — broken into solid piers + a knee-wall (sill), leaving a service
// window opening and a door opening. Every front piece tops out at the front
// eave height (the horizontal line where the roof meets the front wall).
//
//   |<- left ->|<--- window --->|<- mid ->|<-- door -->|<- right ->|
//   |   pier   |    (opening)   |   pier  |  (opening)  |   pier   |
//   |          |   [sill below] |         |             |          |
// =============================================================================

// front_wall_left_pier — solid pier left of the service window, ground to eave.
module front_wall_left_pier() {
    translate([0, 0, 0])
        cube([left_pier_width, wall_thickness, front_eave_height]);
}


// front_wall_sill — the low knee-wall beneath the service window opening.
// The window opening sits above it.
// TODO: counter + window frame modules slot in above this sill (later group).
module front_wall_sill() {
    translate([window_left, 0, 0])
        cube([window_width, wall_thickness, sill_height]);
}


// front_wall_mid_pier — solid pier between the window and the door, full height.
module front_wall_mid_pier() {
    translate([window_right, 0, 0])
        cube([mid_pier_width, wall_thickness, front_eave_height]);
}


// front_wall_right_pier — solid pier right of the door, out to the front corner.
// Width is derived so the pier chain always ends flush with the right corner.
module front_wall_right_pier() {
    translate([door_right, 0, 0])
        cube([right_pier_width, wall_thickness, front_eave_height]);
}


// -----------------------------------------------------------------------------
// OPENING ANNOTATIONS (for reference — these are EMPTY volumes in the shell):
//
//   Service window opening:
//     X = [window_left .. window_right], Z = [sill_height .. front_eave_height]
//     TODO: window frame + service counter modules slot in here (later group).
//
//   Door opening:
//     X = [door_left .. door_right], Z = [0 .. front_eave_height] (full height)
//     TODO: door / door-frame module slots in here (later group).
// -----------------------------------------------------------------------------


// =============================================================================
// assemble — visual verification ONLY (not for export). Shows every piece in
// the shared coordinate system, each in its own colour, so the assembled shell
// can be checked against the reference before exporting individual STLs.
// =============================================================================
module assemble() {
    color("LightGray")  base_slab();

    color("SkyBlue")    back_wall();
    color("Orange")     left_side_wall();
    color("Orange")     right_side_wall();

    color("FireBrick")  front_wall_left_pier();
    color("Peru")       front_wall_sill();
    color("FireBrick")  front_wall_mid_pier();
    color("FireBrick")  front_wall_right_pier();
}
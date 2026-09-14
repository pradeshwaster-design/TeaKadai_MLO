// =============================================================================
// Tea Shop — GROUP 2: ROOF MODULE LIBRARY
// -----------------------------------------------------------------------------
// This file DEFINES all roof parts (and visual assemble() preview).
// It creates NO geometry on its own when included, allowing individual
// export parts (part_*.scad) and the assembly file to include it cleanly.
//
// SHARED GLOBAL COORDINATE SYSTEM:
//   +X -> left -> right  (0 = left wall outer face, BUILD_W = right wall)
//   +Y -> front -> back  (0 = front eave wall face, BUILD_D = back wall)
//   +Z -> up             (0 = plinth / porch floor datum)
//
// All parts are positioned in place so exported STLs align without manual transforms.
//
// TODO: The wooden pergola structure (posts, crossbeams, longitudinal purlins,
//       flat roof slats, and signboard brackets) is a separate upcoming group
//       and will attach along the front eave edge (Y = -ROOF_OVERHANG_FRONT to 0)
//       extending forward over the porch slab (-base_front_margin .. 0).
// =============================================================================

include <tea_shop_roof_parameters.scad>;

// -----------------------------------------------------------------------------
// _roof_transform — internal transformation helper.
// Translates to the lowest front-left corner of the roof slab bottom face
// (X = -ROOF_OVERHANG_LEFT, Y = -ROOF_OVERHANG_FRONT, Z = ROOF_ORIGIN_Z)
// and rotates around the X-axis by ROOF_ANGLE (pitch angle).
//
// In the child coordinate system:
//   local X : across roof width [0 .. ROOF_WIDTH]
//   local Y : along roof slope UP from front eave to back [0 .. ROOF_SLOPE_LEN]
//   local Z : normal (perpendicular) to the roof plane, pointing up [0 .. thickness]
// -----------------------------------------------------------------------------
module _roof_transform() {
    translate([ROOF_ORIGIN_X, ROOF_ORIGIN_Y, ROOF_ORIGIN_Z])
        rotate([ROOF_ANGLE, 0, 0])
            children();
}


// =============================================================================
// 1. roof_slab — the structural roof substrate.
// A flat slanted slab resting directly on top of the front, back, and side walls.
// Overhangs the building on left, right, and back, and projects forward past
// the front eave to shelter the front wall and meet the pergola frame.
// =============================================================================
module roof_slab() {
    _roof_transform()
        cube([ROOF_WIDTH, ROOF_SLOPE_LEN, ROOF_THICKNESS]);
}


// =============================================================================
// 2. ridge_cap_or_top_trim — raised cap strip along the high back edge.
// As confirmed in the wireframe (countryside-tea-shop-3d-model-9cc7378ff7.webp)
// and clay render (countryside-tea-shop-3d-model-4b97af2b49.webp), this is a
// raised half-round/chamfered capping strip running along the very top edge of
// the roof where it meets the tall back wall, sealing the tile ends against weather.
// =============================================================================
module _ridge_cap_profile_2d() {
    polygon(points = [
        [-RIDGE_CAP_WIDTH/2, 0],
        [-RIDGE_CAP_WIDTH*0.4, RIDGE_CAP_HEIGHT*0.7],
        [-RIDGE_CAP_WIDTH*0.2, RIDGE_CAP_HEIGHT*0.95],
        [ 0,                   RIDGE_CAP_HEIGHT],
        [ RIDGE_CAP_WIDTH*0.2, RIDGE_CAP_HEIGHT*0.95],
        [ RIDGE_CAP_WIDTH*0.4, RIDGE_CAP_HEIGHT*0.7],
        [ RIDGE_CAP_WIDTH/2, 0]
    ]);
}

module ridge_cap_or_top_trim() {
    _roof_transform() {
        translate([-FASCIA_THICKNESS, ROOF_SLOPE_LEN - RIDGE_CAP_WIDTH/2, ROOF_THICKNESS + TILE_HEIGHT])
            rotate([0, 90, 0])
                linear_extrude(height = ROOF_WIDTH + 2 * FASCIA_THICKNESS)
                    _ridge_cap_profile_2d();
    }
}


// =============================================================================
// 3. eave_fascia_left and eave_fascia_right — wooden trim boards running along
// the left and right sloped edges (rakes/verges) of the roof slab.
// Visible in textured renders as the dark timber strips along the outer roof edges.
// Covers both the slab edge and tile profile, extending slightly below the slab.
// =============================================================================
module eave_fascia_left() {
    _roof_transform() {
        translate([-FASCIA_THICKNESS, 0, -(FASCIA_WIDTH - ROOF_THICKNESS)/2])
            cube([FASCIA_THICKNESS, ROOF_SLOPE_LEN, FASCIA_WIDTH]);
    }
}

module eave_fascia_right() {
    _roof_transform() {
        translate([ROOF_WIDTH, 0, -(FASCIA_WIDTH - ROOF_THICKNESS)/2])
            cube([FASCIA_THICKNESS, ROOF_SLOPE_LEN, FASCIA_WIDTH]);
    }
}


// =============================================================================
// 4. eave_fascia_front — horizontal trim board running across the low front
// eave of the roof slab, immediately above where the pergola structure connects.
// =============================================================================
module eave_fascia_front() {
    _roof_transform() {
        translate([-FASCIA_THICKNESS, -FASCIA_THICKNESS, -(FASCIA_WIDTH - ROOF_THICKNESS)/2])
            cube([ROOF_WIDTH + 2 * FASCIA_THICKNESS, FASCIA_THICKNESS, FASCIA_WIDTH]);
    }
}


// =============================================================================
// 5. roof_tile_pattern — shallow repeating bump/ridge pattern on the top face
// of roof_slab(), representing the terracotta barrel tiles visible in the renders.
// Modeled as real geometry using lightweight 2D extruded curved crests running
// down the slope direction (local Y) and repeated along local X with a for loop.
// Parametric spacing (TILE_PITCH) and bump size (TILE_WIDTH, TILE_HEIGHT) allow
// tuning print resolution and file size.
// =============================================================================
module _tile_crest_2d() {
    polygon(points = [
        [-TILE_WIDTH * 0.50, 0],
        [-TILE_WIDTH * 0.42, TILE_HEIGHT * 0.50],
        [-TILE_WIDTH * 0.28, TILE_HEIGHT * 0.85],
        [0,                  TILE_HEIGHT],
        [ TILE_WIDTH * 0.28, TILE_HEIGHT * 0.85],
        [ TILE_WIDTH * 0.42, TILE_HEIGHT * 0.50],
        [ TILE_WIDTH * 0.50, 0]
    ]);
}

module roof_tile_pattern() {
    _roof_transform() {
        rotate([90, 0, 0])
        translate([0, ROOF_THICKNESS, -ROOF_SLOPE_LEN])
        linear_extrude(height = ROOF_SLOPE_LEN) {
            for (x = [TILE_PITCH/2 : TILE_PITCH : ROOF_WIDTH - TILE_PITCH/2]) {
                translate([x, 0, 0])
                    _tile_crest_2d();
            }
        }
    }
}


// =============================================================================
// assemble — visual verification assembly for Group 2 pieces (not for export).
// Displays each module in a distinct contrasting color.
// =============================================================================
module assemble() {
    color("Tan")          roof_slab();
    color("Chocolate")    roof_tile_pattern();
    color("DarkRed")      ridge_cap_or_top_trim();
    color("SaddleBrown")  eave_fascia_left();
    color("SaddleBrown")  eave_fascia_right();
    color("SaddleBrown")  eave_fascia_front();
}

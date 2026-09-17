// =============================================================================
// Tea Shop — GROUP 4: COUNTER / SERVICE WINDOW
// =============================================================================
// All units: mm (1000 mm = 1.0 m), real-life scale.
// GTA V uses metres: 1000 OpenSCAD units = 1 GTA unit.
//
// SHARED GLOBAL COORDINATE SYSTEM (identical to Groups 1–3):
//   +X -> left -> right  (0 = left outer wall face, BUILD_W = right outer wall)
//   +Y -> front -> back  (0 = front eave wall face, BUILD_D = back wall)
//   +Z -> up             (0 = ground / plinth top datum)
//
// This group fills the window opening left empty in Group 1's front wall.
// The window opening in Group 1 spans:
//   X: [window_left .. window_right] = [600 .. 4000]  (width = 3400 mm)
//   Z: [sill_height .. front_eave_height] = [900 .. 2400]  (height = 1500 mm)
//   Y: the wall occupies [0 .. wall_thickness] = [0 .. 250]
//
// REFERENCE ANALYSIS (from attached PDF / reference images):
//
// 1. WINDOW FRAME — Front elevation (9b1fed6bc4, d9d4619809) clearly shows
//    a teal/blue-painted frame surrounding the service window opening. The
//    frame consists of 4 bars:
//      - Top header bar across the top of the opening
//      - Bottom sill trim bar across the bottom (sitting on top of the sill wall)
//      - Left vertical jamb bar
//      - Right vertical jamb bar
//    MULLIONS: The front elevation and wireframe images both show a single
//    uninterrupted clear span with NO vertical mullion dividers. The opening
//    is one large service hatch. Mullion module is therefore OMITTED.
//
// 2. COUNTER LEDGE — The wireframe interior shot (8ffafd36e4) and clay render
//    (4b97af2b49) show a flat counter slab sitting ON TOP of the sill wall,
//    extending ~800 mm inward (toward the back wall) into the interior. Tea
//    items (stove, teapot, glasses) rest on this surface. The ledge appears
//    to be a separate raised slab sitting on top of the front_wall_sill from
//    Group 1, NOT flush with the sill's top face — it has visible thickness.
//    The ledge also overhangs slightly forward (~50 mm) past the outer wall
//    face for the exterior "counter" service lip where customers are served.
//
// 3. COUNTER SUPPORT LEGS — The wireframe interior shot (8ffafd36e4) shows
//    two small rectangular support legs/blocks under the counter ledge on the
//    interior side, near the left and right ends of the counter span, where
//    the ledge cantilevers past the sill wall into the room.
//
// UV UNWRAPPING PRIORITY (for Blender/GTA V MLO workflow):
//   HIGH PRIORITY (visible, textured):
//     - Frame bars: the front-facing painted surfaces (exterior face toward -Y)
//     - Counter ledge: the top surface (items sit here, visible through window)
//     - Counter ledge: the front edge (visible to customers outside)
//   LOW PRIORITY (hidden/interior, can use simple flat color):
//     - Frame bars: back faces (hidden against wall)
//     - Counter ledge: bottom face (hidden, under the slab)
//     - Support legs: mostly hidden under the counter
//
// TODO: The counter-top tea service props (stove, kettle, glasses, jars,
//       bread packets — a later group) sit on top of counter_ledge().
// TODO: The "TEA PRICE LIST" sign (a later group) mounts on the exterior
//       wall face just below/beside this window, at approximately
//       X = 600..1200, Z = 400..850 (visible in reference 9b1fed6bc4).
// TODO: The small framed picture/poster visible on the interior back wall
//       above the counter (visible in wireframe 8ffafd36e4) is a later group.
// =============================================================================


// =============================================================================
// 1. SHARED GLOBAL VARIABLES (from Groups 1–3 — identical values, not changed)
// =============================================================================
WALL_T  = 250;   // wall panel thickness                      (0.25 m)
BUILD_W = 6000;  // building width along X                    (6.00 m)
BUILD_D = 4000;  // building depth along Y                    (4.00 m)
BACK_H  = 3200;  // wall height at BACK (tall lean-to side)   (3.20 m)
FRONT_H = 2400;  // wall height at FRONT eave (short side)    (2.40 m)

wall_thickness    = WALL_T;
building_width    = BUILD_W;
building_depth    = BUILD_D;
back_height       = BACK_H;
front_eave_height = FRONT_H;

// Group 1 front wall opening dimensions:
left_pier_width   = 600;
window_width      = 3400;
mid_pier_width    = 500;
door_width        = 1000;
sill_height       = 900;

// Derived from Group 1 (identical to tea_shop_parameters.scad):
window_left       = left_pier_width;                    // 600 mm
window_right      = window_left + window_width;         // 4000 mm
door_left         = window_right + mid_pier_width;      // 4500 mm
door_right        = door_left + door_width;             // 5500 mm
window_open_height = front_eave_height - sill_height;   // 1500 mm


// =============================================================================
// 2. GROUP 4 PARAMETERS — Window Frame & Counter Dimensions
// =============================================================================

// --- Window Frame Bars -------------------------------------------------------
// REFERENCE NOTE: The teal/blue frame in the front elevation (9b1fed6bc4)
// appears to be roughly 60-80 mm wide painted timber/steel bar, with a
// depth (thickness into the wall) of about 40-50 mm. The frame sits on
// the EXTERIOR face of the wall (Y < wall_thickness), flush with or
// slightly proud of the wall surface.
//
// [ESTIMATE NOTE]: Bar width and depth estimated from proportional analysis
// of the front elevation — the frame bars are roughly 1/20th of the window
// opening height (1500/20 ≈ 75 mm) and appear as a thin painted strip.
FRAME_BAR_WIDTH   = 70;    // visible width of the frame bar (mm)         (0.07 m)
FRAME_BAR_DEPTH   = 40;    // thickness of frame bar into the wall (mm)   (0.04 m)

// Frame placement: the frame sits on the exterior wall face. The wall outer
// face is at Y = 0. The frame bar centre-line aligns with the wall face,
// so the frame protrudes slightly forward of the wall (by half its depth)
// and slightly inward. This creates the visible painted border seen in the
// reference without z-fighting against the wall geometry.
FRAME_Y_OFFSET    = -5;    // frame starts 5 mm forward of wall face (avoids z-fight)

// Frame fit logic:
// The header and sill trim bars span the FULL window opening width (WIN_W)
// plus overlap onto the pier edges by FRAME_BAR_WIDTH on each side, so
// the frame visually "wraps" the opening. The jambs run vertically between
// the header and sill trim, sitting inside the horizontal bars.
// This means:
//   Header/Sill X span:  [window_left - FRAME_BAR_WIDTH .. window_right + FRAME_BAR_WIDTH]
//   Header/Sill total W: window_width + 2 * FRAME_BAR_WIDTH
//   Jamb X:              left jamb at [window_left - FRAME_BAR_WIDTH .. window_left]
//                        right jamb at [window_right .. window_right + FRAME_BAR_WIDTH]
//   Jamb Z span:         [sill_height .. sill_height + window_open_height]
//                        (between the sill trim top and header bottom)

// --- Counter Ledge -----------------------------------------------------------
// REFERENCE NOTE: The wireframe interior (8ffafd36e4) shows the counter slab
// extending approximately 800 mm back from the front wall into the interior.
// The clay render (4b97af2b49) confirms a flat work surface at sill height
// with tea-making items arranged on it.
//
// [ESTIMATE NOTE]: Counter depth estimated from interior wireframe proportions.
// The ledge appears to span roughly 20-25% of the building depth (4000 mm),
// so ~800-1000 mm. Using 800 mm as a conservative estimate.
COUNTER_DEPTH     = 800;   // how far the counter extends inward (Y dir)  (0.80 m)
COUNTER_THICKNESS = 40;    // slab thickness of the counter top           (0.04 m)
COUNTER_OVERHANG  = 50;    // how far the counter lip overhangs forward   (0.05 m)
                           // past the outer wall face (customers lean here)

// The counter ledge spans the same X range as the window opening:
COUNTER_X_START   = window_left;   // 600 mm (same as window start)
COUNTER_X_END     = window_right;  // 4000 mm (same as window end)
COUNTER_WIDTH     = COUNTER_X_END - COUNTER_X_START;  // 3400 mm

// Counter Z position: the ledge sits ON TOP of the front_wall_sill
// (which occupies Z = [0 .. sill_height]). The ledge's bottom face
// sits at Z = sill_height (flush on the sill top), and the counter
// top surface is at Z = sill_height + COUNTER_THICKNESS.
COUNTER_Z         = sill_height;   // 900 mm

// --- Counter Support Legs ----------------------------------------------------
// REFERENCE NOTE: The wireframe interior shot (8ffafd36e4) shows two small
// rectangular blocks/legs supporting the cantilevered portion of the counter
// ledge on the interior side. They appear near the left and right ends of
// the counter, standing on the floor (Z=0) up to the underside of the ledge.
//
// [ESTIMATE NOTE]: Leg cross-section estimated at ~80x80 mm (small timber
// posts), and they appear to be inset ~200 mm from each end of the counter.
LEG_WIDTH         = 80;    // leg cross-section along X                   (0.08 m)
LEG_DEPTH         = 80;    // leg cross-section along Y                   (0.08 m)
LEG_HEIGHT        = sill_height;  // legs run from floor to sill height   (0.90 m)

// Leg positions (X coordinate of leg centre):
// Inset ~200 mm from each end of the counter span
LEG_INSET         = 200;   // how far each leg is inset from counter edge (mm)
LEG_LEFT_X        = COUNTER_X_START + LEG_INSET;   // 600 + 200 = 800 mm
LEG_RIGHT_X       = COUNTER_X_END - LEG_INSET;     // 4000 - 200 = 3800 mm

// Leg Y position: the legs sit at the BACK edge of the counter ledge,
// supporting the cantilevered portion farthest from the front wall.
// Back edge of counter = wall_thickness + COUNTER_DEPTH
LEG_Y             = wall_thickness + COUNTER_DEPTH - LEG_DEPTH;  // interior side


// =============================================================================
// MODULE 1a: window_header()
// -----------------------------------------------------------------------------
// Top horizontal bar of the window frame. Sits across the top edge of the
// window opening at Z = sill_height + window_open_height = front_eave_height.
// Spans the full opening width plus overlap onto both piers.
//
// Position derivation:
//   X: window_left - FRAME_BAR_WIDTH  (overlaps onto left pier by one bar width)
//   Y: FRAME_Y_OFFSET (slightly forward of wall face to avoid z-fighting)
//   Z: front_eave_height - FRAME_BAR_WIDTH  (bar hangs down from eave line)
//       to front_eave_height (top flush with eave line)
// =============================================================================
module window_header() {
    translate([
        window_left - FRAME_BAR_WIDTH,            // X: start overlapping left pier
        FRAME_Y_OFFSET,                            // Y: slightly proud of wall face
        front_eave_height - FRAME_BAR_WIDTH        // Z: hangs down from eave line
    ])
        cube([
            window_width + 2 * FRAME_BAR_WIDTH,   // X span: full opening + overlap
            FRAME_BAR_DEPTH,                        // Y: bar thickness into wall
            FRAME_BAR_WIDTH                         // Z: bar height
        ]);
}


// =============================================================================
// MODULE 1b: window_sill_trim()
// -----------------------------------------------------------------------------
// Bottom horizontal bar of the window frame. Sits across the bottom edge of
// the window opening at Z = sill_height.
// Spans the full opening width plus overlap onto both piers.
//
// Position derivation:
//   X: same as header
//   Y: FRAME_Y_OFFSET
//   Z: sill_height  (sits on top of the sill wall's top face)
// =============================================================================
module window_sill_trim() {
    translate([
        window_left - FRAME_BAR_WIDTH,
        FRAME_Y_OFFSET,
        sill_height
    ])
        cube([
            window_width + 2 * FRAME_BAR_WIDTH,
            FRAME_BAR_DEPTH,
            FRAME_BAR_WIDTH
        ]);
}


// =============================================================================
// MODULE 1c: window_jamb_left()
// -----------------------------------------------------------------------------
// Left vertical bar of the window frame. Runs along the left edge of the
// window opening (at X = window_left).
//
// Position derivation:
//   X: window_left - FRAME_BAR_WIDTH  (sits on the pier side of the opening edge)
//   Y: FRAME_Y_OFFSET
//   Z: sill_height  (starts at sill top, runs up to eave)
//   Height: window_open_height (fills the full opening vertically)
// =============================================================================
module window_jamb_left() {
    translate([
        window_left - FRAME_BAR_WIDTH,
        FRAME_Y_OFFSET,
        sill_height
    ])
        cube([
            FRAME_BAR_WIDTH,
            FRAME_BAR_DEPTH,
            window_open_height
        ]);
}


// =============================================================================
// MODULE 1d: window_jamb_right()
// -----------------------------------------------------------------------------
// Right vertical bar of the window frame. Runs along the right edge of the
// window opening (at X = window_right).
//
// Position derivation:
//   X: window_right  (flush with the right side of the opening)
//   Y: FRAME_Y_OFFSET
//   Z: sill_height
//   Height: window_open_height
// =============================================================================
module window_jamb_right() {
    translate([
        window_right,
        FRAME_Y_OFFSET,
        sill_height
    ])
        cube([
            FRAME_BAR_WIDTH,
            FRAME_BAR_DEPTH,
            window_open_height
        ]);
}


// =============================================================================
// MODULE 1: window_frame()
// -----------------------------------------------------------------------------
// Combines all 4 frame sub-pieces into one composite module for convenience.
// Each sub-piece remains independently callable for separate OBJ export.
//
// MULLION NOTE: The reference front elevation (9b1fed6bc4) and wireframe
// (9cc7378ff7) both show the service window as a SINGLE uninterrupted
// opening — there are NO vertical mullion bars dividing the span into
// panes. The window_mullion() module is therefore intentionally omitted.
// If a mullion is later needed (e.g. for a variant), add a vertical bar
// at the midpoint: translate([window_left + window_width/2 - FRAME_BAR_WIDTH/2, ...]).
// =============================================================================
module window_frame() {
    window_header();
    window_sill_trim();
    window_jamb_left();
    window_jamb_right();
}


// =============================================================================
// MODULE 2: counter_ledge()
// -----------------------------------------------------------------------------
// The flat interior counter slab/table that sits at sill height, extending
// inward (toward the back wall) into the building interior. This is the
// work surface where tea items (stove, teapot, glasses, jars) rest.
//
// REFERENCE CHECK: The counter is a SEPARATE raised slab sitting ON TOP of
// the front_wall_sill from Group 1. In the wireframe (8ffafd36e4) you can
// see a clear horizontal line at counter level that is distinct from and
// slightly above the sill wall top face. The counter also overhangs slightly
// forward past the outer wall face, creating a service lip for customers.
//
// Position derivation:
//   X: window_left (600 mm) to window_right (4000 mm) — same as window span
//   Y: -COUNTER_OVERHANG (extends 50 mm forward of wall outer face)
//      to wall_thickness + COUNTER_DEPTH (extends 800 mm past inner wall face)
//   Z: sill_height (900 mm) — bottom face sits on top of the sill wall
//   Thickness: COUNTER_THICKNESS (40 mm) — top surface at Z = 940 mm
//
// TODO: Counter-top tea service props (stove, kettle, glasses, jars,
//       bread packets) sit on top of this surface (Z = sill_height +
//       COUNTER_THICKNESS = 940 mm). These are a later component group.
// =============================================================================
module counter_ledge() {
    translate([
        COUNTER_X_START,                           // X: left edge of window
        -COUNTER_OVERHANG,                         // Y: overhangs forward past wall
        COUNTER_Z                                   // Z: sits on sill top
    ])
        cube([
            COUNTER_WIDTH,                          // X: 3400 mm
            COUNTER_OVERHANG + wall_thickness + COUNTER_DEPTH,  // Y: total depth
            COUNTER_THICKNESS                       // Z: 40 mm thick
        ]);
}


// =============================================================================
// MODULE 3: counter_support_leg()
// -----------------------------------------------------------------------------
// A single rectangular support leg/block that stands under the counter ledge
// on the interior side, supporting the cantilevered portion of the counter
// that extends past the front wall into the room.
//
// Modeled at the specified [x, y] position, standing from Z=0 to Z=sill_height.
// Instanced twice in assemble(): once at LEG_LEFT_X, once at LEG_RIGHT_X.
//
// REFERENCE CHECK: The wireframe interior shot (8ffafd36e4) clearly shows
// rectangular blocks under the counter near the left and right ends. They
// appear to be simple timber posts (~80x80 mm cross-section).
//
// [ESTIMATE NOTE]: Leg positions (200 mm inset from each end of the counter
// span) are estimated — the wireframe doesn't give exact pixel positions,
// but the legs are clearly near the extremes of the counter, not centred.
// =============================================================================
module counter_support_leg(x_pos) {
    translate([
        x_pos - LEG_WIDTH / 2,                    // X: centred on x_pos
        LEG_Y,                                     // Y: at back edge of counter
        0                                           // Z: floor
    ])
        cube([
            LEG_WIDTH,                              // X: 80 mm
            LEG_DEPTH,                              // Y: 80 mm
            LEG_HEIGHT                              // Z: floor to sill (900 mm)
        ]);
}


// =============================================================================
// assemble() — Visual verification preview for Group 4 only (not for export).
// Shows all counter/window pieces together in distinct colors.
// Frame bars are teal/blue to match the reference paint color.
// =============================================================================
module assemble() {
    // --- Window frame (teal/blue as in reference paint) ----------------------
    color("Teal") {
        window_header();
        window_sill_trim();
        window_jamb_left();
        window_jamb_right();
    }

    // --- Counter ledge (wood tone — visible work surface) --------------------
    color("Peru")
        counter_ledge();

    // --- Counter support legs (2 instances, darker wood) ---------------------
    color("SaddleBrown") {
        counter_support_leg(LEG_LEFT_X);
        counter_support_leg(LEG_RIGHT_X);
    }
}

// Default preview invocation:
assemble();

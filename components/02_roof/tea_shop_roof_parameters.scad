// =============================================================================
// Tea Shop — GROUP 2: ROOF PARAMETERS
// -----------------------------------------------------------------------------
// OpenSCAD native unit: 1 mm (1000 mm = 1.0 m). Real-life scale.
// Reuses Group 1 (Base & Shell) dimensions and shared global coordinate system:
//   +X -> left -> right  (building width along X, left wall at X = 0)
//   +Y -> front -> back  (building depth along Y, front eave at Y = 0)
//   +Z -> up             (ground / plinth datum = Z = 0)
// =============================================================================

// --- SHARED GLOBAL VARIABLES FROM GROUP 1 (identical values) -----------------
WALL_T             = 250;   // wall panel thickness                      (0.25 m)
BUILD_W            = 6000;  // building width along X, left -> right      (6.00 m)
BUILD_D            = 4000;  // building depth along Y, front eave -> back (4.00 m)
BACK_H             = 3200;  // full wall height at the BACK (tall side)   (3.20 m)
FRONT_H            = 2400;  // wall height at the FRONT eave (short side) (2.40 m)

// Aliases matching Group 1's tea_shop_parameters.scad naming convention
wall_thickness     = WALL_T;
building_width     = BUILD_W;
building_depth     = BUILD_D;
back_height        = BACK_H;
front_eave_height  = FRONT_H;

// --- GROUP 2: ROOF SLAB & OVERHANG PARAMETERS --------------------------------
ROOF_THICKNESS      = 50;   // structural substrate slab thickness       (0.05 m)
ROOF_OVERHANG_LEFT  = 150;  // overhang beyond outer face of left wall    (0.15 m)
ROOF_OVERHANG_RIGHT = 150;  // overhang beyond outer face of right wall   (0.15 m)
ROOF_OVERHANG_BACK  = 150;  // overhang beyond outer face of back wall    (0.15 m)
ROOF_OVERHANG_FRONT = 250;  // overhang forward past front eave wall      (0.25 m)
                            // (Estimated: in reference images, the tiled roof
                            //  terminates ~250mm past the front wall where the
                            //  pergola rafters tie in. Tune here if desired.)

// --- FASCIA / BARGEBOARD TRIM PARAMETERS ------------------------------------
FASCIA_THICKNESS    = 30;   // board thickness (along X for sides, Y for front)
FASCIA_WIDTH        = 100;  // board face height (normal to roof plane)

// --- TOP RIDGE CAPPING STRIP PARAMETERS -------------------------------------
// (Raised capping strip running along the highest back edge where roof meets
//  back wall, visible in wireframe and clay renders to seal top tile ends)
RIDGE_CAP_WIDTH     = 100;  // width / run of capping strip along slope   (0.10 m)
RIDGE_CAP_HEIGHT    = 35;   // raised bump height of capping strip        (0.035 m)

// --- TERRACOTTA ROOF TILE GEOMETRY PARAMETERS -------------------------------
// Shallow repeating barrel / curved ridges running down the slope direction
TILE_PITCH          = 175;  // center-to-center spacing along X between tile crests
TILE_WIDTH          = 120;  // width of each individual curved tile crest
TILE_HEIGHT         = 25;   // raised crest height of tile bump above slab
TILE_FN             = 16;   // polygon facets for lightweight STL export

// =============================================================================
// MATHEMATICAL SLOPE DERIVATION (Trig / Geometry)
// -----------------------------------------------------------------------------
// The monopitch lean-to roof connects the top of the short front wall (Z=FRONT_H
// at Y=0) to the top of the tall back wall (Z=BACK_H at Y=BUILD_D).
//
//   Vertical Rise : ROOF_RISE  = BACK_H - FRONT_H = 3200 - 2400 = 800 mm
//   Horizontal Run: ROOF_RUN   = BUILD_D = 4000 mm
//   Slope Tangent : tan(theta) = Rise / Run = 800 / 4000 = 0.20
//   Slope Angle   : ROOF_ANGLE = atan(0.20) ≈ 11.30993°
//
// Using the exact trigonometric angle prevents any height drift between the
// walls and the roof.
// =============================================================================
ROOF_RISE           = BACK_H - FRONT_H;
ROOF_RUN            = BUILD_D;
ROOF_ANGLE          = atan(ROOF_RISE / ROOF_RUN);

// Total projected extents:
ROOF_WIDTH          = BUILD_W + ROOF_OVERHANG_LEFT + ROOF_OVERHANG_RIGHT;
ROOF_DEPTH_PROJ     = BUILD_D + ROOF_OVERHANG_FRONT + ROOF_OVERHANG_BACK;

// True length along the sloped roof plane (hypotenuse of total run and rise):
ROOF_SLOPE_LEN      = ROOF_DEPTH_PROJ / cos(ROOF_ANGLE);

// Reference coordinate for the sloped roof frame:
// Origin at the lowest front-left corner of the sloped roof slab bottom face
ROOF_ORIGIN_X       = -ROOF_OVERHANG_LEFT;
ROOF_ORIGIN_Y       = -ROOF_OVERHANG_FRONT;
ROOF_ORIGIN_Z       = FRONT_H - ROOF_OVERHANG_FRONT * tan(ROOF_ANGLE);

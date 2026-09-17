// =============================================================================
// TEA SHOP DIORAMA — GROUP 6: EXTERIOR FURNITURE PARAMETERS
// =============================================================================
// All units: mm (1000 mm = 1.0 m), 1:1 real-world scale (1000 units = 1 GTA unit).
// Shared global coordinate system (identical to Groups 1–5):
//   +X -> left -> right  (0 = left outer wall, BUILD_W = right outer wall)
//   +Y -> front -> back  (0 = front wall eave face, BUILD_D = back wall, porch in -Y)
//   +Z -> up             (0 = top surface of base slab / ground datum)
// =============================================================================

// =============================================================================
// 1. SHARED GLOBAL VARIABLES (Reused from Groups 1–5 — identical values)
// =============================================================================
WALL_T             = 250;   // wall panel thickness                      (0.25 m)
BUILD_W            = 6000;  // building width along X                    (6.00 m)
BUILD_D            = 4000;  // building depth along Y                    (4.00 m)
FRONT_H            = 2400;  // wall height at FRONT eave (short side)    (2.40 m)
WIN_X              = 600;   // left pier width / window start X datum    (0.60 m)
WIN_W              = 3400;  // service window width                      (3.40 m)
SILL_H             = 900;   // knee-wall sill height beneath window      (0.90 m)
BASE_H             = 200;   // base plinth vertical thickness            (0.20 m)
BASE_MARGIN_FRONT  = 3000;  // front porch slab depth (extends to Y=-3m) (3.00 m)

// Aliases for compatibility with earlier group files:
wall_thickness     = WALL_T;
building_width     = BUILD_W;
building_depth     = BUILD_D;
front_eave_height  = FRONT_H;
sill_height        = SILL_H;
base_front_margin  = BASE_MARGIN_FRONT;


// =============================================================================
// 2. GROUP 6 PARAMETERS — BENCH (Long Wooden Porch Bench)
// =============================================================================
// REFERENCE OBSERVATIONS (Images: page 1/2 daylight/night, page 5 clay,
// page 7 front elevation, page 8 wireframe, page 14 eye-level):
//
// 1. Bench Style & Proportions:
//    - Simple utilitarian Indian roadside tea stall wooden bench.
//    - Single flat solid rectangular wooden plank for the seat.
//    - Two leg assemblies (one at each end). Wireframe (page 8) and clay (page 5)
//      confirm each leg pair is NOT a solid A-frame slab, but TWO straight
//      square timber posts tied together under the seat by a horizontal cross
//      apron rail. The posts are vertical (0 deg angle) with inset mounting.
//    - Bench height is roughly half the window sill height:
//      SILL_H = 900 mm -> BENCH_HEIGHT = 460 mm (~18 inches standard seating).
//    - Bench length spans ~1500 mm, comfortably seating 3-4 patrons.
//    - Bench width is ~400 mm (standard 16-inch bench seat).
//
// [ESTIMATED DIMENSIONS NOTE]:
// - Bench top thickness (40 mm) estimated from front elevation pixel ratio
//   (~1/11 of bench height).
// - Leg post cross-section (45x45 mm) estimated from wireframe edge density.
// - Inset of legs from ends (80 mm) and edges (17.5 mm) estimated from clay shot.
// - Bench X position (X = 550 mm) sits under the left pier and left edge of
//   the service window, leaving clear passage to the counter and door.
// - Bench Y position (Y = -1250 mm) sits centrally under the pergola canopy
//   (between wall Y=0 and front post line Y=-2250 mm).
BENCH_LENGTH          = 1500; // bench seat plank length along X (mm)
BENCH_WIDTH           = 400;  // bench seat plank width along Y (mm)
BENCH_HEIGHT          = 460;  // total seat height from ground (Z=0) to top face (mm)
BENCH_TOP_THICKNESS   = 40;   // thickness of seat top plank (mm)

// Bench Leg Pair (2 posts + top cross apron rail per end):
BENCH_LEG_SIZE        = 45;   // square timber leg cross-section (45x45 mm)
BENCH_LEG_ANGLE       = 0;    // leg angle from vertical (0 deg = straight vertical posts)
BENCH_LEG_PAIR_WIDTH  = 320;  // center-to-center span across Y of the 2 end legs (mm)
                              // Outer edge-to-edge span = 320 + 45 = 365 mm
                              // Leaves (400 - 365)/2 = 17.5 mm front/back overhang
BENCH_LEG_INSET_X     = 80;   // inset of leg center from left/right plank ends (mm)
BENCH_APRON_WIDTH     = 30;   // thickness of horizontal cross apron rail along X (mm)
BENCH_APRON_HEIGHT    = 50;   // vertical height of horizontal cross apron rail (mm)

// Bench Porch Placement (World Coordinates):
BENCH_POS_X           = 550;  // left edge X coordinate of bench top (mm)
BENCH_POS_Y           = -1250;// center Y coordinate of bench (mm)
                              // Back edge is at Y = -1050 mm, Front edge at Y = -1450 mm
BENCH_ROT_Z           = 0;    // rotation angle about Z (0 = parallel to front wall)


// =============================================================================
// 3. GROUP 6 PARAMETERS — STOOLS (Round Wooden Porch Stools)
// =============================================================================
// REFERENCE OBSERVATIONS (Images: page 1/2, page 5 clay, page 7 elevation,
// page 8 wireframe, page 13 interior close-up, page 14 eye-level):
//
// 1. Stool Style & Proportions:
//    - Round wooden top seat disc with bevel/slight chamfer, resting on
//      4 splayed square timber legs.
//    - Polycount optimization: 12-sided cylinder ( = 12) provides a clean,
//      authentic round silhouette while keeping polycount low for GTA V MLO props.
//    - Stool height is 450 mm (level with the bench, exactly half the 900mm sill).
//    - Seat diameter is 300 mm (~12 inches), standard for street tea stalls.
//    - Legs splay outward slightly from under the seat disc (angle ~3.5 deg),
//      ensuring stability while remaining inside the seat diameter footprint at the base.
//
// 2. Stool Clustering Layout:
//    - The reference images show 3 stools clustered together directly in front of
//      the counter window (X = 2500..3400 mm), where patrons sit to drink tea.
//    - They are NOT placed on a rigid grid:
//        * Stool 1: [2550, -1550] — front-left of the cluster, closer to walkway
//        * Stool 2: [2850, -1050] — back-mid of the cluster, closer to counter window
//        * Stool 3: [3350, -1400] — front-right of the cluster, near entrance path
//
// [ESTIMATED DIMENSIONS NOTE]:
// - Seat thickness (35 mm) estimated from front elevation and wireframe.
// - Leg cross-section (30x30 mm) estimated from wireframe edge density.
// - Splay angle (3.5 deg) estimated from wireframe slope relative to vertical.
STOOL_HEIGHT          = 450;  // total height to top of stool seat (mm)
STOOL_SEAT_DIA        = 300;  // round seat disc diameter (mm)
STOOL_SEAT_RADIUS     = STOOL_SEAT_DIA / 2; // 150 mm
STOOL_SEAT_THICKNESS  = 35;   // seat disc thickness (mm)

// Stool Leg Dimensions:
STOOL_LEG_SIZE        = 30;   // square timber leg cross-section (30x30 mm)
STOOL_LEG_SPLAY_ANGLE = 3.5;  // outward splay angle from vertical (degrees)
STOOL_LEG_RADIUS_TOP  = 95;   // radial distance of leg center from stool center at top (mm)
                              // Leaves 150 - (95 + 15) = 40 mm seat lip overhang

// Derived stool leg length along its angled axis:
STOOL_LEG_H           = STOOL_HEIGHT - STOOL_SEAT_THICKNESS; // vertical leg span (415 mm)
STOOL_LEG_LEN         = STOOL_LEG_H / cos(STOOL_LEG_SPLAY_ANGLE); // angled length (~415.78 mm)

// Low-poly curvature resolution for MLO optimization:
STOOL_FN              = 12;   // 12-sided polygon for round seat disc (MLO target)

// Stool Positions Array (3 clustered [X, Y] coordinates on the porch):
STOOL_POSITIONS = [
    [2550, -1550],  // Stool 1: Front-Left
    [2850, -1050],  // Stool 2: Back-Mid (near counter)
    [3350, -1400]   // Stool 3: Front-Right (near entrance)
];

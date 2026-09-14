// =============================================================================
// Tea Shop — GROUP 3: PERGOLA PARAMETERS
// -----------------------------------------------------------------------------
// All units: mm (1000 mm = 1.0 m), real-life scale.
// Shared global coordinate system (identical to Groups 1 & 2):
//   +X -> left -> right  (0 = left outer wall face, BUILD_W = right outer wall)
//   +Y -> front -> back  (0 = front eave wall face, BUILD_D = back wall)
//   +Z -> up             (0 = ground / plinth top datum)
//   Porch canopy extends in negative Y (forward, from Y = 0 to Y ≈ -2450 mm).
// =============================================================================

// --- SHARED GLOBAL VARIABLES (from Groups 1 & 2 — identical values) ----------
WALL_T  = 250;   // wall panel thickness                      (0.25 m)
BUILD_W = 6000;  // building width along X                    (6.00 m)
BUILD_D = 4000;  // building depth along Y                    (4.00 m)
BACK_H  = 3200;  // wall height at BACK (tall lean-to side)   (3.20 m)
FRONT_H = 2400;  // wall height at FRONT eave (short side)    (2.40 m)

// Group 1 alias names
wall_thickness    = WALL_T;
building_width    = BUILD_W;
building_depth    = BUILD_D;
back_height       = BACK_H;
front_eave_height = FRONT_H;

// Group 1 front opening & plinth references:
sill_height       = 900;   // knee-wall sill datum where brace foot rests (0.90 m)
base_front_margin = 3000;  // total front porch slab depth               (3.00 m)

// Group 2 roof slope derivation (pergola slope follows this exact angle):
ROOF_RISE  = BACK_H - FRONT_H;  // 800 mm
ROOF_RUN   = BUILD_D;            // 4000 mm
ROOF_ANGLE = atan(ROOF_RISE / ROOF_RUN); // ~11.3099°


// =============================================================================
// GROUP 3 PARAMETERS — Pergola Structure & Dimensions
// =============================================================================

// --- Post Cross-Section & Layout ---------------------------------------------
// REFERENCE NOTE: Posts are square timber (~100x100 mm), confirmed from
// wireframe (countryside-tea-shop-3d-model-9cc7378ff7.webp).
POST_SIZE = 100;  // square timber post dimension (100 mm × 100 mm) (0.10 m)

// Y coordinate of the front posts line:
// Placed at Y = -2250 mm (~75% forward across the 3.0 m porch slab),
// leaving ~750 mm open patio in front of posts as shown in reference renders.
POST_Y    = -2250;

// Array of 4 post positions [X, Y]:
// Derived from front elevation proportions:
//   - Post 1 (X=100)  : near left edge of pergola / bench area
//   - Post 2 (X=2200) : intermediate post subdividing wide 3.4m service window span
//   - Post 3 (X=4250) : positioned at mid-pier directly supporting signboard
//   - Post 4 (X=5900) : near right corner of pergola
PERGOLA_POST_POSITIONS = [
    [100,  POST_Y],  // Post 1: Front-Left
    [2200, POST_Y],  // Post 2: Front-Mid-Left
    [4250, POST_Y],  // Post 3: Front-Mid-Right (under "TEA SHOP" sign)
    [5900, POST_Y]   // Post 4: Front-Right
];

// --- Beam Dimensions ---------------------------------------------------------
MAIN_BEAM_WIDTH  = 80;   // thickness of header & ledger beams along Y (0.08 m)
MAIN_BEAM_HEIGHT = 120;  // vertical depth of header & ledger beams    (0.12 m)

// --- Cross Beams / Rafters ---------------------------------------------------
CROSS_BEAM_WIDTH  = 80;   // rafter timber thickness along X            (0.08 m)
CROSS_BEAM_HEIGHT = 100;  // rafter timber depth normal to slope        (0.10 m)

// Rafter X positions aligning directly over the 4 posts:
CROSS_BEAM_X_POSITIONS = [100, 2200, 4250, 5900];

// Sloped length of rafter from front wall (Y=0) to 200 mm past the posts:
CROSS_BEAM_SLOPE_LEN = (abs(POST_Y) + 200) / cos(ROOF_ANGLE);

// --- Pergola Slope Datum & Post Height Derivation ----------------------------
// The pergola roof slopes DOWNWARDS from the front wall eave (Y=0, Z=FRONT_H)
// toward the front posts (Y=POST_Y).
// Under the slope, the rafter top is at: FRONT_H - abs(POST_Y) * tan(ROOF_ANGLE).
// Below the rafters is the header beam (MAIN_BEAM_HEIGHT).
// Post tops touch the underside of the header beam:
PERGOLA_EAVE_Z = FRONT_H;
POST_HEIGHT    = PERGOLA_EAVE_Z - abs(POST_Y) * tan(ROOF_ANGLE) - CROSS_BEAM_HEIGHT - MAIN_BEAM_HEIGHT;

// --- Diagonal Prop Brace -----------------------------------------------------
// Single prop strut visible in window wireframe (8ffafd36e4.webp), anchoring
// near the counter sill and rising diagonally to the overhead rafter.
BRACE_WIDTH     = 60;   // diagonal brace width                       (0.06 m)
BRACE_THICKNESS = 60;   // diagonal brace thickness                   (0.06 m)
BRACE_LENGTH    = 1550; // length along diagonal strut axis           (1.55 m)
BRACE_ANGLE     = 32;   // angle of brace from vertical in degrees

// --- Slatted Roof Canopy (Planks) --------------------------------------------
// 8 flat timber planks running along X (spanning full width), arrayed along
// the slope from the front wall eave to cantilever slightly past the front posts.
SLAT_WIDTH        = 265;  // width of each individual wooden plank      (0.265 m)
SLAT_THICKNESS    = 25;   // thickness of timber plank                  (0.025 m)
SLAT_GAP          = 30;   // air gap between consecutive slats          (0.030 m)
SLAT_COUNT        = 8;    // count matching 8 planks visible in wireframe
SLAT_LENGTH       = 6200; // full span along X (covers 6000 mm + 100 mm side margins)
SLAT_START_OFFSET = 60;   // distance along slope from wall face to first slat (mm)

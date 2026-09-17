// =============================================================================
// TEA SHOP DIORAMA — SIGNAGE PARAMETERS (3D TAMIL "டீ கடை")
// =============================================================================
// All units: mm (1000 mm = 1.0 m), 1:1 real-world scale (1000 units = 1 GTA unit).
// Shared global coordinate system (identical to Groups 1–4):
//   +X -> left -> right  (0 = left outer wall, BUILD_W = right outer wall)
//   +Y -> front -> back  (0 = front eave wall, BUILD_D = back wall)
//   +Z -> up             (0 = ground / plinth top datum)
// =============================================================================

// --- SHARED GLOBAL VARIABLES (Reused from Groups 1–4) ------------------------
WALL_T             = 250;   // wall panel thickness
BUILD_W            = 6000;  // building width along X (6.00 m)
BUILD_D            = 4000;  // building depth along Y (4.00 m)
BACK_H             = 3200;  // wall height at BACK (tall side)
FRONT_H            = 2400;  // wall height at FRONT eave (short side)

// Group 1 front opening & plinth references:
left_pier_width    = 600;
window_width       = 3400;
mid_pier_width     = 500;
door_width         = 1000;
sill_height        = 900;

window_left        = left_pier_width;                   // 600 mm
window_right       = window_left + window_width;        // 4000 mm
door_left          = window_right + mid_pier_width;     // 4500 mm
door_right         = door_left + door_width;            // 5500 mm

// Group 2/3 roof slope derivation:
ROOF_RISE          = BACK_H - FRONT_H;                 // 800 mm
ROOF_RUN           = BUILD_D;                           // 4000 mm
ROOF_ANGLE         = atan(ROOF_RISE / ROOF_RUN);        // ~11.3099°

// Group 3 pergola structure references:
POST_SIZE          = 100;
POST_Y             = -2250;                             // front post line (mm)
MAIN_BEAM_WIDTH    = 80;
MAIN_BEAM_HEIGHT   = 120;
CROSS_BEAM_WIDTH   = 80;
CROSS_BEAM_HEIGHT  = 100;
PERGOLA_EAVE_Z     = FRONT_H;
POST_HEIGHT        = PERGOLA_EAVE_Z - abs(POST_Y) * tan(ROOF_ANGLE) - CROSS_BEAM_HEIGHT - MAIN_BEAM_HEIGHT;


// =============================================================================
// SIGNAGE PARAMETERS — ACCURATE SCALE & FACADE POSITIONING
// =============================================================================

// --- 1. Main Hanging Signboard ("டீ கடை") --------------------------------------
// REFERENCE OBSERVATIONS (Images 9b1fed6bc4, 0d34e93fe1, 9cc7378ff7):
// - Positioned centered directly on the front facade: X = BUILD_W / 2 = 3000 mm.
// - Dimensions: 1600 mm wide x 920 mm high, 30 mm thick base plate.
// - Raised outer protective rim border (25 mm wide, 8 mm projection).
// - 3D Tamil typography: "டீ கடை" (Tea Kadai) extruded in bold 3D letters.
// - Decorative separator line + authentic 3D tea cup graphic on right side.
// - Bottom edge rests directly on top of the front pergola canopy / beam line.
HANGING_SIGN_W     = 1600;  // signboard width along X (mm)
HANGING_SIGN_H     = 920;   // signboard height along Z (mm)
HANGING_SIGN_T     = 30;    // board base plate thickness along Y (mm)
HANGING_SIGN_RIM_W = 25;    // width of outer raised border frame (mm)
HANGING_SIGN_RIM_T = 8;     // projection of outer border frame (mm)
HANGING_SIGN_LET_T = 10;    // extrusion depth of 3D Tamil text & graphics (mm)

HANGING_SIGN_X     = BUILD_W / 2; // Centered at X = 3000 mm on front facade
HANGING_SIGN_Y     = POST_Y - MAIN_BEAM_WIDTH / 2 - HANGING_SIGN_T; // sitting on front face of beam
// Elevation: bottom rests flush on top of the pergola canopy eave line:
HANGING_SIGN_Z     = PERGOLA_EAVE_Z - abs(POST_Y) * tan(ROOF_ANGLE) + 10; // ≈ 1960 mm


// --- 2. Sign Bracket / Mounting Framework ------------------------------------
// Timber framework supporting the sign from behind, anchoring it to the pergola:
BRACKET_POST_W     = 90;    // upright support timber width along X (mm)
BRACKET_POST_D     = 80;    // upright support timber depth along Y (mm)
BRACKET_POST_TOP_Z = HANGING_SIGN_Z + HANGING_SIGN_H;
BRACKET_POST_H     = BRACKET_POST_TOP_Z - (POST_HEIGHT + MAIN_BEAM_HEIGHT);

BRACKET_BATTEN_W   = HANGING_SIGN_W - 120; // rear cross-batten width along X (mm)
BRACKET_BATTEN_D   = 45;                   // rear cross-batten depth along Y (mm)
BRACKET_BATTEN_H   = 55;                   // rear cross-batten height along Z (mm)


// --- 3. Front Wall Price List Sign ("விலைப்பட்டியல்") ------------------------
// REFERENCE OBSERVATIONS (Images 9b1fed6bc4, 8ffafd36e4):
// - Mounted flat on the exterior front knee-wall sill, beneath the service window.
// - Dimensions: 520 mm wide x 420 mm high x 15 mm thick.
// - Outer frame rim (15 mm wide) + 3D Tamil header "விலைப்பட்டியல்" (Price List).
PRICE_SIGN_W       = 520;   // width along X (mm)
PRICE_SIGN_H       = 420;   // height along Z (mm)
PRICE_SIGN_T       = 15;    // thickness along Y (mm)
PRICE_SIGN_RIM_W   = 15;    // border rim width (mm)
PRICE_SIGN_RIM_T   = 5;     // border rim thickness (mm)
PRICE_SIGN_LET_T   = 6;     // text/lines extrusion depth (mm)

PRICE_SIGN_X       = window_left + 450; // X = 1050 mm
PRICE_SIGN_Y       = -PRICE_SIGN_T - 2; // 2 mm proud of front wall (prevents z-fighting)
PRICE_SIGN_Z       = 350;               // centered vertically on the 900mm sill

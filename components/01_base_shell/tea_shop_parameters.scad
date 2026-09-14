// =============================================================================
// Tea Shop — SHARED PARAMETERS (Base & Shell)
// -----------------------------------------------------------------------------
// OpenSCAD's native unit is 1 mm, so every value here is the REAL-LIFE size
// in millimetres (1000 mm = 1 m). E.g. building_width = 6000 means 6.0 m.
//
// For MLO / FiveM (which uses metres as 1 unit = 1 m), either:
//   (a) export each STL here and re-import at a scale of 0.001 (mm -> m), or
//   (b) model in metres directly by dividing every value below by 1000.
//
// Tune each value here; every module pulls its size from these variables.
// =============================================================================


// --- building shell / roof (lean-to: TALL back, SHORT front eave) -----------
wall_thickness    = 250;   // wall panel thickness                      (0.25 m)
building_width    = 6000;  // X extent, left wall -> right wall          (6.00 m)
building_depth    = 4000;  // Y extent, front eave -> back wall          (4.00 m)
back_height       = 3200;  // full wall height at the BACK (tall side)   (3.20 m)
front_eave_height = 2400;  // wall height at the FRONT eave (short side) (2.40 m)

// --- front wall openings (service window + door), measured along X ----------
left_pier_width   = 600;   // solid pier left of the service window      (0.60 m)
window_width      = 3400;  // service window opening width — made WIDE   (3.40 m)
mid_pier_width    = 500;   // solid pier between window and door         (0.50 m)
door_width        = 1000;  // door opening width                         (1.00 m)
sill_height       = 900;   // knee-wall (sill) height beneath the window (0.90 m)

// --- base slab / plinth ------------------------------------------------------
base_thickness    = 200;   // vertical thickness of the ground plinth    (0.20 m)
base_side_margin  = 900;   // slab overhang beyond left/right walls      (0.90 m)
base_back_margin  = 600;   // slab overhang behind the back wall         (0.60 m)
base_front_margin = 3000;  // extra slab in FRONT = porch/patio (pergola)(3.00 m)


// -----------------------------------------------------------------------------
// DERIVED DIMENSIONS (do not edit — computed from the values above)
// -----------------------------------------------------------------------------

// front-wall pier chain, left -> right, must sum exactly to building_width
window_left      = left_pier_width;                    // X where the window starts
window_right     = window_left + window_width;         // X where the window ends
door_left        = window_right + mid_pier_width;      // X where the door starts
door_right       = door_left + door_width;             // X where the door ends
right_pier_width = building_width - door_right;        // fills the rest to the corner

// window opening rises from the top of the sill up to the front eave line
window_open_height = front_eave_height - sill_height;
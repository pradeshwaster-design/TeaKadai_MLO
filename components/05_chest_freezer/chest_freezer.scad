// =====================================================================
//  CHEST FREEZER  -  split-lid style  -  1:1 REAL-LIFE SIZE
//  Units: millimetres (1 OpenSCAD unit = 1 mm)
//
//  Modeled from the reference photo:
//   * two side-by-side top lids, each with a soft raised inner panel
//   * recessed pull-grips near the front edge of each lid
//   * lock plate on the front face, right side below the lid seam
//   * ventilation grille at the bottom-right of the front face
//   * small dark feet, softly rounded cabinet corners
//
//  Overall envelope incl. overhangs: 1116 W x 714 D x 864 H (mm)
// =====================================================================

// ---------------------- OVERALL SIZE (real life) --------------------
body_w = 1100;   // cabinet width  (X, left-right)
body_d = 700;    // cabinet depth  (Y, front-back)
body_h = 795;    // cabinet height (Z, floor -> top of cabinet walls)
lid_h  = 55;     // lid thickness
feet_h = 14;     // clearance under the cabinet (feet height)

// ------------------------------- LIDS -------------------------------
lid_overhang_f = 14;  // lid overhangs the front face by this much
lid_overhang_s = 8;   // lid overhangs each outer side wall by this much
lid_r          = 16;  // lid edge rounding
lid_gap        = 2;   // gap between the two lids at the centre

panel_inset    = 80;  // inner panel border width - sides + back
panel_inset_f  = 80;  // inner panel border width - front
panel_raise    = 9;   // inner panel rises above the lid border
panel_soft     = 12;  // softness (chamfer) of the raised panel edge
panel_r        = 30;  // inner panel footprint corner rounding

// ---------------------------- PULL GRIPS ----------------------------
grip_w      = 210;    // grip length (X)
grip_d      = 18;     // grip depth (Y)
grip_recess = 18;     // pocket depth sunk into the lid top
grip_front  = 45;     // grip front edge -> lid front edge

// ------------------------- FRONT-FACE DETAILS -----------------------
lock_w   = 44;        // lock plate width
lock_h   = 66;        // lock plate height
lock_prt = 5;         // lock plate protrusion from the face
lock_x   = 440;       // lock centre offset from cabinet centre (right = +)
lock_top = 80;        // lock top edge below the cabinet/lid seam

vent_w     = 140;     // vent grille width
vent_h     = 70;      // vent grille height
vent_deep  = 16;      // grille pocket depth into the front wall
vent_x     = 410;     // grille centre offset from cabinet centre (right = +)
vent_z     = 75;      // grille centre height above the floor
vent_slats = 5;       // number of horizontal slats

// ------------------------------- FEET -------------------------------
foot_size  = 70;      // foot pad width/depth
foot_inset = 60;      // foot pad inset from the cabinet corners

// ------------------------------ COLORS ------------------------------
col_body = [0.845, 0.815, 0.745];  // warm oyster beige (photo match)
col_lid  = [0.860, 0.830, 0.760];  // lid, a touch lighter
col_dark = [0.050, 0.050, 0.050];  // near black - grips, lock, vent
col_key  = [0.580, 0.560, 0.520];  // keyhole metal

$fn = 64;

// ------------------------------ MODULES -----------------------------

// Box with vertically rounded corners, centred in XY, rising from z=0.
module vround_box(w, d, h, r) {
    linear_extrude(height = h)
        offset(r = r) offset(delta = -r) square([w, d], center = true);
}

// Four small dark feet under the corners.
module feet() {
    color(col_dark)
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (body_w/2 - foot_inset - foot_size/2),
                       sy * (body_d/2 - foot_inset - foot_size/2), 0])
                vround_box(foot_size, foot_size, feet_h, 8);
}

// Cabinet body with the vent pocket cut into the front wall.
module cabinet() {
    difference() {
        color(col_body)
            translate([0, 0, feet_h])
                vround_box(body_w, body_d, body_h, 18);

        // vent pocket opening in the front face (16 mm deep)
        color(col_body)
        translate([vent_x, -body_d/2 + vent_deep/2 - 0.5,
                   vent_z - vent_h/2])
            vround_box(vent_w, vent_deep + 1, vent_h, 4);
    }

    // dark back panel inside the vent pocket
    color(col_dark)
        translate([vent_x, -body_d/2 + 2 + (vent_deep - 2)/2, vent_z])
            vround_box(vent_w - 8, vent_deep - 2, vent_h - 8, 4);
}

// Horizontal slats across the vent opening.
module vent() {
    gap = (vent_h - vent_slats * 9) / (vent_slats + 1);
    color(col_body)
        for (i = [0 : vent_slats - 1])
            translate([vent_x, -body_d/2 - 0.5,
                       vent_z - vent_h/2 + gap + i * (9 + gap) + 9/2])
                cube([vent_w - 4, 3, 9], center = true);
}

// Lock plate with keyhole on the front face.
module lock() {
    z_seam  = feet_h + body_h;
    y_front = -body_d/2 - lock_prt;      // outer face of the plate
    translate([lock_x, y_front + (lock_prt + 5)/2,
               z_seam - lock_top - lock_h/2]) {
        color(col_dark) vround_box(lock_w, lock_prt + 5, lock_h, 2.5);
        // keyhole disc, slightly proud of the plate face
        translate([0, -(lock_prt + 5)/2 - 0.75, 0])
            color(col_key) cylinder(h = 1.5, r = 6, center = true);
    }
}

// One lid; s = -1 is the left lid, s = +1 is the right lid.
module lid(s) {
    w   = body_w/2 + lid_overhang_s - lid_gap/2;   // single lid width
    d   = body_d + lid_overhang_f;                 // single lid depth
    x_c = s * (lid_gap/2 + w/2);
    y_c = -lid_overhang_f/2;                       // shifted to the front
    z0  = feet_h + body_h;
    gy  = -d/2 + grip_front + grip_d/2;            // grip centre (Y, local)

    color(col_lid)
    translate([x_c, y_c, z0]) {
        difference() {
            vround_box(w, d, lid_h, lid_r);
            // pull-grip pocket sunk into the top, near the front edge
            color(col_lid)
            translate([0, gy, lid_h - grip_recess + (grip_recess + 20)/2])
                vround_box(grip_w, grip_d, grip_recess + 20, 6);
        }
        // dark liner filling the grip pocket (reads as a dark slot)
        color(col_dark)
            translate([0, gy, lid_h - grip_recess + (grip_recess - 0.5)/2])
                vround_box(grip_w - 1, grip_d - 1, grip_recess - 0.5, 5);

        // soft raised inner panel
        translate([0, (panel_inset_f - panel_inset)/2, lid_h])
            hull() {
                translate([0, 0, 0])
                    vround_box(w - 2*panel_inset,
                               d - panel_inset - panel_inset_f,
                               1, panel_r);
                translate([0, 0, panel_raise - 1])
                    vround_box(w - 2*panel_inset - 2*panel_soft,
                               d - panel_inset - panel_inset_f - 2*panel_soft,
                               1, max(panel_r - panel_soft, 2));
            }
    }
}

// ------------------------------ ASSEMBLY ----------------------------
module freezer() {
    feet();
    cabinet();
    vent();
    lock();
    lid(-1);
    lid(1);
}

freezer();


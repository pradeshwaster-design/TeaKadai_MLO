// =====================================================================
//  WATER CAN (20 L / 5-gal style) ON STAND  --  GTA V MLO prop
//  ------------------------------------------------------------------
//  UNITS: 1 unit = 1 meter. GTA V world coordinates are in meters,
//  so export at 1:1 scale -- no scaling needed downstream.
//
//  Based on a standard 20 L (5-gallon) water can with a tap fitted at
//  the bottom front, sitting on a box-style stand (as in the photo).
//
//  REAL-WORLD REFERENCE SIZES
//    20 L can  : ~0.46-0.51 m tall, ~0.27-0.29 m diameter
//    55 mm neck thread, ~60 mm outer cap
//    Tap       : ~65-90 mm spout, mounted low on the can body
//    Stand     : 0.6-1.0 m tall counter/dispenser stand
//    Total build height here: ~1.10 m (tap at ~0.66 m -- comfortable
//    filling height for a glass, matches the photo proportions)
//
//  EXPORT (GUI):   File > Export > STL  (or 3MF / OFF)
//  EXPORT (CLI):
//    openscad -o water_can_full.stl water_can_stand.scad
//    openscad -o water_can_only.stl export_can.scad
//    openscad -o stand_only.stl     export_stand.scad
//  (The included export_*.scad wrappers build one part at a time; the
//   parts are also selectable in the GUI via `part`, or with
//   -D part="can"  -- note: this OpenSCAD 2021.01 has no OBJ exporter,
//   STL/3MF import fine into Blender+Sollumz and 3ds Max GIMS.)
//
//  GTA PIPELINE: import the STL/3MF into Blender (+Sollumz) or 3ds Max
//  (GIMS Evo), turn it into a ydr prop. Each part is built with its
//  origin at its own base-centre, which is the friendly pivot for
//  prop placement. `segments = 24` keeps the mesh game-ready
//  (~1-2 k triangles total).
// =====================================================================

/* [Output] */
// Which part to build / export ("all", "can", "stand")
part = "all"; // [all, can, stand]
// Cylinder/revolve resolution. Game-friendly: 16-32. Preview: 48+
segments    = 24;
// Show a 1.2 m ground reference square (preview only)
show_ground = false;

/* [Can -- real-world scale, meters] */
// Total can height (20 L can is 0.46-0.51 m)
can_h     = 0.48;
// Body diameter at the base
can_d_bot = 0.28;
// Body diameter at the shoulder (slight taper, like real cans)
can_d_top = 0.265;
// Plastic wall thickness (3 mm) -- used when hollow = true
wall      = 0.003;
// false = solid single-skin mesh (lowest poly, recommended for game)
// true  = shelled can with 3 mm walls
hollow       = false;
// Rounded base fillet radius
base_fillet  = 0.012;
// Height where the shoulder curve starts
shoulder_z   = 0.38;
// Height of the shoulder curve
shoulder_h   = 0.08;
// Neck radius (55 mm thread finish ~= 0.027 m)
neck_r       = 0.027;

/* [Cap] */
cap_r = 0.030;   // ~60 mm outer diameter
cap_h = 0.018;

/* [Tap] */
// Fit a dispensing tap at the bottom front of the can
fit_tap      = true;
// Tap centre height above the can base
tap_z        = 0.075;
// How far the spout sticks out from the can wall
tap_len      = 0.065;
// Spout radius
tap_r        = 0.009;
// Down-turned nozzle length at the spout end
tap_nozzle_h = 0.016;
// How deep the tap boss sinks into the can wall
tap_embed    = 0.004;

/* [Stand -- real-world scale, meters] */
stand_w   = 0.36;   // footprint width  (photo shows a box stand)
stand_d   = 0.36;   // footprint depth
stand_h   = 0.60;   // height (0.6-1.0 m typical; photo ~counter height)
stand_taper = 0.92; // 1.0 = straight sides, <1 = tapers inward toward top
lip       = 0.015;  // top ledge overhang all round
lip_h     = 0.02;   // top ledge thickness
stand_wall = 0.02;  // wall thickness -- used when stand_hollow = true
stand_hollow = false;

/* [Preview colours] */
can_color   = [0.93, 0.91, 0.85];  // cream white plastic
cap_color   = [0.95, 0.95, 0.95];
tap_color   = [0.92, 0.92, 0.92];  // white plastic tap (as in photo)
stand_color = [0.16, 0.19, 0.15];  // dark olive/charcoal

// ---------------------------------------------------------------------
//  DERIVED VALUES
// ---------------------------------------------------------------------
can_r_bot = can_d_bot / 2;
can_r_top = can_d_top / 2;

$fn = segments;

// Arc helper: ellipse/arc points from angle a0 to a1 (degrees) around
// centre (cx, cz) with radii (rx, rz). Returns 2D [x, z] points.
function arc_pts(cx, cz, rx, rz, a0, a1, steps) =
    [for (i = [0 : steps])
        let (a = a0 + (a1 - a0) * i / steps)
        [cx + rx * cos(a), cz + rz * sin(a)]];

// 2D half-profile of the can (r, z), revolved around the Z axis.
// Base fillet -> slightly tapered wall -> shoulder curve -> straight neck.
function can_profile(r_bot, r_top, r_neck, h, z_sh, sh_h, fil) =
    concat(
        [[0, 0]],                                              // bottom centre
        [[r_bot - fil, 0]],                                    // bottom face
        arc_pts(r_bot - fil, fil, fil, fil, 270, 360, 4),      // base fillet
        [[r_top, z_sh]],                                       // tapered wall
        arc_pts(r_neck, z_sh, r_top - r_neck, sh_h, 0, 90, 6), // shoulder curve
        [[r_neck, h]],                                         // straight neck
        [[0, h]]                                               // top centre
    );

// Radius of the can wall at a given height (linear taper below shoulder)
function can_r_at(z) =
    can_r_bot + (can_r_top - can_r_bot) * min(z, shoulder_z) / shoulder_z;

// ---------------------------------------------------------------------
//  CAN
// ---------------------------------------------------------------------
module revolved_can(r_bot, r_top, r_neck, h) {
    rotate_extrude($fn = segments)
        polygon(points = can_profile(r_bot, r_top, r_neck, h,
                                     shoulder_z, shoulder_h, base_fillet));
}

module tap(r_wall) {
    y0 = r_wall - tap_embed;   // start slightly inside the can wall
    union() {
        // mounting boss / flange against the can
        translate([0, y0, tap_z])
            rotate([-90, 0, 0]) cylinder(h = 0.012, r = tap_r * 1.9, $fn = 20);
        // spout pointing forward (+Y)
        translate([0, y0, tap_z])
            rotate([-90, 0, 0]) cylinder(h = tap_len, r = tap_r, $fn = 20);
        // down-turned nozzle at the spout end
        translate([0, y0 + tap_len, tap_z - tap_nozzle_h])
            cylinder(h = tap_nozzle_h, r = tap_r * 0.85, $fn = 16);
        // lever handle on top of the spout (embedded 4 mm so the
        // union stays manifold -- no tangent face contact)
        translate([-0.025, y0 + 0.012, tap_z + tap_r - 0.004])
            cube([0.05, 0.014, 0.006]);
        translate([0, y0 + 0.012, tap_z + tap_r])
            sphere(r = 0.006, $fn = 16);
    }
}

module water_can() {
    union() {
        color(can_color)
        if (hollow) {
            difference() {
                revolved_can(can_r_bot, can_r_top, neck_r, can_h);
                translate([0, 0, wall])
                    revolved_can(can_r_bot - wall, can_r_top - wall,
                                 neck_r - wall, can_h - wall);
            }
        } else {
            revolved_can(can_r_bot, can_r_top, neck_r, can_h);
        }
        // screw cap on top (embedded 1 mm into the neck for a clean union)
        color(cap_color)
            translate([0, 0, can_h - 0.001])
                cylinder(h = cap_h + 0.001, r1 = cap_r, r2 = cap_r * 0.94,
                         $fn = segments);
        // dispensing tap
        if (fit_tap)
            color(tap_color)
                tap(can_r_at(tap_z));
    }
}

// ---------------------------------------------------------------------
//  STAND
// ---------------------------------------------------------------------
module stand() {
    tw = stand_w * stand_taper;   // top width of tapered body
    td = stand_d * stand_taper;   // top depth of tapered body
    difference() {
        union() {
            // tapered pedestal body
            hull() {
                translate([0, 0, 0.0005])
                    cube([stand_w, stand_d, 0.001], center = true);
                translate([0, 0, stand_h - 0.0005])
                    cube([tw, td, 0.001], center = true);
            }
            // top ledge (overlaps the pedestal 1 mm for a clean union)
            translate([0, 0, stand_h - 0.001])
                translate([0, 0, (lip_h + 0.001) / 2])
                    cube([tw + 2 * lip, td + 2 * lip, lip_h + 0.001],
                         center = true);
        }
        // optional hollow underside (useful only for 3D printing)
        if (stand_hollow)
            hull() {
                translate([0, 0, stand_wall])
                    cube([stand_w - 2 * stand_wall,
                          stand_d - 2 * stand_wall, 0.001], center = true);
                translate([0, 0, stand_h - 0.0005])
                    cube([tw - 2 * stand_wall,
                          td - 2 * stand_wall, 0.001], center = true);
            }
    }
}

// ---------------------------------------------------------------------
//  ASSEMBLY
// ---------------------------------------------------------------------
if (part == "can") {
    water_can();
} else if (part == "stand") {
    color(stand_color) stand();
} else {
    // explicit union so the sunk-in can merges into one watertight solid
    union() {
        color(stand_color) stand();
        // can sits on the ledge top, sunk 0.5 mm for a watertight union
        translate([0, 0, stand_h + lip_h - 0.0005])
            water_can();
    }
}

if (show_ground)
    %translate([0, 0, -0.001]) cube([1.2, 1.2, 0.002], center = true);

// Sanity check in the console: overall bounding dimensions in meters
total_h = stand_h + lip_h + can_h + cap_h;
echo(str("Can height: ", can_h, " m | Footprint: ", stand_w, " x ", stand_d,
         " m | TOTAL build height: ", total_h, " m"));



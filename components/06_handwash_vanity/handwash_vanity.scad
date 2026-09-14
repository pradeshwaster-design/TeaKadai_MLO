// =====================================================================
//  RUSTIC WASHBASIN VANITY  --  cupboard + concrete top + sink + faucet
//  Modeled from reference photo, real-life size: 1 unit = 1 mm
//
//  Assembled overall: 620 W x 530 D x 885 H mm (countertop included)
//
//  GTA V / MLO: GTA V world units are METERS (1 unit = 1 m).
//  Set gta_scale = true before exporting -> output is scaled by 0.001
//  so it imports at real-life size directly.
//
//  Requires OpenSCAD 2019.05+ (uses rotate_extrude with angle=).
// =====================================================================

/* [What to show / export] */
// "assembly" = everything together. Individual names export a single
// mesh each (best for texturing / openable doors in Blender).
part = "assembly"; // [assembly, carcass, door_left, door_right, countertop, sink, faucet, door_handles]

/* [Export] */
// true = scale output by 0.001 (mm -> meters) for GTA V MLO
gta_scale = false;
// curve smoothness: 24 = game-friendly, 48 = preview, 96 = smooth render
quality = 48;

/* [Cabinet carcass] */
cab_w   = 560;   // carcass width  (x)
cab_d   = 480;   // carcass depth  (y)
cab_h   = 850;   // height to top of carcass (countertop sits on top)
panel_t = 18;    // side / bottom / door panel thickness
back_t  = 15;    // back panel thickness
toe_h   = 70;    // recessed toe-kick height
toe_in  = 35;    // toe-kick setback
stile_w = 45;    // face-frame stile width
rail_h  = 75;    // face-frame bottom rail height
frame_t = 20;    // face-frame thickness

/* [Countertop] */
ct_t          = 35;   // slab thickness
ct_over_side  = 30;   // overhang left + right
ct_over_front = 35;
ct_over_back  = 15;

/* [Sink basin] */
cut_w        = 420;   // cut-out width  (x)
cut_d        = 300;   // cut-out depth  (y)
cut_y        = -35;   // cut-out center offset (+ front / - back)
basin_depth  = 130;   // basin depth below countertop
basin_wall   = 12;
basin_bottom = 15;
basin_r      = 30;    // plan corner radius

/* [Faucet] */
fct_x      = 0;
fct_y      = -220;   // on the counter, behind the basin
riser_h    = 215;    // riser height above countertop
bend_r     = 55;     // gooseneck bend radius (= spout reach / 2)
spout_drop = 135;    // spout tip height above countertop
tube_r     = 11;

/* [Door hardware] */
bar_len      = 150;
bar_r        = 6;
bar_standoff = 24;

/* [Preview colors] */
c_wood   = [0.47, 0.30, 0.15];
c_wood_d = [0.30, 0.19, 0.10];
c_blue   = [0.24, 0.42, 0.60];
c_stone  = [0.45, 0.43, 0.40];
c_basin  = [0.05, 0.05, 0.06];
c_metal  = [0.16, 0.16, 0.17];
c_bronze = [0.45, 0.33, 0.20];

$fn = quality;

// ---------------- derived (do not edit) ----------------
ct_w     = cab_w + 2*ct_over_side;               // 620
ct_d     = cab_d + ct_over_front + ct_over_back; // 530
ct_z     = cab_h;                                // countertop bottom z
front_y  = cab_d/2;                              // cabinet front plane
door_w   = (cab_w - 2*stile_w - 6)/2;            // each door width
door_z0  = toe_h + rail_h + 3;                   // door bottom
door_z1  = cab_h - 8;                            // door top
door_cx  = door_w/2 + 3;                         // door center from middle
door_zc  = (door_z0 + door_z1)/2;
handle_x = cab_w/2 - stile_w - 37;               // bar handle x from middle

// ---------------- helpers ----------------
module rbox(size, r) {   // CORNER-anchored box with rounded vertical corners
  linear_extrude(height = size[2])
    offset(r = r) offset(delta = -r)
      square([size[0], size[1]]);
}

// ---------------- cabinet carcass ----------------
module carcass() {
  color(c_wood_d)                                        // toe kick
    translate([-(cab_w - 2*toe_in)/2, -(cab_d - 2*toe_in)/2, 0])
      cube([cab_w - 2*toe_in, cab_d - 2*toe_in, toe_h]);
  color(c_wood) {
    translate([-cab_w/2, -cab_d/2, toe_h])               // bottom panel
      cube([cab_w, cab_d, panel_t]);
    for (s = [-1, 1])                                    // side panels
      translate([s < 0 ? -cab_w/2 : cab_w/2 - panel_t, -cab_d/2, toe_h + panel_t])
        cube([panel_t, cab_d, cab_h - toe_h - panel_t]);
    translate([-cab_w/2 + panel_t, -cab_d/2, toe_h + panel_t])   // back panel
      cube([cab_w - 2*panel_t, back_t, cab_h - toe_h - panel_t]);
    // top stretchers (front one blocks the slot behind the doors)
    translate([-cab_w/2 + panel_t, front_y - 45, cab_h - panel_t])
      cube([cab_w - 2*panel_t, 20, panel_t]);
    translate([-cab_w/2 + panel_t, -cab_d/2 + back_t, cab_h - panel_t])
      cube([cab_w - 2*panel_t, 20, panel_t]);
  }
}

// ---------------- face frame (stiles + bottom rail) ----------------
module face_frame() {
  color(c_wood) {
    for (s = [-1, 1])
      translate([s < 0 ? -cab_w/2 : cab_w/2 - stile_w, front_y - frame_t, toe_h])
        cube([stile_w, frame_t, cab_h - toe_h]);
    translate([-cab_w/2 + stile_w, front_y - frame_t, toe_h])
      cube([cab_w - 2*stile_w, frame_t, rail_h]);
  }
}

// ---------------- doors (blue painted slab doors) ----------------
module door(cx) {
  color(c_blue)
    translate([cx - door_w/2, front_y - frame_t - 2, door_z0])
      rbox([door_w, panel_t, door_z1 - door_z0], 2);
}
module door_left()  door(-door_cx);
module door_right() door( door_cx);

// ---------------- vertical bar handles on the doors ----------------
module door_handles() {
  color(c_bronze)
  for (s = [-1, 1]) {
    // the bar
    translate([s*handle_x, front_y - 6 + bar_standoff + bar_r, door_zc - bar_len/2])
      cylinder(r = bar_r, h = bar_len);
    // arms to the door face
    for (zz = [door_zc - bar_len/2 + 15, door_zc + bar_len/2 - 15])
      translate([s*handle_x, front_y - 6, zz])
        rotate([-90, 0, 0]) cylinder(r = 5, h = bar_standoff + bar_r + 2);
  }
}

// ---------------- concrete countertop with basin cut-out ----------------
module countertop() {
  difference() {
    color(c_stone)
      translate([-ct_w/2, -cab_d/2 - ct_over_back, ct_z])
        cube([ct_w, ct_d, ct_t]);
    color(c_stone)
      translate([-cut_w/2 + basin_r, cut_y - cut_d/2 + basin_r, ct_z - 1])
        rbox([cut_w, cut_d, ct_t + 2], basin_r);
  }
}

// ---------------- dark undermount basin + drain ----------------
module sink() {
  ow  = cut_w + 2*basin_wall;
  od  = cut_d + 2*basin_wall;
  oz0 = ct_z - basin_depth;
  difference() {
    union() {
      difference() {
        color(c_basin)
          translate([-ow/2 + basin_r, cut_y - od/2 + basin_r, oz0])
            rbox([ow, od, basin_depth], basin_r);
        color(c_basin)
          translate([-cut_w/2 + basin_r, cut_y - cut_d/2 + basin_r, oz0 + basin_bottom - 1])
            rbox([cut_w, cut_d, basin_depth - basin_bottom + 1], max(basin_r - 10, 5));
      }
      color(c_metal)
        translate([0, cut_y, oz0 + basin_bottom - 2])
          cylinder(r = 40, h = 6);                       // drain flange
    }
    translate([0, cut_y, oz0 - 1])
      cylinder(r = 22, h = basin_bottom + 6);            // drain hole
  }
}

// ---------------- gooseneck faucet with two cross handles ----------------
module faucet() {
  color(c_metal)
  translate([fct_x, fct_y, ct_z + ct_t]) {
    cylinder(r = 26, h = 10);                                    // base flange
    cylinder(r = 16, h = 22);                                    // base collar
    translate([0, 0, 10]) cylinder(r = tube_r, h = riser_h - 10); // riser
    // 180-degree gooseneck bend (both ends stay vertical)
    translate([0, bend_r, riser_h])
      rotate([0, 0, 90]) rotate([90, 0, 0])
        rotate_extrude(angle = 180) translate([bend_r, 0]) circle(r = tube_r);
    translate([0, 2*bend_r, spout_drop])
      cylinder(r = tube_r, h = riser_h - spout_drop);            // spout tube
    translate([0, 2*bend_r, spout_drop - 12])
      cylinder(r = 8.5, h = 14);                                 // aerator
    for (s = [-1, 1])                                            // cross handles
      translate([s*38, 0, 12]) rotate([0, s*15, 0]) {
        cylinder(r = 6.5, h = 40);                               // stem
        translate([0, 0, 40]) cylinder(r = 13, h = 14);          // knob
        translate([0, 0, 47]) {
          cube([34, 4.5, 4.5], center = true);                   // cross bars
          cube([4.5, 34, 4.5], center = true);
        }
        translate([0, 0, 54]) sphere(r = 6.5);                   // cap
      }
  }
}

// ---------------- full assembly ----------------
module assembly() {
  carcass();
  face_frame();
  door_left();
  door_right();
  door_handles();
  countertop();
  sink();
  faucet();
}

// ---------------- what to show / export ----------------
module pick() {
  if (part == "carcass")           { carcass(); face_frame(); }
  else if (part == "door_left")    door_left();
  else if (part == "door_right")   door_right();
  else if (part == "countertop")   countertop();
  else if (part == "sink")         sink();
  else if (part == "faucet")       faucet();
  else if (part == "door_handles") door_handles();
  else                             assembly();
}

echo(str("OVERALL: ", ct_w, " x ", ct_d, " x ", cab_h + ct_t, " mm (W x D x H)"));
echo(str("Doors: ", door_w, " x ", door_z1 - door_z0, " mm each | gta_scale = ", gta_scale));

if (gta_scale) scale(0.001) pick();
else pick();

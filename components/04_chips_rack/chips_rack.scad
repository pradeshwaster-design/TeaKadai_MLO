// =====================================================================
//  Hanging chips display rack  -  real-life size (millimetres)
//
//  Frame : ~1100 mm wide x 1400 mm tall, 25 mm steel tube, T-feet 400 mm
//  Bags  : ~88 x 132 x 45 mm flow-pack snack bags hung in strips
//
//  FOR GTA V (MLO):  1 OpenSCAD unit = 1 mm.
//  Render (F6) -> File > Export > STL -> import in Blender -> scale 0.001
//  (GTA world units are metres) -> export with GIMS Evo / CodeWalker.
//
//  STL carries no colour: export the frame and the bags separately
//  (toggle show_frame / show_bags) and assign materials in Blender.
// =====================================================================

$fn = 24;

/* ---------- rack frame (real-life mm) ---------- */
rack_w   = 1100;                     // overall width
rack_h   = 1400;                     // overall height
tube_d   = 25;                       // tube outer diameter
foot_len = 400;                      // floor foot length (front-back)
rails_z  = [1380, 1000, 700, 420];   // rail centre heights

/* ---------- snack bag (w x h x d) ---------- */
bag_w  = 88;                         // width  (left-right)
bag_h  = 132;                        // height (vertical)
bag_d  = 45;                         // depth  (front-back)
bag_r  = 9;                          // corner rounding
slot_w = 16;                         // hang slot width
slot_h = 7;                          // hang slot height
drop   = 12;                         // overlap between bags in a strip

/* ---------- preview colours ---------- */
tube_col   = [0.23, 0.24, 0.26];
yellow_col = [0.98, 0.72, 0.12];
blue_col   = [0.10, 0.33, 0.80];
gold_col   = [0.96, 0.78, 0.20];

show_frame = true;
show_bags  = true;

/* strips: [x from left edge, rail height, bag count, colour, y offset]
   y 47 = front layer (long strips crossing lower rails)
   y 94 = extra front layer resting on the 47 layer
   y 0  = centred on the rack plane                                  */
strips = [
    // top rail : yellow (left), blue (middle-right)
    [  90, 1380, 5, yellow_col, 47],
    [ 200, 1380, 5, yellow_col, 47],
    [ 310, 1380, 4, yellow_col, 47],
    [ 420, 1380, 5, yellow_col, 47],
    [ 540, 1380, 5, blue_col,   47],
    [ 655, 1380, 4, blue_col,   47],
    [ 770, 1380, 5, blue_col,   47],
    [ 880, 1380, 3, blue_col,    0],
    [ 990, 1380, 3, blue_col,    0],
    // 2nd rail, right side
    [ 870, 1000, 4, gold_col,   47],
    [ 985, 1000, 4, gold_col,   47],
    // 3rd rail, right side (front layer resting on the strips above)
    [ 870,  700, 3, gold_col,   94],
    [ 985,  700, 3, gold_col,   94],
    // bottom rail, left
    [  90,  420, 3, blue_col,    0],
    [ 200,  420, 3, blue_col,    0]
];

/* ---------------- modules ---------------- */

module bag() {
    difference() {
        minkowski() {                          // rounded rectangular pouch
            cube([bag_w - 2*bag_r, bag_d - 2*bag_r, bag_h - 2*bag_r],
                 center = true);
            sphere(r = bag_r, $fn = 16);
        }
        translate([0, 0, bag_h/2 - 18])        // hang slot through top seal
            cube([slot_w, bag_d + 6, slot_h], center = true);
    }
}

module clip_ring() {                           // S-hook ring around a rail
    rotate([0, 90, 0]) rotate_extrude()
        translate([tube_d/2 + 2, 0]) circle(r = 2.5);
}

module chip_strip(n, y_off) {
    color(tube_col) clip_ring();
    if (y_off > 20)                            // clip arm out to the bag
        color(tube_col) translate([0, 10, -5]) cube([14, y_off - 10, 10]);
    for (i = [0 : n - 1])                      // bags stacked downward
        translate([0, y_off, tube_d/2 - bag_h/2 - i*(bag_h - drop)])
            bag();
}

module frame() {
    color(tube_col) {
        for (x = [-rack_w/2, rack_w/2]) {
            translate([x, 0, 0]) cylinder(h = rack_h, d = tube_d);      // posts
            translate([x, 0, rack_h]) sphere(d = tube_d);               // caps
            translate([x, 0, tube_d/2]) rotate([90, 0, 0])
                cylinder(h = foot_len, d = tube_d, center = true);      // T-foot
            for (y = [-foot_len/2, foot_len/2])
                translate([x, y, tube_d/2]) sphere(d = tube_d);         // foot caps
        }
        for (z = rails_z)                                               // rails
            translate([-rack_w/2 + tube_d/2, 0, z]) rotate([0, 90, 0])
                cylinder(h = rack_w - tube_d, d = tube_d);
    }
}

/* ---------------- build ---------------- */

if (show_frame) frame();

if (show_bags)
    for (s = strips)
        translate([s[0] - rack_w/2, 0, s[1]])
            color(s[3]) chip_strip(s[2], s[4]);

// Telescope fittings, August 2023
//
// Lenses from I. R. Poyser's K.2 kit: http://irpoyser.co.uk/telescope-kits/
//  - 2" / 51mm objective lens, ~15mm thick, ~183mm focal length
//  - 2  21.6mm achromatic eyepiece lenses, 8mm at centre, 5mm at edge with .5mm bevel.
// Tubing is stainless steel:
//  - 57mm o.d. / 54mm i.d. for main tube
//  - 28mm o.d. / 25mm i.d. for eyepiece

// Render circles with this many segments.
$fn = 120;

// Reduce sliding surfaces this much to allow for overextrusion
give = 0.1;

//
// Eyepiece
//

// Length of the eyepiece tube
eyepiece_tube_length = 77;
// Inner radius of the eyepiece tube
eyepiece_tube_radius = 12.55;
// Thickness of the eyepiece tube
eyepiece_tube_thickness = 1.4;

// Inner radius of the spacers and sleeves.
eyepiece_inner_radius = 9.8;

// Length of the spacer before the bevel (the thick part)
eyepiece_spacer_length_before = 1.5;
// Length of the 45-degree bevel
eyepiece_spacer_bevel = 1.5;
// Length of the spacer after the bevel (the thin part)
eyepiece_spacer_length_after = 1.75;
// Inner radius of the spacer after the bevel (the thin part)
eyepiece_spacer_radius = eyepiece_inner_radius + eyepiece_spacer_bevel;
// Total length of the spacer
eyepiece_spacer_length = eyepiece_spacer_length_before + eyepiece_spacer_bevel + eyepiece_spacer_length_after;
// Nominal length of 2 lenses + 4 spacers, including the slight gaps.
eyepiece_lens_assembly_length = 4 * (eyepiece_spacer_length + 0.25);

// Length of the field stop, from the end of the spacer to the image field.
eyepiece_field_stop_length = 20;
// Radius of the illuminated field.
eyepiece_field_radius = 6;

// Length of the retaining sleeve between the field stop and the collar
eyepiece_retainer_length = 20;

// Thickness of the flange at the end of the tube
flange_thickness = 2;
// Length of the collar that goes outside the tube to grip it.
collar_length = 10;

// Layout grid step for printing
grid = 50;

// Retaining sleeve, to fit inside eyepiece tube.
module eyepiece_retainer() {
    difference() {
        cylinder(h = eyepiece_retainer_length, r = eyepiece_tube_radius);
        cylinder(h = eyepiece_retainer_length, r = eyepiece_inner_radius);
    }
}

// The volume to be removed to make the spacer bevel
module eyepiece_bevel() {
    union() {
        intersection() {
            // Outer limit of the volume
            cylinder(h = eyepiece_spacer_length, r = eyepiece_spacer_radius);
            // Cone that includes the bevel surface itself.
            translate([0, 0, eyepiece_spacer_length_before - eyepiece_inner_radius])
                cylinder(h = eyepiece_tube_radius * 2, r1 = 0, r2 = eyepiece_tube_radius * 2);
        }
        // Inner limit of the volume
        cylinder(h = eyepiece_spacer_length, r = eyepiece_inner_radius);
    }
}

// Spacer to sit on one side of one eyepiece lens.
module eyepiece_spacer() {
    difference() {
        cylinder(h = eyepiece_spacer_length, r = eyepiece_tube_radius - give);
        eyepiece_bevel();
    }
}

// Last spacer in the stack has a flange that sits outside the tube.
module eyepiece_end_spacer() {
    union() {
        // Spacer part to hold the lens
        translate([0, 0, flange_thickness])
            eyepiece_spacer();
        // Flat outside part
        difference() {
            cylinder(h = flange_thickness, r = eyepiece_tube_radius + eyepiece_tube_thickness - give);
            cylinder(h = flange_thickness, r = eyepiece_inner_radius + give);
        }
        // Part that grips the tube
        difference() {
            cylinder(h = collar_length, r = eyepiece_tube_radius + eyepiece_tube_thickness + flange_thickness);
            cylinder(h = collar_length, r = eyepiece_inner_radius);
            translate([0, 0, flange_thickness])
                cylinder(h = collar_length, r = eyepiece_tube_radius + eyepiece_tube_thickness);
        }
    }
}

module eyepiece_field_stop() {
    union() {
        // Sleeve to set the distance correctly
        difference() {
            cylinder(h = eyepiece_field_stop_length, r = eyepiece_tube_radius);
            cylinder(h = eyepiece_field_stop_length, r = eyepiece_inner_radius);
        }
        // Disc to set the field, tapered to a point.
        difference() {
            cylinder(h = 2, r = eyepiece_tube_radius);
            translate([0, 0, -eyepiece_field_radius])
                cylinder(h = eyepiece_field_radius * 2, r1 = 0, r2 = eyepiece_field_radius * 2);
        }        
    }
}

// Other end of the stack also gets a collar to hold things together
module eyepiece_collar() {
    union() {
        // Outside parts
        difference() {
            cylinder(h = collar_length, r = eyepiece_tube_radius + eyepiece_tube_thickness + flange_thickness);
            cylinder(h = collar_length, r = eyepiece_inner_radius);
            translate([0, 0, flange_thickness])
                cylinder(h = collar_length, r = eyepiece_tube_radius + eyepiece_tube_thickness);
            }
        }
        // Inside parts
        difference() {
            cylinder(h = eyepiece_tube_length + flange_thickness - (eyepiece_lens_assembly_length + eyepiece_field_stop_length + eyepiece_retainer_length), r = eyepiece_tube_radius);
            cylinder(h = eyepiece_tube_length + flange_thickness, r = eyepiece_inner_radius);
        }
}

module eyepiece() {
    translate([0, 0, 0]) eyepiece_collar();
    translate([grid, 0, 0]) eyepiece_end_spacer();
    translate([grid, grid, 0]) eyepiece_spacer();
    translate([grid * 2, 0, 0]) eyepiece_spacer();
    translate([grid * 2, grid, 0]) eyepiece_spacer();
    translate([grid * 3, 0, 0]) eyepiece_field_stop();
    translate([grid * 3, grid, 0]) eyepiece_retainer();
}



//
// Main tube
//

// Inner radius of the main tube
main_tube_radius = 27.05;
// Thickness of the main tube
main_tube_thickness = 1.5;

// Inner radius of the spacers and sleeves.
main_inner_radius = 24.5;

// Length of the spacer before the bevel (the thick part)
main_spacer_length_before = 10;
// Length of the 45-degree bevel
main_spacer_bevel = 1.5;
// Length of the spacer after the bevel (the thin part)
main_spacer_length_after = 4;
// Inner radius of the spacer after the bevel (the thin part)
main_spacer_radius = main_inner_radius + main_spacer_bevel;
// Nominal length of lens + spacers, including the slight gap.
main_lens_assembly_length = 2 * (main_spacer_length_before + main_spacer_bevel + main_spacer_length_after + 0.25);


module everything() {
    eyepiece();
}

everything();
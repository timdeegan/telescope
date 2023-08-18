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
give = 0.05;

//
// Eyepiece
//

// Length of the eyepiece tube
eyepiece_tube_length = 77;
// Inner radius of the eyepiece tube
eyepiece_tube_radius = 12.6;
// Thickness of the eyepiece tube
eyepiece_tube_thickness = 1.55;

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

// Length of the main tube
main_tube_length = 250;
// Inner radius of the main tube
main_tube_radius = 27.05;
// Thickness of the main tube
main_tube_thickness = 1.5;

// Inner radius of the spacers and sleeves.
main_inner_radius = 24.5;
// Inner radius of the baffle sleeves
main_baffle_radius = 25.5;

// Length of the spacer before the bevel (the thick part)
main_spacer_length_before = 10;
// Length of the 45-degree bevel
main_spacer_bevel = 1.5;
// Length of the spacer after the bevel (the thin part)
main_spacer_length_after = 4;
// Inner radius of the spacer after the bevel (the thin part)
main_spacer_radius = main_inner_radius + main_spacer_bevel;
// Total length of the spacer.
main_spacer_length = main_spacer_length_before + main_spacer_bevel + main_spacer_length_after;
// Nominal length of lens + spacers, including the slight gap.
main_lens_assembly_length = 2 * (main_spacer_length + 0.25);

// Retaining sleeve in front of the objective; adjust length to make focus work.
main_retainer_length = 36;

// Length of the plug
plug_length = 30;
// Thickness of the gap left for felt in the plug.
felt_thickness = 0.8;

// Thickness of the flange at the end of the tube
flange_thickness = 2;
// Length of the collar that goes outside the tube to grip it.
collar_length = 10;

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

// The field stop, and a spacer to put it the right distance from the lens.
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
    grid = 40;
    translate([0, 0, 0]) eyepiece_collar();
    translate([0, grid, 0]) eyepiece_end_spacer();
    translate([0, grid * 2, 0]) eyepiece_spacer();
    translate([0, grid * 3, 0]) eyepiece_spacer();
    translate([0, grid * 4, 0]) eyepiece_spacer();
    translate([0, grid * 5, 0]) eyepiece_field_stop();
    translate([0, grid * 6, 0]) eyepiece_retainer();
}

//
// Main tube
//

// The volume to be removed to make the main-tube spacer bevel
module main_bevel() {
    union() {
        intersection() {
            // Outer limit of the volume
            cylinder(h = main_spacer_length, r = main_spacer_radius);
            // Cone that includes the bevel surface itself.
            translate([0, 0, main_spacer_length_before - main_inner_radius])
                cylinder(h = main_tube_radius * 2, r1 = 0, r2 = main_tube_radius * 2);
        }
        // Inner limit of the volume
        cylinder(h = main_spacer_length, r = main_inner_radius);
    }
}

// Spacer to sit on one side of the objective lens.
module main_spacer() {
    difference() {
        cylinder(h = main_spacer_length, r = main_tube_radius - give);
        main_bevel();
    }
}

// A baffle, and a spacer to set it the right distance from its neighbour.
module baffle(height, length) {
    union() {
        // Sleeve to set the distance correctly
        difference() {
            cylinder(h = length, r = main_tube_radius - give);
            cylinder(h = length, r = main_baffle_radius);
        }
        // Disc to set the field, tapered to a point.
        difference() {
            cylinder(h = 2, r = main_tube_radius - give);
            translate([0, 0, height - main_tube_radius])
                cylinder(h = main_tube_radius, r1 = 0, r2 = main_tube_radius);
        }        
    }
}

// The end plug that holds the eyepiece/focus tube.
module plug() {
    union() {
        // The main plug
        difference() {
            cylinder(h = plug_length, r = main_tube_radius);
            cylinder(h = plug_length, r = eyepiece_tube_radius + eyepiece_tube_thickness - give);
            translate([0, 0, flange_thickness])
                cylinder(h = plug_length - 2 * flange_thickness, r = eyepiece_tube_radius + eyepiece_tube_thickness + felt_thickness);
         }
         // The collar
         difference() {
             cylinder(h = collar_length, r = main_tube_radius + main_tube_thickness + flange_thickness);
             cylinder(h = collar_length, r = eyepiece_tube_radius + eyepiece_tube_thickness - give);
             translate([0, 0, flange_thickness])
                cylinder(h = collar_length, r = main_tube_radius + main_tube_thickness);
         }
    }
}

// Front collar that spaces the main tube correctly
module main_collar() {
    union() {
        // Retaining ring to hold the lens ain the right place
        translate([0, 0, flange_thickness])
            difference() {
                cylinder(h = main_retainer_length, r = main_tube_radius);
                cylinder(h = main_retainer_length, r = main_baffle_radius);
            }
        // The collar.
        difference() {
            cylinder(h = collar_length, r = main_tube_radius + main_tube_thickness + flange_thickness);
            cylinder(h = collar_length, r = main_baffle_radius);
            translate([0, 0, flange_thickness])
                cylinder(h = collar_length, r = main_tube_radius + main_tube_thickness);
         }        
    }
}

module main() {
    grid = 75;
    translate([0, 0, 0]) main_spacer();
    translate([0, grid, 0]) main_spacer();
    translate([0, grid * 2, 0]) plug();
    translate([0, grid * 3, 0]) main_collar();
    translate([grid, 0, 0]) baffle(height = 3.5, length = 25 - main_spacer_length_before);
    translate([grid, grid, 0]) baffle(height = 8, length = 40);
    translate([grid, grid * 2, 0]) baffle(height = 13, length = 48);   
}


module everything() {
    main();
    translate([135, 0, 0])
        eyepiece();
}

everything();
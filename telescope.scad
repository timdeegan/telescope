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

// Reduce every surface by this much to allow for overextrusion
give = 0.1;

//
// Eyepiece
//

// Length of the placeholder eyepiece tube
eyepiece_tube_length = 30;
// Inner radius of the eyepiece tube
eyepiece_tube_radius = 12.5;
// Thickness of the eyepiece tube
eyepiece_tube_thickness = 3;

// Thickness of the retaining sleeve
eyepiece_retainer_thickness = 2.7;
// Inner radius of the retaining sleeve
eyepiece_inner_radius = eyepiece_tube_radius - eyepiece_retainer_thickness;
// Length of the retaining sleeve
eyepiece_retainer_length = 10;

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

// Thickness of the flange at the end of the tube
eyepiece_flange_thickness = 3;

// Layout grid step for printing
grid = 50;

// Plain tubing, placeholder for metal tubing to come.
module eyepiece_tube() {
    difference() {
        cylinder(h = eyepiece_tube_length, r = eyepiece_tube_radius + eyepiece_tube_thickness - give);
        cylinder(h = eyepiece_tube_length, r = eyepiece_tube_radius + give);
    }
}

// Retaining sleeve, to fit inside eyepiece tube.
module eyepiece_retainer() {
    difference() {
        cylinder(h = eyepiece_retainer_length, r = eyepiece_tube_radius - give);
        cylinder(h = eyepiece_retainer_length, r = eyepiece_inner_radius + give);
    }
}

// The volume to be removed to make the spacer bevel
module eyepiece_bevel() {
    union() {
        intersection() {
            // Outer limit of the volume
            cylinder(h = eyepiece_spacer_length, r = eyepiece_spacer_radius + give);
            // Cone that includes the bevel surface itself.
            translate([0, 0, eyepiece_spacer_length_before - eyepiece_inner_radius - give])
                cylinder(h = eyepiece_tube_radius * 2, r1 = 0, r2 = eyepiece_tube_radius * 2);
        }
        // Inner limit of the volume
        cylinder(h = eyepiece_spacer_length, r = eyepiece_inner_radius + give);
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
        translate([0, 0, eyepiece_flange_thickness])
            eyepiece_spacer();
        difference() {
            cylinder(h = eyepiece_flange_thickness, r = eyepiece_tube_radius + eyepiece_tube_thickness - give);
            cylinder(h = eyepiece_flange_thickness, r = eyepiece_inner_radius + give);
        }
    }
}

module eyepiece() {
    eyepiece_tube();
    translate([0, grid, 0]) eyepiece_retainer();
    translate([grid, 0, 0]) eyepiece_end_spacer();
    translate([grid, grid, 0]) eyepiece_spacer();
    translate([grid * 2, 0, 0]) eyepiece_spacer();
    translate([grid * 2, grid, 0]) eyepiece_spacer();
}

module everything() {
    eyepiece();
}

everything();
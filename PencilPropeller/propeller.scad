
// A propeller for Oskar's bed.

// Fine rendering
$fa=1;
$fs=0.5;

// Fast rendering
// $fa=5;
// $fs=3;

pencil_dia=7.7; // Diameter of your pencil (including epsilon)
disk_dia=6*pencil_dia; // Diameter of the propellerhead
thick=18; // Thickness of the propellerhead

// The pencil is attached with a screw with the following parameters
screw_head=6; // diameter of the head hole
screw_body=2.85; // diameter of the screw hole 
screw_body_length=10; // length of the screw hole
screw_pos=screw_head/2 + 2; // position of the screw head from the
                            // inside of the propellor

rounded_rad = 2;  // Radius of a little sphere used to round the
                  // propellerhead

// The holes for the wings are epsilon larger in each direction.  
// .4mm seems to be a good compromise
wing_epsilon_thick = 0.2;
wing_epsilon_wide = 0.4;

// Parameters of the wing
wing_thick = 3; // Includes a tolerance
wing_wide = 7.5;
// How deep do wings stick into the head
wing_deep = (disk_dia-pencil_dia)/2 - 2;  // 1mm between pencil hole and wing hole

propeller_imprint_text = "Oskar";
text_deep=1;

// Wing settings
wing_long=80;   // Length of the wing extension
end_width=50;   // How wide should it be in the end 
start_width=35; // How wide should it start?

wing_imprint_text = "\u2708";  // Imprint on the wing
wing_imprint_size = 30; // Text size
// wing_imprint_font = "Arial Rounded MT Bold";
wing_imprint_font = "Arial Unicode MS";

// Washer settings
washer_dia=2.7*pencil_dia;
washer_thick=2;

// There are four different modules, the head, the wings, washers, and
// the stopper (for the other end of the pencil.

// head ();
wing ();
// debug_wing_hole ();
// debug_wing ();
// washer();
// stopper ();

module debug_wing () {
    // For debugging the wing attachment, print only the wing handle with
    // the following
    intersection () {
	wing ();
	window_wide = wing_deep + start_width/4 + 10;
	translate ([0,window_wide/2-2,0])
	cube ([start_width,window_wide,100], center=true);
    }
}

module debug_wing_hole () {
    difference () {
	intersection (){
	    cylinder (h=1.4*wing_wide, d = disk_dia);
	    rotate ([0,0,45])
	    translate ([disk_dia/4,0,0])
	    cube ([disk_dia/2,disk_dia/2,2*thick], center=true);
	    cube ([disk_dia/2,disk_dia/2,2*thick]);
	}
	cylinder (d = pencil_dia ,h=2*thick, center=true);
	wing_hole (45,1.4*wing_wide/2);
    }

}

module wing_hole (angle, height) {
    translate ([0,0,height])
    rotate ([45,0,angle])
    translate ([disk_dia - wing_deep,0,0])
    cube(size=[disk_dia,
	    wing_thick + wing_epsilon_thick,
	    wing_wide  + wing_epsilon_wide], center=true);
}

module propeller_imprint (){
    translate ([0,0,thick-text_deep])
    resize (newsize = [0.8*disk_dia, 0, text_deep+2], auto=true)
    linear_extrude(height=thick+2)    
    text(propeller_imprint_text, halign="center",
	valign="center",
	font = "Arial Rounded MT Bold");
}

module propeller_body () {
    cylinder (d=disk_dia, h=thick-rounded_rad);
    translate ([0,0,thick-rounded_rad])
    rotate_extrude(convexity = 10)
    translate([disk_dia/2-rounded_rad, 0, 0])
    circle(r = rounded_rad, center=true);
// this takes way to long to render
//     for ( i = [0:180] )
//       rotate ([0,0,2*i])
//       translate ([0,disk_dia/2-rounded_rad,thick-rounded_rad])
//       sphere (r=rounded_rad,center=true);
    translate ([0,0,thick-rounded_rad])
      cylinder (d=disk_dia-2*rounded_rad, h=rounded_rad);
    }

// The head of the propeller.  Connect four wings by sticking or
// gluing them in, connect the pencil with an M3 screw.
module head () {
    difference () {
	propeller_body ();
	translate ([0,0,-1])
	cylinder(d=pencil_dia, h=thick-4);
	// Schraubenloch
	translate ([0,0,screw_pos])
	rotate ([90,0,0])
	cylinder(d=screw_body, h=100);
	// Schraubenkopf
	translate ([0,-screw_body_length,screw_pos])
	rotate ([90,0,0])
	cylinder(d=screw_head, h=100);
	for ( i = [0:3]) 
	wing_hole (45+90*i, 10);
	propeller_imprint ();
    }
}

module curve_out () {
    difference () {
	square ([start_width/4,start_width/4]);
	translate ([start_width/4, start_width/4])
	circle(r=start_width/4);
    }
}

module 2d_wing () {
    translate ([0,(wing_wide + wing_deep)/2])
    square ([wing_wide, wing_wide + wing_deep], center=true);
    translate ([wing_wide/2, 0])
    curve_out();
    translate ([-wing_wide/2, 0])
    rotate (90) curve_out();
    // Connect the two by moving the pedal part over a minimal amount:
    translate ([0,0.1])
    hull () {
	translate ([-start_width/4-wing_wide/2,-start_width/4])
	circle (r=start_width/4, center=true);
	translate ([start_width/4+wing_wide/2,-start_width/4])
	circle (r=start_width/4, center=true);
	translate ([-end_width/4-wing_wide/2, -wing_long])
	circle (r=end_width/4, center=true);
	translate ([+end_width/4+wing_wide/2, -wing_long])
	circle (r=end_width/4, center=true);
	translate ([0, -wing_long+6])
	circle (r=end_width/2, center=true);
    }
}

module wing_imprint (){
    translate ([0,-4*wing_long/5,wing_thick-text_deep])
    linear_extrude(height=wing_thick+2)    
    text(wing_imprint_text, halign="center",
	valign="center",
	size=wing_imprint_size,
	font = wing_imprint_font);
}

module wing () {
    difference () {
	linear_extrude (height = wing_thick ) {
	    2d_wing ();
	}
	wing_imprint ();
    }
}


module washer () {
    difference () {
	cylinder (d=washer_dia, h=washer_thick);
	translate ([0,0,-1])
	cylinder(d=pencil_dia, h=thick-4);
    }
}

module stopper () {
    difference () {
	hull () {
	    cylinder (d=4*pencil_dia, h=2*screw_pos);
	    translate ([0,0,6*screw_pos])
	    sphere (r=screw_pos);
	    }
	translate ([0,0,-1])
	hull () {    
	    cylinder(d=pencil_dia, h=5*screw_pos-4);
	    translate ([0,0,6*screw_pos-2])
	    sphere (d=screw_pos);
	}

	// Screwhole
	translate ([0,0,screw_pos])
	rotate ([90,0,0])
	cylinder(d=screw_body, h=100);
	// Screwhead
	translate ([0,-screw_body_length,screw_pos])
	rotate ([90,0,0])
	cylinder(d=screw_head, h=100);
    }
}


// Fine rendering
$fa=1;
$fs=0.5;
$fn=20;

// Fast rendering
// $fa=20;
// $fs=12;
// $fn=6;

surface_thickness=5;
sc=100; // simplex_scale
no_surface_bars = 200;
frame_multiplier = 1.6;

// simplex_segre();
// cube_segre();
simplex_segre_flat();

// A bar with rounded corners
module bar (p1, p2, r1) { // Two end points and radius
    hull() {
    translate (p1) sphere (d = r1);
    translate (p2) sphere (d = r1);
    }
    // assign (p=p2-p1) translate (p1 + p/2) sphere (r1 = r);
}

module segre_surface () {
    // The surface
    for ( s = [ 0 : 1/no_surface_bars : 1])
    bar ([s*sc,0,s*sc], [sc*(1-s),sc,s*sc], surface_thickness);
}

module cube_segre() {
    bar ([0,0,0], [0,0,sc], frame_multiplier*surface_thickness);
    bar ([0,0,0], [0,sc,0], frame_multiplier*surface_thickness);
    bar ([0,0,0], [sc,0,0], frame_multiplier*surface_thickness);
    bar ([sc,0,0], [sc,sc,0], frame_multiplier*surface_thickness);
    bar ([sc,0,0], [sc,0,sc], frame_multiplier*surface_thickness);
    bar ([0,sc,0], [0,sc,sc], frame_multiplier*surface_thickness);
    bar ([0,sc,0], [sc,sc,0], frame_multiplier*surface_thickness);
    bar ([0,0,sc], [0,sc,sc], frame_multiplier*surface_thickness);
    bar ([0,0,sc], [sc,0,sc], frame_multiplier*surface_thickness);    
    bar ([sc,sc,0], [sc,sc,sc], frame_multiplier*surface_thickness);
    bar ([sc,0,sc], [sc,sc,sc], frame_multiplier*surface_thickness);
    bar ([0,sc,sc], [sc,sc,sc], frame_multiplier*surface_thickness);
    segre_surface();    
    }

module simplex_segre () {
    // The simplex
    bar ([0,0,0], [sc,sc,0], frame_multiplier*surface_thickness);
    bar ([0,0,0], [0,sc,sc], frame_multiplier*surface_thickness);
    bar ([0,0,0], [sc,0,sc], frame_multiplier*surface_thickness);
    bar ([sc,sc,0], [sc,0,sc], frame_multiplier*surface_thickness);
    bar ([0,sc,sc], [sc,0,sc], frame_multiplier*surface_thickness);
    bar ([sc,sc,0], [0,sc,sc], frame_multiplier*surface_thickness);
    segre_surface();
}

module simplex_segre_flat(){
    // lay the simplex flat and very mildly truncate it
    difference () {
	translate ([0,0,1/3*frame_multiplier*surface_thickness])
	rotate( v = [1,1,0], a = acos(1/sqrt(3))){
	    simplex_segre();
	}
	translate ([0,0,-1/2*surface_thickness])
	cube ([4*sc,4*sc,surface_thickness], center=true);
    }
}





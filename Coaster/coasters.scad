$fa=0.5;
$fs=0.5;

corner_rad=4; // Radius of rounded corner in mm
side=92; // side length
thick=3.2; // thickness
hole_deep=2.2; // How deep should the text be
text_prop=0.8; // Which proportion of side should text be wide
imprint_font="Arial Unicode MS";

coaster();

// Choose your imprint here:
module Imprint (){
    // EinsteinPythagorasImprint();
    // PoissonImprint ();
    PiImprint();
}

// Rule: The imprint centers itself, but it is scaled by the parent module
module PoissonImprint () {
    translate ([-20,0]){
	text("p(k)", halign="center", valign="center", font = imprint_font);
	translate([15,-1.35])
	text("=", halign="center", valign="center", font = imprint_font);
	translate ([20,0])
	square ([29,1]);
	translate ([26,9])
	text ("\u03BB", halign="center", valign="center", font=imprint_font);
	translate ([30,14])
	text ("k", halign="center", valign="center", font=imprint_font, size=6);
	translate ([39,7.5])
	text ("e", halign="center", valign="center", font=imprint_font);
	translate ([46,14])
	text ("-\u03BB", halign="center", valign="center", font=imprint_font, size=6);
	translate ([32,-7.5])
	text ("k!", halign="center", valign="center", font=imprint_font);
    }
}

module PiImprint () {
    translate([2,0]){
	// Times has a reasonable looking pi
	translate([-5,0])
	text("\u03C0",  size=15, halign="right",valign="center", font="Times New Roman");
	translate([-4,0])
	text("=3", halign="left", valign="center", font=imprint_font);
    }
}

module EinsteinPythagorasImprint () {
    text("E = m(a +b )", halign="center", valign="center", font = imprint_font);
    translate ([12,5.5])
    text("2", halign="center", valign="center", font = imprint_font, size=6);
    translate ([31,5.5])
    text("2", halign="center", valign="center", font = imprint_font, size=6);
    }

module coaster () {
// 4 cylinders and convex hull
dist=side-2*corner_rad;
difference (){
hull () {
	for (i = [-1,1])
	for (j = [-1,1])
	translate ([i*(side/2-corner_rad), j*(side/2-corner_rad), thick/2])
	cylinder (h=thick, r=corner_rad, center=true);
    }
    resize (newsize = [text_prop*side, 0, thick+2], auto=true)
      translate ([0,0,thick-hole_deep])
      linear_extrude(height=thick+2)    
      Imprint();
  }
}

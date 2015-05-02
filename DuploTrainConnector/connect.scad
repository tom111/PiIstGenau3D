$fa=1;
$fs=0.5;

// Connect two male ends of Duplo trains

height=5; // height of the part
d1 = 18; // original outer diameter from Duplo
d2 = d1-3;    // shrinked for better movement
inner_dia = 6.3; // Inner diameter


// part1();
// part2();
// connector_blocking();
connector_normal();

module default_part() {
    difference () {
	cylinder (d=d1, height, center=true);
	cylinder (d=8, h=height+2, center=true);
	translate ([5,0,0])
	cube ([10,inner_dia,6], center=true);
    }    
}

module part1 () {
    y = (d1-inner_dia)/2;
    x = 8.5;
    // This part is constructed so that it won't move on the train.
    difference () {
	union () {
	    cylinder (d=d1, height, center=true);
	    translate ([x/2,y,0])
	    cube ([x,y,height], center=true);
	    translate ([x/2,-y,0])
	    cube ([x,y,height], center=true);
	    }
	cylinder (d=8, h=height+2, center=true);
	translate ([5,0,0])
	cube ([10,inner_dia,6], center=true);
    }
}

module part2() {
    y = (18-inner_dia)/2;
    x = 3;
    // This part should move easily on the train
    difference () {
	cylinder (d=d2, height, center=true);
	cylinder (d=8, h=height+2, center=true);
	translate ([5,0,0])
	cube ([10,inner_dia,6], center=true);
    }
}

module connector_blocking () {
    translate ([7,0,0])
    part1();
    translate ([-7,0,0])
    mirror ([1,0,0])
    part2();
}

module connector_normal(){
    translate ([7,0,0])
    default_part();
    translate ([-7,0,0])
    mirror ([1,0,0])
    default_part();
    }
include <dankbowl-constants.scad>

tcanw = 130;
tcanh = 216;
tcand = 128;

// FIXME need eliminate some weight! take in the bottom as a pyramid
// at the bare minimum. currently 300g+

rotate([90, 0, 0]){ // put the final object in the xy plane
	translate([0, 0, -tcand]){
		difference(){
			roundedcube([tcanw, tcanh, tcand], false, 5, "ymax");
			translate([6 / 2, 6, 5 / 2]){
				roundedcube([tcanw - 6, tcanh, tcand - 6], false, 5);
			}
		}
	}

	/*translate([22, -tcanh + 20, -2]){
		rotate([0, 0, 30]){
			import("double M5.stl");
		}
	}*/

	translate([tcanw / 2, 75, 0]){
		rotate([0, 0, 30]){
			import("insert-hollow-for.stl");
		}
	}
}

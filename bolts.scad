include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <dankbowl-constants.scad>
// bolts for the front/back of the Bowls

singlew = mtotx / 2;
doublew = mtotx;

rotate([90, 0, 0]){
	translate([10, 0, 0]){
		screw("M4", length=singlew, thread_len=towerw / 2);
	}
	translate([20, 0, 0]){
		screw("M4", length=singlew, thread=0);
	}
	translate([30, 0, 0]){
		screw("M4", length=doublew, thread=0);
	}
}

rotate([90, 0, 0]){
	screw("M5", length=singlew, thread_len=towerw / 2);
	translate([-10, 0, 0]){
		screw("M5", length=singlew, thread=0);
	}
	translate([-20, 0, 0]){
		screw("M5", length=doublew, thread=0);
	}
}
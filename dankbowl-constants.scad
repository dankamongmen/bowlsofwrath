include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <roundedcube.scad>
include <hex.scad>
// common constants used across multiple files

$fa = 6;
//$fs = 1.75 / 2;
$fn = 32;

// a carton is 222mm long where it intersects with the bolt.
// two next to one another are 204mm wide with a ~20mm clearance.
// a carton is 250mm tall.

module multicolor(color) {
	if (current_color != "ALL" && current_color != color) { 
			// ignore our children.
			// (I originally used "scale([0,0,0])" which also works but isn't needed.) 
	} else {
			color(color)
			children();
	}        
}

boltd = 5;
wallr = 5;
wallx = 8;
wally = wallr;
wallz = wallr;
mainx = 204;
mainy = 76;
mainz = 222;
totx = mainx + wallx * 2;
totz = mainz + wallz * 2;
toty = mainy + wally;

towerd = 20;
towerw = 18;

bard = 3;

swatchx = 20;
swatchy = 20;
swatchz = 2;

rwallr = 8; // same thickness as honeycomb

fpanelx = (mainx - towerw) / 2;
fpanely = mainy;
fpanelz = 8;

height = 20;
wall = 1.8;

mtotx = mainx + rwallr * 2;
mtoty = mainy + rwallr;
mtotz = mainz + rwallr * 2 - 6;


// interaction between fpanels and extremal side of bowls:
// can be magnets and/or rotating, sliding slug.
// cutaway for 20x5x2mm bar magnet--triangle on top to avoid need for supports
magneth = 20;
magnetw = 5;
magnetd = 3; // give away 1mm
module maghole(y){
	translate([0, y, 0]){
		cube([magnetd, magneth, magnetw]);
		translate([0, 0, magnetw]){
			rotate([0, 90, 0]){
				linear_extrude(magnetd){
					polygon([[0, magneth], [magnetw / 2, magneth + magnetw / 2], [magnetw, magneth]]);
				}
			}
		}
	}
}

module magholes(){
	//translate([fpanelx - magnetd, 0, fpanelz / 2]){
		for(i = [rwallr + 5:magneth * 1.5:fpanely - rwallr]){
			maghole(i);
		}
	//}
}

// it needs to cross the full wall of the bowl, and leave room
// on the placard to easily manipulate it.
boltlength = rwallr * 4;
boltlatchw = 2;
sluglength = rwallr * 3;

module boltpath(){
	// first the bottom
	screw_hole("M5", length=mtotx*3, thread=false, orient=LEFT);
	// now the top
	translate([0, mainy - 10, 0]){
		screw_hole("M5", length=mtotx*3, thread=false, orient=LEFT);
	}
}
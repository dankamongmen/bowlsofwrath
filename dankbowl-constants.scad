include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <roundedcube.scad>
include <hex.scad>
// common constants used across multiple files

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


// interaction between fpanels and extremal side of bowls
// can be magnets and/or rotating, sliding slug
// cutaway for 5x3mm circular magnet
magnetr = 5 / 2;
magneth = 3;
module maghole(y){
	translate([0, y, 0]){
		rotate([0, 90, 0]){
			cylinder(magneth, magnetr, magnetr);
		}
	}
}

// it needs to cross the full wall of the bowl, and leave room
// on the placard to easily manipulate it.
boltlength = rwallr * 4;
boltlatchw = 2;
sluglength = rwallr * 3;
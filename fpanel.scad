include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <roundedcube.scad>
include <hex.scad>
include <dankbowl-constants.scad>

// front panel for the bowl. two fit on the front.
// they are held in at the top by an M5 bolt, and at
// the bottom by their clamp.

// viewport for hydrogmeter on front face. we use a kite
// to eliminate any need for supports.
vx = 60;
module viewport(){
	// a rectangular viewport would be 60x36
	vy = 36;
	// from 20-70x, 20-50y
	translate([(fpanelx - vx) / 2, 17, 0]){
		linear_extrude(fpanelz){
			polygon([[0, vy / 2], [vx / 2, vy], [vx, vy / 2], [vx / 2, 0]]);
		}
	}
}

lex = fpanelz / 2 - 1; // don't let them meet in the middle
module coretext(ftype){
	linear_extrude(lex){
		text(ftype, font="Prosto One");
	}
}

module drawtext(filtype){
	translate([fpanelx - 39, 10, fpanelz - lex]){
		coretext(filtype);
	}
	translate([35, 10, lex]){
		rotate([0, 180, 0]){
			coretext(filtype);
		}
	}
}

module sideplug(y){
	translate([-towerw / 2, fpanely - y, 0]){
		rotate([0, 90, 0]){
			r = 5 / 2 - .2; // fit in m5 hole with some allowance
			cylinder(towerw / 2, r, r);
		}
	}
}

module sidehole(y){
	translate([0, y, 0]){
		rotate([0, 90, 0]){
			r = (fpanelz - 2) / 2;
			cylinder(boltlength * 2, r, r);
		}
	}
	translate([0, y, 0]){
		cube([boltlatchw, fpanely - y, fpanelz / 2]);
	}
	translate([rwallr, y, 0]){
		cube([boltlatchw, fpanely - y, fpanelz / 2]);
	}
	translate([0, y, 0]){
		cube([rwallr, fpanely - y, boltlatchw]);
	}
}

module fpanel(filtype){
	multicolor("black"){
		difference(){
			// main panel, arise
			linear_extrude(fpanelz){
				translate([0, rwallr, 0]){
					/*translate([rwallr, 0, 0]){
						circle(rwallr);
					}*/
					translate([fpanelx - rwallr, 0, 0]){
						circle(rwallr);
					}
					square([fpanelx, fpanely - rwallr], false);
				}
				square([fpanelx - rwallr, rwallr, 0], false);
			}
			viewport();
			// through-hexagon into which a swatch can be inserted
			translate([14, fpanely - 20, 0]){
				rotate([0, 0, 30]){
					linear_extrude(fpanelz){
						circle(10, $fn=6);
					}
				}
			}
			translate([fpanelx - boltlength, 0, fpanelz / 2]){
				sidehole(fpanely - 7.4);
			}
			drawtext(filtype);
			// now as many magnet holes as will fit
			translate([fpanelx - magneth, 0, fpanelz / 2]){
				for(i = [rwallr + 1 + magnetr:magnetr * 4:fpanely - 20]){
					maghole(i);
				}
			}
		}
		translate([0, 0, fpanelz / 2]){
			sideplug(fpanely - 7.4);
			sideplug(5);
		}
	}
	multicolor("white"){
		drawtext(filtype);
	}
}
include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <hex.scad>
include <dankbowl-constants.scad>

// front panel for the bowl. two fit on the front.
// they are held in at the top by an M5 bolt, and at
// the bottom by their clamp.

// viewport for hydrogmeter on front face. we use a kite
// to eliminate any need for supports.
module vptriangle(){
	polygon([[0, 0], [6, 0], [0, 6]]);
}

module inroll(){
	roll = 5;
	difference(){
		square(roll);
		translate([roll, roll, 0]){
			circle(roll);
		}
	}
}

vx = 60;
module viewport(){
	// a rectangular viewport would be 60x36
	vy = 36;
	// from 20-70x, 20-50y
	translate([(fpanelx - vx) / 2, 17, 0]){
		/*
		linear_extrude(fpanelz){
			polygon([[0, vy / 2], [vx / 2, vy], [vx, vy / 2], [vx / 2, 0]]);
		}
		*/
		difference(){
			cube([60, 36, fpanelz]);
			linear_extrude(fpanelz){
				inroll();
				translate([60, 0, 0]){
					rotate([0, 0, 90]){
						vptriangle();
					}
				}
				translate([0, 36, 0]){
					rotate([0, 0, 270]){
						vptriangle();
					}
					translate([60, 0, 0]){
						rotate([0, 0, 180]){
							inroll();
						}
					}
				}
			}
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
	translate([(fpanelx - vx) / 2, 5, fpanelz - lex]){
		coretext(filtype);
	}
	translate([vx + 16, 5, lex]){
		rotate([0, 180, 0]){
			coretext(filtype);
		}
	}
}

// keep these short so that (a) they can be shoved in and (b)
// they're less likely to snap off.
module sideplug(y){
	translate([-5, fpanely - y, 0]){
		rotate([0, 90, 0]){
			r = 5 / 2 - .2; // fit in m5 hole with some allowance
			cylinder(5, r, r);
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
					translate([fpanelx - rwallr, 0, 0]){
						circle(rwallr);
					}
					translate([rwallr, 0, 0]){
						circle(rwallr);
					}
					square([fpanelx, fpanely - rwallr], false);
				}
				translate([rwallr, 0, 0]){
					square([fpanelx - 2 * rwallr, rwallr, 0], false);
				}
			}
			viewport();
			// through-hexagon into which a swatch can be inserted
			// FIXME ought just be a 1x1 honeycomb wall!
			translate([13.8, fpanely - 16, 0]){
				rotate([0, 0, -15]){
					linear_extrude(fpanelz){
						circle(sqrt(72), $fn=6);
					}
				}
			}
			drawtext(filtype);
			// now as many magnet holes as will fit
			translate([0, 0, (fpanelz - magnetw) / 2]){
				translate([fpanelx - magnetd, 0, 0]){
					magholes(false);
				}
				magholes(false);
			}
			translate([0, 5, fpanelz / 2]){
				boltpath();
			}
		}
	}
	multicolor("white"){
		drawtext(filtype);
	}
}

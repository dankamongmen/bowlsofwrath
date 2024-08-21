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
	translate([-fpanelz / 2, 17, (fpanelx + vx) / 2]){
		rotate([0, 90, 0]){
			linear_extrude(fpanelz){
				polygon([[0, vy / 2], [vx / 2, vy], [vx, vy / 2], [vx / 2, 0]]);
			}
		}
	}
}

module coretext(ftype){
	lex = fpanelz / 2 - 1; // don't let them meet in the middle
	rotate([0, 90, 0]){
		linear_extrude(lex){
			text(ftype, font="Prosto One");
		}
	}
}

module drawtext(filtype){
	translate([1, 14, 90]){
		coretext(filtype);
	}
	translate([-1, 14, 57]){
		rotate([0, 180, 0]){
			coretext(filtype);
		}
	}
}

module fpanel(filtype){
	rotate([0, 90, 0]){
		multicolor("black"){
			difference(){
				union(){
					// main panel cube
					translate([-fpanelz / 2, 0, 0]){
						cube([fpanelz, fpanely - clampr - 5.5, fpanelx]);
					}
					// decorative rounding at the top
					translate([0, fpanely - 8, 0]){
						cylinder(fpanelx, 4, 4);
					}	
				}
				union(){
					viewport();
					// top cylinder interior
					translate([0.5, fpanely - 10, 0]){
						screw_hole("M5", length = 200, thread=false);
					}
					// bottom cylinder interior
					translate([0.5, 5, 0]){
						screw_hole("M5", length = 200, thread=false);
					}
					// through-hexagon into which a swatch can be inserted
					translate([-4, 20, 14]){
						rotate([30, 0, 0])
						rotate([0, 90, 0]){
							linear_extrude(fpanelz){
								circle(10, $fn=6);
							}
						}
					}
					drawtext(filtype);
				}
			}
		}
		multicolor("white"){
			drawtext(filtype);
		}
	}
}
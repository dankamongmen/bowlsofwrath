include <dankbowl-constants.scad>

$fa = 6;
$fs = 1.75 / 2;
$fn = 16;

// 0.0.99 -- external rounding only with "y" to properly hold combs
//           lined up througholes better
// 0.0.98 -- properly oriented side honeycomb for external latching

current_color = "ALL";

htotx = height + 2 * wall - 0.05; // FIXME eliminate
xoffbase = -100.2; // FIXME eliminate
module lfill(){
	polygon([[xoffbase, -33],
				 [xoffbase, -29 + htotx],
				 [xoffbase + htotx / 2 + 0.5, -28 + 2 * htotx / 3],
				 [xoffbase + htotx / 2 + 0.5, -35 + htotx / 3]]);
}

//hexh = 5.77349; // 10**2 + x**2 = 11.547**2
hexh = 7.5;
hexy = 26.5;
module sidecomb(){
	translate([0, mtoty / 2, mtotz / 2 - 3]){
		rotate([0, 90, 0]){
			hexwall(8, 3);
			// fill in the top holes (on the left side, bottom on right)
			for(i = [0:1:7]){
				linear_extrude(8){
					polygon([[xoffbase + i * htotx, hexy + hexh],
									 [xoffbase + i * htotx + 11.8, hexy],
									 [xoffbase + i * htotx + 23.6, hexy + hexh]]);
					polygon([[xoffbase + i * htotx, -hexy - hexh],
									 [xoffbase + i * htotx + 11.8, -hexy],
									 [xoffbase + i * htotx + 23.6, -hexy - hexh]]);
				}
			}
			linear_extrude(8){
				polygon([[xoffbase + 8 * htotx, 34],
				         [xoffbase + 8 * htotx + wall + height / 2, 27],
				         [xoffbase + 8 * htotx + wall + height / 2, 34]]);
				polygon([[xoffbase + 8 * htotx, -34],
				         [xoffbase + 8 * htotx + wall + height / 2, -27],
				         [xoffbase + 8 * htotx + wall + height / 2, -34]]);
				// fill in the front holes on both sides
				translate([0, -1, 0]){
					lfill();
				}
				translate([0, height * 2, 0]){
					lfill();
				}
				// fill in the back hole on both sides
				translate([0, height - 1, 0]){
					mirror([1, 0, 0]){
						lfill();
					}
				}
			}
		}
	}
}

difference(){
	// the primary bowl
	roundedcube([mtotx, mtoty, mtotz], false, rwallr, "y");
	//cube([mtotx, mtoty, mtotz]);
	// remove the core, leaving filleted inside
	translate([(mtotx - mainx) / 2, rwallr, -rwallr]){
		roundedcube([mainx, mainy, mainz * rwallr], false, wallr, "ymin");
	}
	// remove the bottom half of the bottom
	translate([0, 0, 0]){
		cube([mtotx, rwallr / 2, mtotz]);
	}
	// remove the sides to insert the honeycomb
	translate([0, rwallr + wallr, rwallr + wallr + 5]){
		cube([mtotx, mainy - rwallr - wallr -1, mainz - wallr - 19]);
	}
	// passageways for bolts (front then back)
	translate([0, mtoty - rwallr - boltd / 2, mtotz - towerd / 2 + boltd / 2]){
		rotate([0, 90, 0]){
			cylinder(mtotx, boltd / 2, boltd / 2);
			translate([0, -65, 0]){
				screw_hole("M5", length=mtotx*3, thread=false);
			}
		}
	}
	translate([0, mtoty - rwallr - boltd / 2, towerd / 2 - boltd / 2]){
		rotate([0, 90, 0]){
			cylinder(mtotx, boltd / 2, boltd / 2);
			translate([0, -65, 0]){
				screw_hole("M5", length=mtotx*3, thread=false);
			}
		}
	}
	translate([mtotx - 14, 7, mtotz - 20]){
		rotate([90, 90, 180]){
			linear_extrude(2){
				text("v0.0.99 2024-08-19", size=4);
			}
		}
	}
}

multicolor("green"){
	// left side
	translate([0, 1, 5]){
		sidecomb();
	}
	// right side
	translate([totx - 8, 1, wallz]){
		translate([8, mtoty, 0]){
			rotate([180, 180, 0]){
				sidecomb();
			}
		}
	}
}

module tower(){
	// tower in front/back centers for bolts
	// we have about 20mm of gap between the two boxes
	difference(){
		rotate([0, 90, 0]){
			// triangle support for tower
			translate([0, 0, wallr]){
				linear_extrude(towerw - wallr * 2){
						polygon([
							[towerd / 2, 0],
							[towerd / 2, mainy - 2],
							[towerd, 0]
						]);
				}
			}
			roundedcube([towerd - wallz * 3 + 1, mainy - 2, towerw], false, wallr, "y");
		}
		// top hole
		translate([towerw / 2, mainy - 8 - boltd / 2, -3.4]){
			screw_hole("M5", length=towerw, thread=true, orient=LEFT);
		}
		// bottom hole
		translate([towerw / 2, 4.5, -3.4]){
			screw_hole("M5", length=towerw, thread=true, orient=LEFT);
		}		
	}
}

multicolor("blue"){
	// tower in the front
	translate([mtotx / 2 - towerw / 2, 8, mtotz - wallr + 1]){
		tower();
	}
	// tower in the back (aligned to x axis)
	translate([mtotx / 2 - towerw / 2, 8, wallr - 1]){
		mirror([0, 0, 1]){
			tower();
		}
	}
} // blue

// for testing
/*multicolor("red"){
	translate([0, mtoty - rwallr - boltd / 2, towerd / 2 - boltd / 2]){
		rotate([0, 90, 0]){
			cylinder(mtotx, boltd / 2, boltd / 2);
			translate([0, -65, 0]){
				cylinder(mtotx, boltd / 2, boltd / 2);
			}
		}
	}
	translate([0, mtoty - rwallr - boltd / 2, mtotz - towerd / 2 + boltd / 2]){
		rotate([0, 90, 0]){
			cylinder(mtotx, boltd / 2, boltd / 2);
			translate([0, -65, 0]){
				cylinder(mtotx, boltd / 2, boltd / 2);
			}
		}
	}
	translate([0, 24.6, 29.6]){
		rotate([30, 0, 0]){
			rotate([0, 90, 0]){
				linear_extrude(mtotx){
					circle(13.6, $fn=6);
				}
			}
		}
	}
}*/

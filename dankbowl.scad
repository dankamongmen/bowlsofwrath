include <dankbowl-constants.scad>

// user configuration begins **********************
// the bottom can either be 8mm thick, and implement a honeycomb
//  oriented for insertion from below (set hcombbottom true), or it
//  can be a solid 4mm (set hcombbottom false).
hcombbottom = true;
// user configuration ends ************************

$fa = 6;
$fs = 1.75 / 2;
$fn = 16;

// 0.0.99 -- external rounding only with "y" to properly hold combs
//           lined up througholes better
//           added optional honeycomb bottom
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
lex = 8.1002;
module sidecomb(){
	translate([0, mtoty / 2, mtotz / 2 - 3]){
		rotate([0, 90, 0]){
			hexwall(8, 3);
			// fill in the top holes (on the left side, bottom on right)
			for(i = [0:1:7]){
				linear_extrude(lex){
					polygon([[xoffbase + i * htotx, hexy + hexh],
									 [xoffbase + i * htotx + 11.8, hexy],
									 [xoffbase + i * htotx + 23.6, hexy + hexh]]);
					polygon([[xoffbase + i * htotx, -hexy - hexh],
									 [xoffbase + i * htotx + 11.8, -hexy],
									 [xoffbase + i * htotx + 23.6, -hexy - hexh]]);
				}
			}
			linear_extrude(lex){
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

module bfill(x){
	polygon([[-33, x],
				 [-29 + htotx, x],
				 [-28 + 2 * htotx / 3, x + htotx / 2 + 0.5],
				 [-35 + htotx / 3, x + htotx / 2 + 0.5]]);
}

module bottom(){
	difference(){
		translate([mainx / 2 + rwallr, 0, mainz / 2 + rwallr - 1]){
			rotate([0, 90, 0]){
				rotate([270, 0, 0]){
					hexwall(7, 9);
					// fill in front and back
					for(i = [0:1:4]){
						translate([-88, 40.8 * i - 81.5, 0]){
							rotate([0, 0, 90]){
								linear_extrude(lex){
									circle(14, $fn = 6);
								}
							}
						}
					}
					for(i = [0:1:3]){
						translate([88, 40.8 * i - 61, 0]){
							rotate([0, 0, 90]){
								linear_extrude(lex){
									circle(14, $fn = 6);
								}
							}
						}
					}
					// fill in left and right
					for(i = [0:1:7]){
						translate([23.5 * i - 76, -mainx / 2, 0]){
							rotate([0, 0, 90]){
								linear_extrude(lex){
									circle(14, $fn = 6);
								}
							}
						}
						translate([23.5 * i - 76, mainx / 2, 0]){
							rotate([0, 0, 90]){
								linear_extrude(lex){
									circle(14, $fn = 6);
								}
							}
						}
					}
				}
			}
		}
		// remove anything leaking over the sides
		union(){
			translate([mtotx, 0, 0]){
				cube([10, lex, mtotz]);
			}
			translate([-10, 0, 0]){
				cube([10, lex, mtotz]);
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
	if(hcombbottom){
		// remove the bottom
		translate([rwallr * 2 - 1, 0, towerd + 10]){
			cube([mtotx - rwallr * 4 + 2, rwallr * 10, mtotz - towerd * 2 - 16]);
		}
	}else{
		// remove the bottom half of the bottom
		cube([mtotx, rwallr / 2, mtotz]);
	}
	// remove the sides to insert the honeycomb
	translate([0, rwallr + wallr, rwallr + wallr + 5]){
		cube([mtotx, mainy - rwallr - wallr -1, mainz - wallr - 19]);
	}
	// passageways for bolts (front then back)
	translate([0, mtoty - rwallr - boltd / 2, mtotz - towerd / 2 + boltd / 2 + 1]){
		rotate([0, 90, 0]){
			cylinder(mtotx, boltd / 2, boltd / 2);
			translate([0, -65, 0]){
				screw_hole("M5", length=mtotx*3, thread=false);
			}
		}
	}
	translate([0, mtoty - rwallr - boltd / 2, towerd / 2 - boltd / 2 - 1]){
		rotate([0, 90, 0]){
			cylinder(mtotx, boltd / 2, boltd / 2);
			translate([0, -65, 0]){
				screw_hole("M5", length=mtotx*3, thread=false);
			}
		}
	}
	translate([mtotx - 20, 7, mtotz - 10]){
		rotate([90, 0, 180]){
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
	if(hcombbottom){
		bottom();
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
		translate([towerw / 2, mainy - 8 - boltd / 2, -2.4]){
			screw_hole("M5", length=towerw, thread=true, orient=LEFT);
		}
		// bottom hole
		translate([towerw / 2, 4.5, -2.4]){
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

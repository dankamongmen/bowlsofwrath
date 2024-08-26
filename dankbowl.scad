include <dankbowl-constants.scad>
include <fpanel.scad>

// 0.0.997 -- perfect rounding on interior
// 0.0.996 -- fermilab style sides on towers
//            switch to bar magnets
// 0.0.995 -- added cutaways for magnets
//            boxed off back of towers
// 0.0.992 -- reduced height by 4mm
//            fixed up some minor manifold faults
//            honeycomb bottom is mandatory
// 0.0.991 -- lined up througholes better
//            added optional honeycomb bottom
//            moved out holes for 2mm more length
// 0.0.99 -- external rounding only with "y" to properly hold combs
// 0.0.98 -- properly oriented side honeycomb for external latching

current_color = "ALL";

module lfill(xoffbase){
	polygon([[xoffbase, -33.5],
				 [xoffbase, -29 + htotx],
				 [xoffbase + htotx / 2 + 0.5, -28 + 2 * htotx / 3],
				 [xoffbase + htotx / 2 + 0.5, -35 + htotx / 3]]);
}

module bfill(x){
	polygon([[-33, x],
				 [-29 + htotx, x],
				 [-28 + 2 * htotx / 3, x + htotx / 2 + 0.5],
				 [-35 + htotx / 3, x + htotx / 2 + 0.5]]);
}

//hexh = 5.77349; // 10**2 + x**2 = 11.547**2
hexh = 7.5;
hexy = 26.5;
lex = 8.1002;
htotx = height + 2 * wall - 0.05; // FIXME eliminate

// the sidecomb ought be mtoty - rwallr * 2 tall,
// mtotz - rwallr * 2 long, and rwallr deep.
module sidecomb(){
	xoffbase = -100.2; // FIXME eliminate
	translate([0, mtoty / 2 + rwallr, mtotz / 2]){
		rotate([0, 90, 0]){
			intersection(){
				union(){
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
							lfill(xoffbase);
						}
						translate([0, height * 2, 0]){
							lfill(xoffbase);
						}
						// fill in the back hole on both sides
						translate([0, height - 0.75, 0]){
							mirror([1, 0, 0]){
								lfill(xoffbase);
							}
						}
					}
					// fill in the remaining front
					translate([mtotz / 2 - rwallr * 2, -mtoty / 2 + rwallr, 0]){
						cube([rwallr, mtoty - rwallr * 2, rwallr]);
					}
					// fill in the remaining back
					translate([-mtotz / 2 + rwallr, -mtoty / 2 + rwallr, 0]){
						cube([rwallr, mtoty - rwallr * 2, rwallr]);
					}
				} // end union
				// should fill this space:
				translate([0, 0, rwallr / 2]){
					cube([mtotz - rwallr * 2, mtoty - rwallr * 2, rwallr], true);
				}
			} // end intersection
		} // end rotate
	} // end translate
}

module bottom(){
	intersection(){
		// want to line up with the middle rows on the sides
		translate([mainx / 2 + rwallr, 0, mainz / 2 + rwallr - 3]){
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
		translate([rwallr, 0, rwallr]){
			cube([mtotx - rwallr * 2, lex, mtotz - rwallr * 2]);
		}
	}
}

module magholepair(){
	translate([0, 0, (fpanelz - magnetw) / 2]){
		magholes();
	}
	translate([0, 0, mtotz - magnetw - (fpanelz - magnetw) / 2]){
		magholes();
	}
}

module tower(){
	// tower in front/back centers for bolts
	// we have about 20mm of gap between the two boxes
	difference(){
		union(){
			rotate([0, 90, 0]){
				// triangle support for tower
				translate([0, 0, wallr]){
					linear_extrude(towerw - wallr * 2){
							polygon([
								[towerd / 2, 0],
								[towerd / 2, mainy - wallr],
								[towerd, 0]
							]);
					}
				}
				roundedcube([towerd - wallz * 3 + 1, mainy, towerw], false, wallr, "xmin");
			}
			// restore full bottom
			translate([-rwallr, 0, -towerd / 2 - 1]){
				difference(){
					cube([towerw + rwallr * 2, 9, towerd / 2 + wallr]);
					translate([0, rwallr, 0]){
						linear_extrude(towerd / 2 + wallr){
							circle(rwallr);
							translate([towerw + rwallr * 2, 0, 0]){
								circle(rwallr);
							}
						}
					}
				}
			}
		}
		// top hole
		translate([towerw / 2, mainy - 5, 0]){
			screw_hole("M5", length=towerw + rwallr * 2, thread=true, orient=LEFT);
		}
		// bottom hole
		translate([towerw / 2, 5, 0]){
			screw_hole("M5", length=towerw + rwallr * 2, thread=true, orient=LEFT);
		}
		translate([0, 0, -fpanelz / 2]){
			magholepair();
			translate([towerw - magnetd, 0, 0]){
				magholepair();
			}
		}
	}
}

// rotate the entirety to sit on the plate naturally
rotate([90, 0, 0]){
	difference(){
		union(){
			difference(){
				// the primary bowl
				roundedcube([mtotx, mtoty, mtotz], false, rwallr, "ymin");
				// remove the bottom
				translate([rwallr * 2, 0, towerd + 8]){
					cube([mtotx - rwallr * 4, rwallr, mtotz - towerd * 2 - 16]);
				}
				// remove the sides to insert the honeycomb
				translate([0, rwallr * 2, rwallr]){
					cube([mtotx, mtoty - rwallr * 2, mtotz - rwallr * 2]);
				}
				// passageways for bolts (front then back)
				translate([0, rwallr + 5, mtotz - fpanelz / 2]){
					boltpath();
				}
				translate([0, rwallr + 5, fpanelz / 2]){
					boltpath();
				}
				translate([rwallr - magnetd + 0.1, rwallr, 0]){
					magholepair();
				}
				translate([mtotx - rwallr - 0.1, rwallr, 0]){
					magholepair();
				}
				translate([mtotx - 20, 7, mtotz - 10]){
					rotate([90, 0, 180]){
						linear_extrude(2){
							text("v0.0.997 2024-08-26", size=4);
						}
					}
				}
			}

			multicolor("green"){
				// left side. don't translate -- the hole ought come to meet us
				// (thus requiring less translation for the other side).
				sidecomb();
			}
			
			multicolor("pink"){
				// right side
				translate([totx, mtoty + rwallr * 2, 0]){
					rotate([180, 180, 0]){
						sidecomb();
					}
				}
			}
			
			multicolor("white"){
				bottom();
			}
		}
		// remove the core, leaving filleted inside
		translate([(mtotx - mainx) / 2, rwallr * 2, -rwallr]){
			cube([mainx, mtoty - rwallr * 2, mtotz + 2 * rwallr]);
			translate([rwallr, -rwallr, 0]){
				cube([mainx - rwallr * 2, rwallr, mtotz + 2 * rwallr]);
			}
		}
		translate([rwallr * 2, rwallr * 2, 0]){
			linear_extrude(mtotz){
				circle(rwallr);
			}
		}
		translate([mtotx - rwallr * 2, rwallr * 2, 0]){
			linear_extrude(mtotz){
				circle(rwallr);
			}
		}
	}	// end difference

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
	multicolor("red"){
		/*translate([0, rwallr + 5, mtotz - fpanelz / 2]){
			boltpath();
		}
		translate([0, rwallr + 5, fpanelz / 2]){
			boltpath();
		}
		translate([0, 30, 27.2]){
			rotate([30, 0, 0]){
				rotate([0, 90, 0]){
					linear_extrude(mtotx){
						circle(13.6, $fn=6);
					}
				}
			}
		}*/
	}
} // end rotation
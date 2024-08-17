// minimized from https://www.printables.com/model/152592-honeycomb-storage-wall

// numx: number of hexagons to make in the X axis
// numy: number of hexagons to make in the Y axis
module hexwall(numx, numy){
	/* [Shape of the hexes - you probably don't want to mess with these]  */
	// thickness of the thinner wall
	wall=1.8; //[:0.01]

	// Height of the hexagon
	height=20;

	// Calculates the long diagonal (the diameter of a circle inscribed on the hexagon) from the short diagonal (the height of the hexagon)
	function ld_from_sd(short_diameter) =
			(2/sqrt(3)*short_diameter);
			
	// Calculates the edge length (length of one side) from the short diagonal (the height of the hexagon)
	function a_from_sd(short_diameter) =
			(short_diameter/sqrt(3));

	module cell(height, wall) {
			union() {
					tube(od=ld_from_sd(height+wall*2), id1=ld_from_sd(height)+0.5, id2=ld_from_sd(height), h=0.5, $fn=6, anchor=BOTTOM);
					up(0.5) tube(od=ld_from_sd(height+wall*2), id=2/sqrt(3)*height, h=4.5, $fn=6, anchor=BOTTOM);
					up(5) tube(od=ld_from_sd(height+wall*2), id1=ld_from_sd(height),id2=ld_from_sd(height+wall), h=1, $fn=6, anchor=BOTTOM);
					up(6) tube(od=ld_from_sd(height+wall*2), id=ld_from_sd(height+wall), h=2, $fn=6, anchor=BOTTOM);
			}
	}

	module section(numx, numy) {
			grid_copies(n=[numx,numy], spacing=sqrt(3)/2 * (height+wall*4), stagger=true) {
				zrot(30) cell(height, wall);
			}
	}

	module section_unioned_with_cutout(numx,numy) {
		section(numx,numy);
	}

	mirror([1,0,0]) section_unioned_with_cutout(numx*2,numy);
}

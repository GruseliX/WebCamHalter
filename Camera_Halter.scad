include <BOSL2/std.scad>
include <BOSL2/threading.scad>

/*  [Hidden] */
$fn = 100;
$fa = 32;
$fs = 0.1;

/* [Display] */
// Base
show_base = true;
// Scharaube
show_screw = true;
show_housing = true;

/* [Befestigung] */

// Maße Der Befestigung
dim_bef = [ 30.0, 40.0, 3.0 ];
// Farbe des Befestigungsteils
color_bef = "slategrey";
// Durchmesser Stütze
d_nups = 5;
// Lange der Stützen
l_nups = 4;
// Abstand vom Mittelpunkt
dist_to_center_nups = d_nups / 2 + 6;
// Wand Rahmen
wall_border = 3;
// Dimensionen Rahmen
dim_border = [ 23, 23, 4 ];

/* [Schraube] */

// Durchmesser
d_thread = 4.95; //M6
// Länge
h_thread = 8.0;
// Farbe des Schraubenteils
color_wheel = "DeepPink";
// Zahnung
pitch_thread = 1.0;
// Abschluss
end_len_thread = 0.3;
// Fase
bevel_thread = true;
// Zugabe
offset_thread = 0.3;
// Wie tief eingedreht
inserted_thread = -0;
// Maße des Rades
dim_wheel = [ 32, 3 ];
// Abstand
clearence_wheel = 0.2;

/* [Gehäuse] */
// Maße des Gehäuses
dim_housing = [ 30, 40, 8 ];
// Farbe des Gehäuseteils
color_housing = "slategrey";

module screw()
{
	color(color_wheel, 1)
	{
		translate([ 0, 0, inserted_thread ])
		{
			union()
			{
				threaded_rod(d = d_thread, h = h_thread, pitch = pitch_thread, end_len = end_len_thread,
				             bevel = bevel_thread);
				translate([ 0, 0, -(dim_bef[2] / 2 + dim_wheel[1] + clearence_wheel) ])
				{
					cyl(d1 = dim_wheel[0], d2 = dim_wheel[0], h = dim_wheel[1], rounding = 0.1, texture = "trunc_ribs",
					    tex_size = [ 2, 2 ]);
				}
			}
		}
	}
}

module base_plate()
{
	color(color_bef, 1)
	{
		union()
		{
			difference()
			{
				// ground plate
				translate([ 0, 0, -dim_bef[2] / 2 ])
				{
					cuboid(dim_bef, rounding = 0.1,
					       edges =
					           [
						           TOP + FRONT, TOP + RIGHT, TOP + BACK, TOP + LEFT, FRONT + RIGHT, FRONT + LEFT,
						           BACK + RIGHT, BACK +
						           LEFT
					           ],
					       $fn = 4);
				}

				// extra clearence for the screw
				translate([ 0, 0, -(dim_bef[2] + offset_thread) ])
				{
					cylinder(h = dim_bef[2] + 2.0 * offset_thread, r = (d_thread) / 2.0 + offset_thread);
				}
			}

			// Nupsi 0
			rotate([ 0, 180, 0 ])
			{
				translate([ 0, -dist_to_center_nups, -l_nups / 2 ])
				{

					cyl(l = l_nups, d = d_nups, chamfer1 = d_nups / 2 - 1, chamfang = 75, from_end = true);
				}
			}

			// Nupsi 1
			rotate([ 0, 180, 0 ])
			{
				translate([ 0, dist_to_center_nups, -l_nups / 2 ])
				{

					cyl(l = l_nups, d = d_nups, chamfer1 = d_nups / 2 - 1, chamfang = 75, from_end = true);
				}
			}

			// border
			translate([ 0, 0, 0 ])
			{
				% rect_tube(size = dim_border[0] + wall_border, wall = wall_border, rounding = 0.5, h = 4);
			}
		}
	}
}

module housing()
{
	color(color_housing, 1)
	{
		difference()
		{
			union()
			{
				translate([ 0, 0, -(dim_bef[2] + dim_housing[2]) ])
				{
					rect_tube(size = [ dim_housing[0], dim_housing[1] ], wall = 3, rounding = 0.5, h = dim_housing[2]);

					translate([ 0, 0, dim_housing[2] * 1 / 6 ])
					{
						cuboid(size = [ dim_housing[0] - 3, dim_housing[1] - 3, dim_housing[2] * 1 / 3 ]);
					}
				}
			}
			translate([ 0, 0, -(dim_bef[2] / 2 + dim_wheel[1] + 0.5) ])
			{
				cuboid(size = [ dim_wheel[0] + 8, dim_wheel[0], dim_wheel[1] + 0.4 ]);
			}
		}
	}
}

if (show_base == true)
	base_plate();
if (show_screw == true)
	screw();
if (show_housing == true)
	housing();

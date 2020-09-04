// E60 Rear Window Regulator clasp
// Designed by Sean Clulow
// Version 0.2.0

/*
The profile of the window regulator cable cover/clasp is G shaped.
For descriptive purposes we will call the 3 main sides of the clasp "top", "side" and "bottom", with the a "tongue" protuding inwards from the "bottom".
However in the CAD model the "side" of the regulator is allighed with the yz (x=0) plane and the "bottom" is alligned with the xz (y=0) plane and the the top is in the +ve y dimension (parallel to the xzplane) .
This is to ensure when 3D printed, the (theoretically) weaker z plane is at right angles to any loads or stressors
I have increased the thickness of the clasp to 1.5mm to permit easier printing.
*/


$fa=1;
$fs=0.4;
center=false;

wid=19; // Width of Main Body (x-axis)
dep=12.5; // Depth of Main Body (y-axis)
hig=39; // Height of Main Body (z-axis)
size=[wid,dep,hig];
//zcent is the mirror plane (on z axis)
zcent=hig/2;
radius=1.5;
thickness=1.5;
xplanes=[0,thickness, wid-thickness, wid];
yplanes=[0,thickness, dep-thickness, dep];
// Working anti-clockwise round the profile from the open end.
z0=hig; //height of clasp
z1 = 24; // 2nd (triangular) step on RHS of clasp "top"
z2= 27; // 1st step on RHS of clasp top
z3= 32; // LHS of "top" and first step on "side" i.e. max height of "side"
z4= 20; // 2nd (triangular) step on "side" of clasp
z5=10; // 3rd step on "side" and first step on "bottom" max height of "bottom"
z6=5; // 2nd step on "bottom" and height of "tongue"
zheights=[z0, z1, z2, z3, z4, z5, z6];
zpoints=[for(i = [0 : len(zheights) - 1]) [zcent-zheights[i]/2, zcent+zheights[i]/2]];
echo(xplanes);
echo(yplanes);
echo(zpoints);

// Create main bulk and Hollow out
// the shapes to remove material are deliberately increased by 1mm top and bottop in z dimension to eliminate "artifacts" in rendering

difference()
{
	//Main Body
	union()
	{
		translate([radius,0,0]) color("blue") cube(size - [2*radius,0,0]);
		translate([0,radius,0]) color("green") cube(size - [0,2*radius,0]);
		// Round Corners
		for (x = [radius, size[0]-radius], y = [radius, size[1]-radius]) {
			translate([x,y,0]) color("red") cylinder(r=radius, h=size[2]);
		};
		// Bump for Cable ends
		translate([7.5,8,0]) color("pink") cylinder(h=size[2], r=5);
		// Reinforcement over bump
		translate([3.5,11.5,4.5]) color("yellow") cube([12.5 ,2.5,30]);
	}
	// Hollow out (subtraction) in z direction
	// Gap for main Body
	translate([xplanes[1],yplanes[1],0]) cube([14,yplanes[2]-yplanes[1],hig]);

	// Gap above tongue
	translate([15.5,4,0]) cube([2,7,hig]);

	// Gap outside (in front of or to the left of) tongue
	translate([17.5,0,0]) cube([1.5,11,hig]);

	// Grove for cable ends
	translate([7.5,8,0]) cylinder(h=hig, r=3.5);

	// champher on tongue
	linear_extrude(height = hig) polygon(points=[[17.5, 3], [16.5, 4], [17.5,4]]);

	// champher on "top" open (right hand) side that slides under the lip
	linear_extrude(height = hig) polygon(points=[[16.5, 12.5], [19, 12.5], [19,11.5]]);

	// End of Z subtraction

	// Subtraction to Shape "top" of clasp (above cable ends) on the right hand side

	translate([16.5,yplanes[2],0]) cube([2.5,thickness,zpoints[2][0]]);
	translate([16.5,yplanes[2],zpoints[2][1]]) cube([2.5,thickness,zpoints[2][0]]);

	// triangles
	T1=[[0,0], [0,2.5], [2.5,0]];
	translate([wid,yplanes[2], 6]) rotate([90, 0, 180]) linear_extrude(height = thickness) polygon(T1);
	translate([wid,yplanes[2], 33]) rotate([0,90,90]) linear_extrude(height = thickness) polygon(T1);

	// Round the corners
	difference()
	{
	translate([13.5,yplanes[2],0]) cube([3,thickness,3]);
	translate([13.5,yplanes[2],3]) rotate([90, 0, 180]) cylinder(r=3, h=thickness);
	}
	difference()
	{
	translate([13.5,yplanes[2],36]) cube([3,thickness,3]);
	translate([13.5,yplanes[2],36]) rotate([90, 0, 180]) cylinder(r=3, h=thickness);
	}

	// Subtraction to Shape side of clasp

	// Remove Blocks top and bottom
	translate([0,0,0]) cube([4,dep,zpoints[3][0]]);
	translate([0,0,zpoints[3][1]]) cube([4,dep,zpoints[3][0]]);

	// Remove Triangle
	T2 = [[0,0], [0,7], [7,0]];
	translate([0,2, 3.5]) rotate([90, 0, 90]) linear_extrude(height = thickness) polygon(T2);
	translate([0,2, 35.5]) rotate([0,90,0]) linear_extrude(height = thickness) polygon(T2);

	// Subtraction to Shape underside of clasp
	// Remove blocks top and bottom
	translate([0,0,0]) cube([wid,3,zpoints[5][0]]);
	translate([0,0,zpoints[5][1]]) cube([wid,3,zpoints[5][0]]);

	// Subtraction to Shape tongue of clasp

	translate([14,0,0]) cube([4,5.5,zpoints[6][0]]);
	translate([14,0,zpoints[6][1]]) cube([4,5.5, zpoints[6][0]]);

	//End of subtraction
}

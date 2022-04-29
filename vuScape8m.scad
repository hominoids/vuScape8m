/*
    vuScape8m Case Copyright 2022 Edward A. Kisiel
    hominoid @ www.forum.odroid.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    Code released under GPLv3: http://www.gnu.org/licenses/gpl.html

    2022xxxx Version 1.0.0    vuScape8m Vu8m SBC Case initial release
    
*/

use <./lib/fillets.scad>;
use <./lib/sbc_models.scad>;
use <./lib/sbc_case_builder_library.scad>;

view = "model";                     // viewing mode "platter", "model", "debug"
sbc_model = "m1";                   // sbc "c4"
fan = true;                         // fan (true or false)
vent = true;                        // vent (true or false)
bracket = "none";                   // bracket style "none","arch","speaker"

sbc_off = false;                    // sbc off in model view (true or false)
vu8m_off = false;                   // vu8m off in model view (true or false)
move_bottom = 0;                    // moves top mm in model view or < 0 = off
move_top = 0;                       // moves bottom mm in model view or < 0 = off
move_cover = 0;                     // moves sbc cover mm in model view or < 0 = off    

case_offset_x = 0;                  // additional case x axis
case_offset_y = 16;                 // additional case y axis size 16mm
case_offset_tz = 0;                 // additional case top z axis size 4.5 min.
case_offset_bz = 0;                 // additional case bottom z axis size

wallthick = 2.5;                    // case wall thickness
floorthick = 2;                     // case floor thickness
topthick = 2;                       // case top thickness
sidethick = 2;                      // case side thickness
gap = 1;                            // distance between pcb and case

h_depth = 123;                      // heatsink width

c_width = 175+2*(wallthick+gap);    // cover width
c_depth = 132+2*(wallthick+gap);    // cover depth
c_height = 28+topthick+gap;         // cover height 28 with access panel

c_fillet = 6;                       // corner fillets
fillet = 0;                         // edge fillets
tab_clearance = 8;
view_angle = 15;
lcd_size = [198,133,4.45];
view_size = [172.224,107.64,.125];        // 154.21 x 85.92
pcb_tmaxz = 7.5;
pcb_bmaxz = 5;

width = lcd_size[0]+(2*(wallthick+gap))+case_offset_x;
depth = lcd_size[1]+(2*(wallthick+gap))+case_offset_y;
top_height = pcb_tmaxz+topthick+case_offset_tz;
bottom_height = pcb_bmaxz+floorthick+case_offset_bz;
case_z = bottom_height+top_height;

bottom_standoff=[   8,     // diameter
                   18,     // height (top_height)
                  2.5,     // holesize
                   10,     // supportsize
                    4,     // supportheight
                    4,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    0,     // standoff style 0=hex, 1=cylinder
                    1,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
top_standoff=[      7.5,   // radius
                  top_height-topthick,     // height
                  2.7,     // holesize
                   10,     // supportsize
                    4,     // supportheight
                    1,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    0,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
mount_standoff=[    7,     // radius
                 10.2,     // height (bottom_height-pcb_z)
                  2.7,     // holesize
                    7,     // supportsize
                    4,     // supportheight
                    4,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    1,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
boom_standoff=[     7,     // radius
                    5,     // height (bottom_height-pcb_z)
                  2.7,     // holesize
                    7,     // supportsize
                    4,     // supportheight
                    4,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    1,     // standoff style 0=hex, 1=cylinder
                    0,     // enable reverse standoff
                    0,     // enable insert at top of standoff
                  4.5,     // insert hole dia. mm
                  5.1];    // insert depth mm
                  
adjust = .1;
$fn = 90;

echo(width=width, depth=depth, height=top_height);

/*
$vpt = [8, -6.5, 67];
$vpr = [83.3, 0, $t*360];
$vpd = 590;
*/

// platter view
if (view == "platter") {
    translate([0,0,-11]) case_bottom();
    translate([400,0,42]) rotate([0,180,0]) case_cover();
    translate([0,depth+10,0]) case_top();
    }
// model view
if (view == "model") {
//    translate([(-width/2)+10,0,27]) rotate([90+view_angle,0,0]){         // 8.5, 27 or 
        if(sbc_off == false && sbc_model == "m1") translate([27,30,bottom_height+22]) 
            rotate([0,180,270]) sbc(sbc_model);
        if(move_top >= 0) {
            color("grey",1) translate([0,0,move_top]) case_top();
        }
        if(move_bottom >= 0) {
            color("dimgrey",1) translate([0,0,1+move_bottom+adjust]) case_bottom();
        }
        if(move_cover >= 0) {
            color("grey",1) translate([-10,0,move_cover]) case_cover();
        }
        translate([gap+wallthick+lcd_size[0],gap+wallthick+(case_offset_y/2),4+topthick]) 
            rotate([0,180,0]) hk_vu8m(false);
//    }
}
// debug
if (view == "debug") {
case_top();
//translate([0,0,-11]) case_bottom();
//translate([164.85,0,38]) rotate([0,180,0]) case_cover();
//translate([-150,depth-60,-2.5]) rotate([0,90,0]) bracket("speaker","left");
//translate([-10,30,-170.5]) rotate([0,-90,0]) bracket("speaker","right");
//access_cover([37,58,2],"landscape");
}


module case_bottom() {
    difference() {
        translate([(width/2),(depth/2),top_height-floorthick]) 
            cube_fillet_inside([width-(wallthick*2)-.6,depth-(wallthick*2)-.6,floorthick], 
                vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1], 
                    top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);        
        translate([20+case_offset_x,30,-1]) cube([120,58,4]);
        translate([76.5+case_offset_x,18.1,-1]) cube([18,12,4]);
        // case bottom standoffs openings
        translate([((width/2)-gap-wallthick-lcd_size[0]/2)+1,3.5,bottom_height+floorthick+adjust]) 
            cylinder(d=3, h=4);
        translate([width-12,3.5,bottom_height+floorthick+adjust]) cylinder(d=3, h=4);
        translate([((width/2)-gap-wallthick-lcd_size[0]/2)+1,depth-12,bottom_height+floorthick+adjust]) 
            cylinder(d=3, h=4);
        translate([width-12,depth-12,bottom_height+floorthick+adjust]) cylinder(d=3, h=4);
        // vu8m post openings
        translate([gap+wallthick+14.5,16,bottom_height-floorthick-adjust])  cylinder(d=7, h=4);
        translate([width-gap-wallthick-44.5,16,bottom_height-floorthick-adjust]) cylinder(d=7, h=4);
        translate([gap+wallthick+14.5,depth-gap-wallthick-12.5,bottom_height-floorthick-adjust]) cylinder(d=7, h=4);
        translate([width-gap-wallthick-44.5,depth-gap-wallthick-12.5,bottom_height-floorthick-adjust]) cylinder(d=7, h=4);
        // case bottom standoffs openings
        translate([gap+wallthick+3,5,bottom_height-floorthick-adjust])  cylinder(d=3.2, h=4);
        translate([width-gap-wallthick-3,5,bottom_height-floorthick-adjust]) cylinder(d=3.2, h=4);
        translate([gap+wallthick+3,depth-gap-wallthick-2,bottom_height-floorthick-adjust]) cylinder(d=3.2, h=4);
        translate([width-gap-wallthick-3,depth-gap-wallthick-2,bottom_height-floorthick-adjust]) cylinder(d=3.2, h=4);
        // mipi dsi opening
        translate([166,35.5,bottom_height-gap/2-adjust]) cube([16,25,floorthick+2*adjust]);
    }
}

module case_top() {
    difference() {
        union() {
            difference() {
                translate([(width/2),
                    (depth/2),top_height/2]) 
                        cube_fillet_inside([width,depth,top_height], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], top=[0,0,0,0], 
                                bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
                translate([(width/2),(depth/2),(top_height/2)+topthick]) 
                        cube_fillet_inside([width-(wallthick*2),depth-(wallthick*2),top_height], 
                            vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],top=[0,0,0,0],
                                bottom=[fillet,fillet,fillet,fillet,fillet], $fn=90);
                // lcd opening
                translate([gap+wallthick+(lcd_size[0]-view_size[0])/2+(case_offset_x/2),
                    gap+wallthick+(lcd_size[1]-view_size[1])/2+(case_offset_y/2),-1]) 
                        slab([view_size[0],view_size[1],4],1);
                // case top standoffs openings
                translate([gap+wallthick+3,5,-adjust])  cylinder(d=6.70, h=4);
                translate([width-gap-wallthick-3,5,-adjust]) cylinder(d=6.70, h=4);
                translate([gap+wallthick+3,depth-gap-wallthick-2,-adjust]) cylinder(d=6.70, h=4);
                translate([width-gap-wallthick-3,depth-gap-wallthick-2,-adjust]) cylinder(d=6.70, h=4);
            }
            // case top standoffs
            translate([gap+wallthick+3,5,0]) rotate([0,0,30]) standoff(top_standoff);
            translate([width-gap-wallthick-3,5,0]) rotate([0,0,30]) standoff(top_standoff);
            translate([gap+wallthick+3,depth-gap-wallthick-2,0]) rotate([0,0,30]) 
                standoff(top_standoff);
            translate([width-gap-wallthick-3,depth-gap-wallthick-2,0]) rotate([0,0,30]) standoff(top_standoff);        
        }
    }
}

module case_cover() {

    difference() {
        union() {
            difference() {
                translate([(width/2)-wallthick-gap+13,
                    (depth/2)-wallthick-gap+3,bottom_height+(c_height/2)]) 
                        cube_fillet_inside([c_width,c_depth,c_height], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                                top=[fillet,fillet,fillet,fillet,fillet], 
                                    bottom=[0,0,0,0], $fn=90);
                translate([(width/2)-wallthick-gap+13,(depth/2)-wallthick-gap+3,
                    bottom_height+(c_height/2)-topthick]) 
                        cube_fillet_inside([c_width-(wallthick*2),c_depth-(wallthick*2),c_height+adjust], 
                            vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],
                                top=[fillet,fillet,fillet,fillet,fillet],
                                    bottom=[0,0,0,0], $fn=90);
                // heatsink openings
                translate([(width/2)-67,(depth/2)-wallthick-gap-33,bottom_height+c_height-floorthick]) 
                        cube([c_width-57,c_depth-2*(wallthick+gap)-65,topthick+2]);
                translate([(width/2)-67,(depth/2)-wallthick-gap-48,bottom_height+c_height-floorthick]) 
                        cube([c_width-57,4,topthick+2]);
                translate([(width/2)-67,(depth/2)-wallthick-gap+45,bottom_height+c_height-floorthick]) 
                        cube([c_width-57,4,topthick+2]);
                // hdmi opening
                translate([(width/2)-wallthick-gap-75,
                    (depth/2)-wallthick-gap+25,bottom_height+(top_height/2)+15.5]) rotate([0,180,90]) hdmi_open();              
                // lan openings
                translate([(width/2)-wallthick-gap-72,
                    (depth/2)-wallthick-gap+27,bottom_height+(top_height/2)+16.25]) 
                        rotate([0,180,0]) cube([6.56,16.5,14]);
                // usb openings
                translate([(width/2)-wallthick-gap-72,
                    (depth/2)-wallthick-gap-9.5,bottom_height+(top_height/2)+16.25-adjust]) 
                        rotate([0,180,0]) cube([12,15.25,16.5]);
                translate([(width/2)-wallthick-gap-72,
                    (depth/2)-wallthick-gap-27.5,bottom_height+(top_height/2)+16.25-adjust]) 
                        rotate([0,180,0]) cube([12,15.25,16.5]);
                // power opening
                translate([(width/2)-wallthick-gap-79,
                    (depth/2)-wallthick-gap-42,bottom_height+(top_height/2)+12.5]) 
                        rotate([0,90,0]) slab([7,7,6],2);
                // usb-otg opening
                translate([(width/2)-wallthick-gap+22,
                    (depth/2)-wallthick-gap-23.5,bottom_height+(top_height/2)+12.25]) 
                        rotate([0,0,0]) microusb_open();
            }
        }
    }
}


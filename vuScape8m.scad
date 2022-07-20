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

    20220505 Version 1.0.0    vuScape8m Vu8m and Odroid-M1 integrated Case initial release.
    20220509 Version 1.0.1    adjusted location of brackets and mounting holes,
                              odroid-m1 audio plug opening moved 1mm.
    20220606 Version 1.1.0    added new stand for 180 rotated display, updated sbc_model.scad
                              and sbc_case_builder_library.scad, added bottom vent.
    20220720 Version 1.1.1    added openings for camera fpc

*/

use <./lib/fillets.scad>;
use <./lib/sbc_models.scad>;
use <./lib/sbc_case_builder_library.scad>;

view = "model";                     // viewing mode "platter", "model", "debug"
sbc_model = "m1";                   // sbc "m1"
vent = true;                        // vent (true or false)
bracket = true;                     // bracket (true or false)
flip = false;                       // brackets that invert display
sd_indent = true;                   // sdcard sphere indent
camera_cable = true;                // camera fpc openings (true or false)

sbc_off = false;                    // sbc off in model view (true or false)
vu8m_off = false;                   // vu8m off in model view (true or false)
move_bottom = 0;                    // moves top mm in model view or < 0 = off
move_top = 0;                       // moves bottom mm in model view or < 0 = off
move_cover = 0;                     // moves sbc cover mm in model view or < 0 = off    

case_offset_x = 0;                  // additional case x axis
case_offset_y = 16;                 // additional case y axis size 16mm
case_offset_tz = 0;                 // additional case top z axis
case_offset_bz = 0;                 // additional case bottom z axis

wallthick = 2;                      // case wall thickness
floorthick = 2;                     // case floor thickness
topthick = 2;                       // case top thickness
sidethick = 2;                      // case side thickness
gap = 1;                            // distance between pcb and case

h_depth = 123;                      // heatsink width

c_width = 153+2*(wallthick+gap);    // cover width
c_depth = 134+2*(wallthick+gap);    // cover depth
c_height = 25+floorthick+gap;       // cover height 

c_fillet = 6;                       // corner fillets
fillet = 0;                         // edge fillets
tab_clearance = 8;
view_angle = 15;
lcd_size = [198,133,4.45];
view_size = [172.224,107.64,.125];
pcb_tmaxz = 7.5;
pcb_bmaxz = 5;

width = lcd_size[0]+(2*(wallthick+gap))+case_offset_x;
depth = lcd_size[1]+(2*(wallthick+gap))+case_offset_y;
top_height = pcb_tmaxz+topthick+case_offset_tz;
bottom_height = pcb_bmaxz+floorthick+case_offset_bz;
case_z = bottom_height+top_height;

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
cover_standoff=[   12,     // radius
             c_height,     // height
                  3.2,     // holesize
                   10,     // supportsize
                    4,     // supportheight
                    2,     // 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
                    1,     // standoff style 0=hex, 1=cylinder
                    1,     // enable reverse standoff
                    1,     // enable insert at top of standoff
                    8,     // insert hole dia. mm
                    6];    // insert depth mm
                  
adjust = .1;
$fn = 90;

echo(width=width, depth=depth, height=top_height);

// platter view
if (view == "platter") {
    translate([-1.5,-2,-6.5]) case_bottom();
    translate([420,-6.5,38]) rotate([0,180,0]) case_cover();
    translate([0,depth+10,0]) case_top();
    translate([-150,35,12]) rotate([0,270,0]) bracket("left");
    translate([-130,30,191.5]) rotate([0,90,0]) bracket("right");
    }
// model view
if (view == "model") {
    translate([(width/2),-40,19]) rotate([90+view_angle,0,180]) {
        if(sbc_off == false && sbc_model == "m1") translate([42,30,bottom_height+22]) 
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
        if(vu8m_off == false) {
         translate([gap+wallthick+lcd_size[0],gap+wallthick+(case_offset_y/2),4+topthick]) 
             rotate([0,180,0]) hk_vu8m(false);
        }
        if(bracket == true && flip == false) {
         color("grey",1) translate([gap+wallthick+8.5,(case_offset_y/2)-3.5,bottom_height-8]) 
             rotate([0,0,0]) bracket("left");
         color("grey",1) translate([gap+wallthick+9.5,(case_offset_y/2)-3.5,bottom_height-8]) 
             rotate([0,0,0]) bracket("right");
        }
        if(bracket == true && flip == true) {
         color("grey",1) translate([gap+wallthick+8.5+181,(case_offset_y/2)-3.5+146,bottom_height-8]) 
             rotate([0,0,180]) bracket("left");
         color("grey",1) translate([gap+wallthick+9.5+179,(case_offset_y/2)-3.5+146,bottom_height-8]) 
             rotate([0,0,180]) bracket("right");
        }
    }
}
// debug
if (view == "debug") {
//case_top();
//translate([0,0,-11]) case_bottom();
translate([164.85,0,38]) rotate([0,180,0]) case_cover();
//translate([-150,35,12]) rotate([0,270,0]) bracket("left");
//translate([-130,30,191.5]) rotate([0,90,0]) bracket("right");
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
        translate([gap+wallthick+14.5,15.5,bottom_height-floorthick-adjust])  
            cylinder(d=7, h=4);
        translate([width-gap-wallthick-44.5,15.5,bottom_height-floorthick-adjust]) 
            cylinder(d=7, h=4);
        translate([gap+wallthick+14.5,depth-gap-wallthick-12.5,bottom_height-floorthick-adjust]) 
            cylinder(d=7, h=4);
        translate([width-gap-wallthick-44.5,depth-gap-wallthick-12.5,bottom_height-floorthick-adjust]) 
            cylinder(d=7, h=4);
        // case bottom standoffs openings
        translate([gap+wallthick+3,5,bottom_height-floorthick-adjust])  
            cylinder(d=3.2, h=4);
        translate([width-gap-wallthick-3,5,bottom_height-floorthick-adjust]) 
            cylinder(d=3.2, h=4);
        translate([gap+wallthick+3,depth-gap-wallthick-2,bottom_height-floorthick-adjust]) 
            cylinder(d=3.2, h=4);
        translate([width-gap-wallthick-3,depth-gap-wallthick-2,bottom_height-floorthick-adjust]) 
            cylinder(d=3.2, h=4);
        // mipi dsi opening
        translate([157.5,32.5,bottom_height-gap/2-adjust]) cube([33,31,floorthick+2*adjust]);
    }
    // mipi cover
    difference() {
        translate([181.5,48,bottom_height+floorthick+2.5]) 
            cube_fillet_inside([25,37,6], vertical=[c_fillet,0,0,c_fillet], 
                top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);
        translate([181.5,48,bottom_height-floorthick+4]) 
            cube_fillet_inside([25-2*(wallthick+gap),37-2*(wallthick+gap),6], 
                vertical=[c_fillet-3,0,0,c_fillet-3], top=[fillet,fillet,fillet,fillet,fillet],
                    bottom=[0,0,0,0], $fn=90);
        translate([164,32.5,bottom_height-floorthick+3]) cube([12,31,3]);
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
            translate([width-gap-wallthick-3,depth-gap-wallthick-2,0]) rotate([0,0,30]) 
                standoff(top_standoff);        
        }
    }
}


module case_cover() {

    difference() {
        union() {
            difference() {
                translate([(width/2)-3,(depth/2),bottom_height+(c_height/2)+floorthick]) 
                        cube_fillet_inside([c_width,c_depth,c_height], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                                top=[fillet,fillet,fillet,fillet,fillet], 
                                    bottom=[0,0,0,0], $fn=90);
                translate([(width/2)-3,(depth/2),bottom_height+(c_height/2)]) 
                    cube_fillet_inside([c_width-2*(wallthick),c_depth-2*(wallthick),c_height+adjust],
                        vertical=[c_fillet-1,c_fillet-1,c_fillet-1,c_fillet-1],
                            top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);
                // io cutout
                translate([(width/2)-70,(depth/2)-wallthick-gap,bottom_height+floorthick+gap+c_height/2]) 
                        cube_fillet_inside([c_width-126,c_depth-2*(wallthick+gap)-35,c_height+3], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                                top=[fillet,fillet,fillet,fillet,fillet], 
                                    bottom=[0,0,0,0], $fn=90);
            }
            // io opening walls
            difference() {
                translate([(width/2)-73,(depth/2)-wallthick-gap,bottom_height+floorthick+c_height/2]) 
                        cube_fillet_inside([c_width-117,c_depth-2*(wallthick+gap)-35,c_height], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                                top=[fillet,fillet,fillet,fillet,fillet], 
                                    bottom=[0,0,0,0], $fn=90);
                translate([(width/2)-73-wallthick,(depth/2)-wallthick-gap,bottom_height+floorthick+c_height/2])
                        cube_fillet_inside([c_width-117,c_depth-3.5*(wallthick+gap)-35,c_height+4*wallthick], 
                            vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                                top=[fillet,fillet,fillet,fillet,fillet], 
                                    bottom=[0,0,0,0], $fn=90);
            }
        }
        // io trim
        translate([(width/2)-132.5,(depth/2)-wallthick-gap-55,bottom_height-adjust]) 
            cube([50,110,c_height+5]);
        // heatsink openings
        translate([(width/2)-52,(depth/2)-wallthick-gap-32.5,bottom_height+c_height-floorthick-adjust]) 
                cube([126,c_depth-2*(wallthick+gap)-68,floorthick+3]);
        translate([(width/2)-52,(depth/2)-wallthick-gap-48.5,bottom_height+c_height-floorthick-adjust]) 
                cube([126,4,floorthick+3]);
        translate([(width/2)-52,(depth/2)-wallthick-gap+45.5,bottom_height+c_height-floorthick-adjust]) 
                cube([126,4,floorthick+3]);
        // hdmi opening
        translate([(width/2)-wallthick-gap-49,
            (depth/2)-wallthick-gap+25,bottom_height+(top_height/2)+15.5]) rotate([0,180,90]) hdmi_open();
        // lan openings
        translate([(width/2)-wallthick-gap-46,
            (depth/2)-wallthick-gap+27,bottom_height+(top_height/2)+15.75]) 
                rotate([0,180,0]) cube([6.56,16.5,14]);
        // usb openings
        translate([(width/2)-wallthick-gap-45,
            (depth/2)-wallthick-gap-9.5,bottom_height+(top_height/2)+15.75-adjust]) 
                rotate([0,180,0]) cube([12,15.25,16.5]);
        translate([(width/2)-wallthick-gap-45,
            (depth/2)-wallthick-gap-27.5,bottom_height+(top_height/2)+15.75-adjust]) 
                rotate([0,180,0]) cube([12,15.25,16.5]);
        // power opening
        translate([(width/2)-wallthick-gap-52,
            (depth/2)-wallthick-gap-42,bottom_height+(top_height/2)+12.5]) 
                rotate([0,90,0]) slab([7,7,8],2);
        // usb-otg opening
        translate([(width/2)-wallthick-gap-47,
            (depth/2)-wallthick-gap-24.5,bottom_height+(top_height/2)+17]) 
                rotate([0,0,90]) microusb_open();
        // audio jack opening
        translate([(width/2)-wallthick-gap+75,
            (depth/2)-wallthick-gap+32.5,bottom_height+(top_height/2)+13.5]) 
                rotate([0,90,0]) cylinder(d=6, h=7);
        translate([(width/2)-wallthick-gap+78.5,
            (depth/2)-wallthick-gap+32.5,bottom_height+(top_height/2)+13.5]) 
                rotate([0,90,0]) cylinder(d=9, h=2);
        // ir opening
        translate([(width/2)-wallthick-gap+75,
            (depth/2)-wallthick-gap-18.5,bottom_height+(top_height/2)+9.25]) 
                rotate([0,90,0]) cylinder(d=6, h=7);        
        // sdcard opening
        translate([(width/2)-wallthick-gap+75,
            (depth/2)-wallthick-gap-40,bottom_height+(top_height/2)+12]) cube([20,15,3]);
        if(sd_indent == true) {
            translate([(width/2)-wallthick-gap+87.5,
                (depth/2)-wallthick-gap-32,bottom_height+(top_height/2)+13.5]) sphere(d=20);
        }
        // audio plug opening
        translate([(width/2)-wallthick-gap+75,
            (depth/2)-wallthick-gap+17,bottom_height+(top_height/2)+11.5]) cube([8,7,4.5]);
        // button opening
        translate([(width/2)-wallthick-gap+75,
            (depth/2)-wallthick-gap+8.25,bottom_height+(top_height/2)+10]) 
                rotate([0,90,0]) cylinder(d=6,h=40); 
        // mipi dsi opening
        translate([(width/2)-wallthick-gap+75,
            (depth/2)-wallthick-gap-42,bottom_height+(top_height/2)-3.5]) 
                cube([12,31,4]);
        // top vents
        if(vent == true) {
            translate([(width/2)-wallthick-gap-25,
                (depth/2)-wallthick-gap+75,bottom_height+(top_height/2)+4]) vent(2,12,8,2,1,12,"vertical");
            translate([(width/2)-wallthick-gap-25,
                (depth/2)-wallthick-gap-63,bottom_height+(top_height/2)+4]) vent(2,12,8,2,1,12,"vertical");
        }
        if(camera_cable == true) {
            translate([(width/2)-wallthick-gap,
                (depth/2)-wallthick-gap+70,bottom_height+(top_height/2)-3]) cube([17,8,2]);
            translate([(width/2)-wallthick-gap,
                (depth/2)-wallthick-gap-68,bottom_height+(top_height/2)-3]) cube([17,8,2]);
            translate([(width/2)-wallthick-gap+75,
                (depth/2)-wallthick-gap+12,bottom_height+(top_height/2)-3]) cube([8,17,2]);
            translate([(width/2)-wallthick-gap-55,
                (depth/2)-wallthick-gap+8,bottom_height+(top_height/2)-3]) cube([8,17,2]);
        }
        // sbc mount holes
        translate([gap+wallthick+56.25,39.25,bottom_height+c_height-floorthick])  
            slot(3.2,4,6);
        translate([gap+wallthick+88.25,39.25,bottom_height+c_height-floorthick])  
            slot(3.2,4,6);
        translate([gap+wallthick+127.75,39.25,bottom_height+c_height-floorthick])  
            slot(3.2,4,6);
        translate([width-gap-wallthick-38.25,39.25,bottom_height+c_height-floorthick]) 
            slot(3.2,4,6);
        translate([gap+wallthick+56.25,110.75,bottom_height+c_height-floorthick])  
            slot(3.2,4,6);
        translate([gap+wallthick+88.25,110.75,bottom_height+c_height-floorthick])  
            slot(3.2,4,6);
        translate([gap+wallthick+127.75,110.75,bottom_height+c_height-floorthick])  
            slot(3.2,4,6);
        translate([width-gap-wallthick-38.25,110.75,bottom_height+c_height-floorthick]) 
            slot(3.2,4,6);
        // cover standoff openings
        translate([gap+wallthick+24.5,15.5,bottom_height+c_height-floorthick])  
            cylinder(d=7, h=6);
        translate([width-gap-wallthick-34.5,15.5,bottom_height+c_height-floorthick]) 
            cylinder(d=7, h=6);
        translate([gap+wallthick+24.5,depth-gap-wallthick-12.5,bottom_height+c_height-floorthick]) 
            cylinder(d=7, h=6);
        translate([width-gap-wallthick-34.5,depth-gap-wallthick-12.5,bottom_height+c_height-floorthick]) 
            cylinder(d=7, h=6);       
    }
    // cover standoffs
    translate([gap+wallthick+24.5,15.5,bottom_height+c_height+floorthick])  
        standoff(cover_standoff);
    translate([width-gap-wallthick-34.5,15.5,bottom_height+c_height+floorthick]) 
        standoff(cover_standoff);
    translate([gap+wallthick+24.5,depth-gap-wallthick-12.5,bottom_height+c_height+floorthick]) 
        standoff(cover_standoff);
    translate([width-gap-wallthick-34.5,depth-gap-wallthick-12.5,bottom_height+c_height+floorthick]) 
        standoff(cover_standoff);
}


module bracket(side) {
   
    // left bracket
    if(side == "left") {
        difference() {
            union() {
                translate([-2*(wallthick+gap)+.5,(depth/2)-wallthick-gap-10.5,top_height+3]) 
                    cube_fillet_inside([12,depth+18,4], 
                        vertical=[0,c_fillet,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
            
                translate([-2*(wallthick+gap)+.5,-wallthick-gap-6.25,top_height+42]) rotate([90-view_angle,0,0])
                    cube_fillet_inside([12,100,4], 
                        vertical=[0,0,0,0], top=[0,0,0,0], 
                            bottom=[8,0,8,0], $fn=90);
                difference() {
                    translate([-11.5,-15,10]) rotate([0,90,0]) cylinder(d=100, h=12, $fn=360);
                    translate([-14,-15,10]) rotate([0,90,0]) cylinder(d=94, h=12+3, $fn=360);
                }
            }
            // cover trim
            if(flip == false) {
                translate([((width/2)-gap-wallthick-lcd_size[0]/2)+17,13,top_height-adjust])
                    cube_fillet_inside([40,22,c_height], vertical=[0,0,c_fillet,c_fillet], 
                        top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);            
                translate([((width/2)-gap-wallthick-lcd_size[0]/2)+17,130,top_height-adjust])
                    cube_fillet_inside([40,28,c_height], vertical=[0,c_fillet,0,c_fillet], 
                        top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);
            }
            if(flip == true) {
            translate([7,102.5,bottom_height+floorthick+4.75]) 
                cube_fillet_inside([20,38,7], vertical=[c_fillet,c_fillet,c_fillet,c_fillet], 
                    top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);
            }
            // holes
            translate([((width/2)-gap-wallthick-lcd_size[0]/2)-5.5,.5,bottom_height+floorthick+adjust]) 
                cylinder(d=3, h=15);
            translate([((width/2)-gap-wallthick-lcd_size[0]/2)-5.5,depth-9.5,bottom_height+floorthick+adjust]) 
                cylinder(d=3, h=15);
            // trim
            translate([-2*(wallthick+gap)-6.5,(depth/2)-wallthick-gap-50,top_height-45]) cube([14,38,46]);
            translate([-2*(wallthick+gap)-6.5,(depth/2)-wallthick-gap-140,top_height-56]) cube([14,98,46]);
            translate([-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-152.85,top_height-15]) 
                rotate([-view_angle,0,0]) cube([50,50,140]);
        }          
    }
    // right bracket
    if(side == "right") {
        difference() {
            union() {
                translate([width-2*(wallthick+gap)+.5-13,(depth/2)-wallthick-gap-10.5,top_height+3]) 
                    cube_fillet_inside([12,depth+18,4], 
                        vertical=[c_fillet,0,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                translate([width-2*(wallthick+gap)+.5-13,-wallthick-gap-6.25,top_height+42]) 
                    rotate([90-view_angle,0,0]) cube_fillet_inside([12,100,4], 
                        vertical=[0,0,0,0], top=[0,0,0,0], 
                            bottom=[8,0,8,0], $fn=90);         
                difference() {
                    translate([width-2*(wallthick+gap)-18.5,-15,10]) rotate([0,90,0]) 
                        cylinder(d=100, h=12, $fn=360);
                    translate([width-2*(wallthick+gap)-18.5-1,-15,10]) rotate([0,90,0]) 
                        cylinder(d=94, h=12+3, $fn=360);
                }
            }
            // cover trim
            if(flip == false) {
                translate([162.25,43.5,bottom_height+floorthick+4.75]) 
                    cube_fillet_inside([41,38,7], vertical=[c_fillet,0,c_fillet,c_fillet], 
                        top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);
            }
            if(flip == true) {
                translate([((width/2)-gap-wallthick+lcd_size[0]/2)-35,lcd_size[1],top_height-adjust])
                    cube_fillet_inside([40,22,c_height], vertical=[c_fillet,c_fillet,0,0], 
                        top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);            
                translate([((width/2)-gap-wallthick+lcd_size[0]/2)-35,16,c_height-top_height])
                    cube_fillet_inside([40,28,c_height+16], vertical=[0,c_fillet,0,c_fillet], 
                        top=[fillet,fillet,fillet,fillet,fillet], bottom=[0,0,0,0], $fn=90);
            }            
            // holes
            translate([width-18.5,.5,bottom_height+floorthick+adjust]) cylinder(d=3, h=15);
            translate([width-18.5,depth-9.5,bottom_height+floorthick+adjust]) cylinder(d=3, h=15);
            // trim
            translate([width-2*(wallthick+gap)-19,(depth/2)-wallthick-gap-60,top_height-45]) 
                cube([14,50,46]);
            translate([width-2*(wallthick+gap)-19,(depth/2)-wallthick-gap-140,top_height-71]) 
                cube([14,98,60]);
            translate([width-2*(wallthick+gap)-30,(depth/2)-wallthick-gap-173.56,top_height-15]) 
                rotate([-view_angle,0,0]) cube([50,70,140]);
        }
    }
}
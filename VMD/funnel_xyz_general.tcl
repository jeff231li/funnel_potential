proc cv_axis { Ligand Z_init Z_final Z_cc Alpha R_cyl } {

foreach i [molinfo list] {

set allatoms [ atomselect $i all ]
$allatoms update
set frame [molinfo $i get frame]

graphics $i delete all

## DEFINE A and B as coordinates
 set cm_A_x [lindex $Z_init 0]
 set cm_A_y [lindex $Z_init 1]
 set cm_A_z [lindex $Z_init 2]

 set cm_B_x [lindex $Z_final 0]
 set cm_B_y [lindex $Z_final 1]
 set cm_B_z [lindex $Z_final 2]

## plot A and B
graphics $i color white
graphics $i sphere "$cm_A_x $cm_A_y $cm_A_z" radius 1.0 resolution 100
graphics $i text   "$cm_A_x $cm_A_y $cm_A_z" " A "
graphics $i sphere "$cm_B_x $cm_B_y $cm_B_z" radius 1.0 resolution 100
graphics $i text   "$cm_B_x $cm_B_y $cm_B_z" " B "

set dist_AB [string range [expr sqrt( ($cm_B_x-$cm_A_x)*($cm_B_x-$cm_A_x) + ($cm_B_y-$cm_A_y)*($cm_B_y-$cm_A_y) +($cm_B_z-$cm_A_z)*($cm_B_z-$cm_A_z))] 0 3]

set dist_AB_x [expr ($cm_B_x+$cm_A_x)/2]
set dist_AB_y [expr ($cm_B_y+$cm_A_y)/2]
set dist_AB_z [expr ($cm_B_z+$cm_A_z)/2]

graphics $i text "$dist_AB_x $dist_AB_y $dist_AB_z" "$dist_AB"

## Distance of the ligand from the beginning
set cm_L [measure center $Ligand weight mass]
set cm_L_x [lindex $cm_L 0]
set cm_L_y [lindex $cm_L 1]
set cm_L_z [lindex $cm_L 2]

set dist_AL [string range [expr sqrt( ($cm_L_x-$cm_A_x)*($cm_L_x-$cm_A_x) + ($cm_L_y-$cm_A_y)*($cm_L_y-$cm_A_y) +($cm_L_z-$cm_A_z)*($cm_L_z-$cm_A_z))] 0 3]

set dist_AL_x [expr ($cm_L_x+$cm_A_x)/2]
set dist_AL_y [expr ($cm_L_y+$cm_A_y)/2]
set dist_AL_z [expr ($cm_L_z+$cm_A_z)/2]

graphics $i color green
graphics $i text "$dist_AL_x $dist_AL_y $dist_AL_z" "$dist_AL"

## point at infinity
set t_inf   1.0
set x_inf [expr $cm_A_x + ($cm_B_x-$cm_A_x)*$t_inf]
set y_inf [expr $cm_A_y + ($cm_B_y-$cm_A_y)*$t_inf]
set z_inf [expr $cm_A_z + ($cm_B_z-$cm_A_z)*$t_inf]
# and here is the AXIS!
graphics $i line "$cm_A_x $cm_A_y $cm_A_z" "$x_inf $y_inf $z_inf" width 2 style dashed


## PARAMETERS OF THE CYLINDER
## 1) define R_cyl
set R_cyl $R_cyl

## 2) define z_cc where the cone switches into the cylinder
set z_cc   $Z_cc
set t_cyl  [expr $z_cc / $dist_AB] 
set x_cyl  [expr $cm_A_x + ($cm_B_x-$cm_A_x)*$t_cyl]
set y_cyl  [expr $cm_A_y + ($cm_B_y-$cm_A_y)*$t_cyl]
set z_cyl  [expr $cm_A_z + ($cm_B_z-$cm_A_z)*$t_cyl]

set lim [expr $z_cc + 5]
#set lim 7
set t_lim [expr $lim / $dist_AB]
set x_lim  [expr $cm_A_x + ($cm_B_x-$cm_A_x)*$t_lim]
set y_lim  [expr $cm_A_y + ($cm_B_y-$cm_A_y)*$t_lim]
set z_lim  [expr $cm_A_z + ($cm_B_z-$cm_A_z)*$t_lim]

graphics $i color orange 
graphics $i sphere "$x_cyl $y_cyl $z_cyl" radius 0.3 resolution 100
graphics $i text "$x_cyl $y_cyl $z_cyl" " z_cc "
graphics $i color red
graphics $i sphere "$x_lim $y_lim $z_lim" radius 1.5 resolution 100

set dist_VA_x [expr ($cm_A_x+$x_cyl)/2]
set dist_VA_y [expr ($cm_A_y+$y_cyl)/2]
set dist_VA_z [expr ($cm_A_z+$z_cyl)/2]

graphics $i text "$dist_VA_x $dist_VA_y $dist_VA_z" "$z_cc"


## PARAMETERS OF THE CONE
## 1) define cone ANGLE
set alpha $Alpha

## 2) vertex cone
set z_cone [expr $z_cc + $R_cyl / tan($alpha)]
set t_cone [expr $z_cone / $dist_AB]
set x_cone [expr $cm_A_x + ($cm_B_x-$cm_A_x)*$t_cone]
set y_cone [expr $cm_A_y + ($cm_B_y-$cm_A_y)*$t_cone]
set z_cone [expr $cm_A_z + ($cm_B_z-$cm_A_z)*$t_cone]

## 3) another point P
set dist_HP [expr $R_cyl + tan($alpha) * $z_cc]


## draw cone and cilinder
graphics $i color orange
graphics $i material Transparent 
graphics $i cone "$cm_A_x $cm_A_y $cm_A_z" "$x_cone $y_cone $z_cone" radius $dist_HP resolution 100 
graphics $i cylinder  "$x_cyl $y_cyl $z_cyl" "$x_inf $y_inf $z_inf"  radius $R_cyl resolution 100 filled no 

$allatoms update

}
}

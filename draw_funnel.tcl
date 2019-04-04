source funnel_xyz_general.tcl

# Funnel Options
set Z_cc  12.0 ;# Switching dist from cone to cylinder
set alpha 0.55 ;# Angle of cone in radians
set R_cyl 1.0  ;# Radius of cylinder

#######################
## Axis Vector       ##
#######################
# Initial Point
set s1 [atomselect top "insert selection for point A here"]
set c1 [measure center $s1 weight mass]

# Final Point
set s2 [atomselect top "insert selection for point B here"]
set c2 [measure center $s2 weight mass]

# Axis
set axis [vecnorm [vecsub $c2 $c1]]

#######################
## Funnel A-B Points ##
#######################
# Ligand Molecule
set lig [atomselect top "insert selection for ligand"]
set cl [measure center $lig weight mass]

# Funnel Initial Points
set c3 [vecadd $c2 [vecscale $axis -8]]

# Funnel Final Points
set c4 [vecadd $c3 [vecscale $axis 25]]

# Draw Funnel
cv_axis $lig $c3 $c4 $Z_cc $alpha $R_cyl

# Ion Initial Distance
set df [vecsub $cl $c1]
set dr [vecdot $df $axis]

#######################
## Print Positions   ##
#######################
set f [open "Funnel-Colvar.dat" w]
puts $f "Funnel Init"
puts $f [format "%10.5f %10.5f %10.5f" [lindex $c3 0] [lindex $c3 1] [lindex $c3 2]]
puts $f "Funnel Final"
puts $f [format "%10.5f %10.5f %10.5f" [lindex $c4 0] [lindex $c4 1] [lindex $c4 2]]
puts $f "Funnel Axis"
puts $f [format "%10.5f %10.5f %10.5f" [lindex $axis 0] [lindex $axis 1] [lindex $axis 2]]
puts $f "Dummy Atom"
puts $f [format "%10.5f %10.5f %10.5f" [lindex $cl 0] [lindex $cl 1] [lindex $cl 2]]
puts $f "Distance"
puts $f [format "%10.5f" $dr]
close $f

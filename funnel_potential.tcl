################################################################
## Read PDB file and store atoms                              ##
################################################################
set N 0
set group {}
set inStream [open $pdbFile r]
foreach line [split [read $inStream] \n] {
	# ATOMS
    set string1 [string trim [string range $line 0 3]]

    if { [string equal $string1 {ATOM}] } {
		# Symbols 12-16 should be "Atom Names"
        set string2 [string trim [string range $line 12 16]]

		# Symbols 22-26 should be "resID"
        set string3 [string trim [string range $line 22 26]]

		# Symbols 72-76 should be "Segname"
        set string4 [string trim [string range $line 72 75]]

		# Symbols 54-60 = "Occupancy" | Symbols 61-65 = "Beta"
        if {$pdbCol == "O"} {
            set string5 [string trim [string range $line 56 60]]
        } else {
            set string5 [string trim [string range $line 61 65]]
        }

		# Collect only flagged atoms
        if { $string5 == $pdbColValue } {
            lappend group [atomid $string4 $string3 $string2]
            set N [expr $N + 1]
        }
    }
}
close $inStream
set a1 [addgroup $group]

################################################################
## Initialize                                                 ##
################################################################
set t 0 ;# Counter

set CartX "1.0 0.0 0.0" ;# Cartesian X-axis
set CartY "0.0 1.0 0.0" ;# Cartesian Y-axis
set CartZ "0.0 0.0 1.0" ;# Cartesian Z-axis

# Funnel Axes (normalized)
set v_axis [vecsub $v_fina $v_init]
set v_norm [expr 1.0/sqrt(pow([lindex $v_axis 0],2) + \
                          pow([lindex $v_axis 1],2) + \
                          pow([lindex $v_axis 2],2))]
set v_axis [vecscale $v_norm $v_axis]

################################################################
## Write Header to Output                                     ##
################################################################
set outfile [open $FunnelOut w]
puts $outfile [format "#INIT:   %.3f %.3f %.3f" \
       [lindex $v_init 0] [lindex $v_init 1] [lindex $v_init 2]]
puts $outfile [format "#FINA:   %.3f %.3f %.3f" \
       [lindex $v_fina 0] [lindex $v_fina 1] [lindex $v_fina 2]]
puts $outfile [format "#VECT:   %.3f %.3f %.3f" \
       [lindex $v_axis 0] [lindex $v_axis 1] [lindex $v_axis 2]]
puts $outfile [format "#RCYL:   %.2f" $Rcyl]
puts $outfile [format "#RALPHA: %.2f" $Ralpha]
puts $outfile [format "#ZCC:    %.2f" $Zcc]
puts $outfile [format "#KCYL:   %.2f" $Kcyl]
puts $outfile [format "#%19s %18s %18s %18s" \
        "Time (ps)" "Rxy (Ang)" "Rz (Ang)" "F (kcal/mol/A)"]
close $outfile

# Print funnel information to log file
print "FUNNEL atoms   : $N"
print [format "FUNNEL v_init  : %.3f %.3f %.3f" \
        [lindex $v_init 0] [lindex $v_init 1] [lindex $v_init 2]]
print [format "FUNNEL v_final : %.3f %.3f %.3f" \
        [lindex $v_fina 0] [lindex $v_fina 1] [lindex $v_fina 2]]
print [format "FUNNEL axis    : %.3f %.3f %.3f" \
        [lindex $v_axis 0] [lindex $v_axis 1] [lindex $v_axis 2]]
print [format "FUNNEL radius  : %.2f" $Rcyl]
print [format "FUNNEL angle   : %.2f" $Ralpha]
print [format "FUNNEL center  : %.2f" $Zcc]
print [format "FUNNEL spring  : %.2f" $Kcyl]

################################################################
## Main Routine for Funnel Potential                          ##
################################################################
proc calcforces { } {
    global a1 t Dtime v_init v_axis Rcyl Ralpha Zcc Kcyl \
           CartX CartY CartZ FunnelFreq FunnelOut

	# Get current coordinates
    loadcoords coordinate
    set rCOM $coordinate($a1)

	# Projection onto funnel axis
    set vecR [vecsub $rCOM $v_init]
    set rz [expr [lindex $vecR 0]*[lindex $v_axis 0] + \
                 [lindex $vecR 1]*[lindex $v_axis 1] + \
                 [lindex $vecR 2]*[lindex $v_axis 2]]

	# Projection onto orthogonal plane
    set vector [vecscale $rz $v_axis]
    set dist_v_ortho [vecsub $vecR $vector]
    set rxy [expr sqrt(pow([lindex $dist_v_ortho 0],2) + \
                       pow([lindex $dist_v_ortho 1],2) + \
                       pow([lindex $dist_v_ortho 2],2))]
					   
	# Determine Boundary based on Rz position
    if {$rz >= $Zcc} {
        set Rxy $Rcyl
    } else {
        set zr  [expr $Zcc - $rz]
        set Rxy [expr $zr * tan($Ralpha) + $Rcyl]
    }

	# Conditional for Funnel
    if {$rxy >= $Rxy} {
        set Force   [expr -$Kcyl * ($rxy - $Rxy) / $rxy]
        set F_ortho [vecscale $Force $dist_v_ortho]
        set Fx [expr [lindex $F_ortho 0]*[lindex $CartX 0] + \
                     [lindex $F_ortho 1]*[lindex $CartX 1] + \
                     [lindex $F_ortho 2]*[lindex $CartX 2]]
        set Fy [expr [lindex $F_ortho 0]*[lindex $CartY 0] + \
                     [lindex $F_ortho 1]*[lindex $CartY 1] + \
                     [lindex $F_ortho 2]*[lindex $CartY 2]]
        set Fz [expr [lindex $F_ortho 0]*[lindex $CartZ 0] + \
                     [lindex $F_ortho 1]*[lindex $CartZ 1] + \
                     [lindex $F_ortho 2]*[lindex $CartZ 2]]
        addforce $a1 "$Fx $Fy $Fz"
    } else {
        set Force 0.0
    }

	# Output
    if { [expr $t % $FunnelFreq] == 0 } {
        set Time      [expr $t*$Dtime/1000]
        set outfile   [open $FunnelOut a]
        puts $outfile [format "%20.5f %18.10f %18.10f %18.10f" \
		                  $Time $rxy $rz $Force]
        close $outfile
    }
    incr t
    return
}
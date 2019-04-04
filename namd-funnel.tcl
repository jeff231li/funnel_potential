tclForces on

# Funnel Options
set v_init " 3.79790  -29.53702  -10.11779"
set v_fina "22.35501  -14.84706  -18.17005"
set Zcc         12.0
set Ralpha       0.6
set Rcyl         1.0
set Kcyl        10.0

# Input Options
set pdbFile     atoms.pdb
set pdbCol      O
set pdbColValue 8.0

# Output Options
set FunnelFreq  500
set FunnelOut   FM01.dat

tclForcesScript funnel.tcl
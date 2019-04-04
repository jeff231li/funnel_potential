tclForces on

# Funnel Parameters
set v_init      "0.0 0.0 0.0"
set v_fina      "0.0 0.0 10.0"
set Zcc         12.0
set Ralpha       0.6
set Rcyl         1.0
set Kcyl        10.0

# Ligand selection Options
set pdbFile     atoms.pdb
set pdbCol      O
set pdbColValue 8.0

# Output Options
set FunnelFreq  500
set FunnelOut   FM01.dat

tclForcesScript funnel.tcl

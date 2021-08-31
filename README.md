# Funnel Potential
Implementation of a funnel potential in [NAMD](NAMD/) and [OpenMM](OpenMM/) based on the work done of Limongelli et al.

* Limongelli, V., Bonomi, M., & Parrinello, M. (2013). Funnel metadynamics as accurate binding free-energy method. Proceedings of the National Academy of Sciences, 110(16), 6358-6363.

### NAMD Implementation

For the NAMD implementation, I have written the code in `TclForces` and the user specifies the end points 
**A** and **B**. In this way, the funnel potential can be placed on an arbitrary axis other than the three Cartesian axes.

The main function is written in the file [`funnel_potential.tcl`](NAMD/funnel_potential.tcl) and needs to be sourced in the main NAMD 
configuration file. As a minimal example, [`namd_config_funnel.tcl`](NAMD/namd_config_funnel.tcl) contains the variables needed by the 
user that controls the funnel length, width etc.

Once the funnel potential is configured, the reaction coordinate for the molecule/ligand along the funnel axis is done using the colvar module ([`colvars.tcl`](NAMD/colvars.tcl)).

### OpenMM Implementation

For the OpenMM implementation, I used the `CustomCentroidBondForce` and fixes the funnel axis to the Cartesian axes. 
Two separate `CustomCentroidBondForce` are implemented in [`apply_funnel_potential.py`](OpenMM/apply_funnel_potential.py), 
one for the funnel potential in the radial direction, and the other for the reaction coordinate in the z-axis.

### VMD Visualization

To aid in determining the end points, [`draw_funnel.tcl`](VMD/draw_funnel.tcl) can be used in VMD to draw a transparent funnel that 
uses [`function_xyz_general.tcl`](VMD/funnel_xyz_general.tcl) as its main function.


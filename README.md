# funnel_potential
NAMD implementation of a funnel potential using the tclForces interface. This is based on the work done by Limongelli et al.

* Limongelli, V., Bonomi, M., & Parrinello, M. (2013). Funnel metadynamics as accurate binding free-energy method. Proceedings of the National Academy of Sciences, 110(16), 6358-6363.

I have written the code so that the user specifies the end points **A** and **B** so that the funnel can be placed on an arbitrary axis other than the three Cartesian axes.

The main function is written in the file `funnel_potential.tcl` and needs to be sourced in the main NAMD configuration file. As an example, `namd_config_funnel.tcl` contains the variables needed by the user that controls the funnel length, width etc.

To aid in determining the end points, `draw_funnel.tcl` can be used in VMD to draw a transparent funnel that uses `function_xyz_general.tcl` as its main function.

Once the funnel potential is configured the biasing is done with the colvar module (e.g. `colvars.tcl`).

#!/usr/bin/env python

from typing import List, Optional

import openmm
import openmm.unit as openmm_unit


def add_funnel_potential(
    system: openmm.System,
    host_index: List[int],
    guest_index: List[int],
    k_xy: Optional[openmm_unit.Quantity] = 10.0
    * openmm_unit.kilocalorie_per_mole
    / openmm_unit.angstrom**2,
    z_cc: Optional[openmm_unit.Quantity] = 11.0 * openmm_unit.angstrom,
    alpha: Optional[openmm_unit.Quantity] = 35.0 * openmm_unit.degrees,
    R_cylinder: Optional[openmm_unit.Quantity] = 1.0 * openmm_unit.angstrom,
    force_group: Optional[int] = 10,
):
    """
    Applies a funnel potential to a guest molecule
    """

    # Funnel potential string expression
    funnel = openmm.CustomCentroidBondForce(
        2,
        "U_funnel + U_cylinder;"
        "U_funnel = step(z_cc - abs(r_z))*step(r_xy - R_funnel)*Wall_funnel;"
        "U_cylinder = step(abs(r_z) - z_cc)*step(r_xy - R_cylinder)*Wall_cylinder;"
        "Wall_funnel = 0.5 * k_xy * (r_xy - R_funnel)^2;"
        "Wall_cylinder = 0.5 * k_xy * (r_xy - R_cylinder)^2;"
        "R_funnel = (z_cc-abs(r_z))*tan(alpha) + R_cylinder;"
        "r_xy = sqrt((x2 - x1)^2 + (y2 - y1)^2);"
        "r_z = z2 - z1;",
    )
    funnel.setUsesPeriodicBoundaryConditions(False)
    funnel.setForceGroup(force_group)

    # Funnel parameters
    funnel.addGlobalParameter("k_xy", k_xy)
    funnel.addGlobalParameter("z_cc", z_cc)
    funnel.addGlobalParameter("alpha", alpha)
    funnel.addGlobalParameter("R_cylinder", R_cylinder)

    # Add host and guest indices
    g1 = funnel.addGroup(host_index, [1.0 for i in range(len(host_index))])
    g2 = funnel.addGroup(guest_index, [1.0 for i in range(len(guest_index))])

    # Add bond
    funnel.addBond([g1, g2], [])

    # Add force to system
    system.addForce(funnel)


def add_reaction_coordinate(
    system: openmm.System,
    host_index: List[int],
    guest_index: List[int],
    k_z: openmm_unit.Quantity,
    z_0: openmm_unit.Quantity,
    force_group: Optional[int] = 11,
):
    """
    Applies the umbrella reaction coordinate to the guest molecule
    """

    # Simple umbrella potential string expression
    reaction = openmm.CustomCentroidBondForce(
        2, "0.5 * k_z * (r_z - z_0)^2;" "r_z = z2 - z1;"
    )
    reaction.setUsesPeriodicBoundaryConditions(False)
    reaction.setForceGroup(force_group)

    # Umbrella parameters
    reaction.addPerBondParameter("k_z", k_z)
    reaction.addPerBondParameter("z_0", z_0)

    # Add host and guest indices
    g1 = funnel.addGroup(host_index, [1.0 for i in range(len(host_index))])
    g2 = funnel.addGroup(guest_index, [1.0 for i in range(len(guest_index))])

    # Add bond
    reaction.addBond([g1, g2], [k_z, z_0])

    # Add force to system
    system.addForce(reaction)

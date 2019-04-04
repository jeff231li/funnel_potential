colvarsTrajFrequency    5000
colvarsRestartFrequency 10000

#############################################################
## PROTEIN RESTRAINTS                                      ##
#############################################################
colvar {
  name ProtCM
  distance {
    group1 {
      atomsFile     atoms.pdb
      atomsCol      O
      atomsColValue 1.0
    }
    group2 {
      dummyatom (0.0,0.0,0.0)
    }
  }
}
colvar {
  name ProtOR
  orientation   {
    atoms {
      atomsFile          atoms.pdb
      atomsCol           O
      atomsColValue      1.0
  }
    refPositionsFile     atoms.pdb
    refPositionsCol      O
    refPositionsColValue 1.0
  }
}
#############################################################
## KEEP HP1-HP2 GATE OPEN                                  ##
#############################################################
colvar {
    name Gate-1
    #lowerWall         10.0
    #lowerWallConstant 10.0
    distance {
        group1 {
            atomsFile     atoms.pdb
            atomsCol      O
            atomsColValue 2.0
        }
        group2 {
            atomsFile     atoms.pdb
            atomsCol      O
            atomsColValue 3.0
        }
    }
}
colvar {
    name Gate-2
    #lowerWall         10.0
    #lowerWallConstant 10.0
    distance {
        group1 {
            atomsFile     atoms.pdb
            atomsCol      O
            atomsColValue 4.0
        }
        group2 {
            atomsFile     atoms.pdb
            atomsCol      O
            atomsColValue 5.0
        }
    }
}
colvar {
    name Gate-3
    #lowerWall         10.0
    #lowerWallConstant 10.0
    distance {
        group1 {
            atomsFile     atoms.pdb
            atomsCol      O
            atomsColValue 6.0
        }
        group2 {
            atomsFile     atoms.pdb
            atomsCol      O
            atomsColValue 7.0
        }
    }
}
#############################################################
## SODIUM ION DISTANCE                                     ##
#############################################################
# Na1-to-Bulk Z coordinate
colvar {
  name posit-Z
  distanceZ {
    axis (0.74228,0.58760,-0.32209)
    main {
      atomsFile     atoms.pdb
      atomsCol      O
      atomsColValue 8.0
    }
    ref {
      dummyatom (-2.68389,-30.88303,-10.93883)
    }
  }
}

#############################################################
## UMBRELLA HARMONIC RESTRAINTS                            ##
#############################################################
# Protein Restraint
harmonic {
  colvars       ProtCM
  centers       0.0
  forceConstant 1000.0
}
harmonic {
  colvars       ProtOR
  centers       (1.0, 0.0, 0.0, 0.0)
  forceConstant 10000.0
}
# Na1-to-Bulk Z
harmonic {
  colvars       posit-Z
  centers        -1.0
  targetCenters  18.0
  targetNumSteps  150000
  targetNumStages 39
  forceConstant   20.0
}

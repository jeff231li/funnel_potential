colvarsTrajFrequency    5000
colvarsRestartFrequency 10000

# Molecule - Z position
colvar {
  name posit-Z
  width 0.1
  lowerBoundary 0.0
  upperBoundary 10.0
  distanceZ {
    axis (0.0, 0.0, 1.0)
    main {
      atomNumbers {1}
    }
    ref {
      dummyatom (0.0, 0.0, 0.0)
    }
  }
}
# Well-tempered metadynamics
metadynamics {
  colvars         posit-Z
  hillWeight      0.2
  wellTempered    on
  biasTemperature 3000
}
# Flat-bottom potential 
harmonicWalls {
  colvars         posit-Z
  lowerWalls      0.0
  upperWalls     10.0
  forceConstant   1.0
}

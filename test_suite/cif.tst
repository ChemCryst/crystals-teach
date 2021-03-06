#
# This test takes a non-centro structure (cyclo) and tests all the
# following features of SFLS in all combinations:
#
#  Refinement, Scale, Calc            } These options are worked
#  Mixed ISO/ANISO refinement         } through in the instruction file
#  Extinction                         } cycloref.dat.
#
#  F and F squared refinement FSQ or NOFSQ
#  Anomalous scattering ANOM or NOANOM
#

\set time slow
\store CSYS SVN '0000'
\use cyclo.in
# Do a pretty picture:
\MOLAX
ATOM FIRST UNTIL LAST
PLOT
END
#                                         FSQ, ANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\USE cycloref.dat

\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END


\ For non-gui versions bonding is not always updated.
#BONDCALC FORCE
END

#STORE CSYS CIF 'cif.out'

#APPEND PUNCH

#CIF
END

#PARAMETERS
LAYOUT INSET = 1 NCHAR = 120 ESD=EXCLRH
COORD SELECT=ALL MONITOR=LOW PRINT=YES PUNCH=CIF NCHAR=14
U'S MONITOR=OFF, PRINT=NO, PUNCH=NO, NCHAR=14
END
#DIST
E.S.D YES YES
SELECT RANGE=L41
OUTPUT MON=DIST PUNCH = CIF HESD=NONFIXED
END
#DISTANCE 
OUT PUNCh=H-CIF mon=ang
SELECT RANGE=LIMIT
LIMIT 0.7 2.6 0.7 2.6 
E.S.D YES YES
PIVOT H
BOND O N C
END 
#PUNCH 12 C
END
#PUNCH 16 C
END
#SUM LIST 28 HI
END
# test esds on hydrogen bonds
#EDIT
TRANSFORM 1 0 0 0 1 0 0 0 1 H(1,3,1,2,-1)
END

\LIST 12
BLOCK SCALE
CONTINUE C(1,X'S,U[ISO])
CONTINUE C(2,X'S,U[ISO])
CONTINUE O(3,X'S,U'S)
CONTINUE C(4,X'S,U[ISO])
CONTINUE O(5,X'S,U'S)
CONTINUE N(6,X'S,U[ISO])
CONTINUE C(7,X'S,U[33])
CONTINUE O(8,X'S,U[ISO])
CONTINUE C(9,X'S,U[11])
CONTINUE C(10,X'S,U[22])
CONTINUE C(11,X'S,U[23])
END
# H not refined. H-bond D&A will have esds because of N6 and O8
#sfls
ref
shift gen=0
end
#PARAMETERS
LAYOUT INSET = 1 NCHAR = 120 ESD=EXCLRH
COORD SELECT=ALL MONITOR=LOW PRINT=YES PUNCH=CIF NCHAR=14
U'S MONITOR=OFF, PRINT=NO, PUNCH=NO, NCHAR=14
END
#DIST
E.S.D YES YES
SELECT RANGE=L41
OUTPUT MON=DIST PUNCH = CIF HESD=NONFIXED
END
#DISTANCE
OUT PUNCh=H-CIF mon=ang
SELECT RANGE=LIMIT
LIMIT 0.7 2.6 0.7 2.6
E.S.D YES YES
PIVOT H
BOND O N C
END

#list 12
full x's
ride n(6,x's) h(1,x's)
end
# H  constrained. N-H bond will, have no esd, other will
#list 22
end
#sfls
ref
shift gen=0
end
#PARAMETERS
LAYOUT INSET = 1 NCHAR = 120 ESD=EXCLRH
COORD SELECT=ALL MONITOR=LOW PRINT=YES PUNCH=CIF NCHAR=14
U'S MONITOR=OFF, PRINT=NO, PUNCH=NO, NCHAR=14
END
#DIST
E.S.D YES YES
SELECT RANGE=L41
OUTPUT MON=DIST PUNCH = CIF HESD=NONFIXED
END
#DISTANCE
OUT PUNCh=H-CIF mon=ang
SELECT RANGE=LIMIT
LIMIT 0.7 2.6 0.7 2.6
E.S.D YES YES
PIVOT H
BOND O N C
END

#list 12
full x's h(1,x's)
end
# H refined with distance restraint
#LIST     16
dist 1.0,.05=n(6) to h(1)
END
#sfls
ref
shift gen=0
end
#PARAMETERS
LAYOUT INSET = 1 NCHAR = 120 ESD=EXCLRH
COORD SELECT=ALL MONITOR=LOW PRINT=YES PUNCH=CIF NCHAR=14
U'S MONITOR=OFF, PRINT=NO, PUNCH=NO, NCHAR=14
END
#DIST
E.S.D YES YES
SELECT RANGE=L41
OUTPUT MON=DIST PUNCH = CIF HESD=NONFIXED
END
#DISTANCE
OUT PUNCh=H-CIF mon=ang
SELECT RANGE=LIMIT
LIMIT 0.7 2.6 0.7 2.6
E.S.D YES YES
PIVOT H
BOND O N C
END


\FINISH

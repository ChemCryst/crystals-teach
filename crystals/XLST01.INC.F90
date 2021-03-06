! module version on the INC file with common blocks
! The common blocks are kept inside the module untile all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XLST01 INC file
module xlst01_mod
  INTEGER L1P1, M1P1, MD1P1, N1P1, L1P2, M1P2, MD1P2, N1P2
  INTEGER L1M1, M1M1, MD1M1, N1M1, L1M2, M1M2, MD1M2, N1M2
  INTEGER L1O1, M1O1, MD1O1, N1O1, L1O2, M1O2, MD1O2, N1O2
  INTEGER L1S, M1S, MD1S, N1S, L1A, M1A, MD1A, N1A, L1C, M1C, MD1C, N1C

  COMMON/XLST01/L1P1, M1P1, MD1P1, N1P1, L1P2, M1P2, MD1P2, N1P2, &
    L1M1, M1M1, MD1M1, N1M1, L1M2, M1M2, MD1M2, N1M2, &
    L1O1, M1O1, MD1O1, N1O1, L1O2, M1O2, MD1O2, N1O2, &
    L1S, M1S, MD1S, N1S, L1A, M1A, MD1A, N1A, L1C, M1C, MD1C, N1C
end module

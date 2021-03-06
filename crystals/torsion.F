C $Log: not supported by cvs2svn $
C Revision 1.11  2011/09/30 07:07:31  djw
C Remove diagnostic print
C
C Revision 1.10  2011/08/11 09:32:09  djw
C Check esd is less than zerosq (not zero)
C
C Revision 1.9  2011/08/08 10:44:34  djw
C Move print of vcv matrix from torsion into igetvcv in vcv
C
C Revision 1.7  2007/10/09 07:07:13  djw
C Use Mario Nardeli's torsion esd code
C
C Revision 1.6  2006/01/06 10:08:57  djw
C Fixes to cif output of torsion angles
C
C Revision 1.5  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:05  rich
C New CRYSTALS repository
C
C Revision 1.4  2003/08/05 11:11:12  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.3  2001/07/19 11:57:58  ckp2
C Pass a variable rather than a value. It seemed to cause problems.
C
C Revision 1.2  2001/02/26 10:30:24  richard
C Added changelog to top of file
C
C
CODE FOR HTORS
      SUBROUTINE HTORS
C--MAIN TORSION ANGLE CALCULATION ROUTINE
C
C---- NOTE THAT THIS USES THE ORIGINAL LEXICAL SCANNER, NOT THE
C     LATER SINGLE-STEP SCANNER.
C--
      DIMENSION LATOM(4)
      DIMENSION R(4,3), SD(4,3), XYZ(3)
      DIMENSION RI(3,4),  VCV(12,12)
      CHARACTER *64 CBUFF
      CHARACTER *32 CATOM(4), CBLANK
      INCLUDE 'ICOM12.INC'
      INCLUDE 'ICOM30.INC'
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'TYPE11.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XWORKA.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST12.INC'
      INCLUDE 'QLST30.INC'
C 
      INCLUDE 'QSTR11.INC'
C 

      DATA IVERSN  /204/
      DATA CBLANK /' '/
      DATA AZERO /0.0/
C
      REWIND (MTE)
c----- Set print flag to no
CDJWJAN06
c      MY = 0
c      MW = 0
c      MV = 0
C
C--SET UP THE TIMING CONTROL
      CALL XTIME1(2)
C--READ THE INPUT CONTROL CARDS WITH THE LEXICAL SCANNER
      ISTAT = KLEXAN ( IULN , IFIRST , LENGTH )
      IF ( ISTAT .LT. 0 ) GO TO 9910
C----- GET THE PUBLICATION ETC FLAG FROM THE LEXICAL COMMON BLOCK
      IPBFLG = MY
      LEVEL = MW
      JESD = MV
C--CLEAR THE CORE
      CALL XRSL
      CALL XCSAE
C----- SET UP A DISTANCE-TYPE STACK OF ONLY 4 ATOM FOR THE ESDS
C      FROM THE FULL VCV MATRIX
C      (SOME ITEMS NOT USED IN THIS CONTEXT):
C
C   0 I  ADDRESS OF ATOM IN L5 (USE THIS TO FIND THE ATOM TYPE & SERIAL)
C   1    ACCEPTANCE FLAG (NOT USED) 
C   2 I  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CofS)
C   3 I  NON-PRIMITIVE LATTICE INDICATOR
C   4 I  T(X)
C   5 I  T(Y)
C   6 I  T(Z)
C   7 R  TRANSFORMED X
C   8 R  TRANSFORMED Y
C   9 R  TRANSFORMED Z
C  10    DISTANCE (NOT USED)
C  11    DISTANCE SQUARED (NOT USED)
C  12 I  ADDRESS IN LIST 12.
C  13    TARGET CONTACT DISTANCE FOR RESTRAINTS (NOT USED)
C
      NATOMAX = 10 ! MAXIMUM NUMBER OF ATOMS IS A SINGLE TORSION SET
      JSTACK = LFL
      ISTACK = JSTACK
      LSTACK = 14      !SHOULD THIS BE THE SAME AS NW LATER?
      LFL = LFL - LSTACK*NATOMAX !NATOMAX ATOMS
C
C--LOAD THE RELEVANT LISTS
      CALL XFAL01
      CALL XFAL02
      CALL XFAL30
C----- STORE MEAN SIGMA - THIS IS USED WITH THE NARDELI APPROXIMATION
C      AND CAN BE REMOVED ONE DAY.
      DO I=1,3
        DO J=1,4
            SD(J,I)= STORE(L30CF+14)
        ENDDO
      ENDDO
c
C----- GET THE LIST TYPE FROM THE LEXICAL COMMON BLOCK
      IULN5=KTYP05(MX)
      CALL XLDR05(IULN5)
      IF ( IERFLG .LT. 0 ) GO TO 9900
      INCLUDE 'IDIM12.INC'
C-----------------------------------------------------------
      IESD = -1
      TAU1 = 0.
      TAU2 = 0.
      ESD = 0.
      IF (JESD .GE. 1) THEN
       IF ((KEXIST(12).LE.0).OR.(KEXIST(11).LE.0)
     1 .OR. (KEXIST(22).LE.0)) THEN
C       INDICATE THAT LIST 12 IS NOT TO BE USED
        DO  I=1,IDIM12
         ICOM12(I)=NOWT
        ENDDO
       ELSE
C----- LOAD LIST 12
         JQ = 0
         JS = 1
C--LOAD LIST 12
         CALL XFAL12 (JS,JQ,JU,JV)
C - if LIST 5 and 11 are out of synch, XFAL12 generates an error
c   and abandons the input file. Looks ugly in XTORS2.SSC
c   Implement Pascals nostop optional parameter?
         IF (IERFLG.GE.0) I = KSET52(0,-1)
C--LOAD LIST 11
         IF (IERFLG.GE.0) CALL XFAL11 (1,0)
         IF (IERFLG.LT.0) THEN
C         CLEAR ERROR FLAG
          IERFLG = 0
         ELSE
          IF (ISTORE(L11P+15).GE.0) THEN
            if (issmon.ne.1) CALL SETISSMON(0) ! Turn monitoring back on
            IF (ISSPRT.EQ.0) WRITE (NCWU,200)
            WRITE (CMON,200)
            CALL XPRVDU (NCVDU,3,0)
200         FORMAT (' Matrix is wrong type for e.s.d.''s')
            CALL XERHND (IERWRN)  ! should not be an error now
          ELSE
C           APPLY THE CORRECT MULTIPLICATION FACTOR TO THE MATRIX
C           NOTE THAT PUNCH 11 C LISTS JUST THE UNSCALED INVERSE MATRIX
            C = STORE(L11P+17)/STORE(L11P+16)
            M11 = L11+N11-1
            DO 250 I = L11,M11
              STR11(I) = STR11(I)*C
 250        CONTINUE
            IESD = 1
          ENDIF
         ENDIF
       ENDIF
      ENDIF
C--LIST READ IN OKAY  -  SET UP THE INITIAL CONTROL FLAGS
      CALL XILEXP(IULN,IFIRST)
C-----------------------------------------------------------
c
C--PRINT THE INITIAL CAPTIONS
      CALL XPRTCN
c
      IF (JESD .GE.1)  THEN
        if (issmon.ne.1) CALL SETISSMON(0) ! Turn monitoring back on
        IF  (IESD .LE. 0) THEN
            WRITE(CMON,'(A)') 
     1 '{E Matrix for e.s.ds missing. Using mean errors instead'
        ELSE
            WRITE(CMON,'(A)') 
     1 '   The SU is computed from the full VcV matrix if available'
        ENDIF
      ELSE
        WRITE(CMON,'(A)')
     1 '   The su is computed from the mean atomic variances'
      ENDIF
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1)(3:))
C
      WRITE ( CMON,1100)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
1100  FORMAT(' A positive rotation is',
     2 ' clockwise from atom 1 to 4,',
     3 ' when viewed from atom 2 to 3')
c
      WRITE ( CMON,1149)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) THEN
        IF (IESD .EQ. 1) THEN
            WRITE(NCWU, 1151)
        ELSE
            WRITE(NCWU, 1150) 
        ENDIF
      ENDIF
1149  FORMAT(33X, ' Torsion angle & su')
1150  FORMAT(53X, ' Torsion angle & su')
1151  FORMAT(53X, ' Torsion angle & VcV-su')
C--SET THE ERROR COUNTERS
      LEF=0
      LSTLEF=0
C
C----- SET UP A BUFFER FOR THE PUBLICATION LISTING
      IPUB = KSTALL (24)
C--PROCESS THE NEXT CARD FROM THE DISC
1200  CONTINUE
      IF(KLDNLR(I))2950,1250,1200
C--CHECK THAT THE FUNCTION IS FOR AN 'ATOM' CARD
1250  CONTINUE
      IF(MG-1)1200,1300,1200
C--CHECK IF A NEW CAPTION IS REQUIRED
1300  CONTINUE
      IF(LEF-LSTLEF)1350,1400,1350
C--NEW CAPTION IS REQUIRED
1350  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1150)
      ENDIF
C--RESET THE ERROR COUNTER
1400  CONTINUE
      LSTLEF=LEF
C
C--START OF 'ATOM' CARD
      NATOM=0
c---- re-set the start of the distance-type stack for the vcv
      ISTACK = JSTACK
C--SET ASIDE AN AREA IN WHICH GENERATED PARAMETERS CAN BE STORED
      JUNK=NFL
      NFL=NFL+MD5
C
C--SET UP THE POINTER FOR THE FIRST ATOM FOUND  -  A STACK IS FORMED HER
      IBASE=NFL
C--SET UP THE NUMBER OF WORDS IN THE STACK
      NWS=9
c----- save room for 4 blocks of atom data
      IDJW = KCHNFL(4*NWS)
C--SET THE RUNNING POINTER TO THE STACK  -  'JD'
c-- step backwards because later we step forwards!!
      JD=IBASE-NWS
C--CHECK FOR ARGUMENTS
      IF(ME)1500,1500,1600
C--NO ARGUMENTS FOUND
1500  CONTINUE
      CALL XPCLNN(LN)
      WRITE ( CMON,1550)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
1550  FORMAT(' No arguments found')
      GOTO 1200
C--ARGUMENTS TO BE PROCESSED  -  CHECK FOR AN OPERAND
1600  CONTINUE
      IF(ISTORE(MF))1750,1650,1650
C--ARGUMENT IS OF THE WRONG TYPE
1650  CONTINUE
      CALL XPCLNN(LN)
      WRITE ( CMON,1700)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
1700  FORMAT(' Only atoms may appear on an ''ATOM'' card')
      GOTO 2650
C--PICK UP ATOM SPECIFICATION AND FIND THE ATOMS IN LIST 5
1750  CONTINUE
      JC = 0
      IF(KATOMU(JC))2650,2650,1800
C--UPDATE THE NUMBER OF ATOMS FOUND
1800  CONTINUE
C
      NATOM=NATOM+N5A
C--= RESTRICT STACK
      IF (NATOM .GT. NATOMAX) THEN
        NATOM =NATOMAX
C TODO: RE-SET N5A if too many atoms
        WRITE(CMON,'(A,I4,a)')'List restricted to',natom,' atoms'
        CALL XPRVDU(NCVDU,1,0)
      ENDIF
650   CONTINUE
c
C----- THE DISTANCE STACK DETAILS
C----- LOOP OVER THE ATOMS FOUND AND STORE THEM
C
C      FIRST CREATE A DISTANCE-TYPE STACK FOR THE VCV CODE
      MSTART = MQ
      M5TMP = M5A
      IF (IESD .EQ. 1)  L12TMP = L12A
c
c  NOW CREATE THE ORIGINAL hOURANI sTACK FOR THE OLD CODE
C  NOTE THAT WE HAVE POSITIONS IN BOTH STACKS FOR THE MOMNET
C  THE HOURANI STACK CAN GO ONCE WE ARE HAPPY WITH THE NEW CODE
      DO 1950 JE=1,N5A
      JD=JD+NWS
      NFL=NFL+NWS
      IF(NFL+27-LFL)1850,1850,2800
1850  CONTINUE
C--GENERATED THE MOVED PARAMETERS
c
      IF(KATOMS(MQ,M5A,JUNK))2650,2650,1900
1900  CONTINUE
C--MOVE THE GENERATED COORDINATES TO THEIR PLACE ON THE STACK
      CALL XMOVE(STORE(JUNK+4),STORE(JD),3)
C--STORE THE ADDRESS OF THE ATOM IN LIST 5
      ISTORE(JD+3)=M5A
C--STORE THE SYMMETRY OPERATORS USED TO GENERATE THE NEW COORDS.
      ISTORE(JD+4)=ISTORE(MQ+7)
      ISTORE(JD+5)=ISTORE(MQ+8)
      ISTORE(JD+6)=ISTORE(MQ+9)
      ISTORE(JD+7)=ISTORE(MQ+10)
      ISTORE(JD+8)=ISTORE(MQ+11)
C
      IF (IESD .EQ. 1) THEN
C     CREATE THE DISTANCE-TYPE STACK
       ISTACK = ISTACK-LSTACK
       ISTORE(ISTACK) = M5TMP
       ISTORE(ISTACK+12) = L12TMP
C           S,L,T,T,T
       CALL XMOVEI (ISTORE(MSTART+7),ISTORE(ISTACK+2),5)
C           x', y', z'
       CALL XMOVE (STORE(junk+4),STORE(ISTACK+7),3)
C--UPDATE FOR THE NEXT ATOM
       L12TMP = ISTORE(L12TMP)
      ENDIF
      M5TMP = M5TMP+MD5A
      M5A=M5A+MD5A
1950  CONTINUE
c
C--CHECK FOR END OF CARD NOW
      IF(KOP(8))2000,1600,1600
C--END OF CARD  -  CHECK THE NUMBER OF ATOMS FOUND
2000  CONTINUE
      IF(NATOM-4)2050,2150,2150
C--NOT ENOUGH ATOMS
2050  CONTINUE
      CALL XPCLNN(LN)
      WRITE ( CMON,2100)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
2100  FORMAT(' Not enough atoms provided')
      GOTO 2650
C--SET POINTERS TO THE FIRST THREE ATOMS IN THE STACK
2150  CONTINUE
C---- SAVE THE START OF THE DISTANCE-TYPE STACK
      JSTACK = ISTACK
c
c      write(ncwu,*)'Stack dump', jstack, lstack, natom
c      ikdjw = jstack
c      do iidjw = 1, natom
c        write(ncwu,*) (istore(ikdjw+ildjw),ildjw=0,lstack-1)
c        ikdjw = ikdjw + lstack
c        write(ncwu,'(/)')
c      enddo
c
      IBASE1=IBASE
      IBASE2=IBASE+NWS
      IBASE3=IBASE+NWS+NWS
C--SET POINTERS TO THE REMAINING ATOMS IN THE STACK
      IBASE4=IBASE3
      NATOM=NATOM-3
C--SET UP SPACE FOR ROTATION MATRIX AT 'MAT'
      MAT=NFL
      NFL=NFL+9
CDJWAPR07      
C--- STORE ORTHOGONAL ATOMS FOR NARDELLI TORS2
      CALL XMLTTM(STORE(L1O1),STORE(ibase1),xyz,3,3,1)
      r(1,1)=xyz(1)
      r(1,2)=xyz(2)
      r(1,3)=xyz(3)
      CALL XMLTTM(STORE(L1O1),STORE(ibase2),xyz,3,3,1)
      r(2,1)=xyz(1)
      r(2,2)=xyz(2)
      r(2,3)=xyz(3)
      CALL XMLTTM(STORE(L1O1),STORE(ibase3),xyz,3,3,1)
      r(3,1)=xyz(1)
      r(3,2)=xyz(2)
      r(3,3)=xyz(3)
C
C--STORE FIRST TWO VECTORS AT 'IBASE1', 'IBASE2'
      STORE(IBASE1)=STORE(IBASE1)-STORE(IBASE2)
      STORE(IBASE1+1)=STORE(IBASE1+1)-STORE(IBASE2+1)
      STORE(IBASE1+2)=STORE(IBASE1+2)-STORE(IBASE2+2)
      STORE(IBASE2)=STORE(IBASE3)-STORE(IBASE2)
      STORE(IBASE2+1)=STORE(IBASE3+1)-STORE(IBASE2+1)
      STORE(IBASE2+2)=STORE(IBASE3+2)-STORE(IBASE2+2)
C--ORTHOGONALISE FIRST TWO VECTORS, THEN NORMALISE
      JB=IBASE1
      DO 2250 JA=1,2
      CALL XMLTTM(STORE(L1O1),STORE(JB),STORE(NFL),3,3,1)
      CALL XMOVE(STORE(NFL),STORE(JB),3)
      IF(NORM3(STORE(JB)))2850,2200,2200
C--POINT TO THE SECOND VECTOR
2200  CONTINUE
      JB=IBASE2
2250  CONTINUE
      angle1= store(ibase1)*store(ibase2)+
     1 store(ibase1+1)*store(ibase2+1)+
     1 store(ibase1+2)*store(ibase2+2)
C
C--SET A POINTER FOR THE ATOM NUMBER
      JQ=1
C--PRINT THE FIRST THREE ATOMS OF THE TORSION ANGLE
      JPUB = IPUB
      DO 2400 JA=IBASE1,IBASE3,NWS
      JF=ISTORE(JA+3)
C--FIX THE SERIAL NUMBER
      JG=NINT(STORE(JF+1))
      JB=JA+4
      JD=JA+8
C----- COMPRESS ATOMS INTO CHARACTER FORM
      CALL CATSTR (STORE(JF)    ,STORE(JF+1)  ,ISTORE(JB)
     1 ,ISTORE(JB+1) ,ISTORE(JB+2) ,ISTORE(JB+3) ,ISTORE(JB+4),
     2 CATOM(JQ), LATOM(JQ))
C----- STORE THE 3 ATOMS IF NECESSARY
      IF (IPBFLG) 2370,2370,2360
2360  CONTINUE
      STORE(JPUB) = STORE(JF)
      STORE(JPUB+1) = STORE(JF+1)
      ISTORE(JPUB+2) = ISTORE(JB)
      ISTORE(JPUB+3) = ISTORE(JB+1)
      ISTORE(JPUB+4) = ISTORE(JB+2)
      ISTORE(JPUB+5) = ISTORE(JB+3)
      ISTORE(JPUB+6) = ISTORE(JB+4)
      JPUB = JPUB+7
2370  CONTINUE
      JQ=JQ+1
2400  CONTINUE
C--FORM ROTATION MATRIX FROM THESE VECTORS
      CALL XMOVE(STORE(IBASE2),STORE(MAT+6),3)
      IF(NCROP3(STORE(IBASE2),STORE(IBASE1),STORE(MAT+3)))2700,2450,
     2 2450
C--FORM TRANSPOSED ROTATION MATRIX AT 'MAT'
2450  CONTINUE
      IF(NCROP3(STORE(MAT+3),STORE(IBASE2),STORE(MAT)))2700,2500,2500
C
C--LOOP OVER ALL THE NEXT ATOM IN THE STACK AND COMPUTE IS ANGLE
2500  CONTINUE
C
      IBASE4=IBASE4+NWS
C--DECREMENT THE NUMBER OF ATOMS
      NATOM=NATOM-1
C-SAVE 4TH ATOM FOR TORS2
      CALL XMLTTM(STORE(L1O1),STORE(ibase4),xyz,3,3,1)
      r(4,1)=xyz(1)
      r(4,2)=xyz(2)
      r(4,3)=xyz(3)
c
C--FORM THIRD VECTOR AT IBASE4
      STORE(IBASE4)=STORE(IBASE4)-STORE(IBASE3)
      STORE(IBASE4+1)=STORE(IBASE4+1)-STORE(IBASE3+1)
      STORE(IBASE4+2)=STORE(IBASE4+2)-STORE(IBASE3+2)
C--ORTHOGONALISE TO 'IBASE1'
      CALL XMLTTM(STORE(L1O1),STORE(IBASE4),STORE(IBASE1),3,3,1)
C--NORMALISE
      IF(NORM3(STORE(IBASE1)))2850,2550,2550
2550  CONTINUE
      angle2= -store(ibase1)*store(ibase2)-
     1 store(ibase1+1)*store(ibase2+1)-
     1 store(ibase1+2)*store(ibase2+2)
     
      IF(ABS(ANGLE1).GT.ABS(ANGLE2)) THEN
       ANGLE3=ANGLE1
      ELSE
       ANGLE3=ANGLE2
      ENDIF

      IF (abs(angle3) .ge. 0.996) THEN
       WRITE(CBUFF,'(A,F6.1)')' Group is almost co-linear ',
     1 RTD*ACOS(ANGLE3)
      ELSE
       CBUFF=' '
      ENDIF
C--ROTATE TO IBASE4
      CALL XMLTTM(STORE(MAT),STORE(IBASE1),STORE(IBASE4),3,3,1)
C--CALCULATE TORSION ANGLE OF VECTOR
      ANGLE=ATAN2(STORE(IBASE4+1),STORE(IBASE4))*RTD
      JF=ISTORE(IBASE4+3)
      JG=NINT(STORE(JF+1))
      JB=IBASE4+4
      JD=IBASE4+8
c
cdjwapr07    NARDELL CODE  - USES MEAN SU FROM LIST 30
      CALL TORS2(R,SD,TAU1,ESD1,KTR)
      ESD = ESD1
c
CDJWJUL2011  USE FULL VCV IF AVAILABLE
      IF (IESD .EQ. 1) THEN
        I = IGETVCV(4, JSTACK, LSTACK, IOUT, LEVEL)
c       TRANSPOSE THE MATRIX OF ORTHOGONAL COORDINATES TO GET ATOMS BY
C       COLUMNS
        CALL XTRANS(R, RI, 4, 3)
        CALL XMOVE(STORE(IOUT), VCV(1,1), 144)
        CALL XTORS(RI, VCV, TAU2, ESD2)
        ESD = ESD2
      ENDIF
c
C--- NOTE THAT TWO ITEMS ARE OUTPUT EVEN WHEN ESDS ARE NOT COMPUTED
c Dont write to MTE if the bonds are almost co-linear
      IF((IPBFLG .GT. 0).AND.(angle3 .ge. 0.996)) 
     1  WRITE (MTE) 'T', ANGLE, ESD,
     1 (STORE(JPUB),STORE(JPUB+1), (ISTORE(KPUB),KPUB=JPUB+2,JPUB+6),
     2  JPUB=IPUB, IPUB+14, 7),
     3 STORE(JF), STORE(JF+1), (ISTORE(JE), JE=JB,JD)
C
C----- COMPRESS ATOMS INTO CHARACTER FORM
       CALL CATSTR (STORE(JF)    ,STORE(JF+1)  ,ISTORE(JB)
     1 ,ISTORE(JB+1) ,ISTORE(JB+2) ,ISTORE(JB+3) ,ISTORE(JB+4),
     2 CATOM(4), LATOM(4))
c
       WRITE ( CMON ,2805) (
     1 CBLANK(1: 10-LATOM(II)), CATOM(II)(1:LATOM(II)),II=1,4)
     2 ,ANGLE, ESD, CBUFF
       CALL XCREMS(CMON,CMON,LENTXT)
       CALL XPRVDU(NCVDU, 1,0)
c
      IF (ISSPRT .EQ. 0) THEN
        IF (IESD .EQ. 1) THEN
       WRITE(NCWU, 2806)(
     1 CBLANK(1: 10-LATOM(II)), CATOM(II)(1:LATOM(II)),II=1,4)
     2 ,ANGLE, ESD1, ESD2, CBUFF
        ELSE
       WRITE(NCWU, 2805)(
     1 CBLANK(1: 10-LATOM(II)), CATOM(II)(1:LATOM(II)),II=1,4)
     2 ,ANGLE, ESD1, CBUFF
        ENDIF
      ENDIF
2805  FORMAT (2A,' to ',2A,' to ',2A,' to ',2A,' = ', T60,2F7.1,A)
2806  FORMAT (2A,' to ',2A,' to ',2A,' to ',2A,' = ', T60,3F7.1,A)
c
C--CHECK IF THERE ARE MORE ATOMS
      IF(NATOM)1200,1200,2500
C
C--CARD PROCESSING ABANDONED
2650  CONTINUE
      CALL XPCA(ISTORE(MD+4))
      GOTO 1200
C
C--FIRST THREE ATOMS ARE CO-LINEAR
2700  CONTINUE
      WRITE ( CMON,2750)
      CALL XPRVDU(NCVDU, 1,0)
2750  FORMAT(' First three atoms are colinear')
      GOTO 2650
C
C--NOT ENOUGH CORE AVAILABLE
2800  CONTINUE
      CALL XICA
      GOTO 2950
C
C--ATOM APPEARS MORE THAN ONCE
2850  CONTINUE
      CALL XPCLNN(LN)
      WRITE ( CMON,2900)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
2900  FORMAT(' An atom has appeared more than once in the list')
      GOTO 2650
C
C--TERMINATION OF THE PROCESSING
2950  CONTINUE
      IESD = 0
      IF (IPBFLG .EQ. 1) THEN
        CALL XPRTDA (4,IESD,NCPU)
      ELSE  IF (IPBFLG .EQ. 2) THEN
        CALL XPRTDA (14,IESD,NCPU)
      ENDIF
      CALL XOPMSG (IOPTOR, IOPEND, IVERSN)
      CALL XTIME2(2)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPTOR , IOPABN , 0 )
      GO TO 2950
9910  CONTINUE
C -- INPUT ERROR
      CALL XOPMSG ( IOPTOR , IOPABN , 0 )
      GO TO 9900
      END
C
CODE FOR XTORS
      SUBROUTINE XTORS(RI, VCV, TAU, ESD)
      use xconst_mod, only: rtd
      implicit none
C
C      COMPUTE THE UNSIGNED DIHEDRAL ANGLE AND ITS
C      ESD FROM THE FULL VCV MATRIX, INCLUDING SYMMETRY
C
C      BASED VERY CLOSELY VAN SCHAIK ET AL
C      J. MOL. BIOL (1993) 234, 751-762
C
C      RI 3,4 MATRIX OF ORTHOGONAL POSTITIONS
C      VCV 12X12 ORTHOGONAL VCV MATRIX
C
      real, dimension(12,12), intent(in) :: vcv !< orthogonal variance covariance matrix
      real, dimension(3,4), intent(in) :: ri !< matrix of orthogonal positions
      real, intent(out) :: tau !< unsigned dihedral angle (degree)
      real, intent(out) :: esd !< standard deviation
C
      integer i
      double precision :: prod, dmj, dmjs, dnk, dnks, dkj, dkjs
      double precision, dimension(3) :: rij, rkj, rkl, rmj, rnk
      double precision, dimension(3) :: dtri, dtrl, dtrj, dtrk
      double precision taudp, zzzdp
      double precision, dimension(12,12) :: vcvdp
      double precision, dimension(12) :: vectordp, scratchdp
C
      vcvdp=vcv
      
      DO I = 1,3
            RIJ(I) = RI(I,1) - RI(I,2)
            RKJ(I) = RI(I,3) - RI(I,2)
            RKL(I) = RI(I,3) - RI(I,4)
      ENDDO
C
      call DNCROP3(RIJ,RKJ,RMJ)
      call DNCROP3(RKJ,RKL,RNK)

      DMJS=dot_product(rmj, rmj)
      DMJ = SQRT(DMJS)
      dnks=dot_product(rnk, rnk)
      DNK = SQRT(DNKS)
      dkjs=dot_product(rkj, rkj)
      DKJ = SQRT(DKJS)
C
      prod=dot_product(rmj, rnk)
C
      TAUdp = PROD/(DMJ*DNK)
      taudp = min(1.0d0, taudp)
      taudp = max(-1.0d0, taudp)
      TAU = ACOS(TAUdp) * 180.0d0/3.1415926535897932d0
C
      DO I = 1,3
            DTRI(I) = RMJ(I)*DKJ/DMJS
            DTRL(I) = -1.0d0*RNK(I)*DKJ/DNKS
      ENDDO
C
      DO I = 1,3
            DTRJ(I) = (dot_product(RIJ, RKJ)/DKJS - 1.0d0)*DTRI(I)
     1      - dot_product(RKL,RKJ)*DTRL(I)/DKJS
C
            DTRK(I) = (dot_product(RKL, RKJ)/DKJS - 1.0d0)*DTRL(I)
     1      - dot_product(RIJ,RKJ)*DTRI(I)/DKJS
C
      ENDDO
C
      DO I = 1,3
            VECTORdp(I) = DTRI(I)
            VECTORdp(3+I) = DTRJ(I)
            VECTORdp(6+I) = DTRK(I)
            VECTORdp(9+I) = DTRL(I)
      ENDDO
C
      SCRATCHdp=matmul(vcvdp, vectordp)
      zzzdp=dot_product(vectordp, scratchdp)
      if(zzzdp<0.0d0) zzzdp=0.0d0
      
      ESD = SQRT(ZZZdp) * RTD
C
      RETURN
      END
C
C
CODE FOR TORS2
      SUBROUTINE TORS2(R,SD,TAU,SIGTAU,KTR)
C----- CODE DONATED BY MARIO NARDELLI
C      R  4X3 MATRIX OF COORDINATES
C      SD 4X3 MATRIX OF ESDS
C      KTR 1 IF WORKS OK
C-----This routine calculates the torsion angle formed by the atoms
C-----1-2-3-4.The angle is positive when the 1-2 bond, view down the
C-----2-3 bond, will eclipse the 3-4 bond when rotates less than 180
C-----deg in a clockwise direction ("right-hand rule",Klyne,W.&
C-----Prelog,V. (1960), Experientia, 16, 521).
C-----S.u. following Stanford & Waser (1972). Acta Cryst.A28,213.
      REAL M(3,3)
      DIMENSION R(4,3),DLT(3,3),DST(3),SD(4,3),DS(4)
      KTR=0
      sigtau = 0.0
      tau = 0.0
      DO 1 J=1,3
      DLT(1,J)=R(2,J)-R(1,J)
      DLT(2,J)=R(2,J)-R(3,J)
      DLT(3,J)=R(4,J)-R(3,J)
    1 CONTINUE
      DO 2 I=1,3
      DST(I)=SQRT(DLT(I,1)**2+DLT(I,2)**2+DLT(I,3)**2)
      IF(DST(I).EQ.0.) GO TO 4
   2  CONTINUE
      DO 3 I=1,3
      DO 3 J=1,3
      M(I,J)=DLT(I,J)/DST(I)
   3  CONTINUE
      CF1=M(1,1)*M(2,1)+M(1,2)*M(2,2)+M(1,3)*M(2,3)
      CF2=M(2,1)*M(3,1)+M(2,2)*M(3,2)+M(2,3)*M(3,3)
      IF(ABS(CF1).GT..999990.OR.ABS(CF2).GT..999990)GO TO 4
      SF1=SQRT(1.-CF1**2)
      SF2=SQRT(1.-CF2**2)
      P=SF1*SF2
      IF(ABS(P).LT.1.E-5)GO TO 4
      STAU=(M(3,1)*(M(2,2)*M(1,3)-M(1,2)*M(2,3))
     1 +M(3,2)*(M(1,1)*M(2,3)-M(1,3)*M(2,1))
     2 +M(3,3)*(M(2,1)*M(1,2)-M(1,1)*M(2,2)))/P
      CTAU=((M(2,2)*M(1,3)-M(1,2)*M(2,3))*( M(3,2)*M(2,3)-M(2,2)*M(3,3)
     1 )+(M(2,3)*M(1,1)-M(2,1)*M(1,3))*(M(3,3)*M(2,1)-M(3,1)*M(2,3))
     2 +(M(2,1)*M(1,2)-M(1,1)*M(2,2))*(M(3,1)*M(2,2)-M(2,1)*M(3,2)))/P
      RR=57.295779
      TAU1=ATAN2(STAU,CTAU)
      TAU=RR*TAU1
      IF(TAU.GT.180.)TAU=TAU-360.
      DO 6 I=1,4
      DS(I)=(SD(I,1)**2+SD(I,2)**2+SD(I,3)**2)/3.
6     DS(I)=SQRT(DS(I))
      S1=(DS(1)/(DST(1)*SF1))**2
      A1=(DST(2)-DST(1)*CF1)/(DST(1)*SF1)
      A2=(DST(2)-DST(3)*CF2)/(DST(3)*SF2)
      S2=(DS(2)/DST(2))**2*(A1**2-2.*A1*(CF2/SF2)*CTAU+(CF2/SF2)**2)
      S3=(DS(3)/DST(2))**2*(A2**2-2.*A2*(CF1/SF1)*CTAU+(CF1/SF1)**2)
      S4=(DS(4)/(DST(3)*SF2))**2
      IF((S1+S2+S3+S4).LT.0.) GO TO 4
      SIGTAU=RR*SQRT(S1+S2+S3+S4)
      GO TO 5
   4  KTR=1
   5  RETURN
      END
c 

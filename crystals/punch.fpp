CODE FOR XPCH5S
      SUBROUTINE XPCH5S
C--PUNCH LIST 5 IN CRYSTALS FORMAT
C
C--
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XUSLST
\XLST05
\XOPVAL
C
\QSTORE
C
C--LOAD LIST 5 FROM THE DISC
      IF (KHUNTR (5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--PUNCH OUT THE LIST HEADING
      CALL XPCHLH(LN5)
C--OUTPUT THE CONTENTS RECORD
      WRITE(NCPU,1000)N5,MD5LS,MD5ES,MD5BS
1000  FORMAT(13HREAD NATOM = ,I6,11H, NLAYER = ,I4,13H, NELEMENT = ,I4,
     2 11H, NBATCH = ,I4)
C--OUTPUT THE OVERALL PARAMETERS
      WRITE(NCPU,1050) STORE(L5O),STORE(L5O+1),STORE(L5O+2),
     1 STORE(L5O+3),STORE(L5O+4),STORE(L5O+5)
1050  FORMAT(8HOVERALL ,F11.6,4(1X,F9.6),1X,F17.7)
C--CHECK FOR SOME ATOMS
      IF(N5)1200,1200,1100
C--OUTPUT THE ATOMS
1100  CONTINUE
      M5 = L5
      DO 1170 K = 1, N5
C----- DONT PUNCH 'SPARE' FOR THE MOMENT - IT CAUSES PROBLEMS
C      WITH ALIEN PROGRAMS
      MD5TMP = MIN (13, MD5)
      J = M5 + MD5TMP - 1
      WRITE(NCPU,1150) (STORE(I), I = M5, J)
1150  FORMAT(5HATOM ,A4,1X,6F11.6/10HCON U[11]=,6F11.6)
      M5 = M5 + MD5
1170  CONTINUE
C--CHECK IF THERE ARE ANY LAYER SCALES TO OUTPUT
1200  CONTINUE
      IF(MD5LS)1350,1350,1250
C--PUNCH THE LAYER SCALES
1250  CONTINUE
      M5LS=L5LS+MD5LS-1
      WRITE(NCPU,1300)(STORE(I),I=L5LS,M5LS)
1300  FORMAT(10HLAYERS    ,6F11.6/(10HCONTINUE  ,6F11.6))
C--CHECK IF THERE ARE ANY ELEMENT SCALES TO OUTPUT
1350  CONTINUE
      IF(MD5ES)1500,1500,1400
C--OUTPUT THE ELEMENT SCALES
1400  CONTINUE
      M5ES=L5ES+MD5ES-1
      WRITE(NCPU,1450)(STORE(I),I=L5ES,M5ES)
1450  FORMAT(10HELEMENTS  ,6F11.6/(10HCONTINUE  ,6F11.6))
C--CHECK IF THERE ARE ANY BATCH SCALS TO BE OUTPUT
1500  CONTINUE
      IF(MD5BS)1650,1650,1550
C--OUTPUT THE BATCH SCALE FACTORS
1550  CONTINUE
      M5BS=L5BS+MD5BS-1
      WRITE(NCPU,1600)(STORE(I),I=L5BS,M5BS)
1600  FORMAT(10HBATCH     ,6F11.6/(10HCONTINUE  ,6F11.6))
C--AND NOW THE 'END'
1650  CONTINUE
      CALL XPCHND
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPPCH , IOPLSP , 5 )
      RETURN
      END
C
C
CODE FOR XPCH5X
      SUBROUTINE XPCH5X
C--PUNCH LIST 5 IN X-RAY FORMAT
C
C--
\ISTORE
C
\STORE
\XCONST
\XUNITS
\XSSVAL
\XLST05
\XOPVAL
C
\QSTORE
C
C--LOAD LIST 5
      CALL XFAL05
      IF ( IERFLG .LT. 0 ) GO TO 9900
      F=1./STORE(L5O)
      WRITE(NCPU,1000)F
1000  FORMAT(//7HSCALE  ,F10.6,4H   1)
      M5=L5
      F=4.*TWOPIS
      N=999
      DO 1400 I=1,N5
      ISTORE(M5+1)=NINT(STORE(M5+1))
      ISTORE(M5+1)=IABS(ISTORE(M5+1))
      IF(ISTORE(M5+1)-1000)1150,1050,1050
1050  CONTINUE
      ISTORE(M5+1)=N
      N=N-1
      IF(N)1100,1100,1150
1100  CONTINUE
      N=999
1150  CONTINUE
C-C-C-TRANSFORM U TO B
C      STORE(M5+3)=STORE(M5+3)*F
C-C-C-CHECK WHETHER ATOM IS ANISOTROPIC
      IF(ABS(STORE(M5+3))-UISO)1180,1190,1190
C-C-C-ANISOTROPIC ATOM
1180  CONTINUE
      WRITE(NCPU,1200)STORE(M5),ISTORE(M5+1),STORE(M5+4),STORE(M5+5),
     2 STORE(M5+6),STORE(M5+3),STORE(M5+2)
      GOTO 1250
C-C-C-ISOTROPIC ATOM, SPHERE, LINE OR RING
1190  CONTINUE
C-C-C-TRANSFORM U TO B
      STORE(M5+7)=STORE(M5+7)*F
      WRITE(NCPU,1200)STORE(M5),ISTORE(M5+1),STORE(M5+4),STORE(M5+5),
     2 STORE(M5+6),STORE(M5+7),STORE(M5+2)
      GOTO 1350
1200  FORMAT(7HATOM   ,A3,I3,3F8.5,F6.3,F5.2)
C      IF(ABS(STORE(M5+3))-UISO)1250,1350,1350
1250  CONTINUE
      J=M5+7
      K=M5+12
      WRITE(NCPU,1300)STORE(M5),ISTORE(M5+1),(STORE(L),L=J,K)
1300  FORMAT(7HUIJ    ,A3,I3,6F8.5)
1350  CONTINUE
      M5=M5+MD5
1400  CONTINUE
      RETURN
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPPCH , IOPLSP , 5 )
      END
C
C
CODE FOR XPCH5C
      SUBROUTINE XPCH5C(ISPACE)
C---- PUNCH LIST 5 IN SHELDRICK FORMAT
C
C--
      CHARACTER*7 CATNM
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XCONST
\XLST05
\XOPVAL
C
\QSTORE
C
C--LOAD LIST 3, TO FIND THE FORM FACTORS TO BE USED
      IF (KHUNTR (3,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL03
      IF (KHUNTR (5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF ( IERFLG .LT. 0 ) GO TO 9900
      M5=L5
      L5A=NFL
      M5A=L5A
      DO 1000 I=1,N5
      ISTORE(M5A)=ISTORE(M5)
      M5=M5+MD5
      M5A=M5A+1
1000  CONTINUE
C--LINK LISTS 5 AND 3
      I=KSET53(0)
      IF ( IERFLG .LT. 0 ) GO TO 9900
      M5=L5
      M5A=L5A
      N=99
      WRITE(NCPU,1050)
1050  FORMAT(/1H )
C--PUNCH EACH ATOM  -  ONE AT A TIME
      DO 1450 I=1,N5
      ISTORE(M5)=ISTORE(M5)+1
      L=M5+4
      M=M5+6
      J=NINT(STORE(M5+1))
      J=IABS(J)
      IF(J-100)1200,1100,1100
1100  CONTINUE
      J=N
      N=N-1
      IF(N)1150,1150,1200
1150  CONTINUE
      N=99
1200  CONTINUE
      WRITE(CATNM,'(A)') ISTORE(M5A)
      CALL XCTRIM (CATNM, ITRIM)
      IF ( ISPACE .EQ. 0 ) ITRIM = ITRIM + 1
      IF (J.LT.10) THEN
        WRITE( CATNM (ITRIM:), '(I1)') J
      ELSE
        WRITE( CATNM (ITRIM:), '(I2)') J
      ENDIF
C--CHECK WHETHER ISO OR ANISO
C-C-C-CHECK WHETHER ANISO OR ISO/SPHERE/LINE/RING
      IF(ABS(STORE(M5+3))-UISO)1250,1350,1350
C-C-C-ANISO
1250  CONTINUE
      M5O=M5+7
      L5O=M5+12
      WRITE(NCPU,1300)CATNM,ISTORE(M5),(STORE(K),K=L,M),
     2 STORE(M5+2),(STORE(K),K=M5O,L5O)
1300  FORMAT(A7,1X,I5,6F10.5,2H =/5X,4F10.5)
      GOTO 1400
C-C-C-ISO/SPHERE/LINE/RING
1350  CONTINUE
      WRITE(NCPU,1300)CATNM,ISTORE(M5),(STORE(K),K=L,M),
C     2 STORE(M5+2),STORE(M5+3)
     2 STORE(M5+2),STORE(M5+7)
1400  CONTINUE
      M5=M5+MD5
      M5A=M5A+1
1450  CONTINUE
      RETURN
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPPCH , IOPLSP , 5 )
      RETURN
      END
C
CODE FOR XPCH5D
      SUBROUTINE XPCH5D
C----- OUTOUT ATOMS IN 'CHIME' PDB FORMAT
CDJWFEB2000
C--
      CHARACTER*6 CLAB
\ISTORE
      DIMENSION A(3)
C
\STORE
\XCOMPD
\XCONST
\XLISTI
\XUNITS
\XTAPES
\XSSVAL
\XCHARS
\XLST01
\XLST05
\XERVAL
\XOPVAL
\XIOBUF
\TSSCHR
\XSSCHR
\UFILE
C
\QSTORE
C
      IF (KEXIST(1) .LT. 1) THEN
      WRITE(CMON,'('' No Cell Parameters Available'')')
      CALL XPRVDU(NCVDU, 1,0)
      RETURN
      ENDIF
      IF (KEXIST(5) .LT. 1) THEN
      WRITE(CMON,'('' No Atoms Available'')')
      CALL XPRVDU(NCVDU, 1,0)
      RETURN
      ENDIF
      CALL XFAL01
      CALL XFAL05
C---- OPEN THE .XYZ FILE
      CALL XMOVEI(KEYFIL(1,23), KDEV, 4)
      CALL XRDOPN(6, KDEV , 'PUBLISH.PDB', 11)

      WRITE(NCFPU1,9100) (STORE(I),I=L1P1,L1P1+2)
     1 ,(RTD*STORE(I),I=L1P1+3,L1P1+5)
9100  format('CRYST1',3F9.3,3F7.2)
      M5 = L5
      DO 100 I = 1, N5
C--COMPUTE THE ORTHOGONAL COORDINATES OF THE ATOM
      CALL XMLTTM(STORE(L1O1),STORE(M5+4),A,3,3,1)
      WRITE(CLAB,'(A4)') STORE(M5)
      IF (CLAB(2:2) .EQ. ' ') THEN
            CLAB(2:2) = CLAB(1:1)
            CLAB(1:1) = ' '
      ENDIF
      IF (STORE(M5+1) .LE. 9 ) THEN
       WRITE(CLAB(3:3),'(I1)') NINT(STORE(M5+1))
      ELSE IF (STORE(M5+1) .LE. 99 ) THEN
       WRITE(CLAB(3:4),'(I2)') NINT(STORE(M5+1))
      ELSE IF (STORE(M5+1) .LE. 999 ) THEN
       WRITE(CLAB(3:5),'(I3)') NINT(STORE(M5+1))
      ENDIF
      WRITE(NCFPU1,  105) I, CLAB, A
105   FORMAT('ATOM',I7,1X,A6,7X,'0',4X,3F8.3)

      M5 = M5 + MD5
100   CONTINUE
C Close the .PDB FILE
        CALL XMOVEI(KEYFIL(1,23), KDEV, 4)
        CALL XRDOPN(7, KDEV , CSSMAP, LSSMAP)
      RETURN
      END
CODE FOR XPCH38
      SUBROUTINE XPCH38
C--PUNCH LIST 38 IN CRYSTALS FORMAT
C
C--
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XUSLST
\XLST38
\XOPVAL
C
\QSTORE
C
C--LOAD LIST 38 FROM THE DISC
      CALL XFAL38
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--PUNCH OUT THE LIST HEADING
      LN38 = 38
      CALL XPCHLH (LN38)
C--OUTPUT THE CONTENTS RECORD
      WRITE(NCPU,1000) N38GR, N38AT, N38LK, N38OR, N38VC
1000  FORMAT('READ NGROUP= ',I5, ' NATOM= ',I5, ' NLINK= ',I5,
     2 ' NORIGIN= ',I5, ' NVECTOR= ',I5)
C
C----- CHECK FOR SOME GROUPS
      IF(N38GR)8200,8200,1100
1100  CONTINUE
      M38GR = L38GR
      M38LK = L38LK
      M38OR = L38OR
      M38VC = L38VC
      M38AT = L38AT
C----- LOOP OVER ALL GROUPS - REMEMBER THERE IS A LINK FOR EACH GROUP.
C
      DO 2000 M38 = 1,N38GR
      I = M38GR + MD38GR -1
      WRITE(NCPU,1200) (STORE(J),J=M38GR,I)
1200  FORMAT('GROUP ',A4,1X,F5.0,1X,F4.0,4(1X,F10.5),/
     2 ('CONT      ',6(1X,F10.5)) )
      I = M38LK + MD38LK -1
      WRITE(NCPU,1250) (ISTORE(J),J=M38LK,I)
1250  FORMAT('LINK',6X,6(1X,2I5))
C
C----- ANY ATOM CARDS ?
      IF (ISTORE(M38LK +1)) 1300,1300,1400
1300  CONTINUE
      WRITE(NCAWU,1350)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1350)
      ENDIF
1350  FORMAT(1X,' LIST 38 error. A group contains no atoms ')
      GOTO 9900
1400  CONTINUE
      I = M38AT + MD38AT*ISTORE(M38LK +1) -1
      WRITE(NCPU,1450) (STORE(J),J=M38AT,I)
1450  FORMAT('ATOM      ', A4,1X,F5.0)
      M38AT = M38AT + MD38AT*ISTORE(M38LK +1)
C
C----- ANY ORIGIN CARDS ?
      IF (ISTORE(M38LK+3)) 1600,1600,1500
1500  CONTINUE
      I = M38OR + MD38OR*ISTORE(M38LK +3) -1
      WRITE(NCPU,1550) (STORE(J),J=M38OR,I)
1550  FORMAT(('ORIGIN    ', A4,6(1X,F5.0)))
      M38OR = M38OR + MD38OR*ISTORE(M38LK+3)
1600  CONTINUE
C
C----- ANY VECTOR CARDS ?
      IF (ISTORE(M38LK+5)) 1750,1750,1650
1650  CONTINUE
      I = M38VC + MD38VC*ISTORE(M38LK +5) -1
      WRITE(NCPU,1700) (STORE(J),J=M38VC,I)
1700  FORMAT(('VECTOR    ', A4,6(1X,F5.0)))
      M38VC = M38VC + MD38VC*ISTORE(M38LK+3)
1750  CONTINUE
C
      M38GR = M38GR + MD38GR
      M38LK = M38LK + MD38LK
2000  CONTINUE
 
C--AND NOW THE 'END'
      CALL XPCHND
      CALL XPCHUS
      RETURN
C
8200  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,8300)
      ENDIF
      WRITE(NCAWU,8300)
8300  FORMAT(' There are no GROUP definitions stored')
      GOTO 9900
C
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPPCH , IOPLSP , 38 )
      RETURN
      END
C
CODE FOR XPCH6S
      SUBROUTINE XPCH6S
C--PUNCH LIST 6 IN S.F.L.S. FORMAT
C
C--
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XLST01
\XUSLST
\XLST06
\XOPVAL
C
\QSTORE
C
      IF (KEXIST(1) .GE. 1) CALL XFAL01
C--SET UP LIST 6 FOR READING ONLY
      IN = 0
      CALL XFAL06(IN)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--PUNCH THE INITIAL HEADING
      CALL XPCHLH(LN6)
C--PUNCH THE 'READ', 'INPUT' AND 'FORMAT' CARDS
      WRITE(NCPU,1000)
C>DJW280896
1000  FORMAT('READ NCOEFFICIENT = 11, TYPE = FIXED, UNIT = DATAFILE' ,
     1 ', CHECK=NO' /
     2 'INPUT H K L /FO/ SIGMA(/FO/) /FC/ PHASE RATIO  /FOT/ ELEMENTS'
     4 ,' SQRTW' /
     3 'FORMAT (3F4.0,F10.2,F8.2,F10.2,F8.4,F 6.2,F10.2,F3.0,G12.5)'
     5 / 'END')
C<DJW280896
C--FETCH THE NEXT REFLECTION
1050  CONTINUE
CDJWMAR99       PUNCH LESS THANS
C      IF (KFNR(IN)) 1250, 1100, 1100
      IF (KLDRNR(IN)) 1250, 1100, 1100
C--FIX THE INDICES
1100  CONTINUE
      J=M6+2
      DO 1150 I=M6,J
      ISTORE(I)=NINT(STORE(I))
1150  CONTINUE
C--FIX THE ELEMENTS
      ISTORE(M6+11)=NINT(STORE(M6+11))
C--PUNCH THE REFLECTION
      WRITE(NCPU,1200)(ISTORE(I),I=M6,J),STORE(M6+3),STORE(M6+12),
     2 STORE(M6+5),STORE(M6+6),STORE(M6+20),STORE(M6+10),ISTORE(M6+11),
     3 STORE(M6+4)
1200  FORMAT(3I4,F10.2,F8.2,F10.2,F8.4,F6.2,F10.2,I3,G12.5)
      GOTO 1050
C--TERMINATE THE LIST
1250  CONTINUE
      I = -512
      WRITE(NCPU,1200)I
      CALL XPCHUS
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPPCH , IOPLSP , 6 )
      RETURN
      END
C
CODE FOR XPCH6O
      SUBROUTINE XPCH6O
C--PUNCH THE OBSERVED QUANTITIES FOR EACH REFLECTION
C
C--
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XLST01
\XUSLST
\XLST06
\XOPVAL
C
\QSTORE
C
      IF (KEXIST(1) .GE. 1) CALL XFAL01
C--SET UP LIST 6 FOR READING ONLY
      IN = 0
      CALL XFAL06(IN)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--PUNCH THE INITIAL HEADING
      CALL XPCHLH(LN6)
C--PUNCH THE 'READ', 'INPUT' AND 'FORMAT' CARDS
      WRITE(NCPU,1000)
1000  FORMAT(53HREAD NCOEFFICIENT = 12, TYPE = FIXED, UNIT = DATAFILE ,
     1  10H, CHECK=NO/
     2 41HINPUT H K L /FO/ SIGMA(/FO/) JCODE RATIO ,
     3 38H BATCH TBAR CORRECTIONS /FOT/ ELEMENTS/14HFORMAT (3F4.0,,
     4 44HF10.2,F8.2,F3.0,F7.1,F3.0,2E12.5,F10.2,F3.0)/3HEND)
C--FETCH THE NEXT REFLECTION
1050  CONTINUE
CDJWMAR99       PUNCH LESS THANS
C      IF (KFNR(IN)) 1250, 1100, 1100
      IF (KLDRNR(IN)) 1250, 1100, 1100
C--FIX THE INDICES
1100  CONTINUE
      J=M6+2
      DO 1150 I=M6,J
      ISTORE(I)=NINT(STORE(I))
1150  CONTINUE
C--FIX THE ELEMENTS
      ISTORE(M6+11)=NINT(STORE(M6+11))
C--FIX THE 'JCODE', 'SERIAL' AND 'BATCH'
      ISTORE(M6+18)=NINT(STORE(M6+18))
      ISTORE(M6+13)=NINT(STORE(M6+13))
      ISTORE(M6+19)=NINT(STORE(M6+19))
C--PUNCH THE REFLECTION
      WRITE(NCPU,1200)(ISTORE(I),I=M6,J),STORE(M6+3),STORE(M6+12),
     2 ISTORE(M6+18),STORE(M6+20),ISTORE(M6+13),STORE(M6+9),
     3 STORE(M6+27),STORE(M6+10),ISTORE(M6+11)
1200  FORMAT(3I4,F10.2,F8.2,I3,F7.1,I3,2E12.5,F10.2,I3)
      GOTO 1050
C--TERMINATE THE LIST
1250  CONTINUE
      I = -512
      WRITE(NCPU,1200)I
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPPCH , IOPLSP , 6 )
      RETURN
      END
C
CODE FOR XPCH6G
      SUBROUTINE XPCH6G(IN)
C--GENERAL COMPRESSED PUNCHING ROUTINES FOR LIST 6
C
C  IN  THE TYPE OF PUNCHING REQUIRED :
C
C      IN - NOT USED (AUG95)
C      -1  '/FO/', OR '/FOT/' AND 'ELEMENTS', DEPENDING UPON LIST 13.
C       0  AS FOR -1, EXCEPT THAT 'RATIO' IS ALSO PUNCHED.
C
C--THE INITIAL INDICES FOR EACH KL GROUP APPEAR ON A SEPARATE CARD.
C  THE END OF EACH KL GROUP IS INDICATED BY A NEGATIVE CARD SEQUENCE
C  NUMBER FOR THE LAST CARD.
C
C--THE FORMAT OF EACH CARD IS   (HSTEP  KEY1  KEY2  .  .)  REPEATED
C  THE 'HSTEP' GIVES THE INCREMENT FROM THE LAST REFLECTION, SO THAT THE
C  DATA MUST BE SORTED.
C
C--INDEX STEPS WHICH ARE NEGATIVE LEAD TO THE REFLECTION BEING REJECTED
C  ON INPUT.
C
C--
\ISTORE
C
      DIMENSION AA(5),IPOS(5)
C
\STORE
\XUNITS
\XSSVAL
\XLST01
\XUSLST
\XCONST
\XCHARS
\XLST06
\XLST13
\XOPVAL
C
\QSTORE
C
      IF (KEXIST(1) .GE. 1) CALL XFAL01
C----- DEFINE IN TO BE 0, I,E. FULL PUNCH
      IN = 0
C--INCREMENT THE VALUE OF 'IN'
      IN=IN+2
C--SET THE NUMBER OF COEFFICIENTS, APART FROM THE INDICES
      NW=IN
C--LOAD LIST 13
      CALL XFAL13
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--CHECK IF THIS STRUCTURE IS TWINNED
      IF(ISTORE(L13CD+1))1050,1000,1000
C--TWINNED  -  ADJUST 'IN' AND 'NW'
1000  CONTINUE
      IN=IN+2
      NW=IN-1
C--CLEAR THE CORE
1050  CONTINUE
      CALL XRSL
      CALL XCSAE
C--SET UP LIST 6 FOR INPUT
      IN1 = 0
      CALL XFAL06(IN1)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--BRANCH ON THE INPUT TYPE
      GOTO(1200,1150,1300,1250,1100),IN
C1100  STOP 230
1100  CALL GUEXIT(230)
C--/FO/ AND RATIO
1150  CONTINUE
      IPOS(2)=M6+20
C--/FO/
1200  CONTINUE
      IPOS(1)=M6+3
      GOTO 1350
C--/FOT/, ELEMENTS AND RATIO
1250  CONTINUE
      IPOS(3)=M6+20
C--/FOT/ AND ELEMENTS
1300  CONTINUE
      IPOS(1)=M6+10
      IPOS(2)=M6+11
C--FIND THE MULTIPLIERS
1350  CONTINUE
      DO 1450 I=1,NW
      M6DTL=L6DTL+MD6DTL*(IPOS(I)-M6)
C--CHECK IF THERE ARE ANY DETAILS STORED
      AA(I)=1.
      IF(STORE(M6DTL+3)-ZERO)1450,1400,1400
C--COMPUTE THE MULTIPLIER
1400  CONTINUE
      AA(I)=999./STORE(M6DTL+1)
1450  CONTINUE
C--CHECK IF THIS IS FOR A TWINNED CRYSTAL
      IF(IN-2)1550,1550,1500
C--TWINNED  -  MULTIPLIER FOR ELEMENTS IS 1.0
1500  CONTINUE
      AA(2)=1.
C--PUNCH THE LIST TYPE
1550  CONTINUE
      CALL XPCHLH(LN6)
C--PUNCH THE 'READ' CARD
      I=NW+3
      WRITE(NCPU,1600)I
1600  FORMAT(20HREAD NCOEFFICIENT = ,I5,
     2 36H, TYPE = COMPRESSED, UNIT = DATAFILE)
C--CHECK FOR A TWINNED STRUCTURE
      IF(IN-2)1650,1650,1750
C--NOT TWINNED
1650  CONTINUE
      WRITE(NCPU,1700)(IB,I=1,IN)
1700  FORMAT(20HINPUT  H  K  L  /FO/,2A1,5HRATIO)
      GOTO 1850
C--TWINNED STRUCTURE
1750  CONTINUE
      WRITE(NCPU,1800)(IB,I=3,IN)
1800  FORMAT(31HINPUT  H  K  L  /FOT/  ELEMENTS,2A1,5HRATIO)
C--OUTPUT THE MULTIPLIERS
1850  CONTINUE
      WRITE(NCPU,1900)(AA(I),I=1,NW)
1900  FORMAT(28HMULTIPLIERS  1.0  1.0  1.0  ,3F17.9)
      CALL XPCHND
C--SET UP A FEW INITIAL CONSTANTS
      CALL XPCHIN(80)
      IK1=-1000000
C--FETCH THE NEXT REFLECTION
1950  CONTINUE
CDJWMAR99       PUNCH LESS THANS
C      IF (KFNR(IN)) 1250, 1100, 1100
      IF (KLDRNR(IN1)) 2400, 2000, 2000
C--COMPUTE THE INDICES
2000  CONTINUE
      JH=NINT(STORE(M6))
      IK=NINT(STORE(M6+1))
      IL=NINT(STORE(M6+2))
C--CHECK IF 'K' HAS CHANGED SINCE THE LAST REFLECTION
      IF(IK-IK1)2200,2050,2200
C--'K' HAS NOT CHANGED  -  CHECK IF 'L' HAS CHANGED
2050  CONTINUE
      IF(IL-IL1)2200,2100,2200
C--THIS IS THE SAME 'KL' PAIR  -  OUTPUT 'H' AND THE COEFFICIENTS
2100  CONTINUE
      CALL XPCHAR(JH)
      DO 2150 M=1,NW
      L=IPOS(M)
      I=NINT(STORE(L)*AA(M))
      CALL XPCHAR(I)
2150  CONTINUE
      GOTO 1950
C--CHANGE 'KL' PAIRS  -  OUTPUT THE TERMINATOR
2200  CONTINUE
      IF(IK1+1000000)2250,2350,2250
C--THIS IS NOT THE FIRST REFLECTION
2250  CONTINUE
      CALL XPCHAR(512)
C--CHECK IF 'L' HAS CHANGED
      IF(IL-IL1)2300,2350,2300
C--NEW LINE FOR NEXT 'L' VALUE
2300  CONTINUE
      CALL XPCHLL
2350  CONTINUE
      CALL XPCHAR(IK)
      CALL XPCHAR(IL)
      IK1=IK
      IL1=IL
      GOTO 2100
C--END OF THE REFLECTIONS  -  OUTPUT THE TERMINATOR
2400  CONTINUE
      CALL XPCHAR(-512)
      CALL XPCHLL
      CALL XPCHUS
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPPCH , IOPLSP , 6 )
      END
CODE FOR XPCH6C
      SUBROUTINE XPCH6C
C----- CIF FORMAT PUNCH
CDJWMAY99 - OUTPUT TO fOREIGN PUNCH UNIT
      CHARACTER*8 CBUF
      DIMENSION KDEV(4)
\TSSCHR
\XSSCHR
\UFILE
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XUSLST
\XCONST
\XCHARS
\XCOMPD
\XLST01
\XLST05
\XLST06
\XLST13
\XOPVAL
\QSTORE
      CALL XRSL
      CALL XCSAE
CRICAUG00 - PREAPRE TO APPEND CIF OUTPUT ON FRN1
      CALL XMOVEI(KEYFIL(1,23), KDEV, 4)
      CALL XRDOPN(8, KDEV , CSSCIF, LSSCIF)

      IF (KEXIST(1) .GE. 1) CALL XFAL01
      CALL XFAL05
      IN = 0
      CALL XFAL06(IN)
      IF (IERFLG .LT. 0) GOTO 9900
      SCALE = STORE(L5O)
      WRITE(NCFPU1, '(''# data_CRYSTALS_cif '')')
      WRITE(NCFPU1, '(''#  '',10A4)') (KTITL(I),I=1,10)
      CALL XDATER ( CBUF(1:8))
      WRITE(NCFPU1,'(''# _audit_creation_date  '',6X, 3(A2,A))')
     1 CBUF(7:8),'-',CBUF(4:5),'-',CBUF(1:2)
      WRITE(NCFPU1, '(''# _audit_creation_method      CRYSTALS '')')
      WRITE(NCFPU1, '(''# NOTE Fc on scale of Fo, '', F12.5)')SCALE
      WRITE(NCFPU1,1000)
1000  FORMAT ( 'loop_',/,'_refln_index_h'/,'_refln_index_k'/,
     1 '_refln_index_l'/,'_refln_F_meas'/,'_refln_F_calc'/,
     2 '_refln_F_sigma' )
1840  CONTINUE
      ISTAT = KLDRNR (IN)
      IF (ISTAT .LT. 0) GOTO 1850
      I = NINT(STORE(M6))
      J = NINT(STORE(M6+1))
      K = NINT(STORE(M6+2))
      FO = STORE(M6+3)
      FC = STORE(M6+5) * SCALE
      IF (STORE(M6+12) .LT. ZERO) THEN
      S = 0.0
      ELSE
      S =  STORE(M6+12)
      ENDIF
      WRITE(NCFPU1, '(3I4, 3F12.2)') I, J, K, FO, FC, S
      GOTO 1840
1850  CONTINUE
      GOTO 9999
9900  CONTINUE
      WRITE(NCFPU1,'(''#  '',10A4)') (KTITL(I),I=1,10)
9999  CONTINUE
CRIGAUG00 - CLOSE CIF
      CALL XRDOPN(7, KDEV , CSSCIF, LSSCIF)
      RETURN
      END
C
CODE FOR XPCHIN
      SUBROUTINE XPCHIN(IN)
C--INITIATE PUNCHING CONSTANTS
C
C  IN  NUMBER OF CHARACTERS ON A LINE
C
C--THIS SET OF ROUTINES USES THE VARIABLES IN 'XWORKA' :
C
C  JO  BOTTOM LOCATION MINUS ONE FOR THE OUTPUT ARRAY
C  JP  BOTTOM LOCATION FOR THE OUTPUT ARRAY
C  JQ  TOP LOCATION FOR THE OUTPUT ARRAY PLUS TWO
C  JR  TOP LOCATION FOR THE OUTPUT ARRAY
C  JS  CURRENT POSITION IN THE OUTPUT ARRAY
C
C--
\STORE
\XLISTI
\XWORKA
C
      IREC=7501
C--SET UP THE CONSTANTS
      JO=NFL-1
      JP=NFL
      JQ=KCHNFL(IN+1)
      JR=JQ-2
      JS=JO
      RETURN
      END
C
CODE FOR XPCHAR
      SUBROUTINE XPCHAR(N)
C--OUTPUT A NUMBER TO THE BUFFER
C
C  N  THE NUMBER TO BE OUTPUT
C
C--
C
C
      DIMENSION IT(20)
\ISTORE
C
\STORE
\XWORKA
\XCHARS
C
\QSTORE
C
C--INSERT THE FINAL BLANK
      M=1
      IT(M)=IB
      I=IABS(N)
C--CHECK IF THE VALUE IS ZERO
      IF(I)1050,1000,1050
C--THE VALUE IS ZERO
1000  CONTINUE
      M=2
      IT(M)=NUMB(1)
      GOTO 1200
C--PROCESS THE NEXT NUMBER
1050  CONTINUE
      J=I
      I=I/10
      J=J-I*10
      M=M+1
      IT(M)=NUMB(J+1)
      IF(I)1100,1100,1050
C--CHECK THE SIGN OF THE INPUT NUMBER
1100  CONTINUE
      IF(N)1150,1200,1200
C--INSERT THE NEGATIVE SIGN
1150  CONTINUE
      M=M+1
      IT(M)=MINUS
C--CHECK IF THERE IS ROOM FOR THIS NUMBER IN THE CORE BUFFER
1200  CONTINUE
      IF(JS+M-JQ)1300,1250,1250
C--PRINT THE LAST CARD
1250  CONTINUE
      CALL XPCHLL
C--OUTPUT THE LAST NUMBER
1300  CONTINUE
      JS=JS+M
      J=JS
      DO 1350 I=1,M
      ISTORE(J)=IT(I)
      J=J-1
1350  CONTINUE
      RETURN
      END
C
CODE FOR XPCHLL
      SUBROUTINE XPCHLL
C--OUTPUT THE LAST CARD THAT HAS BEEN ASSEMBLED
C
C--
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XWORKA
C
\QSTORE
C
C--PUNCH THE LAST CARD
      JS=MIN0(JS,JR)
      WRITE(NCPU,1000)(ISTORE(I),I=JP,JS)
1000  FORMAT(80A1)
      JS=JO
      RETURN
      END
C
CODE FOR XPCHLH
      SUBROUTINE XPCHLH(IN)
C--PUNCH OUT THE LIST HEADING
C
\XCHARS
\XUNITS
\XSSVAL
C
      CALL XDATE(A,B)
      CALL XTIME(C,D)
      WRITE(NCPU,1000)IH,IH,A,B,C,D,IH,IH,IN
1000  FORMAT(A1,79X/A1,12H Punched on ,2A4,4H at ,2A4,47X
     1 /A1,79X/A1,4HLIST,I7,68(' '))
      RETURN
      END
C
CODE FOR XPCHND
      SUBROUTINE XPCHND
C--PUNCH OUT AN 'END'
C
C--
\XUNITS
\XSSVAL
C
      WRITE(NCPU,1000)
1000  FORMAT(3HEND,77(' '))
      RETURN
      END
C
C
CODE FOR XPCHUS
      SUBROUTINE XPCHUS
C
C----- WRITE A 'USE' CARD
\XUNITS
\XSSVAL
\XCHARS
C
      WRITE ( NCPU , 1000 ) IH, IH
1000  FORMAT(A1,' Remove space after hash to activate next line',/
     1  A1, ' USE LAST')
      RETURN
      END
 
C
C
C
CODE FOR XPCHLX
      SUBROUTINE XPCHLX(NUMB,IADDD,LENGRP,NGRP)
C--PUNCH A CARD IMAGE PRODUCED BY THE LEXICAL SCANNER.
C      (SEE ALSO XPRTLC)
C
C  NUMB    THE CARD NUMBER.
C  IADDD   THE DISC ADDRESS OF THE LOGICAL CARD.
C  LENGRP  THE LENGTH OF EACH REAL CARD.
C  NGRP    THE NUMBER OF REAL CARDS IN THIS LOGICAL CARD.
C
C--
      CHARACTER *88 CLINE
C
      DIMENSION CARD(20)
C
\XUNITS
\XSSVAL
C
C--MARK THIS AS THE FIRST REAL CARD
      J=0
C--FIND THE ADDRESS AND LENGTH POINTERS
      N=NGRP
      M=LENGRP
      L=IADDD
C--FIND THE LENGTH TO PRINT
      K=MIN0(M,20)
C--CHECK IF THERE ARE MORE CARDS TO PRINT
1000  CONTINUE
      IF(N)1050,1050,1100
C--NO MORE CARDS  -  RETURN
1050  CONTINUE
      RETURN
C--READ THIS IMAGE DOWN
1100  CONTINUE
      CALL XDOWNF(L,CARD(1),K)
C--UPDATE THE POINTERS
      L=L+KINCRF(M)
      N=N-1
C--CHECK IF THIS IS THE FIRST CARD
      WRITE(CLINE,1200)  CARD
      CALL XCTRIM (CLINE, NCHAR)
      KK = MIN0 ( 80, NCHAR)
      WRITE(NCPU,'(A)')  CLINE(1:KK)
      IF (NCHAR .GE. 81) THEN
       KK = KK + 1
       WRITE(NCPU,'(A)')  CLINE(KK:NCHAR)
      ENDIF
1200  FORMAT(20A4)
      J=1 + J
      GOTO 1000
      END
 

CODE FOR XTRIAL
      SUBROUTINE XTRIAL
C--MOVE A MOLECULE AROUND AND PLOT SUM(FO*FC) AT EACH POINT
C
C  AM      MINIMUM VALUE OF FO TO BE USED (ON SCALE OF FO)
C  SCALE   MAP SCALE FACTOR  -  AUTOMATIC SCALING DONE IF ZERO
C  ITHRES  VALUE BELOW WHICH ALL NUMBERS ARE PRINTED AS ZEROES
C  NX      THE NUMBER OF POINTS ALONG X TO MOVE.
C  NY      THE NUMBER OF POINTS ALONG Y TO MOVE.
C  NZ      THE NUMBER OF POINTS ALONG Z TO MOVE.
C          (THESE DIRECTIONS ARE AFTER TRANSFORMATION.)
C  BPD     LOCATIONS 7-9 CONTAIN THE INITIAL ORIGIN DISTPALCEMENT.
C  APD     THE STEP VECTOR.
C
C--
\ISTORE
C
      DIMENSION PROCS(26)
      DIMENSION A1(26)
      DIMENSION APD(13), BPD(13)
C
\STORE
\XLISTI
\XCONST
\XUNITS
\XSSVAL
\XCHARS
\XWORK
\XWORKA
\XLST01
\XLST02
\XLST03
\XLST05
\XLST06
\XERVAL
\XOPVAL
\XIOBUF
C
\QSTORE
C
      EQUIVALENCE (PROCS(1),APD(1)), (BPD(1),PROCS(14))
      EQUIVALENCE (AM,BPD(1)),(SCALE,BPD(2)),(ITHRES,BPD(3))
      EQUIVALENCE (NNX,BPD(4)),(NNY,BPD(5)),(NNZ,BPD(6))
      EQUIVALENCE (A1(1),A)
C
C
      DATA NCOL/28/
C
      NW=7
C--INITIALISE THE TIMING
      CALL XTIME1(2)
C--READ THE DIRECTIVES
      ISTAT = KRDDPV ( PROCS , 26 )
      IF ( ISTAT .LT. 0 ) GO TO 9910
C--CLEAR THE CORE
1050  CONTINUE
      CALL XRSL
      CALL XCSAE
C--ASSIGN A FEW INPUT CONTROL VALUES
      NX=MAX0(1,NNX)
      NY=MAX0(1,NNY)
      NZ=MAX0(1,NNZ)
C--LOAD A FEW LISTS
      CALL XFAL01
      CALL XFAL02
      CALL XFAL03
      CALL XFAL05
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--LINK LIST 5 TO VARIOUS OTHER LISTS
      JJ=-1
      JA=1
      IF(KSET52(-1,0))1150,1100,1100
1100  CONTINUE
      IF ( IERFLG .LT. 0 ) GO TO 9900
      JJ=0
      JA=N2
1150  CONTINUE
      N3=KSET53(0)+1
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--SET THE INITIAL TRANSFORMED COORD. VALUES
      MINX=0
      MINY=0
      MINZ=0
C--APPLY THE INITIAL DISPALCEMENT
      M5=L5
      DO 1200 I=1,N5
      STORE(M5+4)=STORE(M5+4)+BPD(7)
      STORE(M5+5)=STORE(M5+5)+BPD(8)
      STORE(M5+6)=STORE(M5+6)+BPD(9)
      M5=M5+MD5
1200  CONTINUE
C--SET UP LIST 6 FORM READING
      CALL XFAL06(0)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--SET UP THE INITIAL REFLECTION DATA
      CALL XSFLSQ(AM,BM)
C
C--SET UP A FEW CONSTANTS FOR THE MAP
      W=1000./BM
      IF(SCALE-ZEROSQ)1300,1300,1250
1250  CONTINUE
      W=SCALE
1300  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1350)W
      ENDIF
1350  FORMAT(///,' Scale factor',E20.10)
C--CHECK THAT THERE ARE SOME REFLECTIONS
      IF(ND)1400,1400,1500
1400  CONTINUE
      CALL XERHDR(0)
      WRITE ( CMON , 1450)
      CALL XPRVDU(NCVDU, 1,0)
      WRITE(NCAWU, '(/A)') CMON(1 )(:)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(/A)') CMON(1)(:)
1450  FORMAT(/,' No reflections')
      GOTO 1050
C--SET UP THE MAP AND ACCUMULATION AREAS
1500  CONTINUE
      L8=NFL
      NQ=NX*NY
      LN=8
      IREC=5001
      NO=KCHNFL(3*NQ)-1
      MD8=NY
      NP=L8+NQ
C--SET UP THE NUMBER AREA
      IREC=5002
      NS=KCHLFL(NCOL)
C
C--MAIN CALCULATION LOOP
      DO 2950 N1=1,NZ
      M8=NY-1
C--CLEAR THE MAP AREA
      DO 1550 I=L8,NP
      STORE(I)=0.
1550  CONTINUE
      NB=NA
C--PASS OVER EACH REFLECTION
      DO 2300 I1=1,ND
C--CLEAR THE REFLECTION ACCUMULATION AREA
      DO 1600 J1=NP,NO
      STORE(J1)=0.
1600  CONTINUE
      JF=NB
C--PASS OVER EACH SYMMETRY POSITION FOR EACH RELFECTION
      DO 2050 J1=1,N2
      JG=JF+6
C--INCREMENT THE COS TERMS TO THE NEW LAYER
      DO 1650 K1=JF,JG,2
      A=STORE(K1)
      STORE(K1)=STORE(JF+20)*STORE(K1)-STORE(K1+8)
      STORE(K1+8)=A
1650  CONTINUE
      A=STORE(JF)
      B=STORE(JF+2)
      C=STORE(JF+4)
      D=STORE(JF+6)
      O=STORE(JF+16)
      P=STORE(JF+18)
      L=NP
C--PASS ALONG THE X ROWS
      DO 1750 J=1,NX
      A1(7)=A1(2)
      A1(2)=A1(15)*A1(2)-A1(1)
      A1(5)=A1(2)
      A1(1)=A1(7)
      A1(7)=A1(4)
      A1(4)=A1(15)*A1(4)-A1(3)
      A1(6)=A1(4)
      A1(3)=A1(7)
      M=L+M8
C--ADD IN ALONG THE Y ROWS
      DO 1700 K=L,M
      A1(7)=A1(6)
      A1(6)=A1(16)*A1(6)-A1(5)
      A1(5)=A1(7)
      STORE(K)=STORE(K)+A1(6)
1700  CONTINUE
      L=L+MD8
1750  CONTINUE
C--CHECK IF THIS IS A NON-CENTRO STRUCTURE
      IF(IC)1800,1800,2000
C--NON-CENTRO
1800  CONTINUE
C--UPDATE THE SIN TERMS
      DO 1850 K1=JF,JG,2
      A=STORE(K1+1)
      STORE(K1+1)=STORE(JF+20)*STORE(K1+1)-STORE(K1+9)
      STORE(K1+9)=A
1850  CONTINUE
      A=STORE(JF+1)
      B=STORE(JF+3)
      C=STORE(JF+5)
      D=STORE(JF+7)
      L=NP+NQ
C--PASS ALONG THE X ROWS
      DO 1950 J=1,NX
      A1(7)=A1(2)
      A1(2)=A1(15)*A1(2)-A1(1)
      A1(5)=A1(2)
      A1(1)=A1(7)
      A1(7)=A1(4)
      A1(4)=A1(15)*A1(4)-A1(3)
      A1(6)=A1(4)
      A1(3)=A1(7)
      M=L+M8
C--ADD IN ALONG THE Y ROWS
      DO 1900 K=L,M
      A1(7)=A1(6)
      A1(6)=A1(16)*A1(6)-A1(5)
      A1(5)=A1(7)
      STORE(K)=STORE(K)+A1(6)
1900  CONTINUE
      L=L+MD8
1950  CONTINUE
2000  CONTINUE
      JF=JF+NE
2050  CONTINUE
      NB=NB+NC
C--CALCULATE THE FINAL FC AND ADD IT IN
      I=L8
      J=L8+NQ-1
      L=NP
      M=NP+NQ
      IF(IC)2100,2100,2200
C--NON-CENTRO
2100  CONTINUE
      DO 2150 K=I,J
      STORE(K)=STORE(K)+SQRT(STORE(L)*STORE(L)+STORE(M)*STORE(M))
      L=L+1
      M=M+1
2150  CONTINUE
      GOTO 2300
C--CENTRO
2200  CONTINUE
      DO 2250 K=I,J
      STORE(K)=STORE(K)+ABS(STORE(L))
      L=L+1
2250  CONTINUE
2300  CONTINUE
C
C--MAIN MAP PRINTING ROUTINES
      JA=MINY
      JB=NY
      JZ=1
      M8=L8
2400  CONTINUE
      JY=MIN0(JB,NCOL)-1
      JC=JA+JY
      CALL XPRTCN
      JD=NS-1
      DO 2450 I=JA,JC
      ISTORE(JD+1)=I
      JD=JD+1
2450  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2500)MINZ,JZ,(ISTORE(I),I=NS,JD)
      ENDIF
2500  FORMAT(' Trial map',5X,'Section',I4,5X,'Part',I3///8X,28I4)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2550)(IA,I=NS,JD)
      ENDIF
2550  FORMAT(8X,28(3X,A1))
      JE=M8
      JG=MINX
      DO 2850 I=1,NX
      JF=JE+JY
      DO 2750 J=JE,JF
      STORE(J)=STORE(J)*W
      IF(STORE(J)-999.)2650,2650,2600
2600  CONTINUE
      ISTORE(J)=999
      GOTO 2750
2650  CONTINUE
      ISTORE(J)=NINT(STORE(J))
      IF(ISTORE(J)-ITHRES)2700,2750,2750
2700  CONTINUE
      ISTORE(J)=0
2750  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2800)JG,IA,IB,(ISTORE(J),J=JE,JF)
      ENDIF
2800  FORMAT(/1X,I4,1X,2A1,28I4)
      JE=JE+MD8
      JG=JG+1
2850  CONTINUE
      JZ=JZ+1
      JY=JY+1
      JA=JA+JY
      M8=M8+JY
      JB=JB-JY
C--MORE TO PRINT
      IF(JB)2900,2900,2400
2900  CONTINUE
      MINZ=MINZ+1
2950  CONTINUE
C
C
C
3000  CONTINUE
C
C -- FINAL MESSAGE
C
      CALL XOPMSG ( IOPTRI , IOPEND , 200 )
      CALL XTIME2(2)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPTRI , IOPABN , 0 )
      GO TO 3000
9910  CONTINUE
C -- INPUT ERROR
      CALL XOPMSG ( IOPTRI , IOPCMI , 0 )
      GO TO 9900
      END
C
CODE FOR XSFLSQ
      SUBROUTINE XSFLSQ(S,U)
C--MAIN STRUCTURE FACTOR CALCULATION ROUTINE
C
C  S  MIN VALUE OF FO (ON SCALE OF FO)
C  U  MAX. VALUE OF SUM(FO*FC)
C
C--USEAGE OF CONTROL VARIABLES :
C
C  JA  SET TO 1 FOR ISO ATOMS ONLY , ELSE N2
C  JE
C  JF  USED FOR POINTERS TO THE SIN/COS TERMS FOR EACH REFLECTION
C  JG
C  JS  WORK VARIABLE
C  JT  WORK VARIABLES USED DURING ACCUMULATION OF PARTIAL DERIVATIVES
C  JU
C  JV
C  JW
C  JX  LOOP VARIABLE FOR EQUIVALENT POSITIONS
C  JY  LOOP VARIABLE FOR ATOMS
C  JZ  LOOP VARIABLE FOR THE VARIOUS SYMMETRIES
C
C--USEAGE OF GENERAL VARIABLES
C
C  TC    COEFFICIENT FOR THE ISO-TEMPERATURE FACTORS
C  SST   SIN(THETA)/LAMBDA SQUARED
C  ST    SIN(THETA)/LAMBDA
C  FOCC  FORM FACTOR MULTIPLIED BY THE OCCUPATION NUMBER
C  T     TEMPERATURE FACTOR
C  TFOCC T*FOCC
C
C--XLST07 CONTROLS THE REFLECTION STACK :
C
C  NA    ADDRESS OF THE FIRST ENTRY IN THE STACK
C  NB    CURRENT ADDRESS IN THE STACK
C  NE    NUMBER OF WORDS PER SYMMETRY POSITION IN THE REFLECTION STACK
C  ND    NUMBER OF REFLECTIONS IN THE STACK
C
C  NC   NUMBER OF WORDS PER REFLECTION IN THE STACK (=N2*NE)
C
C--THE FORMAT OF THE STACK IS :
C
C   0  SUM[ COS2PI(H'.S.X + H'.T - 2H'.S.DX - 2H'.S.DY -  H'.S.DZ) ]
C   1  SUM[ SIN2PI(H'.S.X + H'.T - 2H'.S.DX - 2H'.S.DY -  H'.S.DZ) ]
C   2  SUM[ COS2PI(H'.S.X + H'.T -  H'.S.DX - 2H'.S.DY -  H'.S.DZ) ]
C   3  SUM[ SIN2PI(H'.S.X + H'.T -  H'.S.DX - 2H'.S.DY -  H'.S.DZ) ]
C   4  SUM[ COS2PI(H'.S.X + H'.T - 2H'.S.DX -  H'.S.DY -  H'.S.DZ) ]
C   5  SUM[ SIN2PI(H'.S.X + H'.T - 2H'.S.DX -  H'.S.DY -  H'.S.DZ) ]
C   6  SUM[ COS2PI(H'.S.X + H'.T -  H'.S.DX -  H'.S.DY -  H'.S.DZ) ]
C   7  SUM[ SIN2PI(H'.S.X + H'.T -  H'.S.DX -  H'.S.DY -  H'.S.DZ) ]
C   8  SUM[ COS2PI(H'.S.X + H'.T - 2H'.S.DX - 2H'.S.DY - 2H'.S.DZ) ]
C   9  SUM[ SIN2PI(H'.S.X + H'.T - 2H'.S.DX - 2H'.S.DY - 2H'.S.DZ) ]
C  10  SUM[ COS2PI(H'.S.X + H'.T -  H'.S.DX - 2H'.S.DY - 2H'.S.DZ) ]
C  11  SUM[ SIN2PI(H'.S.X + H'.T -  H'.S.DX - 2H'.S.DY - 2H'.S.DZ) ]
C  12  SUM[ COS2PI(H'.S.X + H'.T - 2H'.S.DX -  H'.S.DY - 2H'.S.DZ) ]
C  13  SUM[ SIN2PI(H'.S.X + H'.T - 2H'.S.DX -  H'.S.DY - 2H'.S.DZ) ]
C  14  SUM[ COS2PI(H'.S.X + H'.T -  H'.S.DX -  H'.S.DY - 2H'.S.DZ) ]
C  15  SUM[ SIN2PI(H'.S.X + H'.T -  H'.S.DX -  H'.S.DY - 2H'.S.DZ) ]
C  16  H'.S.DX
C  17  2*COS2PI(H'.S.DX)
C  18  H'.S.DY
C  19  2*COS2PI(H'.S.DY)
C  20  H'.S.DZ
C  21  2*COS2PI(H'.S.DZ)
C
C--
\ISTORE
C
\STORE
\XLISTI
\XCONST
\XUNITS
\XSSVAL
\XWORKA
\XPDS
\XLST01
\XLST02
\XLST03
\XLST05
\XLST06
C
\QSTORE
C
C--INITIALISE TIMING OF THIS SECTION
      CALL XTIME1(3)
      U=0.
      ND=0
      SCALE=1.0/STORE(L5O)
      NA=NFL
      NE=22
      NC=NE*N2
      NB=NA-NC
      IF(N5)1100,1100,2150
C
C--START OF THE LOOP OVER REFLECTIONS
C
1000  CONTINUE
      IF(S-STORE(M6+3))1050,1050,2150
1050  CONTINUE
      ND=ND+1
      NB=NB+NC
      IF(NB+NC-LFL)1150,1100,1100
C--NO MORE STORE AVAILABLE
1100  CONTINUE
      CALL XICA
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2250)ND
      ENDIF
      ND=0
      GOTO 2300
1150  CONTINUE
C
C--CALCULATE THE INFORMATION FOR THE SYMMETRY POSITIONS
C
      M2=L2
      M2T=L2T
      JF=NB
      DO 1400 JZ=1,N2
      STORE(M2T)=STORE(M6)*STORE(M2)+STORE(M6+1)*STORE(M2+3)
     2 +STORE(M6+2)*STORE(M2+6)
      STORE(M2T+1)=STORE(M6)*STORE(M2+1)+STORE(M6+1)*STORE(M2+4)
     2 +STORE(M6+2)*STORE(M2+7)
      STORE(M2T+2)=STORE(M6)*STORE(M2+2)+STORE(M6+1)*STORE(M2+5)
     2 +STORE(M6+2)*STORE(M2+8)
C--CALCULATE THE H.T TERMS
      STORE(M2T+3)=(STORE(M6)*STORE(M2+9)+STORE(M6+1)*STORE(M2+10)
     2 +STORE(M6+2)*STORE(M2+11))*TWOPI
C--CHECK IF THE ANSIO CONTRIBUTIONS ARE REQUIRED
      IF(JA-JZ)1250,1200,1200
1200  CONTINUE
      STORE(M2T+4)=STORE(M2T)*STORE(M2T)
      STORE(M2T+5)=STORE(M2T+1)*STORE(M2T+1)
      STORE(M2T+6)=STORE(M2T+2)*STORE(M2T+2)
      STORE(M2T+7)=STORE(M2T+1)*STORE(M2T+2)
      STORE(M2T+8)=STORE(M2T)*STORE(M2T+2)
      STORE(M2T+9)=STORE(M2T)*STORE(M2T+1)
1250  CONTINUE
      STORE(M2T)=STORE(M2T)*TWOPI
      STORE(M2T+1)=STORE(M2T+1)*TWOPI
      STORE(M2T+2)=STORE(M2T+2)*TWOPI
C--CLEAR THE ACCUMULATION AREAS FOR EACH SYMMETRY POSITION
      JG=JF+NE-1
      DO 1300 JY=JF,JG
      STORE(JY)=0.
1300  CONTINUE
C--CALCULATE THE STEP VECTORS
      JG=JF+16
      DO 1350 JY=1,7,3
      STORE(JG+1)=STORE(M2T)*APD(JY)+STORE(M2T+1)*APD(JY+1)
     2 +STORE(M2T+2)*APD(JY+2)
      STORE(JG)=2.*COS(STORE(JG+1))
      JG=JG+2
1350  CONTINUE
      JF=JF+NE
      M2=M2+MD2
      M2T=M2T+MD2T
1400  CONTINUE
C--CALCULATE SIN(THETA)/LAMBDA SQUARED
      SST=STORE(L1S)*STORE(L2T+4)+STORE(L1S+1)*STORE(L2T+5)
     2 +STORE(L1S+2)*STORE(L2T+6)+STORE(L1S+3)*STORE(L2T+7)
     3 +STORE(L1S+4)*STORE(L2T+8)+STORE(L1S+5)*STORE(L2T+9)
      ST=SQRT(SST)
C--CALCULATE THE TEMPERATURE FACTOR COEFFICIENT
      TC=-SST*TWOPIS*4.
C--CHECK IF THE ANISO TERMS ARE REQUIRED
      IF(JJ)1550,1450,1450
1450  CONTINUE
      M2T=L2T
      DO 1500 JZ=1,N2
      STORE(M2T+4)=STORE(M2T+4)*STORE(L1A)
      STORE(M2T+5)=STORE(M2T+5)*STORE(L1A+1)
      STORE(M2T+6)=STORE(M2T+6)*STORE(L1A+2)
      STORE(M2T+7)=STORE(M2T+7)*STORE(L1A+3)
      STORE(M2T+8)=STORE(M2T+8)*STORE(L1A+4)
      STORE(M2T+9)=STORE(M2T+9)*STORE(L1A+5)
      M2T=M2T+MD2T
1500  CONTINUE
1550  CONTINUE
C
C--CALCULATE THE FORM FACTORS
      CALL XSCATT(ST)
      DO 1600 JZ=1,N3
      M3TR=L3TR+JZ-1
      STORE(M3TR)=STORE(M3TR)*G2
1600  CONTINUE
C
C--LOOP OVER THE ATOMS IN THE CELL
      M5A=L5
      DO 2100 JY=1,N5
C--PICK UP THE FORM FACTORS FOR THIS ATOM
      M3TR=L3TR+ISTORE(M5A)
      FOCC=STORE(M3TR)*STORE(M5A+2)
C--CHECK THE TEMPERAURE TYPE FOR THIS ATOM
      IF(ISTORE(M5A+1))1700,1750,1750
C--CALCULATE THE ISO-TEMPERATURE FACTOR COEFFICIENTS FOR THIS ATOM
1700  CONTINUE
      T=EXP(STORE(M5A+7)*TC)
      TFOCC=T*FOCC
C
C--LOOP CYCLING OVER THE DIFFERENT EQUIVALENT POSITIONS FOR THIS ATOM
C
1750  CONTINUE
      JF=NB
      M2T=L2T
      DO 2050 JX=1,N2T
C--SET UP THE H'.DX COMPONENTS FOR THIS SYMMETRY POSITION
      XDS=STORE(JF+17)
      YDS=STORE(JF+19)
      ZDS=STORE(JF+21)
C--CALCULATE H'.X+H.T - H'.DX
      A=STORE(M5A+4)*STORE(M2T)+STORE(M5A+5)*STORE(M2T+1)+STORE(M5A+6)
     2 *STORE(M2T+2)+STORE(M2T+3)-XDS-YDS-ZDS
C--CHECK THE TEMPERATURE FACTOR TYPE
      IF(ISTORE(M5A+1))1850,1800,1800
C--CALCULATE THE ANISO-TEMPERATURE FACTOR
1800  CONTINUE
      T=EXP(STORE(M5A+7)*STORE(M2T+4)+STORE(M5A+8)*STORE(M2T+5)
     2 +STORE(M5A+9)*STORE(M2T+6)+STORE(M5A+10)*STORE(M2T+7)
     3 +STORE(M5A+11)*STORE(M2T+8)+STORE(M5A+12)*STORE(M2T+9))
      TFOCC=T*FOCC
C--CALCULATE THE SIN/COS TERMS
1850  CONTINUE
      C=TFOCC*STORE(M6+3)*SCALE
      U=U+C
      STORE(JF)=STORE(JF)+C*COS(A-XDS-YDS)
      STORE(JF+2)=STORE(JF+2)+C*COS(A-YDS)
      STORE(JF+4)=STORE(JF+4)+C*COS(A-XDS)
      STORE(JF+6)=STORE(JF+6)+C*COS(A)
      STORE(JF+8)=STORE(JF+8)+C*COS(A-XDS-YDS-ZDS)
      STORE(JF+10)=STORE(JF+10)+C*COS(A-YDS-ZDS)
      STORE(JF+12)=STORE(JF+12)+C*COS(A-XDS-ZDS)
      STORE(JF+14)=STORE(JF+14)+C*COS(A-ZDS)
      IF(IC)1900,1900,1950
C--ADD IN THE NON-CENTRO PART
1900  CONTINUE
      STORE(JF+1)=STORE(JF+1)+C*SIN(A-XDS-YDS)
      STORE(JF+3)=STORE(JF+3)+C*SIN(A-YDS)
      STORE(JF+5)=STORE(JF+5)+C*SIN(A-XDS)
      STORE(JF+7)=STORE(JF+7)+C*SIN(A)
      STORE(JF+9)=STORE(JF+9)+C*SIN(A-XDS-YDS-ZDS)
      STORE(JF+11)=STORE(JF+11)+C*SIN(A-YDS-ZDS)
      STORE(JF+13)=STORE(JF+13)+C*SIN(A-XDS-ZDS)
      STORE(JF+15)=STORE(JF+15)+C*SIN(A-ZDS)
1950  CONTINUE
C--UPDATE THE SYMMETRY INFORMATION POINTER
      M2T=M2T+MD2T
      JF=JF+NE
2050  CONTINUE
      M5A=M5A+MD5A
2100  CONTINUE
C
C--PICK UP THE NEXT REFLECTION
2150  CONTINUE
      IF(KFNR(0)) 2200,1000,1000
2200  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2250)ND
      ENDIF
2250  FORMAT(///,' Structure factors end after',I6,'  reflection(s)')
2300  CONTINUE
      CALL XTIME2(3)
      NFL=NB+NC
      RETURN
      END
C
CODE FOR XSLANT
      SUBROUTINE XSLANT
C--SLANT FOURIER SUBROUTINE
C
C  IN     TYPE OF FOURIER :
C         1  FO
C         2  FC
C         3  DF
C         4  FO PATTERSON
C         5  FC PATTERSON
C  ITHRES PRINT 0 FOR ALL VALUES LESS THAN THIS
C  SCALE  MAP SCALE FACTOR
C  IWT    WEIGHTING
C         0 FOR NO, ELSE 1
C
C--USE OF VARIABLES :
C
C  R  STEP ALONG X IN THE PLANE
C  S  STEP ALONG Y IN THE PLANE
C  U  FINAL MAP SCALE FACTOR
C  V  FC SCALE FACTOR
C  W  SUM OF F*F FOR A PATTERSON
C  X  TRANSFORMED H
C  Y  TRANSFORMED K
C  Z  TRANSFORMED L
C
C--
\ISTORE
C
      PARAMETER (NPROCS = 28)
      DIMENSION PROCS(NPROCS)
      DIMENSION IPROCS(NPROCS)
      DIMENSION APD(13)
      DIMENSION A1(26)
      DIMENSION AMIN(3)
      CHARACTER*16 CMAPTP(5)
      CHARACTER*8  WTED
      DIMENSION KDEV(4)
C
\STORE
\XCONST
\XLISTI
\XUNITS
\XTAPES
\XSSVAL
\XWORK
\XWORKA
\XCHARS
\XLST01
\XLST02
\XLST05
\XLST06
\XLST20
\XERVAL
\XOPVAL
\XIOBUF

C For the name of the fourier.map file:
\TSSCHR
\XSSCHR
\UFILE

cjan99
        REAL START(3), STEPS(3),  TRANS(12)
        INTEGER NUM(3)
cjan99
C
\QSTORE
C
      EQUIVALENCE (APD(1),PROCS(1))
      EQUIVALENCE (IN,APD(10)),(ITHRES,APD(11)),(SCALE,APD(12))
      EQUIVALENCE (IWT, APD(13))
      EQUIVALENCE (A1(1),A)
      EQUIVALENCE (PROCS(1), IPROCS(1))
      EQUIVALENCE (IMODE, PROCS(27)), (IOUTAP, PROCS(26))
      EQUIVALENCE (IOUFIL, PROCS(28))
C
C
      DATA NCOL/28/
C
      DATA CMAPTP / '    F-Obs map   ' , '   F-Calc map   ' ,
     2              ' Difference map ' , '  FO-Patterson  ' ,
     3              '  FC-Patterson  ' /
C
C
      NW=7
C--INITIALISE THE TIMING FUNCTION
      CALL XTIME1(1)
C--READ THE DATA
      ISTAT = KRDDPV ( PROCS, NPROCS)
      IF ( ISTAT .LT. 0 ) GO TO 9910
C--LOAD LISTS ONE AND TWO
      CALL XRSL
      CALL XCSAE
      CALL XFAL01
      CALL XFAL02
      CALL XFAL20
C----- CHECK IF WE USE THE MOLAX MATRIX -
      IF (IMODE .GE. 1) THEN
      CALL XMOVE (STORE(L20V+ IMODE * MD20V), PROCS(14), 3)
C----- COPY AND TRANSPOSE
      CALL XTRANS (STORE(L20M+ IMODE * MD20M), PROCS(1), 3, 3)
      ENDIF
      IF ( IERFLG .LT. 0 ) GO TO 9900
      L2=L2I
      M2=L2+(N2-1)*MD2
C----- SET UP AREA FOR TAPE HEADER
      ITAPE = KCHLFL(21)
C--SET UP AN AREA FOR THE NEW CALCULATED INDICES
      LN=6
      IREC=8001
      JA=NFL
      JB=KCHNFL(N2*NW)
      JADUMP = JA
      JBDUMP = JB
      IF(SCALE-ZEROSQ)1100,1100,1150
1100  CONTINUE
      SCALE=10.
1150  CONTINUE
      U=SCALE
      IF (IWT .LE. 0) THEN
            WTED = '        '
      ELSE
            WTED = 'Weighted'
      ENDIF
C--INVERT THE ROTATION MATRIX
      LN=8
      IREC=8001
      L8RI=KCHLFL(9)
      L8R=KCHLFL(9)
      CALL XMOVE(PROCS(1),STORE(L8R),9)
C----- LOOK FOR SOME SORT OF MATRIX
      IF (ABS(XDETR3(PROCS(1))) .LE. ZERO) THEN
       WRITE ( CMON , 1060) (PROCS(I), I = 1,9)
       CALL XPRVDU(NCVDU, 4,0)
       WRITE(NCAWU, '(A)') (CMON(II)(:),II=1,4)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') (CMON(II)(:),II=1,4)
1060   FORMAT (' Your matrix is probably invalid ', 3(/3F9.3))
       GOTO 9900
      ENDIF
      IF(KINV2(3,STORE(L8R),STORE(L8RI),9,0,APD(1),APD(1),9))9920 ,
     1 1300 , 9920
C--MOVE THE CENTROID AND STEPS IN X, Y AND THE Z HEIGHT
1300  CONTINUE
C----- SPACE FOR THE SECTION LIMITS
      L8T= NFL
      I = KCHNFL(12)
C--READ DOWN THE SCALE FACTOR FROM LIST 5
      V=1.
      IF(KEXIST(5))1600,1600,1550
C--LOAD THE CURRENT LIST 5
1550  CONTINUE
      CALL XFAL05
      IF ( IERFLG .LT. 0 ) GO TO 9900
      V=1./STORE(L5O)
1600  CONTINUE
C--SET UP THE INPUT OF LIST 6
      CALL XFAL06(0)
      L6DUMP = L6R
      N6DUMP = N6R
C
      CALL XMOVE(PROCS(14),STORE(L8T),12)
C----- FLOAT THE NUMBER  OF POINTS (THE INTEGER IS STILL IN ISTORE)
      PROCS(18) = FLOAT( ISTORE(L8T+4))
      PROCS(21) = FLOAT( ISTORE(L8T+7))
      PROCS(24) = FLOAT( ISTORE(L8T+10))
C
C----- WRITE THE M/T HEADER  DETAILS
      IF (IOUTAP .GT. 0) THEN
          REWIND (MT1)
          WRITE (MT1) 'INFO  DOWN, ACROSS AND SECTION '
          WRITE (MT1) 'TRAN', (STORE(I), I=L8R, L8R+8),
     1       (PROCS(I), I=14,16)
          WRITE (MT1) 'CELL', (STORE(I), I = L1P1, L1P1+5)
          WRITE (MT1) 'L14 ',
     1       (STORE(I),STORE(I+2),(STORE(I)+(ISTORE(I+1)-1)*STORE(I+2)),
     1       1. , I = L8T+3, L8T+9, 3)
          WRITE (MT1) 'SIZE', ISTORE(L8T+4), ISTORE(L8T+7),
     1       ISTORE(L8T+10)
           NXNY = ISTORE(L8T+4) * ISTORE(L8T+7)
      END IF

      IF (IOUFIL .GT. 0 ) THEN
           CALL XMOVEI(KEYFIL(1,23), KDEV, 4)
           CALL XRDOPN(6, KDEV , CSSMAP, LSSMAP)
1651       FORMAT(A)
1652       FORMAT(F15.8)
1653       FORMAT(I8)
           WRITE (NCFPU1,1651) 'INFO  DOWN, ACROSS AND SECTION '
           WRITE (NCFPU1,1651) 'TRAN'
           WRITE (NCFPU1,1652) (STORE(I), I=L8R,l8R+8)
           WRITE (NCFPU1,1651) 'CELL'
           WRITE (NCFPU1,1652) (STORE(I), I = L1P1, L1P1+5)
           WRITE (NCFPU1,1651) 'L14 '
           WRITE (NCFPU1,1652)
     1     (STORE(I),STORE(I+2),(STORE(I)+(ISTORE(I+1)-1)*STORE(I+2)),
     1      1. , I = L8T+3, L8T+9, 3)
           WRITE (NCFPU1,1651) 'SIZE'
           WRITE (NCFPU1,1653)ISTORE(L8T+4),ISTORE(L8T+7),ISTORE(L8T+10)
           NXNY = ISTORE(L8T+4) * ISTORE(L8T+7)
      ENDIF
C
C--CHECK THAT THERE ARE SOME REASONABLE INTERVALS
      IF(ABS(STORE(L8T+5))-0.0001)1400,1400,1350
1350  CONTINUE
      IF(ABS(STORE(L8T+8))-0.0001)1400,1400,1500
C--INCORRECT INTERVALS
1400  CONTINUE
      WRITE ( CMON ,1450)
      CALL XPRVDU(NCVDU, 1,0)
      WRITE(NCAWU, '(/A)') CMON(1 )(:)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(/A)') CMON(1 )(:)
1450  FORMAT(' Illegal x or y divisions')
      GOTO 9910
C--COMPUTE THE NUMBER OF STEPS AND THE FIRST PONTS
1500  CONTINUE
      NX=MAX0(1,ISTORE(L8T+4))
      NY=MAX0(1,ISTORE(L8T+7))
      A=STORE(L8T+3)/ABS(STORE(L8T+5))
      MINX=NINT(A)
      A=STORE(L8T+6)/ABS(STORE(L8T+8))
      MINY=NINT(A)
C--CALCULATE THE STEPS ALONG X AND Y IN THE PLANE
      R=STORE(L8T+5)*TWOPI
      S=STORE(L8T+8)*TWOPI
C
C--SET UP THE MAP AREA
      LN=8
      IREC=8003
      L8=NFL
      MD8=NY
      M8=KCHNFL(MD8*NX)-1
      IREC=8004
      NS=KCHLFL(NCOL)
      M8DUMP = M8
      L8DUMP = L8
      NSDUMP = NS
C
C----- START LOOPING OVER SECTIONS
      DO 3300, ISECT = 1, ISTORE(L8T+10)
      ZCOORD=STORE(L8T+9)
      WRITE(NCAWU, '('' Section at z = '', F6.2)') ZCOORD
C--CALCULATE THE COORDINATES OF THE FIRST POINT
      AMIN(1)=STORE(L8T)+STORE(L8RI)*STORE(L8T+3)+STORE(L8RI+1)
     2 *STORE(L8T+6)+STORE(L8RI+2)*STORE(L8T+9)
      AMIN(2)=STORE(L8T+1)+STORE(L8RI+3)*STORE(L8T+3)+STORE(L8RI+4)
     2 *STORE(L8T+6)+STORE(L8RI+5)*STORE(L8T+9)
      AMIN(3)=STORE(L8T+2)+STORE(L8RI+6)*STORE(L8T+3)+STORE(L8RI+7)
     2 *STORE(L8T+6)+STORE(L8RI+8)*STORE(L8T+9)
      AMIN(1)=AMIN(1)*TWOPI
      AMIN(2)=AMIN(2)*TWOPI
      AMIN(3)=AMIN(3)*TWOPI
C
C--CLEAR THE MAP AREA
      M8 = M8DUMP
      L8 = L8DUMP
      NS = NSDUMP
      DO 1650 I=L8,M8
      STORE(I)=0.
1650  CONTINUE
      W=0.
C
C--START OF THE REFLECTION FETCHING LOOP
1700  CONTINUE
      IF(KFNR(0)) 2600,1750,1750
C--GENERATE THE EQUIVALENT REFLECTIONS FOR THESE INDICES
1750  CONTINUE
      JB=JA
      DO 2000 I=L2,M2,MD2
C--CALCULATE THE NEW INDICES
      STORE(JB)=STORE(M6)*STORE(I)+STORE(M6+1)*STORE(I+3)+STORE(M6+2)
     2 *STORE(I+6)
      STORE(JB+1)=STORE(M6)*STORE(I+1)+STORE(M6+1)*STORE(I+4)
     2 +STORE(M6+2)*STORE(I+7)
      STORE(JB+2)=STORE(M6)*STORE(I+2)+STORE(M6+1)*STORE(I+5)
     2 +STORE(M6+2)*STORE(I+8)
C--CHECK IF THESE INDICES HAVE BEEN FOUND BEFORE
      IF(JB-JA)1950,1950,1800
C--CYCLE THROUGH ALL THE PREVIOUS INDICES
1800  CONTINUE
      JC=JB-NW
      DO 1900 J=JA,JC,NW
      IF(ABS(STORE(J)-STORE(JB))+ABS(STORE(J+1)-STORE(JB+1))
     2 +ABS(STORE(J+2)-STORE(JB+2))-0.01)2000,2000,1850
1850  CONTINUE
      IF(ABS(STORE(J)+STORE(JB))+ABS(STORE(J+1)+STORE(JB+1))
     2 +ABS(STORE(J+2)+STORE(JB+2))-0.01)2000,2000,1900
1900  CONTINUE
C--THIS REFLECTION IS UNIQUE
1950  CONTINUE
      IF (IWT .LE. 0) THEN
            STORE(JB+3)=STORE(M6+3)*V
            STORE(JB+4)=STORE(M6+4)
            STORE(JB+5)=STORE(M6+5)
      ELSE
            STORE(JB+3)=STORE(M6+3)*V*STORE(M6+4)
            STORE(JB+4)=STORE(M6+4)
            STORE(JB+5)=STORE(M6+5)*STORE(M6+4)
      ENDIF
      STORE(JB+6)=STORE(M6+6)-TWOPI*(STORE(JB)*STORE(I+9)+STORE(JB+1)
     2 *STORE(I+10)+STORE(JB+2)*STORE(I+11))
      JB=JB+NW
2000  CONTINUE
      JB=JB-NW
C
C--MAIN LOOP FOR ADDING IN THE GENERATED REFLECTIONS
      DO 2550 I=JA,JB,NW
      GOTO(2100,2150,2200,2250,2300,2050),IN
C2050  STOP 275
2050  CALL GUEXIT(275)
C--'FO' FOURIER
2100  CONTINUE
      F=STORE(I+3)
      GOTO 2400
C--'FC' FOURIER
2150  CONTINUE
      F=STORE(I+5)
      GOTO 2400
C--'DF' FOURIER
2200  CONTINUE
      F=STORE(I+3)-STORE(I+5)
      GOTO 2400
C--'FO' PATTERSON
2250  CONTINUE
      F=STORE(I+3)*STORE(I+3)
      GOTO 2350
C--'FC' PATTERSON
2300  CONTINUE
      F=STORE(I+5)*STORE(I+5)
C--ACCUMULATE THE ORIGIN FOR SCALING
2350  CONTINUE
      STORE(I+6)=0.
      W=W+F
C--CALCULATE THE TRANSFORMED INDICES
2400  CONTINUE
      X=STORE(I)*STORE(L8RI)+STORE(I+1)*STORE(L8RI+3)+STORE(I+2)
     2 *STORE(L8RI+6)
      Y=STORE(I)*STORE(L8RI+1)+STORE(I+1)*STORE(L8RI+4)+STORE(I+2)
     2 *STORE(L8RI+7)
C--COMPUTE A FEW INTIAL CONSTANTS NEEDED BEFORE ADDING INTO THE MAP
      O=X*R
      P=Y*S
      H=STORE(I)*AMIN(1)-O+STORE(I+1)*AMIN(2)-P+STORE(I+2)*AMIN(3)
     2 -STORE(I+6)
      A=F*COS(H-O-P)
      B=F*COS(H-P)
      C=F*COS(H-O)
      D=F*COS(H)
      O=2.*COS(O)
      P=2.*COS(P)
C
C--MAIN LOOP FOR ADDING INTO THE MAP
      L=L8
      M8=NY-1
C--PASS ALONG THE X ROWS
      DO 2500 J=1,NX
      A1(7)=A1(2)
      A1(2)=A1(15)*A1(2)-A1(1)
      A1(5)=A1(2)
      A1(1)=A1(7)
      A1(7)=A1(4)
      A1(4)=A1(15)*A1(4)-A1(3)
      A1(6)=A1(4)
      A1(3)=A1(7)
      M=L+M8
C--ADD IN ALONG THE Y ROWS
      DO 2450 K=L,M
      A1(7)=A1(6)
      A1(6)=A1(16)*A1(6)-A1(5)
      A1(5)=A1(7)
      STORE(K)=STORE(K)+A1(6)
2450  CONTINUE
      L=L+MD8
2500  CONTINUE
2550  CONTINUE
C--GO BACK FOR MORE REFLECTIONS
      GOTO 1700
C
C--END OF THE MAP  -  CALCULATE THE SCALE FACTORS
2600  CONTINUE
      GOTO(2700,2700,2700,2750,2750,2650),IN
C2650  STOP 344
2650  CALL GUEXIT(344)
2700  CONTINUE
      W=U*2./STORE(L1P1+6)
      GOTO 2800
2750  CONTINUE
      W=999./W
C
C--MAIN MAP PRINTING ROUTINES
2800  CONTINUE
      IF (IOUTAP .GT. 0) THEN
        WRITE(MT1) NXNY, (STORE(I)*W, I= L8, L8+NXNY-1)
      ENDIF
      IF (IOUFIL .GT. 0) THEN
2801    FORMAT (A)
2802    FORMAT (I8)
2803    FORMAT (F15.8)
        WRITE(NCFPU1,2801) 'BLOCK'
        WRITE(NCFPU1,2802) NXNY
        WRITE(NCFPU1,2803) (STORE(I)*W, I= L8, L8+NXNY-1)
      ENDIF
      JA=MINY
      JB=NY
      JZ=1
      M8=L8
2850  CONTINUE
      JY=MIN0(JB,NCOL)-1
      JC=JA+JY
      CALL XPRTCN
      JD=NS-1
      DO 2900 I=JA,JC
      ISTORE(JD+1)=I
      JD=JD+1
2900  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 2950 ) WTED, CMAPTP(IN) ,
     2 ZCOORD , JZ , ( ISTORE(I) , I = NS , JD )
      ENDIF
2950  FORMAT ( 1X , A, 'Slant Fourier' , 5X , 'Map type is ' , A ,
     2 5X , 'Z =' , F7.3 , 5X , 'Part' , I3 , /// , 8X , 28I4 )
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3000)(IA,I=NS,JD)
      ENDIF
3000  FORMAT(8X,28(3X,A1))
      JE=M8
      JG=MINX
      DO 3200 I=1,NX
      JF=JE+JY
      DO 3100 J=JE,JF
      ISTORE(J)=NINT(STORE(J)*W)
      IF(ISTORE(J)-ITHRES)3050,3100,3100
3050  CONTINUE
      ISTORE(J)=ITHRES
3100  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3150)JG,IA,IB,(ISTORE(J),J=JE,JF)
      ENDIF
3150  FORMAT(/1X,I4,1X,2A1,28I4)
      JE=JE+MD8
      JG=JG+1
3200  CONTINUE
      JZ=JZ+1
      JY=JY+1
      JA=JA+JY
      M8=M8+JY
      JB=JB-JY
C--MORE TO PRINT
      IF(JB)3250,3250,2850
3250  CONTINUE
C----- GET READY FOR NEXT SECTION
      STORE(L8T+9) = STORE(L8T+9) + STORE(L8T+11)
C----- RESTORE REFLECTION ADDRESSES
      N6R = N6DUMP
      L6R = L6DUMP
C----- RESTORE NEW INDEX AREAS
      JA = JADUMP
      JB = JBDUMP
3300  CONTINUE
3301  FORMAT(A)
3302  FORMAT(I8)
3303  FORMAT(F15.8)
      IF (IOUTAP .GT. 0) THEN
        WRITE(MT1) N5, MD5
        M5 = L5
        DO 3310 I = 1, N5
            WRITE(MT1) (STORE(J),J=M5, M5+MD5-1)
            M5 = M5 + MD5
3310    CONTINUE
      ENDIF
      IF (IOUFIL .GT. 0) THEN
        WRITE(NCFPU1,3301)'LIST5'
        WRITE(NCFPU1,3302)N5,MD5
        M5 = L5
        DO I = 1, N5
            WRITE(NCFPU1,3301) STORE(M5)
            DO J = M5+1,M5+MD5-1
                WRITE(NCFPU1,3303) STORE(J)
            END DO
            M5 = M5 + MD5
        END DO
C Close the fourier.map file
        CALL XMOVEI(KEYFIL(1,23), KDEV, 4)
        CALL XRDOPN(7, KDEV , CSSMAP, LSSMAP)
      ENDIF
C
3350  CONTINUE
      CALL XOPMSG (IOPSLA, IOPEND, 201)
      CALL XTIME2(1)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPSLA , IOPABN , 0 )
      GOTO 3350
9910  CONTINUE
C -- INPUT ERROR
      CALL XOPMSG ( IOPSLA , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
C -- SINGULAR MATRIX
      WRITE ( CMON, 9925 )
      CALL XPRVDU(NCVDU, 1,0)
      WRITE(NCAWU, '(A)') CMON(1 )(:)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON( 1)(:)
9925  FORMAT ( 1X , 'Rotation matrix is singular' )
      CALL XERHND ( IERERR )
      GO TO 9900
C
C
      END

CODE FOR FOURIE
      SUBROUTINE FOURIE
      CALL XSYSDC(-1,1)
      CALL XFOURA
      RETURN
      END
C
CODE FOR XFOURA
      SUBROUTINE XFOURA
C--MAIN CONTROL ROUTINE FOR FOURIER CALCULATIONS
C
C--
\ISTORE
\ICOM24
C
\STORE
\XUNITS
\XLST12
\XLST24
\XLST50
&PPC\XGSTOP
C
\QSTORE
\QLST24
C
C--LOAD THE NEXT '#INSTRUCTION'
1000  CONTINUE
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM)1100,1100,1200
1100  CONTINUE
      RETURN
C--BRANCH ON THE TYPE OF OPERATION
1200  CONTINUE
      GOTO (2000,8000,8100,1300),NUM
1300  STOP 541
C
C--'#FOURIER' INSTRUCTION
2000  CONTINUE
      CALL XFOURB
      GOTO 1000
C
C--'#END' INSTRUCTION
8000  CONTINUE
      CALL XMONTR(-1)
      CALL XEND
&PPCCS***
&PPC      IF ( GLSTOP .EQ. 1 ) THEN
&PPC          GOTO 1100
&PPC      ELSE
&PPCCE***
      GOTO 1000
&PPCCS***
&PPC      ENDIF
&PPCCE***
C
C--'#TITLE' INSTRUCTION
8100  CONTINUE
      CALL XRCN
      GOTO 1000
      END
C

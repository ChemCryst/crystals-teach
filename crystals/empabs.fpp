CODE FOR DIFABS
      SUBROUTINE DIFABS
      CALL XSYSDC(-1,1)
      CALL XDIFAB
      RETURN
      END
C
CODE FOR XDIFAB
      SUBROUTINE XDIFAB
C--MAIN ROUTINE TO CONTROL DIFABS
C
C--
\ISTORE
C
\STORE
\XUNITS
\XLST50
\XERVAL
C
\QSTORE
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
      GO TO ( 2000 , 1500 ) , NUM
1500  CONTINUE
      CALL XERHND ( IERPRG )
C
2000  CONTINUE
C
C -- 'DIFABS' INSTRUCTION
C
      CALL XDFABS
      GO TO 1000
C
C
C
      END

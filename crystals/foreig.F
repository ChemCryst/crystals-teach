CODE FOR FOREIG
      SUBROUTINE FOREIG
      CALL XSYSDC(-1,1)
      CALL XFORGN
      RETURN
      END

CODE FOR XFORGN
      SUBROUTINE XFORGN


C -- THIS SUBROUTINE SUPPORTS LINKS TO FORIEGN PROGRAMS


      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'QSTORE.INC'

C--LOAD THE NEXT '#INSTRUCTION'
      NUM = KNXTOP ( LSTOP , LSTNO , ICLASS )

C--CHECK IF WE SHOULD RETURN
      IF ( NUM .LE. 0 ) RETURN

C--BRANCH ON THE TYPE OF OPERATION
      GOTO (2100, 2200, 2300, 9910), NUM
      GO TO 9910

2100  CONTINUE
C -- 'FOREIGN' INSTRUCTION
      CALL XLNKFP
      RETURN

C----- LARSEN SPACE GROUP INPUT
2200  CONTINUE
      CALL XSPCGR
      RETURN

C--   FOURIER LIMITS
2300  CONTINUE
      CALL FOULIM
      RETURN

9910  CONTINUE
      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
      RETURN
      END


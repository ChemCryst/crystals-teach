CODE FOR XCTRIM
      SUBROUTINE XCTRIM( CSOURC, NCHAR)
C------ TRIM OFF TRAILING SPACES
C      CSOURC - SOURCE STRING
C      NCHAR   - LAST NON-SPACE CHARACTER
      CHARACTER *(*) CSOURC
      CHARACTER *1 CBLANK
      DATA CBLANK /' '/
C
      LENGTH = LEN (CSOURC)
      IF (CSOURC(LENGTH:LENGTH) .NE. CBLANK) THEN
            NCHAR = LENGTH
            RETURN
      ENDIF
      DO 100 I = LENGTH, 1, -1
      IF (CSOURC(I:I) .NE. CBLANK) GOTO 200
100   CONTINUE
      I = 0
200   CONTINUE
      NCHAR = I + 1
      RETURN
      END
c
CODE FOR KGTNUM
      FUNCTION KGTNUM( CTEXT, CTERM, NCHAR)
C
C----- GET AN INTEGER NUMBER FROM A TEXT STRING
C
C      CTEXT TEXT STRING
C      CTERM TERMINATOR FOUND
C      NCHAR NUMBER OF CHARACTERS IN NUMBER
C
      CHARACTER *(*) CTEXT
      CHARACTER *1 CTERM
C      CHARACTER *9 CNUM
      CHARACTER *10 CNUM
C
C      DATA CNUM / '123456789' /
      DATA CNUM / '0123456789' /
C
      LENGTH = LEN (CTEXT)
      KGTNUM = 0
      NCHAR = 0
      CTERM = ' '
C
      DO 1000 I = 1, LENGTH
C      IVAL = INDEX (CNUM, CTEXT(I:I))
      IVAL = INDEX (CNUM, CTEXT(I:I)) - 1
C      IF (IVAL .GT. 0) THEN
      IF (IVAL .GE. 0) THEN
            KGTNUM = 10 * KGTNUM + IVAL
            NCHAR = NCHAR + 1
      ELSE
            CTERM = CTEXT(I:I)
            GOTO 1200
      ENDIF
1000  CONTINUE
1200  CONTINUE
      RETURN
      END
C
C
CODE FOR KCCNUM
      FUNCTION KCCNUM ( CINPUT , IRESLT , ITYPE )
C
C -- CONVERT STRING TO NUMERIC VALUE IF POSSIBLE
C
C      CINPUT      STRING TO BE CONVERTED
C      IRESLT      RESULT OF CONVERSION ( MAY BE REAL OR INTEGER )
C      ITYPE       TYPE OF NUMBER
C                    1      INTEGER
C                    2      REAL
C
C      KCCNUM      SUCCESS/FAILURE
C                    -1      FAILURE
C                    +1      SUCCESS
C
      CHARACTER*(*) CINPUT
      CHARACTER*11 CNUMER
      CHARACTER *1 CDOT
      CHARACTER*12 CBUFF1
      CHARACTER*20 CBUFF2
C
      PARAMETER (CDOT = '.')
      PARAMETER ( CNUMER = '0123456789.' )
C
      EQUIVALENCE ( XVALUE , IVALUE )
C
      KCCNUM = -1
      LENC = LEN (CINPUT)
C
C----- LOOK FOR A DECIMAL POINT, SINCE IBM COMPILERS STILL DONT STOP
C      EXECUTION ON A READ ERROR
      IF ( INDEX ( CNUMER , CINPUT(1:1) ) .LE. 0 ) RETURN
      IF ( INDEX ( CINPUT , CDOT ) .GT. 0 ) GOTO 1100
C
C----- TRY AS INTEGER
      ITYPE = 1
      CBUFF1 = CINPUT
      READ ( CBUFF1 , '(BN,I12)' , ERR = 1100 ) IVALUE
C
      IRESLT = IVALUE
      KCCNUM = 1
      RETURN
C
C----- TRY AS REAL
1100  CONTINUE
      ITYPE = 2
      CBUFF2 = CINPUT
      READ ( CBUFF2 , '(BN,F20.0)' , ERR = 1200 ) XVALUE
      CALL XMOVEI ( IVALUE , IRESLT , 1 )
      KCCNUM = 1
      RETURN
C
1200  CONTINUE
      RETURN
C
C
      END
C
C
C
C
C
CODE FOR KCCINT
      FUNCTION    KCCINT (CTEXT, IVALUE)
C
C -- CONVERT TEXT TO INTEGER VALUE
C
C*************** MACHINE OR COMPILER SENSITIVE ********************
C
C      CTEXT       TEXT TO BE CONVERTED ( UP TO 20 CHARACTERS )
C      IVALUE      RESULTANT VALUE
C
C      KCCINT      -1      FAILURE
C                  +1      SUCCESS
C
C THE PARTIAL PRE-CHECKING BEFORE LABEL 100 IS NECESSARY FOR THOSE
C COMPILERS (EG IBM) WHICH DO NOT USE THE ERROR LABEL FOR TYPE
C MIS-MATCHES DURING INTERNAL READS.
C
      CHARACTER*(*) CTEXT
C
      CHARACTER *11 CNUMER
      CHARACTER *20 CBUFF1
C
      PARAMETER ( CNUMER = '0123456789.' )
C
      KCCINT = 1
C
      CBUFF1 = CTEXT
C
C
      DO 10 I = 1,20
        IF ((CBUFF1(I:I) .EQ. ' ') .OR. (CBUFF1(I:I) .EQ. '+')
     1      .OR. (CBUFF1(I:I) .EQ. '-') ) GOTO 5
        GOTO 15
5       CONTINUE
10    CONTINUE
C---- TREAT ALL SPACES AS AN INTEGER
      IF (CBUFF1(20:20) .EQ. ' ') GOTO 100
      GOTO 9900
C
15    CONTINUE
      DO 30 I = 1,20
        IF (INDEX(CNUMER, CBUFF1(I:I)) .LE. 0) GOTO 9900
30    CONTINUE
C
C----- NO CHARACTERS FOUND, TRY TO READ AS INTEGER
100   CONTINUE
      READ ( CBUFF1 ,'(BN,I20)', ERR=9900) IVALUE
      RETURN
C
9900  IVALUE = 0
      KCCINT = -1
      RETURN
C
      END
CODE FOR KCCREA
      FUNCTION KCCREA ( CTEXT , VALUE )
C
C -- CONVERT TEXT TO REAL VALUE
C
C      CTEXT       TEXT TO BE CONVERTED ( UP TO 20 CHARACTERS )
C      VALUE       RESULTANT VALUE
C
C      KCCREA      -1      FAILURE
C                  +1      SUCCESS
C
      CHARACTER*(*) CTEXT
C
      CHARACTER*20 CBUFF1
C
      KCCREA = 1
C
      CBUFF1 = CTEXT
      READ ( CBUFF1 , '(BN,F20.0)' , ERR = 9900 ) VALUE
      RETURN
C
9900  CONTINUE
      VALUE = 0
      KCCREA = -1
      RETURN
C
      END
CODE FOR XCREMS
      SUBROUTINE XCREMS( CSOURC, COUT, LENFIL)
C
C----- REMOVE EXTRA SPACES BY LEFT ADJUSTING STRING
C----- ROUTINE EXITS WHEN OUT STRING FULL
C      LENFIL      USEFUL LENGTH OF RETURNED STRING
C
      CHARACTER *(*) CSOURC, COUT
      CHARACTER *1 CBUF
C
      LIN = LEN (CSOURC)
      LOUT = LEN (COUT)
      J = 0
      IFLAG = 0
      DO 1500 I = 1, LIN
      CBUF = CSOURC(I:I)
      IF (CBUF .EQ. ' ') THEN
            IF (IFLAG .EQ. 1) THEN
                  GOTO 1500
            ELSE
                  IFLAG = 1
            ENDIF
      ELSE
            IFLAG = 0
      ENDIF
      IF (J .LT. LOUT) THEN
            J = J + 1
            COUT(J:J) = CBUF
      ELSE
            GOTO 1600
      ENDIF
1500  CONTINUE
1600  CONTINUE
      LENFIL = J
      IF (LENFIL .LT. LOUT) COUT(LENFIL+1:LOUT) = ' '
C
      RETURN
      END
C
CODE FOR XCRAS
      SUBROUTINE XCRAS ( CSOURC, LENNAM )
C
C----- REMOVE ALL SPACES BY LEFT ADJUSTING STRING
C
C      CSOURC      SOURCE STRING TO BE CONVERTED
C      LENNAM      USEFUL LENGTH
C
C
      CHARACTER *(*) CSOURC
      CHARACTER *1  CBUF
C
      LENFIL=  LEN(CSOURC)
      K = 1
      DO 100 I = 1 , LENFIL
       CBUF = CSOURC(I:I)
       IF (CBUF .NE. ' ') THEN
           CSOURC(K:K) = CBUF
         K = K + 1
       ENDIF
100   CONTINUE
      LENNAM = MAX (1, K-1)
      IF (LENNAM .LT. LENFIL) CSOURC(LENNAM+1:LENFIL) = ' '
      RETURN
      END
C
CODE FOR XMOVEI
      SUBROUTINE XMOVEI ( ISRCE , IRESLT , N )
C
C -- MOVES REALS, INTEGERS OR HOLERITHS FROM 'ISRCE'
C    TO 'IRESLT' WITHOUT TYPE CHECKING OR CONVERSION.
C
C -- MOVE N WORDS FROM 'ISRCE' TO 'IRESLT' . DIRECT FORTRAN WILL
C    FAIL IF TWO OVERLAPPING ARRAYS ARE INVOLVED UNLESS THE
C    SENSE OF THE MOVE CAN BE DETERMINED.
C
      DIMENSION ISRCE(N) , IRESLT(N)
C
C
C
      I = LOC ( ISRCE(1))
      J = LOC ( IRESLT(1))
C
      IF ( I .LT. J ) THEN
        DO 1000 I = N , 1 , -1
          IRESLT(I) = ISRCE(I)
1000    CONTINUE
      ELSE
        DO 1010 I = 1 , N
          IRESLT(I) = ISRCE(I)
1010    CONTINUE
      ENDIF
      RETURN
      END
C
C
CODE FOR XCCUPC
      SUBROUTINE XCCUPC ( CLOWER , CUPPER )
C
C -- CONVERT STRING TO UPPERCASE
C
C      CLOWER      SOURCE STRING TO BE CONVERTED
C      CUPPER      RESULTANT STRING
C
      CHARACTER*(*) CLOWER , CUPPER
      CHARACTER*26 CALPHA , CEQUIV
      DATA CALPHA / 'abcdefghijklmnopqrstuvwxyz' /
      DATA CEQUIV / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
C
C -- MOVE WHOLE STRING.
C-ASSIGNING LOWER TO UPPER IS FORMALLY INVALID
C      CUPPER = CLOWER
      READ(CLOWER,'(A)') CUPPER
      LENGTH = MIN0 ( LEN ( CLOWER ) , LEN ( CUPPER ) )
C -- SEARCH FOR LOWERCASE CHARACTERS AND CONVERT TO UPPERCASE
      DO 2000 I = 1 , LENGTH
        IPOS = INDEX ( CALPHA , CLOWER(I:I) )
        IF ( IPOS .GT. 0 ) CUPPER(I:I) = CEQUIV(IPOS:IPOS)
2000  CONTINUE
      RETURN
      END
C
C
CODE FOR XCCLWC
      SUBROUTINE XCCLWC ( CSOURC, CLOWER )
C
C -- CONVERT STRING TO LOWERCASE
C
C      CSOURC      SOURCE STRING TO BE CONVERTED
C      CLOWER      RESULTANT STRING
C
      CHARACTER*(*) CSOURC,  CLOWER
      CHARACTER*26 CALPHA , CEQUIV
      DATA CALPHA / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
      DATA CEQUIV / 'abcdefghijklmnopqrstuvwxyz' /
C
C -- MOVE WHOLE STRING.
C-ASSIGNING LOWER TO UPPER IS FORMALLY INVALID
C      CLOWER = CSOURC
      READ(CSOURC,'(A)') CLOWER
      LENGTH = MIN0 ( LEN ( CSOURC) , LEN ( CLOWER ) )
C -- SEARCH FOR UPPERCASE CHARACTERS AND CONVERT TO LOWERCASE
      DO 2000 I = 1 , LENGTH
        IPOS = INDEX ( CALPHA , CSOURC(I:I) )
        IF ( IPOS .GT. 0 ) CLOWER(I:I) = CEQUIV(IPOS:IPOS)
2000  CONTINUE
      RETURN
      END

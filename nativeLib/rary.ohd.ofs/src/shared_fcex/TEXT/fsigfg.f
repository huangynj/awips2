C MODULE FSIGFG
C***********************************************************************
C SUBROUTINE TO ROUND A NUMBER TO DESIRED SIGNIFICANT FIGURES.
C
C AUTHOR  ED VANBLARGAN - HRL - JUNE,1983
C
C PROCEDURE:
C MOVE THE DECIMAL IN THE NUMBER TO THE RIGHT SO THERE ARE 9 DIGITS
C AND INTERGERIZE THE NUMBER. ALSO, REMEMBER WHERE THE DECIMAL WAS.
C THEN REDUCE THE DIGITS TO DESIRED NUMBER OF SIGNIFICANT FIGURES.
C SAVE THE DROPPED DIGITS TO SEE IF ROUNDING UP IS NEEDED, IF
C SO DO IT. FINALLY PUT THE DECIMAL BACK IN.
C NOTES:
C WORK WITH ABSOLUTE VALUE AND CONVERT, IF NECESARY, BACK TO NEGATIVE
C   AT END.
C WORK WITH 9 DIGITS SINCE USING INTEGER AND MAX IS 2**(32-1)-1. THIS
C   ALLOWS FOR INTEGER OF 10 DIGITS PLUS THE SIGN BUT ONLY IF
C   FIRST DIGIT IS LESS THAN 3, SO MAKE MAX DIGITS=9.
C   ACTUALLY, BE AWARE THAT THE NUMBER OF SIGNIFICANT FIGURES
C   FOR THE REAL NUMBER VARIES FROM MACHINE TO MACHINE,
C   AND FOR IBM 360/195 IT IS ABOUT 7.
C
C ARGUMENT LIST:
C XNUM   - I/O - R*4 - IN= THE NUMBER TO BE ROUNDED
C                      OUT= THE ROUNDED NUMBER
C NSF    - INP - I*4 - NUMBER OF SIGNIFICANT FIGURES DESIRED
C IER    - OUT - I*4 - STATUS CODE
C                        =0, OK
C                        =1, NO CONVERSION, ORIGINAL NUMBER RETURNED
C
C INTERNAL VARIABLES
C NUM   -INTEGER OF XNUM
C NEG   -NEGATIVE INDICATOR (=-1 IF XNUM IS NEG)
C IMAX  -MAX NUMBER OF SIG FIG ALLOWED
C NDIG  -NUMBER OF DIGITS IN XNUM
C NDECEX-EXPONENT OF 10 REPRESENTING NUMBER OF DECIMAL PLACES
C        USED FROM XNUM
C IREM  -REMAINDER
C***********************************************************************
      SUBROUTINE FSIGFG(XNUM,NSF,IER)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_fcex/RCS/fsigfg.f,v $
     . $',                                                             '
     .$Id: fsigfg.f,v 1.2 2000/12/19 14:53:58 jgofus Exp $
     . $' /
C    ===================================================================
C

        IMAX = 7
        IER  = 1

        IF (XNUM.LE.10.E09-1 .AND. XNUM.NE.0.0 .AND.
     $      NSF.GT.0 .AND. NSF.LE.IMAX               ) THEN
          NEG  = 0
          IF (XNUM.LT.0.0) NEG = -1

C FIND NDIG=MAGNITUDE OF XNUM
          NUM  = ABS(XNUM)
          NDIG = 0
          NTEN = 1
          IEND = IMAX+1
  100     IF (NDIG .GE. IEND) GOTO 120
            IF (NUM .LT. NTEN) THEN
              IER  = 0
              IEND = 0
            ELSE
              NDIG = NDIG+1
              NTEN = 10*NTEN
            ENDIF
            GOTO 100
  120     CONTINUE

C CONTINUE IF XNUM IS NOT TOO BIG
          IF (IER .EQ. 0) THEN

C COMPUTE NDECEX AS HOW MANY OF IMAX NOT TAKEN UP BY THE DIGITS
            NDECEX=10**(IMAX-NDIG)
C EXPAND NUM OUT AND REMOVE DECIMAL POINT
            IREM=(ABS(XNUM)-NUM)*NDECEX
            NUM=NUM*NDECEX+IREM
C REDUCE NUM TO PROPER SIG FIG
            NUMTMP=NUM
            NEXP=10**(IMAX-NSF)
            NUM=NUM/NEXP*NEXP
C CHECK REMAINDER OF DROPPED DIGITS AND SEE IF NEED TO ROUND NUM UP
            IF (NSF.NE.IMAX .AND. NUM.NE.0) THEN
              IREM=MOD(NUMTMP,NUM) / 10**(IMAX-NSF-1)
              IF (IREM.GE.5) NUM=NUM+NEXP
            ENDIF

C PUT NUM BACK INTO DECIMAL FORM
            XNUM=FLOAT(NUM)/NDECEX
            IF (NEG.EQ.-1) XNUM=-XNUM

          ENDIF
        ENDIF

      RETURN
      END

C MODULE PIN26
C-----------------------------------------------------------------------
C
C  INPUT ROUTINE FOR OPERATION 26 - SINGLE RESERVOIR OPERATION
C
      SUBROUTINE PIN26(PO,LEFTP,IUSEP,CO,LEFTC,IUSEC,WORK,NWORK)
C
C.......................................................................
C
C  OPERATION 26 IS THE SINGLE RESERVOIR OPERATION (OP. TYPE 'RES-SNGL')
C
C  PIN26 IS BROKEN INTO FOUR MAIN PARTS, EACH OF WHICH IS FURTHER BROKEN
C  DOWN. THEY ARE:
C
C        1) SUBROUTINE GENL26 - READS, INTERPRETS, AND STORES INTO THE
C             WORK ARRAY THE PARM, TS, AND CO INFO FOR THE GENERAL
C             SECTION OF INPUT FOR OP. 26,
C
C        2) SUBROUTINE SPEC26 - READS, INTERPRETS AND STORES INTO THE
C             WORK ARRAY ALL THE PARMS, TS-INFO AND CARRYOVER FOR ALL TH
C             SCHEMES AND UTILITIES CHOSEN FOR DEFINING THIS RESERVOIR.
C
C        3) SUBROUTINE RCL26 - READS, CHECKS SYNTAX OF, ENCODES, AND
C             STORES INTO THE WORK ARRAY THE RESERVOIR COMMAND LANGUAGE
C             INPUT BY THE USER TO CONTROL THE SIMULATION OF THIS
C             RESERVOIR,
C
C        4) SUBROUTINE STOR26 - TAKES INFO FROM THE WORK ARRAY AND STORE
C             IT IN A DIFFERENT ORDER AND FORMAT INTO THE PO ARRAY.
C
C  INPUT FOR ALL OF THIS PIN ROUTINE IS FREE FORMAT.
C
C.......................................................................
C
      DIMENSION PO(1),CO(1),WORK(1)
      REAL*8 SNAME
      LOGICAL ALLOK,OKGENL,OKSPEC,OKRCL,OKSTOR,NOROOM,OKPOST
C
      INCLUDE 'common/comn26'
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/read26'
      INCLUDE 'common/err26'
      INCLUDE 'common/ts26'
      INCLUDE 'common/rc26'
      INCLUDE 'udebug'
      INCLUDE 'ufreex'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/pin26.f,v $
     . $',                                                             '
     .$Id: pin26.f,v 1.5 2001/06/13 10:10:41 mgm Exp $
     . $' /
C    ===================================================================
C
      DATA NUMOP/26/,SNAME/8HRES-SNGL/
C
C..................................
C  SET DEBUG SWITCH
C
      IBUG = 0
      CALL FPRBUG(SNAME,1,NUMOP,IPBUG)
      IF (ITRACE.GT.0) IBUG = 1
      IF (IPBUG.GT.0)  IBUG = 2
C
C  INITIALIZE NECESSARY VARIABLES
C
      IUSEW = 0
      LEFTW = NWORK
C
      ALLOK = .TRUE.
      NOROOM = .FALSE.
C
      N26TS = 0
C
      NUMRC = 0
      DO 11 I=1,10
           NRC26(I)=0
11    CONTINUE
C
C
C  INITIALIZE THE BLOCK DATA OF UFREEX
C
      ICDSTR = 1
      ICDSTP = 72
      NRDCRD = 0
      IPRCRD = 0
      IPRBLN = 0
      MAXFLD = 50
      IPRMPT = 0
C
C  INITIALIZE THE BLOCK DATA OF UDEBUG
C
      IOGDB = 6
      IUTLTR = 0
      IUTLDB = 0
C
C.........................................................
C  FIRST THING IS TO INPUT ALL CARDS FOR RES-SNGL OPERATION
C  'END' CARD SIGNALS END OF INPUT. LOCATION OF START AND NUMBER
C  OF LINES OF INPUT FOR GENERAL, SPECIFIC AND RCL SECTIONS ARE
C  DETERMINED
C
      CALL CARD26
C............................................................
C  INITIALIZE POINTERS TO LOCATIONS OF GENERAL, SPECIFIC, AND RCL
C  SECTIONS IN WORK ARRAY. GENERAL STARTS ON WORD 4, OTHERS ARE VARIABLE
C  AND WILL BE SET WHEN THE PRECEEDING SECTION IS FINISHED
C
      GENLOC = 4.01
      CALL FLWK26(WORK,IUSEW,LEFTW,GENLOC,501)
      CALL FLWK26(WORK,IUSEW,LEFTW,GENLOC,501)
      CALL FLWK26(WORK,IUSEW,LEFTW,GENLOC,501)
C.........................................
C
C  FIRST INPUT BLOCK IS FOR GENERAL INFORMATION
C
      CALL GENL26(WORK,IUSEW,LEFTW,NPARG,NTSG,NCOG,OKGENL)
C
      IF (IBUG.LT.2) GO TO 100
      WRITE(IODBUG,1600)
 1600 FORMAT(//,' *** WORK ARRAY AFTER GENERAL INPUT ***')
      IF (IUSEW.LE.0) GO TO 100
      DO 50 I=1,IUSEW,8
      IE = I+7
      WRITE(IODBUG,1605) I,IE
 1605 FORMAT(' *** POS. NOS. :',I4,' THRU ',I4)
      WRITE(IODBUG,1610) (WORK(J),J=I,IE)
   50 CONTINUE
 1610 FORMAT(8F10.2)
  100 CONTINUE
C.............................
C  FLAG AN OVERALL ERROR IF AN ERROR OCCURRED IN INPUTTING GENERAL INFO
C
      ALLOK = ALLOK .AND. OKGENL
C
C..............................
C  NEXT BLOCK OF INPUT IS THAT FOR THE INDIVIDUAL SCHEMES AND UTILITIES
C
C  REFILL 2ND WORD OF WORK ARRAY WITH LOCATION OF START OF S/U SPECIFIC
C  INFORMATION.
C
      SPELOC = IUSEW + 1.01
      CALL RFIL26(WORK,2,SPELOC)
C
      CALL SPEC26(WORK,IUSEW,LEFTW,NSUIN,NPARSU,NTSSU,NCOSU,OKSPEC)
      IF (IBUG.LT.2) GO TO 200
      WRITE(IODBUG,1620)
 1620 FORMAT(//,' *** WORK ARRAY AFTER SPECIFIC INPUT ***')
      IF (IUSEW.LE.0) GO TO 200
      DO 150 I=1,IUSEW,8
      IE = I+7
      WRITE(IODBUG,1605) I,IE
      WRITE(IODBUG,1610) (WORK(J),J=I,IE)
  150 CONTINUE
  200 CONTINUE
C
C  ONCE AGAIN, FLAG AN OVERALL ERROR IF ERROR OCCURRED DURING INPUT OF
C   SCHEME AND UTILITY SPECIFIC INFORMATION.
C
      ALLOK = ALLOK .AND. OKSPEC
C
C.............................................
C  NEXT BLOCK IS FOR INPUTTING, CHECKING AND ENCODING THE RESERVOIR
C   COMMAND LANGUAGE (RCL)
C
C  FIRST REFILL 3RD WORD IN WORK WITH THE LOCATION OF THE START OF THE
C  RCL INFORMATION
C
      RCLLOC = IUSEW + 1.01
      CALL RFIL26(WORK,3,RCLLOC)
C
      CALL RCL26(WORK,IUSEW,LEFTW,NUMRCL,OKRCL)
      IF (IBUG.LT.2) GO TO 300
      WRITE(IODBUG,1630)
 1630 FORMAT(//,' *** WORK ARRAY AFTER RCL INPUT ***')
      IF (IUSEW.LE.0) GO TO 300
      DO 250 I=1,IUSEW,8
      IE = I+7
      WRITE(IODBUG,1605) I,IE
      WRITE(IODBUG,1610) (WORK(J),J=I,IE)
  250 CONTINUE
  300 CONTINUE
C
C  ONCE AGAIN, FLAG OVERALL ERROR IF ERROR OCCURRED DURING RCL INPUT.
C
      ALLOK = ALLOK .AND. OKRCL
C
C..........................................................
C  NEXT CHECK IS FOR AVAILABLE SPACE IN PO ARRAY VERSUS THE AMOUNT
C   NECESSARY TO DEFINE THIS RESERVOIR OPERATION.
C
      LUSEP = 19 + (NSUIN*4+1) + (NPARG+NPARSU) +
     .        (NTSG+NTSSU+1) + (NUMRCL) + (NUMRC*2+1)
C
      LUSEC = NCOG + NCOSU
C
      IF ( (LUSEP.GT.LEFTP) .OR. (LUSEC.GT.LEFTC) ) NOROOM = .TRUE.
C
C...................................................
C  IF AN ERROR HAS OCCURRED FOR ANY REASON, EITHER IN ONE OF THE INPUT
C  ROUTINES OR BECAUSE NOT ENOUGH SPACE IS AVAILABLE, DO NOT STORE
C  INFORMATION IN THE PO ARRAY.
C
      IF (.NOT.ALLOK .OR. NOROOM) GO TO 2000
C
      VERSNO=1.0
      CALL STOR26(PO,CO,WORK,VERSNO,OKSTOR)
C
C...................................
C  IF AN ERROR OCCURRED WHILE STORING INFO, RESET THE IUSEP AND IUSEC
C   VARIABLES TO THE ERROR OR NO-USE CONDITION.
C
      IF (.NOT.OKSTOR) GO TO 2000
C...............................
C  OTHERWISE, COMPUTE THE NO. OF WORDS OF WORK SPACE NEEDED,
C  DO SOME MISCELLANEOUS POST-INPUT PROCESSING,
C  AND, SET THE NUMBER OF WORDS USED IN PO AND CO ARRAYS
C  AND THE NUMBER OF WORDS LEFT IN BOTH ARRAYS.
C
      CALL POST26 (PO,NWKSP,OKPOST)
      IF (.NOT.OKPOST) GO TO 2000
C
      PO(16) = NWKSP + 0.01
C
      IUSEP = LUSEP
      IUSEC = LUSEC
C
      GO TO 9999
C
C...................................
C  ERROR HAS OCCURRED SOMEWHERE, SO PRINT MESSAGE AND RESET USE COUNTERS
C
 2000 IUSEP = 0
      IUSEC = 0
C
      IF (NOROOM) THEN
         WRITE (IPR,610) LEFTP,LUSEP,LEFTC,LUSEC
  610 FORMAT ('0**ERROR** ',
     . 'MORE SPACE IS REQUIRED TO STORE THE PARAMETERS AND ',
     . 'CARRYOVER FOR THIS RESERVOIR OPERATION THAN IS AVAILABLE.' /
     .11X,'FOR STORING PARAMETERS IN THE P ARRAY, ',I4,' WORDS ARE ',
     . 'AVAILABLE. ',I4,' WORDS ARE NEEDED.' /
     .11X,'FOR STORING CARRYOVER IN THE C ARRAY, ',I4,' WORDS ARE ',
     . 'AVAILABLE. ',I4,' WORDS ARE NEEDED.')
         CALL ERROR
         ENDIF
C
C  WRITE GENERAL ERROR MESSAGE
      WRITE (IPR,650)
  650 FORMAT ('0**NOTE** ',
     * 'THE CURRENT SINGLE RESERVOIR OPERATION DEFINITION HAS STOPPED ',
     * 'BECAUSE ERRORS WERE ENCOUNTERED.')
C
 9999 IF (ITRACE.GE.1) WRITE (IODBUG,*) 'EXIT PIN26'
C
      RETURN
C
      END

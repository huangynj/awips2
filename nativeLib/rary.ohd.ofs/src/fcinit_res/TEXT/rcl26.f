C MEMBER RCL26
C  (from old member FCRCL26)
C
C DESC READ, INTERPRET, ANALYZE, AND ENCODE RCL INPUT FOR OP26(RES-SNGL)
C
C                             LAST UPDATE: 08/14/95.14:53:04 BY $WC21DT
C
C-----------------------------------------------------------------------
C
      SUBROUTINE RCL26(WORK,IUSEW,LEFTW,LENRCL,OKRCL)
C
C----------------------------------------------------------------------
C
C  ARGUMENTS:
C
C     WORK - ARRAY TO HOLD INFORMATION ON THE RCL AND THE ENCODED RCL
C            IN FINAL PO ARRAY FORMAT
C
C    IUSEW - NUMBER OF WORDS ALREADY USED IN WORK
C    LEFTW - NUMBER OF WORDS LEFT IN WORK
C   LENRCL - NUMBER OF WORDS NEEDED TO STORE THE RCL IN PO FORMAT
C    OKRCL - LOGICAL VARIABLE INDICATING WHETHER THE WHOLE RCL PROCESS
C            WORKED OK OR NOT
C     IBUG - DEBUG CODE
C
C----------------------------------------------------------------------
C
C  JTOSTROWSKI - HRL - MARCH 1983
C----------------------------------------------------------------
      INCLUDE 'common/read26'
      INCLUDE 'common/ionum'
      INCLUDE 'common/ifcl26'
      INCLUDE 'common/cmpv26'
      INCLUDE 'common/fld26'
      INCLUDE 'common/err26'
      INCLUDE 'common/warn26'
      INCLUDE 'common/comn26'
C
      DIMENSION WORK(1),LINE(20),KEYWDS(2,8),LKEYWD(8)
      LOGICAL OKRCL,GETSET
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_res/RCS/rcl26.f,v $
     . $',                                                             '
     .$Id: rcl26.f,v 1.2 1996/01/17 18:58:14 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA KEYWDS/
     .            4HSET ,4H    ,4HDO  ,4H    ,
     .            4HIF  ,4H    ,4HTHEN,4H    ,
     .            4HELSE,4H    ,4HELSE,4HIF  ,
     .            4HENDI,4HF   ,4HENDR,4HCL  /
      DATA LKEYWD/1,1,1,1,1,2,2,2/
      DATA NKEYWD/8/
      DATA NDKEY/2/
C
C  INITIALIZE VARIABLES FOR THIS PASS OF RCL26
C
      OKRCL = .TRUE.
      USEDUP = .FALSE.
      GETSET = .TRUE.
      LENRCL = 0
      NUMERR = 0
      NUMWRN = 0
      NIFCL = 0
      MAXIFC = 50
      LIFCL = 200
      NWIFCL = 0
      NUMCMP = 0
      MAXCMP = 50
C
C  SET PROPER LOCATION FOR READING IN UFLD26 AND ERROR LINE SETTING IN
C  STER26
C
      ISECT = 3
C
C  AN 'RCL' STATEMENT MUST HAVE BEEN FOUND IN THE INPUT STREAM FOR
C  DEFINITION OF THIS OPERATION
C
      IF (LRCL.GT.0) GO TO 10
C
      WRITE(IPR,600)
  600 FORMAT('0**ERROR**'/16X,'NO ''RCL'' KEYWORD HAS BEEN ',
     .'FOUND IN THE INPUT STREAM.'/16X,'THIS KEYWORD IS NECESSARY TO ',
     .'PROCESS THE RCL SUBSECTION'/16X,'OF THE ''RES-SNGL'' OPERATION.')
      OKRCL = .FALSE.
      CALL ERROR
      GO TO 9999
C
C  ALSO, AN 'ENDRCL' STATEMENT MUST HAVE BEEN FOUND IN THE INPUT STREAM
C  FOR DEFINITION OF THIS OPERATION
C
   10 CONTINUE
      IF (NRCL.GT.0) GO TO 20
C
      WRITE(IPR,601)
  601 FORMAT('0**ERROR**'/16X,'NO ''ENDRCL'' KEYWORD HAS BEEN ',
     .'FOUND IN THE INPUT STREAM.'/16X,'THIS KEYWORD IS NECESSARY TO ',
     .'PROCESS THE RCL SUBSECTION'/16X,'OF THE ''RES-SNGL'' OPERATION.')
      OKRCL = .FALSE.
      CALL ERROR
      GO TO 9999
C
C------------------------------------------------------------------
C  FIRST THING IS TO RESERVE FIRST 7 WORDS IN WORK FOR POINTER AND
C  LENGTH INFO ABOUT RCL. ALSO, SET THE OFFSET IN WORK FOR START OF RCL
C  INFORMATION AND SET LOCATION OF START OF RCL IN WORD 3 OF WORK ARRAY.
C
   20 CONTINUE
      NRCOFF = IUSEW
      OFFSET = NRCOFF + 1.01
      CALL RFIL26(WORK,3,OFFSET)
C
      DO 50 I=1,7
      CALL FLWK26(WORK,IUSEW,LEFTW,0.01,501)
   50 CONTINUE
C
C  SET OFFSET OF START OF RCL STATEMENTS
C
      NRCSOF = NRCOFF + 7
C
C  NEXT, POSITION UNIT 89 (MUNI26) TO START OF RCL STATEMENTS
C
      NRC2 = NRCL - 1
      IRCLST = LRCL + 1
      CALL POSN26(MUNI26,IRCLST)
      NCARD = 0
C
C--------------------------------------------------------
C  GET FIRST FIELD FROM LINE OF INPUT
C
  100 IF(USEDUP) GO TO 5000
      NUMFLD = 0
C
      CALL UFLD26(NUMFLD,IRF)
      IF (IRF.GT.0) GO TO 300
C
      NWORD = (LEN-1)/4 + 1
      IDEST = IKEY26(CHAR,NWORD,KEYWDS,LKEYWD,NKEYWD,NDKEY) + 1
C
C  SEND CONTROL TO PROPER LOCATION
C
      GO TO (120,1000,2000,3000,130,130,130,130,4000) , IDEST
C
C------------------------------------------------------------
C  NO VALID KEYWORD FOUND
C
  120 CONTINUE
      CALL STER26(1,1)
      OKRCL = .FALSE.
      GO TO 100
C
C----------------------------------------------------------
C  VALID KEYWORD FOUND, BUT NOT ALLOWED HERE. THESE ARE
C   FOR IF GROUP PROCESSING (I.E. THEN, ELSE, ELSEIF, AND ENDIF)
C
  130 CONTINUE
      CALL STER26(3,1)
      OKRCL = .FALSE.
      IF(NCARD .LT. NRC2-1) GO TO 100
      USEDUP = .TRUE.
      GO TO 5000
C
C---------------------------------------------------------------------
C  ERROR OCCURRED IN UFLD26
C
  300 CONTINUE
      IF (IRF.EQ.1) CALL STER26(19,1)
      IF (IRF.EQ.2) CALL STER26(20,1)
      IF (IRF.EQ.3) CALL STER26(82,1)
      IF (IRF.EQ.4) CALL STER26(1,1)
      OKRCL = .FALSE.
      IF (NCARD .LT. NRC2-1) GO TO 100
      USEDUP = .TRUE.
      GO TO 5000
C
C----------------------------------------------------------
C  'SET' KEYWORD FOUND.ONLY ALLOWED BEFORE ANY OTHER TYPE
C   OF RCL KEYWORDS ARE FOUND.
C
 1000 CONTINUE
      IF (GETSET) GO TO 1100
C
      CALL STER26(2,1)
      OKRCL = .FALSE.
      GO TO 100
C
 1100 CONTINUE
C
      CALL USET26(IRS)
      IF (IRS.GT.0) OKRCL = .FALSE.
      GO TO 100
C
C-------------------------------------------------------------
C  'DO' FOUND
C
 2000 CONTINUE
C
      GETSET = .FALSE.
C
      CALL UDO26(CODE,IRD)
      IF (IRD.EQ.0) GO TO 2100
C
      OKRCL = .FALSE.
      GO TO 100
C
 2100 CONTINUE
C
C  STORE CODE FOR 'DO' IN WORK, FOLLOWED BY S/U CODE RETURNED
C   FROM UDO26
C
      CALL FLWK26(WORK,IUSEW,LEFTW,5.01,501)
      CALL FLWK26(WORK,IUSEW,LEFTW,CODE,501)
      GO TO 100
C
C--------------------------------------------------------------
C  'IF' FOUND. SUB UIF26 PROCESSES ALL INPUT UP TO A MATCHING ENDIF,
C    AND ANY EMBEDDED 'IF' IF FOUND.
C
 3000 CONTINUE
C
      GETSET = .FALSE.
C
      CALL UIF26(WORK,IUSEW,LEFTW,NRCSOF,IRF)
      IF (IRF.GT.0) OKRCL = .FALSE.
      GO TO 100
C
C--------------------------------------------------------------
C  'ENDRCL' FOUND. IF OKRCL IS .FALSE., NO NEED TO DO ANY
C    POST-SYNTACTICAL PROCESSING.
C
 4000 CONTINUE
      USEDUP = .TRUE.
      IF (.NOT.OKRCL.OR.NUMERR.GT.0) GO TO 5000
C
C  FIRST STORE THE CODE FOR 'ENDRCL' IN WORK ARRAY.
C
      CALL FLWK26(WORK,IUSEW,LEFTW,9.01,501)
C
C  NEED TO RESET POINTERS IN EARLIER PARTS OF THE WORK ARRAY, AND TO
C  STORE THE COMPARISON VARIABLES IN THE WORK ARRAY.
C  AFTER THAT, THE IF GROUPS MUST BE CONVERTED INTO RPN FORMAT AND
C  TRANSFERRED TO THE WORK ARRAY
C
C  COMPUTE LENGTH OF RCL STATEMENTS (SEVEN IS # WDS. USED TO STORE
C  RCL POINTER AND LENGTH INFO.)
C
      LENRCS = IUSEW - NRCOFF - 7
      RCLEN = LENRCS + 0.01
      LOCRCS = NRCOFF + 3
      CALL RFIL26(WORK,LOCRCS,RCLEN)
      LOCRST = NRCOFF + 2
      RCLST = NRCOFF + 8.01
      CALL RFIL26(WORK,LOCRST,RCLST)
C
C  COMPUTE TOTAL LENGTH OF ALL RCL INFO UP TO THIS POINT
C
      LENRCL = LENRCL + LENRCS
C
C  SET POINTER TO START OF COMP VARIABLE INFO
C
      LOCCMP = IUSEW + 1
      CMPLOC = LOCCMP + 0.01
      LOCCST = NRCOFF+4
      CALL RFIL26(WORK,LOCCST,CMPLOC)
C
C  STORE ALL COMPARISON VARIABLES IN WORK ARRAY IN FINAL PO ARRAY FORMAT
C
      CALL CMPS26(WORK,IUSEW,LEFTW,NWDCMP)
C
C  COMPUTE LENGTH OF COMP VARIABLE INFO, STORE IT IN PROPER LOCATION
C  OF WORK ARRAY AND UPDATE TOTAL LENGTH OF RCL INFO.
C
 4010 CONTINUE
      CMPLEN = NWDCMP + 0.01
      LOCCLN = NRCOFF + 5
      CALL RFIL26(WORK,LOCCLN,CMPLEN)
C
      LENRCL = LENRCL + NWDCMP
C
C  COMPUTE AND STORE LOCATION OF START OF IF GROUP INFORMATION
C
      LOCIFG = IUSEW + 1
      STRTIF = LOCIFG + 0.01
      LOCIST = NRCOFF + 6
      CALL RFIL26(WORK,LOCIST,STRTIF)
C
C  CONVERT IF GROUPS TO RPN FORMAT AND STORE IN WORK ARRAY. ALSO, WITHIN
C  THIS ROUTINE THE POINTERS TO IF GROUPS MUST BE CONVERTED TO THEIR
C  FINAL LOCATIONS
C
      CALL RPN26(WORK,IUSEW,LEFTW,NWDIF)
C
C  CONVERT THE LENGTH OF IF GROUPS TO REAL AND STORE IN WORK ARRAY
C  ALSO, UPDATE THE TOTAL LENGTH OF RCL INFO AND STORE THIS IN WORK
C   ARRAY.
C
 4020 CONTINUE
      GIFWD = NWDIF + 0.01
      LOCIFL = NRCOFF + 7
      CALL RFIL26(WORK,LOCIFL,GIFWD)
C
      LENRCL = LENRCL + NWDIF
      RCLLEN = LENRCL + 7.01
      LOCLEN = NRCOFF + 1
      CALL RFIL26(WORK,LOCLEN,RCLLEN)
C
C-------------------------------------------------------------
C  NOW ALL FINISHED STORING INFO IN WORK ARRAY. ALL INFO IS IN FINAL
C  PO ARRAY FORMAT AND ONLY NEEDS TO BE TRANSFERRED WITHOUT ANY
C  CONVERSION. EVEN THE POINTERS ARE CORRECT. THIS IS BECAUSE THEY
C  USE RELATIVE LOCATIONS FROM START OF SUBSECTIONS IN ARRAYS AND
C  THE DISTANCES FROM THE START ARE THE SAME IN THE WORK ARRAY AS THEY
C  ARE IN THE PO ARRAY.
C
C
C  NOW PRINT ERROR MESSAGES FOR ANY ERRORS THAT MAY HAVE OCCURRED
C
 5000 CONTINUE
C
      IF (NUMERR.EQ.0.AND.NUMWRN.EQ.0.AND.IBUG.LT.2) GO TO 9999
C
C-------------------------------------------------------------------
C  FIRST THING IS TO ECHO PRINT THE RCL COMMAND LINES FOR USE AS
C  REFERENCES IN THE ERROR MESSAGES THAT MIGHT BE PRINTED.
C
      WRITE(IPR,620)
  620 FORMAT(1H1,' *** RCL COMMANDS INPUT FOR THIS OPERATION DEFINITION
     . ***'//)
C
      IRCLST = LRCL + 1
      CALL POSN26(MUNI26,IRCLST)
C
      NRC2 = NRCL - 1
      IF (NRC2.GT.0) GO TO 25
      CALL STER26(87,1)
      GO TO 5000
C
   25 CONTINUE
      DO 30 I=1,NRC2
      READ(MUNI26,260) LINE
      WRITE(IPR,630) I,LINE
   30 CONTINUE
C
  260 FORMAT(20A4)
  630 FORMAT(1H ,'(',I3,') ',20A4)
      IF (NUMERR.GT.0) OKRCL = .FALSE.
      CALL WNOT26
      CALL EROT26
C
C  ALL FINISHED WITH RCL PROCESSING
C
 9999 CONTINUE
      RETURN
      END

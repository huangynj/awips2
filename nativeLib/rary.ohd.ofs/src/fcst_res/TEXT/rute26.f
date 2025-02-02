C MEMBER RUTE26
C  (from old member FCRUTE26)
C***********************************************************************
      SUBROUTINE RUTE26(FRAC1,FRAC2,SBGN,QOKBGN,QOSBGN,PEAKO,PKPOS,O,
     $SOH,WORK)
C***********************************************************************
C RUTE26 IS A UTILITY SUBROUTINE FOR MODIFIED PULS ROUTING.  INFLOW IS
C ROUTED OVER UNCONTROLLED SPILLWAYS, FULLY-OPEN GATED SPILLWAYS OR
C THROUGH SUICEWAYS.  THE ROUTING MAY START AT THE BEGINNING OF THE
C REGULAR TIME PERIOD (FRAC1=0.) OR DURING THE TIME PERIOD (FRAC1.GT.0.0
C .AND.LT.1.0).  FRAC2 DESIGNATES THE PORTION OF THE TIME PERIOD OVER
C WHICH ROUTING OCCURS.  A SHORTER TIME STEP IS PROVIDED WHEN THE SLOPE
C OF THE STORAGE VS OUTFLOW RELATION REQUIRES IT.  NSTEPS WILL BE
C COMPUTED TO GIVE THE NUMBER OF REQUIRED TIME STEPS WITHIN THE TIME
C PERIOD OR FRACTION OF TIME PERIOD WHEN A SHORTER TIME STEP IS REQUIRED
C***********************************************************************
C THIS SUBROUTINE WAS ORIGINALLY PROGRAMMED BY
C     WILLIAM E. FOX -- CONSULTING HYDROLOGIST
C     DECEMBER, 1981
C***********************************************************************
C SUBROUTINE RUTE26 IS IN
C***********************************************************************
C VARIABLES PASSED TO OR FROM THIS SUBROUTINE ARE DEFINED AS FOLLOWS:
C     NS2 -- POSITION IN ARRAYS AT END OF THIS TIME PERIOD.
C     FRAC1 -- FRACTION OF TIME PERIOD BEFORE ROUTING BEGINS.
C     FRAC2 -- FRACTION OF TIME PERIOD OVER WHICH ROUTING OCCURS.
C     STOCR -- RESERVOIR STORAGE AT ELEVATION OF SPILLWAY CREST.  MUST
C       BE IN UNITS OF MEAN DISCHARGE FOR THE TIME PERIOD.
C     SBGN -- STORAGE AT BEGINNING OF FIRST ROUTING STEP IN UNITS OF
C       MEAN DISCHARGE FOR TIME PERIOD.  WILL BE SAME AS S1 IF
C       ROUTING STARTS AT THE BEGINNING OF THE TIME PERIOD.
C     SFILL -- STORAGE AT ELEVATION WHERE INFLOW IS PASSED IN UNITS OF
C       MEAN DISCHARGE FOR THE TIME PERIOD.
C     SPILMX -- MAXIMUM SPILLWAY DISCHARGE AT ELEVATION CORRESPONDING TO
C       SFILL.
C     S1 -- STORAGE AT BEGINNING OF TIME PERIOD IN UNITS OF MEAN DIS-
C       CHARGE FOR THE TIME PERIOD.
C     S2 -- STORAGE AT END OF TIME PERIOD IN UNITS OF MEAN DISCHARGE FOR
C       THE TIME PERIOD.
C     QI1 -- INFLOW AT BEGINNING OF TIME PERIOD.
C     QI2 -- INFLOW AT END OF TIME PERIOD.
C     QIM -- MEAN INFLOW FOR TIME PERIOD.
C     QO1 -- OUTFLOW AT BEGINNING OF TIME PERIOD.
C     QO2 -- OUTFLOW AT END OF TIME PERIOD.
C     QOM -- MEAN OUTFLOW FOR TIME PERIOD.
C     QOK1 -- NON-SPILLWAY OUTFLOW AT BEGINNING OF TIME PERIOD.
C     QOK2 -- NON-SPILLWAY OUTFLOW AT END OF TIME PERIOD.
C     QOKBGN -- NON-SPILLWAY OUTFLOW AT BEGINNING OF FIRST ROUTING STEP.
C     QOSBGN -- SPILLWAY OUTFLOW AT BEGINNING OF FIRST ROUTING STEP.
C     TESTPK -- TEST VALUE OF OUTFLOW FOR DETERMINING WHETHER OR NOT A
C       PEAK OUTFLOW BETWEEN QO1 AND QO2 WILL LATER REPLACE ONE OF THESE
C       VALUES IN THE OUTFLOW ARRAY.  TESTPK CAN BE FLOOD DISCHARGE OR
C       A LOWER VALUE IF DESIRED.
C     PEAKO -- ARRAY OF PEAK OUTFLOWS ABOVE TESTPK THAT OCCUR BETWEEN
C       INSTANTANEOUS OUTFLOWS AT REGULAR TIME INTERVALS.  THESE PEAK
C       VALUES WILL BE SUBSTITUTED BY THE EXECUTION SUPERVISORY ROUTINE
C       IN THE INSTANTANEOUS OUTFLOW ARRAY AS INDICATED BY POSITION
C       NUMBERS IN THE PKPOS ARRAY.
C     PKPOS -- ARRAY OF POSITION NUMBERS THAT INDICATE WHERE THE
C       CORRESPONDING PEAKO VALUES WILL BE PLACED IN THE INSTANTANEOUS
C       OUTFLOW ARRAY.  UNDEFINED PKPOS VALUE WILL BE -999.0.  PKPOS
C       VALUES ARE REAL NUMBERS IN THE ARRAY BUT WILL BE CONVERTED TO
C       INTEGERS WHEN PUTTING PEAKO VALUES IN THE OUTFLOW ARRAY.
C     NUMPKO -- NUMBER OF PAIRS OF DEFINED PEAKO AND PKPOS VALUES.
C       IF THERE ARE NO DEFINED VALUES, NUMPKO WILL BE -999.
C     NTOTPK -- NO. OF POSITIONS AVAILABLE IN EACH OF THE PEAKO AND
C       PKPOS ARRAYS.
C     O -- OUTFLOW VALUES FOR OUTFLOW VS S+O/2 RELATION.  FIRST VALUE
C       MUST BE 0.
C     SOH -- VALUES OF STORAGE+O/2 CORRESPONDING TO O VALUES.  STORAGE
C       MUST BE IN UNITS OF MEAN DISCHARGE FOR THE TIME PERIOD.  FIRST
C       VALUE MUST BE 0.
C     NOSOH -- NO. OF PAIRS OF O AND SOH VALUES.
C     WORK -- WORKING ARRAY FOR COMPUTATIONS.
C     IBUG -- NO TRACE OR DEBUG (IBUG=0), TRACE ONLY (IBUG=1),TRACE AND
C       DEBUG (IBUG=2).
C     IUNC -- UNCONTROLLED SPILLWAY (OR SLUICE) WHEN IUNC=1.  GATED
C       SPILLWAY WHEN IUNC=0.
C***********************************************************************
C THE TOTAL DISCHARGE (QO2) AND STORAGE (S2) AT THE END OF THE TIME
C PERIOD AND THE AVERAGE TOTAL DISCHARGE (QOM) WILL BE COMPUTED IN THIS
C SUBROUTINE.  ALSO, PEAK VALUES ABOVE TESTPK AND BETWEEN REGULAR TIME
C INTERVAL OUTFLOW VALUES WILL BE COMPUTED AND THE NEAREST ARRAY POSIT-
C IONS.
C***********************************************************************
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/errdat'
      INCLUDE 'common/resv26'
      INCLUDE 'common/root26'
C
      DIMENSION SOH(1),O(1),WORK(1),PEAKO(1),PKPOS(1)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_res/RCS/rute26.f,v $
     . $',                                                             '
     .$Id: rute26.f,v 1.2 2002/02/19 16:13:08 michaelo Exp $
     . $' /
C    ===================================================================
C
CCC EJV MODIFY FOR MAINTENANCE 296
C NEED TO INITIALIZE QQOK1 BECAUSE IT MAY NOT GET INITIALIZED
C TO QOKBGN FURTHER DOWN LIKE IT IS SUPPOSED TO ESPECIALLY
C IF POOL IS JUST EQUAL TO SPILLWAY LIP AND FRAC26 RETURNS FRAC2
C IN OVER26 TO BE 0.0000001
      QQOK1=QOKBGN
CCC END EJV MODIFY
C
C***********************************************************************
C WRITE TRACE AND DEBUG IF REQUIRED.
C***********************************************************************
      IF(IBUG-1)50,10,20
   10 WRITE(IODBUG,30)
      GO TO 50
   20 WRITE(IODBUG,30)
   30 FORMAT(1H0,10X,17H** RUTE26 ENTERED)
      WRITE(IODBUG,40) NS2,FRAC1,FRAC2,SBGN,SFILL,SPILMX,STOCR,S1,S2,  Q
     $I1,QI2,QIM,QO1,QO2,QOM,QOK1,QOK2,QOKBGN,QOSBGN,TESTPK,NTOTPK,IUNC,
     $IBUG
   40 FORMAT(1H0,117H   NS2,FRAC1,FRAC2,SBGN,SFILL,SPILMX,STOCR,S1,S2,
     $QI1,QI2,QIM,QO1,QO2,QOM,QOK1,QOK2,QOKBGN,QOSBGN,TESTPK,NTOTPK,IUNC
     $/1X,I6,9F12.3/1X,10F12.3/1X,2I6/1H0, 8H IBUG IS,I6)
C***********************************************************************
C PUT SOH (STORAGE+O/2) IN WORK ARRAY.  FIRST VALUE OF SOH MUST BE 0.
C STORAGE IN SOH MUST BE IN UNITS OF MEAN DISCHARGE FOR THE TIME PERIOD.
C***********************************************************************
   50 DO 60 I=1,NOSOH
   60 WORK(I)=SOH(I)
C***********************************************************************
C NSAVE WILL BE USED TO DETERMINE NUMBER OF ROUTING STEPS (NSTEPS) WHEN
C ROUTING OCCURS OVER A FRACTION (FRAC2) OF THE TIME PERIOD.  NSTEPS IS
C SET TO 1 BUT MAY BE CHANGED IN DO LOOP 20.
C***********************************************************************
      NSAVE=1
      NSTEPS=1
      STEPS=1.
      IF(FRAC2.LT.0.01) FRAC2=0.01
C***********************************************************************
C FOLLOWING DO LOOP 80 DETERMINES THE NO. OF ROUTING STEPS (NSTEPS)
C WITHIN THE TIME PERIOD OR WITHIN FRAC2*TIME PERIOD.
C DO LOOP 20 ALSO COMPUTES STORAGE IN UNITS OF MEAN DISCHARGE FOR THE
C ROUTING TIME STEP.  STORAGE+O/2 IS THEN COMPUTED AND PUT IN THE WORK
C ARRAY.
C***********************************************************************
      STOR1= (WORK(1)-O(1)*0.5)/FRAC2
      DO 80 I=2,NOSOH
C***********************************************************************
C STORAGE IS CHANGED TO UNITS OF A FRAC2 TIME STEP AND PUT IN THE WORK
C ARRAY.   STORAGE WILL BE IN UNITS OF THE TIME PERIOD IF FRAC2=1.
C FRAC2 IS THE FRACTION OF THE TIME PERIOD OVER WHICH ROUTING OCCURS.
C***********************************************************************
      STOR2=(WORK(I)-O(I)*0.5)/FRAC2
C***********************************************************************
C CHECK WHETHER THE DIFFERENCE OF SUCCESSIVE STORAGE VALUES DIVIDED BY
C THE DIFFERENCE OF SUCCESSIVE O (DISCHARGE) VALUES IS GREATER THEN 0.5.
C  THIS IS THE SAME AS CHECKING THAT MUSKINGUM K IS GREATER THAN 1/2 OF
C THE ROUTING PERIOD SINCE STORAGE IS IN UNITS OF MEAN DISCHARGE FOR
C THE ROUTING PERIOD.
C***********************************************************************
      AK=(STOR2-STOR1)/(O(I)-O(I-1))
      IF(AK.GE.0.5) GO TO 80
C***********************************************************************
C THE ROUTING PERIOD WILL HAVE TO BE DIVIDED INTO NSTEPS ROUTING STEPS.
C***********************************************************************
      NSTEPS=0.5/AK+1.
      NSAVE = MAX0(NSTEPS,NSAVE)
   80 STOR1=STOR2
      NSTEPS=NSAVE
      STEPS=NSTEPS
      IF(NSTEPS.EQ.1.AND.FRAC2.EQ.1.0) GO TO 100
C***********************************************************************
C COMPUTE NEW VALUES OF S+O/2 FOR NSTEPS GREATER THAN 1 AND/OR FRAC2
C LESS THAN 1 AND PUT VALUES OF S+O/2 INTO WORK ARRAY.  S+0/2 IS
C STORAGE+OUTFLOW/2.
C***********************************************************************
      DO 90 I=1,NOSOH
      STOR2=(WORK(I)-O(I)*0.5)*STEPS/FRAC2
   90 WORK(I)=STOR2+O(I)*0.5
C***********************************************************************
C COMPUTE INFLOW (QQI1) AND NON-SPILLWAY OUTFLOW(QQOK1) AT BEGINNING OF
C FIRST ROUTING STEP.  COMPUTE INCREMENTAL INFLOW (DELQI) AND NON-SPILL-
C WAY OUTFLOW (DELQOK) FOR THE ROUTING STEP.
C***********************************************************************
  100 QQI1=QI1+(QI2-QI1)*FRAC1
      IF(FRAC1.EQ.0..AND.FRAC2.LT.1.0) GO TO 110
      QQOK1=QOKBGN
      DELQI=(QI2-QQI1)/STEPS
      DELQOK= (QOK2-QQOK1)/STEPS
      GO TO 120
  110 QQI=QI1+(QI2-QI1)*FRAC2
      DELQI=(QQI-QQI1)/STEPS
      QQOK=QQOK1+(QQOK2-QQOK1)*FRAC2
      DELQOK=(QQOK-QQOK1)/STEPS
C***********************************************************************
C COMPUTE BEGINNING STORAGE (SS1) IN UNITS OF MEAN DISCHARGE FOR THE
C ROUTING TIME STEP AND COMPUTE BEGINNING SI (STORAGE OVER SPILLWAY
C CREST-O/2).
C  (SINCE PULS CURVE IS FOR TOTAL STORAGE, REMOVE SUBTRACTION OF CREST
C   STORAGE IN COMP. OF SI {STORAGE - DISCHARGE/2} JTOSTROWSKI - 12/83)
C
  120 SS1=SBGN*STEPS/FRAC2
      SI=SS1-QOSBGN*0.5
C***********************************************************************
C USE QOS1 FOR BEGINNING SPILLWAY DISCHARGE QOSBGN.
C***********************************************************************
      QOS1=QOSBGN
C***********************************************************************
C SET STEST EQUAL TO SFILL (GATED SPILLWAY) OR STOCR (UNCONTROLLED SPILL
C WAY) AND CONVERT TO UNITS OF MEAN DISCHARGE FOR ROUTING TIME STEP.
C SFILL IS STORAGE LEVEL WHERE INFLOW IS PASSED FOR A GATED SPILLWAY.
C STOCR IS THE POOL STORAGE AT SPILLWAY CREST FOR UNCONTROLLED SPILLWAY.
C***********************************************************************
      IF(IUNC.EQ.1) GO TO 130
      STEST=SFILL*STEPS/FRAC2
      GO TO 140
  130 STEST=STOCR*STEPS/FRAC2
C *********************************************************************
C SET AN INITIAL VALUE FOR PTEST WHICH WILL BE USED FOR COMPUTING THE
C HIGHEST OUTFLOW VALUE DURING THE TIME INTERVAL.  ALSO, SET AN INITIAL
C VALUE FOR THE FRACTION OF TIME (FRACPK) FROM BEGINNING OF TIME PERIOD
C TO HIGHEST OUTFLOW.
C *********************************************************************
  140 PTEST=QOKBGN+QOSBGN
      FRACPK=FRAC1
      DO 210 I=1,NSTEPS
C***********************************************************************
C COMPUTE INFLOW (QQI2) AT END OF ROUTING STEP AND MEAN INFLOW (AVGQI)
C FOR ROUTING STEP.
C***********************************************************************
      QQI2=QQI1+DELQI
      AVGQI=(QQI1+QQI2)*0.5
C***********************************************************************
C COMPUTE NON-SPILLWAY DISCHARGE (QQOK2) AT END OF ROUTING STEP AND
C AVERAGE NON-SPILLWAY DISCHARGE (AVGQOK) FOR THE STEP.
C***********************************************************************
      QQOK2=QQOK1+DELQOK
      AVGQOK=(QQOK1+QQOK2)*0.5
C***********************************************************************
C SUBTRACT AVERAGE NON-SPILLWAY DISCHARGE (AVGQOK) FROM AVERAGE INFLOW
C (AVGQI) TO OBTAIN AVERAGE INFLOW (SPILQI)  FOR ROUTING OVER SPILLWAY.
C***********************************************************************
      SPILQI=AVGQI-AVGQOK
C***********************************************************************
C COMPUTE SO (STORAGE +O/2) FROM EQUATION: AVG INFLOW +S1-O1/2.=S2+O2/2.
C***********************************************************************
      SO=SPILQI+SI
      IF(SO.GT.0.) GO TO 150
      QOS2=0.
      GO TO 160
C***********************************************************************
C COMPUTE SPILLWAY DISCHARGE AT END OT ROUTING TIME STEP FROM (S+O/2) VS
C O RELATION.  S+O/2 IS IN WORK ARRAY.  S+O/2 IS STORAGE+OUTFLOW/2 AND
C O IS OUTFLOW.
C***********************************************************************
  150 CALL TERP26(SO,QOS2,WORK,O,NOSOH,IFLAG,IBUG)
C***********************************************************************
C COMPUTE AVERAGE TOTAL OUTFLOW AVGQO FOR ROUTING TIME STEP AND STORAGE
C SS2 AT THE END OF THE TIME STEP.
C***********************************************************************
  160 AVGQO=AVGQOK+(QOS1+QOS2)*0.5
      SS2=SS1+AVGQI-AVGQO
C***********************************************************************
C CHECK HIGHEST OUTFLOW PTEST AGAINST TOTAL OUTFLOW (QTOTL) AT END OF
C ROUTING STEP AND RESET PTEST AND FRACPK IF REQUIRED.
C***********************************************************************
      QTOTL = QQOK2+QOS2
      IF(PTEST.GE.QTOTL) GO TO 170
      PTEST=QTOTL
      FRACPK=FRACPK+FRAC2/STEPS
C***********************************************************************
C CHECK SS2 (STORAGE AT END OF ROUTING STEP) AGAINST STEST.
C***********************************************************************
  170 IF(SS2.GE.STEST) GO TO 180
      IF(IUNC.EQ.1) GO TO 180
C
C IF THE BEGINNING TIME INTERVAL STORAGE (S1) IS LESS THAN OR EQUAL TO
C AND THE ENDING TIME STEP STORAGE IS LESS THAN STEST, ROUTING WILL
C CONTINUE.  THIS IS THE SITUATION WHERE THE DAM CANNOT PASS THE DESIRED
C OUTFLOW FOR ANOTHER SCHEME AND ROUTING IS NEEDED TO OBTAIN THE MAXIMUM
C POSSIBLE OUTFLOW.
C
      IF(S1.LE.STEST) GO TO 180
C***********************************************************************
C IF THE POOL HAS DROPPED TO SFILL (STEST) FOR A GATED SPILLWAY, INFLOW
C IS PASSED AND THE POOL IS HELD AT SFILL.  SET S2 AND QO2 AND GO TO
C STATEMENT 240 TO COMPUTE QOM.  S2 IS STORAGE AT END OF TIME PERIOD,
C QO2 IS TOTAL OUTFLOW AT END OF TIME PERIOD AND QOM IS MEAN OUTFLOW
C FOR TIME PERIOD.
C***********************************************************************
      SS2=STEST
      S2=SS2*FRAC2/STEPS
      QO2=QI2
      GO TO 240
C***********************************************************************
C WRITE DEBUG IF REQUIRED.
C***********************************************************************
  180 IF(IBUG.NE.2) GO TO 200
      WRITE(IODBUG,190) QQI1,QQI2,QQOK1,QQOK2,QOS1,QOS2,SS1,SS2
  190 FORMAT(1H0,43H    QQI1,QQI2,QQOK1,QQOK2,QOS1,QOS2,SS1,SS2/1X,10F12
     $.3)
C***********************************************************************
C SET VALUES FOR NEXT PASSAGE THROUGH DO LOOP.
C***********************************************************************
  200 QQI1=QQI2
      QQOK1=QQOK2
      QOS1=QOS2
      SS1=SS2
  210 SI=SO-QOS1
C***********************************************************************
C CONVERT SS1 TO UNITS OF MEAN DISCHARGE FOR THE TIME PERIOD.  SS1 IN
C THIS CASE IS THE SAME AS SS2 (THE STORAGE AT THE END OF THE LAST
C ROUTING STEP).
C***********************************************************************
      SS1=SS1*FRAC2/STEPS
      IF(FRAC1.GT.0.0) GO TO 230
      IF(FRAC1.EQ.0.0.AND.FRAC2.EQ.1.0) GO TO 230
C***********************************************************************
C THE REMAINING POSSIBILITY IS (FRAC1.EQ.0.0.AND.FRAC2.LT.1.0).  IN THIS
C CASE, ROUTING STARTS AT THE BEGINNING BUT ENDS DURING THE TIME PERIOD.
C COMPUTE AVERAGE INFLOW AND OUTFLOW TO END OF TIME PERIOD AND CONVERT
C TO MEAN VALUES FOR THE TIME PERIOD IF THIS IS AN UNCONTROLLED
C SPILLWAY.  IF THIS IS A GATED SPILLWAY, SET S2=SFILL AND QO2=QI2 AND
C GO TO 240 TO COMPUTE QOM.  S2 IS THE ENDING TIME PERIOD STORAGE, QO2
C IS THE ENDING TOTAL OUTFLOW, AND QOM IS THE MEAN OUTFLOW.
C***********************************************************************
      IF(IUNC.EQ.1) GO TO 220
      S2=SFILL
      QO2=QI2
      GO TO 240
  220 FRAC=0.5*(1.-FRAC2)
      AVGQI=(QQI1+QI2)*FRAC
      AVGQO=(QOS1+QQOK1+QOK2)*FRAC
      S2=SS1+AVGQI-AVGQO
      QO2=QOK2
      GO TO 240
C***********************************************************************
C IN THE FOLLOWING CASE, ROUTING LASTS THROUGH THE END OF THE TIME
C PERIOD AND S2 IS EQUAL TO SS1.  S2 IS TIME PERIOD ENDING STORAGE
C AND SS1 IS THE STORAGE AT THE END OF THE LAST ROUTING STEP.
C***********************************************************************
  230 S2=SS1
      QO2=QOS1+QOK2
C***********************************************************************
C COMPUTE AVERAGE OUTFLOW QOM FOR THE TIME PERIOD FROM S1, S2, AND QIM.
C***********************************************************************
  240 QOM=S1-S2+QIM
C***********************************************************************
C REDUCE PTEST BY ONE PERCENT TO KEEP FROM MAKING MINOR CHANGES IN
C REGULAR TIME PERIOD OUTFLOWS  IF PTEST IS GREATER THAN A TEST VALUE
C (TESTPK).  CHECK TEST (NEW VALUE OF PTEST) AGAINST QO1 AND QO2 (BEGIN-
C NING AND ENDING TIME INTERVAL OUTFLOWS).  IF
C TEST IS HIGHER, PUT IN PEAKO ARRAY AND PUT NEAREST ARRAY POSITION
C OF OUTFLOW ARRAY IN PKPOS ARRAY.  PEAKO VALUES WILL BE PUT IN THE
C OUTFLOW ARRAY BY THE SUPERVISORY ROUTINE AT THE END OF THE RESERVOIR
C OPERATION.  PTEST CAN REPACE EVEN OBSERVED   VALUES OF OUTFLOW AS
C PTEST IS A BETTER VALUE FOR ROUTING DOWNSTREAM.
C IF NSTEPS=1, NUMPKO WILL BE 0 AND THERE WILL BE NO PEAK OUTFLOWS
C BETWEEN TIME INTERVAL VALUES.
C***********************************************************************
      IF(NSTEPS.NE.1) GO TO 250
      NUMPKO=0
      GO TO 290
  250 IF(PTEST.LE.TESTPK)GO TO 290
cf      TEST=PTEST-0.01*PTEST
cf      IF(TEST.LE.QO1.OR.TEST.LE.QO2) GO TO 290
      IF(PTEST-0.01*PTEST.LE.QO1.OR.PTEST-0.01*PTEST.LE.QO2) GO TO 290
      IF(NUMPKO.EQ.-999)NUMPKO=0
      NUMPKO=NUMPKO+1
      IF(NUMPKO.GT.NTOTPK) GO TO 270
      PEAKO(NUMPKO)=PTEST
      IF(NS2.EQ.1) GO TO 260
      IF(FRACPK.GE.0.5) GO TO 260
      PKPOS(NUMPKO)=NS2-1+0.01
      GO TO 290
  260 PKPOS(NUMPKO)=NS2+0.01
      GO TO 290
  270 WRITE(IPR,280)NTOTPK,NUMPKO
  280 FORMAT(1H0,10X,32H**WARN** THE NUMBER OF POSITIONS,I6,83H IN THE P
     $EAKO ARRAY IN RUTE26 IS INSUFFICIENT TO HOLD THE REQUIRED NO. OF P
     $OSITIONS,I6)
      CALL WARN
C***********************************************************************
C WRITE TRACE AND DEBUG IF REQUIRED.
C***********************************************************************
  290 IF(IBUG-1)370,350,300
  300 WRITE(IODBUG,310)QO2,QOM,S2
  310 FORMAT(1H0,41H QO2,QOM, AND S2 AT THE END OF RUTE26 ARE,3F12.3)
      ROSTEP=FRAC2/STEPS
      WRITE(IODBUG,320) ROSTEP
  320 FORMAT(1H0,61H LENGTH OF ROUTING STEP AS A FRACTION OF THE TIME IN
     $TERVAL IS,F6.3)
      WRITE(IODBUG,330) (O(I),WORK(I),SOH(I),I=1,NOSOH)
  330 FORMAT(1H0,102HOUTFLOW AND TWO CORRESPONDING STORAGE+O/2 (UNITS OF
     $ MEAN FLOW FOR TIME STEP AND TIME INTERVAL) IN SETS/(1X,3(3F12.3))
     $)
      WRITE(IODBUG,340) PTEST,TESTPK,QO1,QO2
  340 FORMAT(1H0,33HHIGHEST OUTFLOW IN TIME PERIOD IS,F12.3,20H.  TEST D
     $ISCHARGE IS,F12.3/36H   BEGINNING AND ENDING OUTFLOWS ARE,2F12.3)
  350 WRITE(IODBUG,360)
  360 FORMAT(1H0,10X,17H** LEAVING RUTE26)
  370 RETURN
      END

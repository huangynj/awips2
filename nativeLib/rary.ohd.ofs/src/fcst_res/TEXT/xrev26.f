C MEMBER XREV26
C  (from old member FCXREV26)
C
C DESC PERFORM PRELIMINARY CALCULATIONS FOR 'RAINEVAP' UTILITY
C-------------------------------------------------------------------
C                             LAST UPDATE: 01/06/94.11:42:04 BY $WC21DT
C
      SUBROUTINE XREV26(PO,W,IDPT,LOCOWS)
C--------------------------------------------------------------------
C  SUBROUTINE TO DO PRELIMINARY CALCULATIONS FOR THE RAIN/EVAP UTILITY
C  (SU#16). MUST GET LOCATION OF PRECIP TIME-SERIES AND SEE IF WE'RE
C  USING EVAPORATION EFFECTS, AND IF SO, HOW THOSE EFFECTS ARE INPUT
C  TO THE PROCEDURE (EITHER TIM-SERIES OR MONTHLY CURVE).
C--------------------------------------------------------------------
C  WRITTEN BY - JOE OSTROWSKI - HRL - OCTOBER 1983
C--------------------------------------------------------------------
C
      INCLUDE 'common/resv26'
      INCLUDE 'common/exg26'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fprog'
      INCLUDE 'common/xre26'
      INCLUDE 'common/rulc26'
C
C  THE FOLLOWING CHANGE MADE ON 12/21/90 -- #625
C      DIMENSION PO(1),W(1),IDPT(1),LOCOWS(1),IEDAY(12)
C      DATA IEDAY/16,47,75,106,136,167,197,228,259,289,320,350/
      INCLUDE 'common/fctime'
      DIMENSION PO(1),W(1),IDPT(1),LOCOWS(1),IEDAY(14),EDAY(14)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_res/RCS/xrev26.f,v $
     . $',                                                             '
     .$Id: xrev26.f,v 1.5 2006/04/19 14:47:36 hsu Exp $
     . $' /
C    ===================================================================
C
      DATA IEDAY/-15,16,47,75,106,136,167,197,228,259,289,320,350,381/
C  END OF CHANGE OF 12/21/90
C
C-------------------------------------------------------------------
C
      IF (IBUG.GE.1) WRITE(IODBUG,1600)
 1600 FORMAT('   *** ENTER XREV26 ***')
C  THE FOLLOWING CHANGE MADE ON 6/29/92 -- #708
      LPYR=LEAP26(JULDAT,MINODT)
      IF(LPYR.LE.0) GO TO 150
      DO 148 I=3,14
  148 IEDAY(I)=IEDAY(I)+LPYR
  150 CONTINUE
C  END OF CHANGE OF 6/29/92
C
C  GET LOCATION INFO FOR THIS UTILITY
C
      SUNUM = 1531.01
      CALL XPTR26(SUNUM,PO,IORD,IBASE,LEVEL,LOCPM,LOCTS,LOCCO)
C
C  SET SWITCH FOR EVAPORATION EFFECTS
C
      IEVSW = PO(LOCPM)
      LOCNXT = LOCPM + 1
      IADDTS = 0
C
C  IF SWITCH < 0, NO EVAP EFFECTS ARE CONSIDERED
C            = 0, EVAP IS CONSIDERED USING MONTHLY CURVE,
C            > 0, EVAP IS CONSIDERED USING TIME-SERIES.
C
C  BUT FIRST, GET THE LOCATION OF TIME-SERIES FOR PRECIP IN D ARRAY
C
      LOCPTS = W(IORD*3-1)
      LOCRTS = IDPT(LOCPTS) + IDOFST*NTIM24
C
C  SET POINTER LOCATIONS IN WORK ARRAY FOR VARIOUS NEEDS OF 'RAINEVAP'.
C
      LPTADL = LOCOWS(5)
      LPTAEL = LPTADL + NDD*NTIM24
      LPTARA = LPTAEL + NSE
      LRETS  = LPTARA + NSE
      LRECO  = LRETS + NDD
C
C  NOW PERFORM PROPER DUTIES FOR HOW EVAP IS TO BE DEALT WITH.
C
      IF (IEVSW) 1100,200,300
C
C----------------------------------------------------------------------
C  HERE WE HAVE THE MONTHLY EVAP CURVE THAT WE MUST CREATE A TIME-SERIES
C  FROM, ONE VALUE PER DAY OF RUN.  DIURNAL DIST'N WILL BE USED TO
C  DISTRIBUTE DAILY EVAP INTO PARTS OF DAY.
C
  200 CONTINUE
C
C  FIND WHERE WE ARE IN THE YEAR TO GIVE US THE PROPER LOCATION FOR
C  PULLING OUT THE PROPER MONTHLY EVAPORATION.
C
      NDAYSE = NUM/NTIM24

      DO  210 IM=1,12
      EDAY(IM) = PO(LOCNXT+IM-1)
  210 CONTINUE
C      EDAY(1) = EDAY(12)
C      EDAY(14) = EDAY(2)
      DO  211 IM=12,1,-1
      EDAY(IM+1) = EDAY(IM)
  211 CONTINUE
      EDAY(1) = EDAY(13)
      EDAY(14) = EDAY(2)
C
      DO  250 ID=1,NDAYSE
      ITDY = JULDAT +ID - 1
      DO  240 IMX = 1,14
  240 IF( ITDY .LT. IEDAY(IMX) ) GO TO  245
  245 CONTINUE
      SLOPE = (EDAY(IMX) - EDAY(IMX-1))/(IEDAY(IMX)-IEDAY(IMX-1))
      W(LRETS+Id-1) = EDAY(IMX-1) + SLOPE*(ITDY-IEDAY(IMX-1))
  250 CONTINUE
C
      IMON = IMX-2
      IF (IMON.GT.12) IMON = 1
      IF(IBUG.LE.0) GO TO 255
      WRITE(IODBUG,1694) JULDAT,NDAYSE,IMON,EDAY(IMON+1)
 1694 FORMAT(5X,'STARTDAT,NDAYSE,MONTH= ',3I5, ' MIDMON EVAP= ',F6.2)
      WRITE(IODBUG,1695) (EDAY(I),I=2,13)
 1695 FORMAT(5X,'MONTHLY EVAPORATION:',/(5X,6F10.2))
      WRITE(IODBUG,1696) (EDAY(I),I=1,14)
 1696 FORMAT(5X,'MONTHLY EVAPORATION REARRANGED:',/(5X,7F10.2))

      WRITE(IODBUG,1697) IMON,(W(LRETS+I-1),I=1,NDAYSE)
 1697 FORMAT(5X,'DAILY EVAPORTAION FOR MONTH: ',I2/(5X,8F10.2))
 255  CONTINUE
C
C  STORE THE DIURNAL DIST'N IN /RNEV26/
C
      LOCNXT = LOCNXT + 12
      DO  260 I=1,NTIM24
      EDISTN(I) = PO(LOCNXT+I-1)
  260 CONTINUE
      GO TO 1000
C
C------------------------------------------------
C  EVAP IS CONSIDERED AND THE EVAP VALUES ARE COMING FROM A TIME-SERIES.
C  ONLY NEED TO SET THE LOCATION OF THE TIME-SERIES IN THE D ARRAY.
C
  300 CONTINUE
      LOCETS = IDPT(LOCPTS+1) + IDOFST*NTIM24
      IADDTS = 1
C  THE FOLLOWING CHANGE MADE ON 10/17/90 -- #280
C      GO TO 1100
      DO 360 I=1,NTIM24
  360 EDISTN(I)=PO(LOCNXT+I-1)
      GO TO 1000
C  END OF CHANGE OF 10/17/90
C
C-----------------------------------------------------
C  THE REMAINING VALUE TO BE PULLED FROM THE PO ARRAY IS THE TOLERANCE
C  FOR ITERATIONS.
C
 1000 CONTINUE
      LOCNXT = LOCNXT + NTIM24
 1100 CONTINUE
      RETOL = PO(LOCNXT)
C
C  SET LOCATION AND NEED TO OUTPUT ADD'L FLOW.
C
      WRADLQ = .FALSE.
      LTSADQ = IDPT(LOCPTS+IADDTS+1)
      IF (LTSADQ .GT. 0) WRADLQ = .TRUE.
      LTSADQ = LTSADQ + IDOFST*NTIM24
C
      IF (IBUG.GE.1) WRITE(IODBUG,1699)
 1699 FORMAT('    *** EXIT XREV26 ***')
      RETURN
      END

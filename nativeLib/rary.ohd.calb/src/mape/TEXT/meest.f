C
C-----------------------------------------------------------------------
C
C @PROCESS LVL(77)
C
      SUBROUTINE MEEST (NSTA,IL,GL,IRGCK,MONTH,IYEAR,IFAR,IPRINT,
     *   MCOUNT,IEND,LASTDA)
C
C  ROUTINE TO ESTIMATE MISSING DATA
C
      DIMENSION IFAR(25),LASTDA(2,12)
C
      INCLUDE 'uiox'
      COMMON /MEDATX/ X(25),Y(25),PTPE(25,31),NWSSTA(25),PXNAME(25),
     *   FE(25),PENORM(25,12),ELEV(25)
      CHARACTER*20 PXNAME
      COMMON /MEESTX/ ISTAQ(4),DQ(4),RDQ(4)
C
      real  flg_p_998
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/calb/src/mape/RCS/meest.f,v $
     . $',                                                             '
     .$Id: meest.f,v 1.1 1997/03/17 17:41:32 dws Exp $
     . $' /
C    ===================================================================
C
      data  flg_p_998/+998.0/
C
      MCOUNT=0
C
      DO 250 IRG=1,NSTA
      DO 210 I=1,IL
      IF (PTPE(IRG,I).LT.flg_p_998) GO TO 210
C   FIND NEAREST VALID STATION IN EACH QUADRANT
      ISTAQ(1)=0
      ISTAQ(2)=0
      ISTAQ(3)=0
      ISTAQ(4)=0
      DQ(1)=99999.0
      DQ(2)=99999.0
      DQ(3)=99999.0
      DQ(4)=99999.0
C     LOOK FOR NEAREST STATION IN EACH QUADRANT
      IPASS=1
10    DO 90 JRG=1,NSTA
C   IF THE STATION TO BE ESTIMATED HAS MONTHLY DATA AND THE ESTIMATOR
C   STATION DOES NOT, AND ITS THE FIRST PASS THROUGH THE STATIONS
C   TRY ANOTHER STATION
      IF (IFAR(IRG).EQ.1.AND.IFAR(JRG).NE.1.AND.IPASS.EQ.1) GO TO 90
C   IF THE ESTIMATOR STATION HAS MONTHLY DATA AND ITS THE FIRST PASS
C   THROUGH THE STATIONS TRY ANOTHER STATION
      IF ((IFAR(JRG).EQ.1).AND.(IPASS.EQ.1)) GO TO 90
C   IF THE ESTIMATOR STATION IS THE STATION TO BE CHECKED, AND
C   THE STATION TO BE ESTIMATED IS THE DUMMY STATON TRY ANOTHER
C   STATION
      IF ((NWSSTA(IRG).GT.9999).AND.(JRG.EQ.IRGCK)) GO TO 90
C   IF THE ESTIMATOR STATION HAS MISSING DATA TRY ANOTHER STATION
      IF (PTPE(JRG,I).GT.flg_p_998) GO TO 90
C   CALCULATE THE DISTANCE BETWEEN THE ESTIMATOR STATION AND THE
C   STATION TO BE ESTIMATED
      DELX=X(JRG)-X(IRG)
      DELY=Y(JRG)-Y(IRG)
      D2=DELX*DELX+DELY*DELY
      IF (D2.LT.1.0) D2=1.0
      D=SQRT(D2)
C   CALCULATE THE DIFFERENCE IN ELEVATION BETWEEN THE ESTIMATOR
C   STATION AND THE STATION TO BE ESTIMATED
      DE=ABS(ELEV(JRG)-ELEV(IRG))
      DE=DE*0.001
      A=FE(IRG)
C   WEIGHT THE DISTANCE AND ELEVATION DIFFERENCES
      D=D*GL+A*DE
C   DETERMINE WHICH QUADRANT THE ESTIMATOR STATION IS IN AND
C    SELECT ONLY THE CLOSEST (DISTANCE AND ELEVATION) ESTIMATOR
C   STATION IN EACH QUADRANT TO THE STATION TO BE ESTIMATED
      IF (DELX) 20,40,30
20    IF (DELY) 50,60,60
30    IF (DELY) 70,70,80
40    IF (DELY) 50,70,80
50    IF (D.GT.DQ(1)) GO TO 90
      DQ(1)=D
      ISTAQ(1)=JRG
      GO TO 90
60    IF (D.GT.DQ(4)) GO TO 90
      DQ(4)=D
      ISTAQ(4)=JRG
      GO TO 90
70    IF (D.GT.DQ(2)) GO TO 90
      DQ(2)=D
      ISTAQ(2)=JRG
      GO TO 90
80    IF (D.GT.DQ(3)) GO TO 90
      DQ(3)=D
      ISTAQ(3)=JRG
90    CONTINUE
C     ESTIMATE MISSING DATA BASED ON DEVIATIONS FROM NORMAL
      SUMD=0.0
      DO 110 JRG=1,4
      IF (ISTAQ(JRG).EQ.0) GO TO 110
       XDQ=0.5
      IF (DQ(JRG).LT.1.0) THEN
         WRITE (LP,100) JRG,DQ(JRG),XDQ
100   FORMAT (' *** NOTE - DQ(',I1,') IS LESS THAN 1 WITH A VALUE OF ',
     *   F6.3,' AND WILL BE SET TO ',F5.2,'.')
         DQ(JRG)=XDQ
         ENDIF
C   CALCULATE 1/DELTA (DISTANCE & ELEVATION) FOR THE STATIONS SELECTED
C   IN EACH QUADRANT
      RDQ(JRG)=1.0/DQ(JRG)
C   CALCULATE THE SUM OF THE (1/DELTAS)
      SUMD=SUMD+RDQ(JRG)
110   CONTINUE
      IF (SUMD.LE.0.0005) GO TO 130
      EST=0.0
      DO 120 JRG=1,4
      IF (ISTAQ(JRG).EQ.0) GO TO 120
C   CALCULATE THE WEIGHT FOR EACH STATION
      RDQ(JRG)=RDQ(JRG)/SUMD
      KRG=ISTAQ(JRG)
C   CALCULATE THE RATIO OF THE NORMAL DAILY ET FOR THE MONTH AT THE
C   STATION TO BE ESTIMATED TO THE NORMAL DAILY ET FOR THE MONTH AT
C   THE ESTIMATOR STAION. AN ESTIMATE OF THE NORMAL ET FOR A
C   PARTICULAR DAY AT A PARTICULAR STATION "COULD" BE MADE BY
C   ASSUMING THAT THE NORMAL MONTHLY VALUE OCCURRED ON THE 16TH OF
C   THE MONTH, AND INTERPOLATING BETWEEN TWO ADJACENT MONTHLY
C   NORMALS. THESE ESTIMATES COULD BE USED TO CALCULATE THE RATIO
C   OF THE ESTIMATED STATION ET TO THE ESTIMATOR STATION ET FOR A
C   PARTICULAR DAY. THE ADDITIONAL CALCULATIONS REQUIRED FOR THIS
C   REFINEMENT WERE NOT CONSIDERED NECESSARY AT THIS TIME
      DELTA=PENORM(IRG,MONTH)/PENORM(KRG,MONTH)
C   SUM THE WEIGHTED AND ADJUSTED ETS OVER ALL THE ESTIMATOR STATIONS.
      EST=EST+((PTPE(KRG,I)*DELTA)*RDQ(JRG))
120   CONTINUE
C   ADD 2000 TO THESE VALUES TO INDICATE THAT THEY ARE ESTIMATED
      PTPE(IRG,I)=EST+2000.0
      GO TO 210
C     ALL ESTIMATORS MISSING
130   IF (IPASS.EQ.2) GO TO 140
      IPASS=2
      GO TO 10
C   ESTIMATE THE MISSING DATA USING MONTHLY MEANS
C
C   COUNT THE NUMBER OF DAYS WHICH WERE ESTIMATED USING
C   MONTHLY MEANS
140   IF (IRG.GT.1) GO TO 150
      MCOUNT=MCOUNT+1
150   RI=I
      IF (I.LT.16) GO TO 160
C   DAY TO BE ESTIMATED IS IN THE SECOND HALF OF THE MONTH
      MONTH2=MONTH+1
      IF (MONTH2.EQ.13) MONTH2=1
      RIL=IL
      PTPE(IRG,I)=(PENORM(IRG,MONTH2)-PENORM(IRG,MONTH))*
     * ((RI-16.)/RIL)+PENORM(IRG,MONTH)+2000.0
      GO TO 190
C   DAY TO BE ESTIMATED IS IN THE FIRST HALF OF THE MONTH
160   MONTH1=MONTH-1
      IYEAR1=IYEAR
      IF (MONTH1.GT.0) GO TO 170
      MONTH1=12
      RLAST1=31
      GO TO 180
170   LY=0
      IF ((IYEAR1-4*(IYEAR1/4)).EQ.0) LY=1
      RLAST1=LASTDA((LY+1),MONTH1)
180   PTPE(IRG,I)=(PENORM(IRG,MONTH)-PENORM(IRG,MONTH1))*
     * ((RLAST1-16.+RI)/RLAST1)+PENORM(IRG,MONTH1)+2000.0
190   WRITE (LP,200) PXNAME(IRG),MONTH,I,IYEAR
200   FORMAT (' ALL ESTIMATORS MISSING FOR ',A,2X,2(I2,'/'),I4,
     * '  THE PTPE VALUE WAS ESTIMATED USING MONTHLY MEANS')
210   CONTINUE
      IF (IPRINT.NE.2) GO TO 250
      IF (IEND.EQ.0) GO TO 220
      IF (IRG.NE.IRGCK.AND.IRG.NE.NSTA) GO TO 250
220   WRITE (LP,230) PXNAME(IRG),MONTH,IYEAR
230   FORMAT (5X,A,2X,I2,'/',I4)
      WRITE (LP,240) (PTPE(IRG,I),I=1,IL)
240   FORMAT (10X,16F7.2)
250   CONTINUE
C
      RETURN
C
      END

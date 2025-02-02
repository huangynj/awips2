C MEMBER FLOOPR
C  (from old member FCFLOOPR)
C
C @PROCESS LVL(77)
C  DESC -- CONVERT STAGE(DISCHARGE) TO DISCHARGE(STAGE) WITH VARIABLE
C                             LAST UPDATE: 11/15/94.15:15:13 BY $WC30KH
C
C          ENERGY SLOPE DUE TO CHANING FLOW
C
C.......................................................................
C
       SUBROUTINE FLOOPR(RCID,ICONV,ITSPOS,NVALS,DELTAT,QDATA,HDATA,
     1                   LOCPTR,T1,METHOD,NEEDEX,CARRYO,JULDAY,INITHR,
     1                   IRCHNG,JEROR,IBUG)
C
C.......................................................................
C
C
C  SUBROUTINE FLOOPR IS A DYNAMIC MODEL OF THE STAGE DISCHARGE RELATION.
C  THE MODEL CONSIDERS THE VARIABLE ENERGY SLOPE DUE TO CHANGING
C  Q WHICH CAUSES A LOOP IN THE STAGE-DISCHARGE RATING CURVE.
C
C ARGUMENT LIST:
C     RCID   - 8-CHAR RATING CURVE IDENTIFIER
C     ICONV  - CONVERSION INDICATOR
C              =1, STAGE TO DISCHARGE CONVERSION
C              =2, DISCHARGE TO STAGE
C     ITSPOS - POSITION IN T.S. ARRAY OF FIRST VAL TO BE CONVERTED
C     NVALS  - THE NUMBER OF VALUES TO BE CONVERTED
C     DELTAT - THE TIME INTERVAL (HRS) BETWEEN VALUES OF SPECIFIED
C                                                         HYDROGRAPH.
C     HDATA  - SPECIFIED STAGE HYDROGRAPH ARRAY (ICONV=1)
C     QDATA  - SPECIFIED DISCHARGE HYDROGRAPH ARRAY (ICONV=2)
C     LOCPTR - POINTER ARRAY
C     T1     - TIMING ARRAY
C     METHOD - METHOD OF CONVERSION INDICATOR
C              =0, SINGLE VALUE RATING CURVE CONVERSION
C              =1, DYNAMIC LOOP RATING CURVE
C  NEEDEX - EXTENSION INDICATOR
C           =0, NO EXTENSION NECESSARY
C           =1, LOG-LOG EXTENSION USED
C           =2, HYDRAULIC EXT. AT UPPER END
C           =3, LOG-LOG LOWER END, HYDRAULIC UPPER END
C           =4, LINEAR EXTENSION USED
C           =5, LINEAR LOWER END, HYDRAULIC UPPER END
C           =6, LOOP RATING AT UPPER END
C           =7, LOG-LOG LOWER END, LOOP RATING UPPER END
C           =8, LINEAR LOWER END, LOOP RATING UPPER END
C     CARRYO - CARRYOVER ARRAY
C              1ST ELEMENT = PREVIOUS STAGE
C              2ND ELEMENT = PREVIOUS DISCHARGE
C              3RD ELEMENT = DQ (ICONV=1);  DH (ICONV=2)
C              4TH ELEMENT = NUMBER OF MISSING VALS PRIOR TO ITSPOS
C    JULDAY - JULIAN DAY(INTERNAL CLOCK) OF INITIAL VALUE TO BE CONVERTE
C    INITHR - HOUR OF INITIAL VALUE TO BE CONVERTED
C    IRCHNG - COMMON BLOCK /FRATNG/ TRANSFER INDICATOR
C             =0, NO CHANGE
C             =1, CALIB. RUN EXCEEDED LAST APPLICABLE DAY OF R.C. IN
C                 /FRATNG/ AND TRANSFER FROM SCRATCH FILE WAS MADE
C     JEROR - ERROR FLAG
C              =0, NORMAL RETURN, NO ERRORS
C              =1, ERROR OCCURRED -- OUTPUT T.S. COULD NOT BE FILLED
C
C
C.......................................................................
C
C   PROGRAM ORIGINALLY WRITTEN BY DANNY FREAD
C   CONVERTED TO SUBROUTINE FOR NWSRFS BY --
C    JONATHAN WETMORE -- HRL -- 801031
C
C.......................................................................
      INCLUDE 'common/fprog'
      INCLUDE 'common/fratng'
      INCLUDE 'common/facxsc'
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/where'
       COMMON/TSID/TSID(2)
      DIMENSION RCID(2),QDATA(*),HDATA(*),CARRYO(*),LOCPTR(*),T1(*)
       DIMENSION SUBNAM(2),OLDSUB(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_rc/RCS/floopr.f,v $
     . $',                                                             '
     .$Id: floopr.f,v 1.2 1998/07/02 17:09:22 page Exp $
     . $' /
C    ===================================================================
C
       DATA SUBNAM/4HFLOO,4HPR  /
C  SET /WHERE/ INFO
C
      DO 500 I=1,2
      OLDSUB(I) = OPNAME(I)
  500 OPNAME(I) = SUBNAM(I)
      IOLDOP = IOPNUM
      IOPNUM = 0
C
      IF (ITRACE.GE.2) WRITE(IODBUG,601)
  601 FORMAT(1H ,21H *** ENTER FLOOPR ***)
C
C
C  SET ARRAY INDEXES
      ITWO=2
      LH1=LOCH
      LHN=LH1+NRCPTS-1
      LQ1=LOCQ
      LQN=LQ1+NRCPTS-1
      LXE1=LXELEV
      LXEN=LXE1+NCROSS-1
      LXT1=LXTOPW
      LXTN=LXT1+NCROSS-1
      RCMXH=XRC(LHN)
      RCMXEL=RCMXH+GZERO
      CARRYO(1)=-999.
      CARRYO(2)=-999.
      CARRYO(3)=-999.
      CARRYO(4)=-999.
C  GRAVITY ACCELERATION CONSTANT
      G=9.8
      LASPOS=ITSPOS+NVALS-1
      DELTAT=DELTAT-0.01
      DT=DELTAT
      DTS=DT*3600.
      METHOD=1
      IRCHNG=0
      JEROR=0
      ICURDA=JULDAY
      IIHR=INITHR
      IF(IBUG.GE.1) WRITE(IODBUG,7889) (CARRYO(I),I=1,4)
 7889 FORMAT(1H0,2X,10HCARRYO(1)=,F10.2,2X,10HCARRYO(2)=,F10.2,
     12X,10HCARRYO(3)=,F10.2,2X,10HCARRYO(4)=,F5.0)
C  ITERATIVE CONVERGENCE CRITERION
      EPH=0.001
      EPQ=0.1
   36 CONTINUE
C
C CHECK THAT 1ST CROSS SECTION ELEV. <= 1ST ELEV. OF RATING CURVE
C
      ELRQ1=XRC(LH1)+GZERO+0.01
      IF(XRC(LXE1).LE.ELRQ1) GO TO 4000
      WRITE(IPR,8149) RCID,XRC(LXE1),ELRQ1,XRC(LXE1)
8149  FORMAT(1H0,10X,'*WARNING*  RATING CURVE ',2A4,
     * /22X,'FIRST CROSS SECTION ELEV.=',F10.2,' M',
     * 4X,'GREATER THAN FIRST ELEV. OF RATING CURVE=',F10.2,' M',
     $ /22X,'LOOP RATING STOPS AT FIRST X.S. ELEV.=',F10.2,' M',2X,
     $ 'ANY LOWER VALUES ARE INTER/EXTRAPOLATED FROM RATING CURVE')
      CALL WARN
 4000 TOPSTG=XRC(LHN)
      TOPQ=XRC(LQ1-1+NRCPTS)
C
      NEEDEX=0
      NW=0
      NRANGE=0
      LOWEXT=0
      IUPEXT=0
      CONR=2./3.*SLOPE/FRLOOP/FRLOOP
C
C  NOTE:  LOOP RATING CURVE MODEL SOMETIMES DEVELOPS NUMERICAL
C         INSTABILITY IF X-SECT TOPWIDTH INCREASES MORE THAN APPROX
C         150 FT PER FOOT OF INCREASE IN ELEVATION.  FOR THIS REASON,
C         AN OFF CHANNEL STORAGE OPTION HAS BEEN ADDED TO OVERCOME
C         INSTABILITY PROBLEMS.  THE FOLLOWING SECTION CHECKS THE X-
C         SECTION DATA AND IF PROBLEM APPEARS IMMINENT, DIVIDES THE
C         X-SECTION INTO ACTIVE FLOW AREA AND OFF-CHANNEL STORAGE.
C......................................................................
C
      LOCFR=EMPTY(1)
      QMIN=XRC(LOCFR+5)
      HMIN=XRC(LOCFR+6)+GZERO
      NOCS=XRC(LOCFR+7)
      IF(NOCS.LE.1) GO TO 337
      LXELOC=LOCFR+8
      LXTWOC=LXELOC+NOCS
      DO 37 I=1,NOCS
   37 OCTW(I)=XRC(LXTWOC-1+I)
C
  337 ACAREA(1)=ABELOW
      ACTW(1)=XRC(LXT1)
      CFK(1)=1.5
      EMPTYS=EMPTY(4)
      EMPTY(4)=1.01
C
      DO 38 I=2,NCROSS
      ACTW(I)=XRC(LXT1-1+I)
      ACAREA(I)=ACAREA(I-1)+((ACTW(I)+ACTW(I-1))/2.)
     1*(XRC(LXE1-1+I)-XRC(LXE1-1+I-1))
C   FIND FK (CELERETY COEFFICIENT) VALUE ASSOC. W/EACH ELEV.
      DELTOP=(ACTW(I)-ACTW(I-1))/(XRC(LXE1-1+I)-XRC(LXE1-1+I-1))
      CFK(I)=((5./3.-(2./3.)*(ACAREA(I)-ACAREA(I-1))*DELTOP/ACTW(I)
     1    /ACTW(I))
     2*(ACAREA(I)-ACAREA(I-1))+CFK(I-1)*ACAREA(I-1))/ACAREA(I)
  38  CONTINUE
       EMPTY(4)=EMPTYS
      IF(IBUG.LT.1) GO TO 214
      WRITE(IODBUG,2141) LH1,LQ1,LXE1,LXT1
 2141 FORMAT(/2X,'LH1=',I5,5X,'LQ1=',I5,5X,'LXE1=',I5,5X,
     & 'LXT1=',I5)
      DO 2143 M=1,NCROSS
       WRITE(IODBUG,2142) M,XRC(LXE1-1+M),ACAREA(M),CMANGN(M)
 2142 FORMAT(1H0,2X,2HI=,I3,2X,12HX-S ELEV(I)=,F10.2,2X,09HXAREA(I)=,
     1F10.2,2X,15HMANNING N (I) =,F10.5)
 2143 CONTINUE
  214  CONTINUE
      IF(IRCHNG.GE.1) GO TO 2145
C
      IMSNG=0
      IF(ICONV-1) 900,900,902
C  INITIALIZE Q VALUES
 900  DO 901 I=ITSPOS,LASPOS
  901 QDATA(I)=-999.
      GO TO 905
 902  DO 903 I=ITSPOS,LASPOS
 903  HDATA(I)=-999.
 905  CONTINUE
      IF(IBUG.GE.1) WRITE(IODBUG,7892) (QDATA(N),N=ITSPOS,LASPOS)
      IF(IBUG.GE.1) WRITE(IODBUG,7893) (HDATA(N),N=ITSPOS,LASPOS)
 7892 FORMAT(1H0,2X,13HQDATA VALUES:,/,2X,8F10.2)
 7893 FORMAT(1H0,2X,13HHDATA VALUES:,/,2X,8F10.2)
      ICARO4=IFIX(CARRYO(4))
       MISING=ICARO4
      IF (ICONV.EQ.1 .AND. IFMSNG(CARRYO(1)).EQ.0) MISING=0
      IF (ICONV.EQ.2 .AND. IFMSNG(CARRYO(2)).EQ.0) MISING=0
      T1(1)=-(MISING+1)*DT
       K=1
       DO 19 I=ITSPOS,LASPOS
      IF(ICONV-1) 13,13,14
 13    IF(IFMSNG(HDATA(I)).EQ.1) GO TO 18
      GO TO 15
  14  IF(IFMSNG(QDATA(I)).EQ.1) GO TO 18
 15    KK=K
       K=K+1
       LOCPTR(K)=I
       T1(K)=T1(KK)+DELTAT*(MISING+1)
       MISING=0
       GO TO 19
  18   MISING=MISING+1
       IMSNG=0
  19   CONTINUE
       NUMLOC=K
      IF(IMSNG.LE.0) GO TO 193
      IF(ICONV.EQ.1) WRITE(IPR,9003) TSID,RCID
9003  FORMAT(/10X,'*WARNING* LOOP RATING DOES NOT ALLOW MISSING DATA!',
     & /20X,'MISSING DATA ARE LINEARLY INTERPOLATED ',
     & 'BETWEEN NON-MISSING DATA FOR STAGE TO DISCHARGE CONVERSION.',
     & /20X,'STAGE TIME SERIES = ',2A4,5X,'RATING CURVE = ',2A4)
      IF(ICONV.EQ.2) WRITE(IPR,9004) TSID,RCID,ISEG,OLDSUB
9004  FORMAT(/10X,'*WARNING* LOOP RATING DOES NOT ALLOW MISSING DATA!',
     & /20X,'MISSING DATA ARE LINEARLY INTERPOLATED ',
     & 'BETWEEN NON-MISSING DATA FOR DISCHARGE TO STAGE CONVERSION.',
     & /20X,'DISCHARGE TIME SERIES = ',2A4,5X,'RATING CURVE = ',2A4)
      CALL WARN
  193 IF(NUMLOC.GT.1) GO TO 194
      IF(IBUG.GE.1) WRITE(IODBUG,1940) ITSPOS,LASPOS
 1940 FORMAT(1H0,2X,34HALL VALUES BETWEEN T.S. POSITIONS ,I2,
     105H AND ,I2,12H ARE MISSING)
      GO TO 212
 194  HP=CARRYO(1)+GZERO
      QP=CARRYO(2)
      DQ=CARRYO(3)
      IF(ICONV.EQ.2) DH=CARRYO(3)
C
C  SET COUNTER
      KT=2
C
      TT=-(ICARO4+1)*DT
      SLE=SLOPE
C  ***NO CARRYOVER***INITIALIZE HP,QP, AND DH VALUES
      ILOC=LOCPTR(KT)
      ILOC1=LOCPTR(KT+1)
      IF(ICONV-1) 60,60,70
C  COMPUTE INITIAL DISCHARGE
   60 IF(IFMSNG(CARRYO(1)).EQ.1) GO TO 65
      DH1=ABS(HDATA(ILOC)-CARRYO(1))/(ILOC+CARRYO(4))
      IF(DH1.LT.0.01) GO TO 110
      DH2=2.*ABS(HDATA(ILOC1)-HDATA(ILOC))/(ILOC1-ILOC)
      IF(DH1.LE.DH2) GO TO 110
C  ***BAD CARRYOVER***INITIALIZE HP,QP, AND DQ VALUES
   65 HP=HDATA(ILOC)+GZERO
C
C      USE LINEAR/LOG-LOG INTERPOLATION/EXTRATION TO GET DISCHARGE
        HPSTG=HP-GZERO
        CALL FHQS1(HPSTG,QP,ICONV,IBUG,NEEDEX,LOWEXT,IUPEXT,
     &  NW,NRANGE,MISING,CARRYO)
      DQ=0.0
      GO TO 100
C  COMPUTE INITIAL STAGE
   70 IF(IFMSNG(CARRYO(2)).EQ.1) GO TO 75
      DQ1=ABS(QDATA(ILOC)-CARRYO(2))/(ILOC+CARRYO(4))
      IF(DQ1.LT.0.01) GO TO 110
      DQ2=2.*ABS(QDATA(ILOC1)-QDATA(ILOC))/(ILOC1-ILOC)
      IF(DQ1.LE.DQ2) GO TO 110
C  ***BAD CARRYOVER***INITIALIZE HP,QP, AND DQ VALUES
   75 QP=QDATA(ILOC)
C
C      USE LINEAR/LOG-LOG INTERPOLATION/EXTRATION TO GET STAGE
        CALL FHQS1(HPSTG,QP,ICONV,IBUG,NEEDEX,LOWEXT,IUPEXT,
     &  NW,NRANGE,MISING,CARRYO)
      HP=HPSTG+GZERO
      DH=0.0
  100 QF=QP
      HF=HP
      TT=T1(KT)
C  INITIAL STAGE/FLOW NOW DET IN ABSENCE OF CARRYOVER.  JUMP TO 160
      GO TO 160
  110 TT=TT+DT
C
C  CHECK TO SEE IF LAST APPLICABLE DAY HAS BEEN EXCEEDED (CALIB PGM)
      IF(MAINUM.LT.3) GO TO 2145
      IF(LASDAY.EQ.0) GO TO 2145
      ITIME=IIHR+DELTAT
      IF(ITIME/24) 2145,2145,2144
 2144 ICURDA=ICURDA+1
      IIHR=IIHR-24
      IF(ICURDA.LE.LASDAY) GO TO 2145
      IRCHNG=1
      IF(IBUG.GE.1) WRITE(IODBUG,1004) ICURDA,LASDAY
 1004 FORMAT(1H0,2X,40H/FRATNG/ COMMON BLOCK TRANSFER NECESSARY,/2X,
     113HCURRENT DAY: ,I10,5X,24HLAST APPLIC. DAY OF RC: ,I10)
      IERR=0
      CALL FGETRC(RCID,IERR)
C
C  IF NO ERROR ENCOUNTERED BY FGETRC, MUST GO BACK AND RECOMPUTE
C  MANNING'S N'S BASED ON NEW RATING CURVE DATA
C
      IF(IERR.EQ.0) GO TO 36
      WRITE(IPR,1005) ICURDA,I
 1005 FORMAT(1H0,10X,57H********* ERROR ENCOUNTERED BY FGETRC PREVENTS S
     1UCCESSFUL,/20X,36HEXECUTION OF FSTGQ. CURRENT DATE IS ,I10,18H T.
     1S. POSITION = ,I4)
      JEROR=1
      GO TO 999
C
 2145 CONTINUE
C  INTERPOLATE AT TIME TT FROM SPECIFIED HYDROGRAPH
      DO 120 K=2,NUMLOC
      KEEP=K
      IF (TT.LE.T1(K)) GO TO 130
  120 CONTINUE
      IF(TT.EQ.T1(NUMLOC)) GO TO 130
      GO TO 210
  130 K=KEEP
       KT=K
      KK=K-1
      DTHU=T1(K)-T1(KK)
      LOCK=LOCPTR(K)
      LOCKK=LOCPTR(KK)
       IF(IBUG.GE.1) WRITE(IODBUG,7983) K,KK,DTHU,LOCK,LOCKK,TT,T1(KK),
     1T1(K)
 7983  FORMAT(01H0,2X,02HK=,I3,2X,03HKK=,I3,07H  DTHU=,F5.0,07H  LOCK=,
     1I4,08H  LOCKK=,I4,/2X,03HTT=,G15.7,09H  T1(KK)=,G15.7,09H   T1(K)=
     .,G15.7)
       IF(IBUG.GE.1) WRITE(IODBUG,7985) HDATA(LOCK),QDATA(LOCK)
 7985 FORMAT(1H0,2X,13H HDATA(LOCK)=,F10.2,
     114H QDATA(LOCK)= ,F10.2)
      IF(ICONV-1) 140,140,150
C
C  CONVERT FROM STAGE TO DISCHARGE
C
 140  EL1=CARRYO(1)+GZERO
      IF(KK.GT.1) EL1=HDATA(LOCKK)+GZERO
      EL2=HDATA(LOCK)+GZERO
      HF=EL1+(TT-T1(KK))/DTHU*(EL2-EL1)
      IF(HF.LE.HMIN) THEN
C
C      WATER ELEV FALL BELOW 1ST ELEV OF CROSS SECTION
C      USE LINEAR/LOG-LOG INTERPOLATION/EXTRATION
        NCRSAV=NCROSS
        NCROSS=0
        HFSTG=HF-GZERO
        CALL FHQS1(HFSTG,QF,ICONV,IBUG,NEEDEX,LOWEXT,IUPEXT,
     &  NW,NRANGE,MISING,CARRYO)
        NCROSS=NCRSAV
        GO TO 160
      END IF
      IF(HF.GT.TOPSTG) THEN
        IF(NEEDEX.EQ.0) NEEDEX=6
        IF(NEEDEX.EQ.1) NEEDEX=7
        IF(NEEDEX.EQ.4) NEEDEX=8
      END IF
C  CHECK SIGN OF DQ FOR N-R ITER
      SNHQ=(HF-HP)*DQ
      IF(SNHQ.LT.0.) DQ=-DQ
      CALL FQSOLV (HF,HP,QP,EPQ,SLE,CONR,DTS,DQ,G,QF,IBUG)
       IF(IBUG.GE.1) WRITE(IODBUG,7984) HP,HF,QP,QF,DQ
 7984 FORMAT(01H0,2X,'HP=',F10.2,05H  HF=,F10.2,05H  QP=,F10.2,
     1    05H  QF=,F10.2,05H  DQ=,F10.2)
      GO TO 160
C
C  CONVERT FROM DISCHARGE TO STAGE
C
 150  QQ1=CARRYO(2)
      IF(KK.GT.1) QQ1=QDATA(LOCKK)
      QF=QQ1+(TT-T1(KK))/DTHU*(QDATA(LOCK)-QQ1)
      IF(QF.LE.QMIN) THEN
C
C      WATER ELEV FALL BELOW 1ST ELEV OF CROSS SECTION
C      USE LINEAR/LOG-LOG INTERPOLATION/EXTRATION
        NCRSAV=NCROSS
        NCROSS=0
        CALL FHQS1(HFSTG,QF,ICONV,IBUG,NEEDEX,LOWEXT,IUPEXT,
     &  NW,NRANGE,MISING,CARRYO)
      HF=HFSTG+GZERO
        NCROSS=NCRSAV
        GO TO 160
      END IF
      IF(QF.GT.TOPQ) THEN
        IF(NEEDEX.EQ.0) NEEDEX=6
        IF(NEEDEX.EQ.1) NEEDEX=7
        IF(NEEDEX.EQ.4) NEEDEX=8
      END IF
C  CHECK SIGN OF DH FOR N-R ITER
      SNHQ=(QF-QP)*DH
      IF(SNHQ.LT.0.) DH=-DH
      CALL FHSOLV (QF,QP,HP,EPH,SLE,CONR,DTS,DH,G,HF,IBUG)
       IF(IBUG.GE.1) WRITE(IODBUG,7986) QQ1,QF,HP,HF,DH
 7986 FORMAT(01H0,2X,'QQ1=',F10.2,05H  QF=,F10.2,05H  HP=,F10.2,
     1    05H  HF=,F10.2,05H  DH=,F10.2)
  160 DQ=QF-QP
      DH=HF-HP
C
       IF(IBUG.GE.1) WRITE(IODBUG,7987) KT,TT,T1(KT)
 7987  FORMAT(2X,4HKT= ,I3,2X,4HTT= ,G15.7,8H T1(KT)=,G15.7)
C  CHECK TO SEE DATA VALUES ARE TO BE STORED
       IF(ABS(TT-T1(KT)).LT.0.1) GO TO 190
      IF(TT-T1(KT)) 200,190,190
  190 KT=KT+1
      KM=KT-1
      LOC=LOCPTR(KM)
      HDATA(LOC)=HF-GZERO
      QDATA(LOC)=QF
       IF(IBUG.GE.1) WRITE(IODBUG,7988) KT,KM,LOC,HDATA(LOC),QDATA(LOC)
 7988  FORMAT(2X,4HKT= ,I3,6H  KM= ,I3,7H  LOC= ,I4,13H  HDATA(LOC)=,
     1F10.2,13H  QDATA(LOC)=,F10.2)
      CARRYO(1)=HF-GZERO
      CARRYO(2)=QF
      CARRYO(3)=DQ
      IF(ICONV.EQ.2) CARRYO(3)=DH
      CARRYO(4)=0.
  200 QP=QF
      HP=HF
      GO TO 110
  210 CONTINUE
      IF(LOCPTR(NUMLOC).NE.LASPOS) CARRYO(4)=LASPOS-LOCPTR(NUMLOC)+.01
      IF(IBUG.GE.1) WRITE(IODBUG,7895) (QDATA(N),N=ITSPOS,LASPOS)
      IF(IBUG.GE.1) WRITE(IODBUG,7896) (HDATA(N),N=ITSPOS,LASPOS)
 7895 FORMAT(1H0,2X,23HCONVERTED QDATA VALUES:,/,2X,8F10.2)
 7896 FORMAT(1H0,2X,23HCONVERTED HDATA VALUES:,/,2X,8F10.2)
  212 IF(NUMLOC.LT.2) CARRYO(4)=CARRYO(4)+NVALS+0.01
 999  CONTINUE
      IF (ITRACE.GE.2) WRITE(IODBUG,609)
  609 FORMAT(1H ,21H *** EXIT  FLOOPR ***)
      OPNAME(1) = OLDSUB(1)
      OPNAME(2) = OLDSUB(2)
      IOPNUM = IOLDOP
C
      RETURN
      END

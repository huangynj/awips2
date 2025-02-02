C MODULE COX21
C-----------------------------------------------------------------------
C
C ROUTINE TO DO CARRYOVER TRANSFER FOR THE DYNAMIC WAVE OPERATION.
C
      SUBROUTINE COX21(POLD,IPOLD,COLD,PONEW,IPONEW,CONEW)
C
C      THIS SUBROUTINE WAS WRITTEN BY:
C      JANICE LEWIS      HRL   NOVEMBER,1982      VERSION NO. 1
C
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
C
      DIMENSION POLD(*),IPOLD(*),COLD(*),PONEW(*),IPONEW(*),CONEW(*)
      CHARACTER*8  SNAME
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_cox/RCS/cox21.f,v $
     . $',                                                             '
     .$Id: cox21.f,v 1.4 2002/02/11 13:53:44 michaelo Exp $
     . $' /
C    ===================================================================
C
C
      DATA  SNAME / 'COX21   ' /
C
C
      CALL FPRBUG(SNAME,1,21,IBUG)
C
      IWARN=0
C
      IF(IBUG.EQ.0) GO TO 20
      ISIZEO=POLD(117)
      ISIZEN=PONEW(117)
CC      WRITE(6,9999) ISIZEO,ISIZEN,POLD(117),IPOLD(117)
CC 9999 FORMAT(2X,7HISIZEO=,I4,2X,7HISIZEN=,I4,2X,5HPOLD=,F5.0,2X,
CC     1 6HIPOLD=,I10)
      WRITE(IODBUG,2)
    2 FORMAT(1H0,10X,47H**********  CONTENTS OF THE OLD PARAMETER ARRAY)
      CALL ARRY21(POLD,POLD,ISIZEO)
      WRITE(IODBUG,4)
    4 FORMAT(1H0,10X,47H**********  CONTENTS OF THE NEW PARAMETER ARRAY)
      CALL ARRY21(PONEW,PONEW,ISIZEN)
C
C        CHECK TO SEE IF MAXIMUM NO. OF SECTIONS IS THE SAME
C
   20 JNO=0
      IF(POLD(25).EQ.PONEW(25)) GO TO 25
      JNO=1
      WRITE(IPR,8020)
 8020 FORMAT(1H0,10X,63H**WARNING** THE NBMAX PARAMETER ON CARD NO. 1 HA
     *S BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF STILL IN SIMULATION MODE
C
   25 IF(POLD(33).EQ.PONEW(33)) GO TO 30
      WRITE(IPR,8025)
 8025 FORMAT(1H0,10X,60H**WARNING** THE NP PARAMETER ON CARD NO. 5 HAS B
     *EEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF BOTTOM SLOPE IS THE SAME
C
   30 IF(ABS(POLD(38)-PONEW(38)).LE.0.000001) GO TO 40
      WRITE(IPR,8030)
 8030 FORMAT(1H0,10X,60H**WARNING** THE SO PARAMETER ON CARD NO. 9 HAS B
     *EEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        FIND STARTING LOCATIONS OF OLD AND NEW PARAMETERS
C
   40 IF(JNO.EQ.1) GO TO 600
      JN=PONEW(25)
      IY=0
      IQ=POLD(5)
      LONB=POLD(56)-1
      LNNB=PONEW(56)-1
      LONQL=POLD(60)-1
      LNNQL=PONEW(60)-1
      LONDV=POLD(109)-1
      LNNDV=PONEW(109)-1
      LONLD=POLD(63)-1
      LNNLD=PONEW(63)-1
      LOLAD=POLD(73)-1
      LNLAD=PONEW(73)-1
      LONYQ=POLD(59)-1
      LNNYQ=PONEW(59)-1
      LONM1=POLD(61)-1
      LNNM1=PONEW(61)-1
      LONCM=POLD(74)-1
      LNNCM=PONEW(74)-1
      LOYCM=POLD(97)-1
      LNYCM=PONEW(97)-1
      LOCM =POLD(89)-1
      LNCM =PONEW(89)-1
      LOX  =POLD(84)-1
      LNX  =PONEW(84)-1
      LOFKC=POLD(71)-1
      LNFKC=PONEW(71)-1
      LOBS =POLD(87)-1
      LNBS =PONEW(87)-1
      LOHS =POLD(90)-1
      LNHS =PONEW(90)-1
      LOAS =POLD(85)-1
      LNAS =PONEW(85)-1
      LONS1=POLD(57)-1
      LNNS1=PONEW(57)-1
      LONSS=POLD(75)-1
      LNNSS=PONEW(75)-1
      LOBSS=POLD(88)-1
      LNBSS=PONEW(88)-1
      LOHSS=POLD(91)-1
      LNHSS=PONEW(91)-1
      LOASS=POLD(86)-1
      LNASS=PONEW(86)-1
      LOLQ =POLD(93)-1
      LNLQ =PONEW(93)-1
      LODIV=POLD(111)
      LNDIV=PONEW(111)
      LOLDV=POLD(110)-1
      LNLDV=PONEW(110)-1
      LOGZ1=POLD(49)-1
      LNGZ1=PONEW(49)-1
C
C         PRINT THE STARTING LOCATIONS OF OLD AND NEW PARAMETERS
C
      IF(IBUG.EQ.0) GO TO 84
      WRITE(IODBUG,81)
   81 FORMAT(1H0,10X,105H   JN  LNB LNJN LATF LCFW LVWD LWGL  LKU  LKD L
     1NQL LNDV LNLD LLAD LPTR LNYQ LNM1 LNCM LYCM  LCM   LX LFKC)
      WRITE(IODBUG,82) JN,LONB,LONJN,LOATF,LOCFW,LOVWD,LOWGL,LOKU,LOKD,
     1 LONQL,LONDV,LONLD,LOLAD,LOPTR,LONYQ,LONM1,LONCM,LOYCM,LOCM,LOX,
     2 LOFKC
   82 FORMAT(1H ,10X,23I5)
      WRITE(IODBUG,82) JN,LNNB,LNNJN,LNATF,LNCFW,LNVWD,LNWGL,LNKU,LNKD,
     1 LNNQL,LNNDV,LNNLD,LNLAD,LNPTR,LNNYQ,LNNM1,LNNCM,LNYCM,LNCM,LNX,
     2 LNFKC
      WRITE(IODBUG,83)
   83 FORMAT(1H0,10X,115H  LBS  LHS  LAS LNS1 LNSS LBSS LHSS LASS  LQL L
     1QLT  LLQ LDIV LLDV LDVT LPLT LDPT LGAT LDGT LST1 LDS1 LGZ1 LSTM LR
     2AT)
      WRITE(IODBUG,82) LOBS,LOHS,LOAS,LONS1,LONSS,LOBSS,LOHSS,LOASS,LOQL
     1,LOQLT,LOLQ,LODIV,LOLDV,LODVT,LOPLT,LODPT,LOGAT,LODGT,LOST1,
     2 LODS1,LOGZ1,LOSTM,LORAT
      WRITE(IODBUG,82) LNBS,LNHS,LNAS,LNNS1,LNNSS,LNBSS,LNHSS,LNASS,LNQL
     1,LNQLT,LNLQ,LNDIV,LNLDV,LNDVT,LNPLT,LNDPT,LNGAT,LNDGT,LNST1,
     2 LNDS1,LNGZ1,LNSTM,LNRAT
C
   84 DO 550 J=1,JN
C
C        CHECK TO SEE IF NO. OF SECTIONS ON EACH RIVER ARE THE SAME
C
      NB0=0
      IF(IPOLD(LONB+J).EQ.IPONEW(LNNB+J)) GO TO 85
      WRITE(IPR,8080) J
 8080 FORMAT(1H0,10X,15H**WARNING** NB(,I2,33H) ON CARD NO. 6 HAS BEEN C
     *HANGED.)
      CALL WARN
      IWARN=IWARN+1
      NB0=1
C
C        CHECK TO SEE IF NO. OF LATRAL FLOWS ARE THE SAME ON EACH RIVER
C
   85 NQL=IPOLD(LONQL+J)
      IF(IPOLD(LONQL+J).EQ.IPONEW(LNNQL+J)) GO TO 90
      WRITE(IPR,8085) J
 8085 FORMAT(1H0,10X,16H**WARNING** NQL(,I2,34H) ON CARD NO. 12 HAS BEEN
     * CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      GO TO 100
C
C        CHECK TO SEE IF LATERAL FLOWS ARE LOCATED IN SAME PLACE ON RIVE
C
   90 IF(NQL.EQ.0) GO TO 102
      DO 95 I=1,NQL
      IF(IPOLD(LOLQ+I).EQ.IPONEW(LNLQ+I)) GO TO 95
      WRITE(IPR,8090) I,J
 8090 FORMAT(1H0,10X,15H**WARNING** LQ(,I2,1H,,I2,34H) ON CARD NO. 38 HA
     *S BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
   95 CONTINUE
C
  100 LOLQ=LOLQ+NQL
      LNLQ=LNLQ+NQL
C
C        CHECK TO SEE IF NO. OF FLOW DIVERSIONS ARE SAME ON EACH RIVER
C
  102 NDV=POLD(LONDV+J)
      IF(IPOLD(LONDV+J).EQ.IPONEW(LNNDV+J)) GO TO 105
      WRITE(IPR,8102) J
 8102 FORMAT(1H0,10X,17H**WARNING** NDIV(,I2,34H) ON CARD NO. 13 HAS BEE
     *N CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      GO TO 115
C
C        CHECK TO SEE IF FLOW DIVERSIONS ARE LOCATED IN SAME PLACE ON
C        RIVER
C
  105 IF(NDV.EQ.0) GO TO 120
      DO 110 I=1,NDV
      IF(IPOLD(LOLDV+I).EQ.IPONEW(LNLDV+I)) GO TO 110
      WRITE(IPR,8105) I,J
 8105 FORMAT(1H0,10X,17H**WARNING** LDIV(,I2,34H) ON CARD NO. 37 HAS BEE
     *N CHANGED.)
      CALL WARN
      IWARN=IWARN+1
  110 CONTINUE
C
  115 LOLDV=LOLDV+NDV
      LNLDV=LNLDV+NDV
C
C        CHECK TO SEE IF NO. OF LOCKS & DAMS ARE THE SAME ON EACH RIVER
C
  120 IF(IPOLD(LONLD+J).EQ.IPONEW(LNNLD+J)) GO TO 130
      WRITE(IPR,8120) J
 8120 FORMAT(1H0,10X,19H**WARNING** NUMLAD(,I2,34H) ON CARD NO. 18 HAS B
     *EEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      GO TO 140
C
C        CHECK TO SEE IF LOCKS & DAMS ARE LOCATED IN SAME PLACE ON RIVER
C
  130 NUM=IPOLD(LONLD+J)
      IF(NUM.EQ.0) GO TO 150
      DO 135 K=1,NUM
      IF(IPOLD(LOLAD+K).EQ.IPONEW(LNLAD+K)) GO TO 135
      WRITE(IPR,8130) K,J
 8130 FORMAT(1H0,10X,16H**WARNING** LAD(,I2,1H,,I2,34H) ON CARD NO. 19 H
     *AS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
  135 CONTINUE
C
  140 LOLAD=LOLAD+NUM
      LNLAD=LNLAD+NUM
C
C        CHECK TO SEE IF NO. OF MANNING'S N REACHES ARE SAME ON EACH
C        RIVER
C
  150 NCMO=0
      NCMLO=POLD(29)
      NCMLN=PONEW(29)
      IF(IPOLD(LONM1+J).EQ.IPONEW(LNNM1+J)) GO TO 160
      WRITE(IPR,8150) J
 8150 FORMAT(1H0,10X,18H**WARNING** NRCM1(,I2,34H) ON CARD NO. 21 HAS BE
     *EN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      NCMO=1
C
C        CHECK TO SEE IF MANNING'S N IS A FUNCTION OF SAME PARAMETER
C
  160 NYQO=0
      IF(IPOLD(LONYQ+J).EQ.IPONEW(LNNYQ+J)) GO TO 170
      WRITE(IPR,8160) J
 8160 FORMAT(1H0,10X,17H**WARNING** NNYQ(,I2,34H) ON CARD NO. 20 HAS BEE
     *N CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      NYQO=1
C
  170 IF(NB0.EQ.1) GO TO 550
      N=IPOLD(LONB+J)
      IF(NYQO.EQ.1) GO TO 275
      IF(NCMO.EQ.1) GO TO 275
      NRCM=IPOLD(LONM1+J)
      NNYQ=IPOLD(LONYQ+J)
C
C        CHECK TO SEE IF MANNING'S N REACH VALUES ARE SAME ON EACH RIVER
C
      IST=1
      IF(NRCM.EQ.0) GO TO 275
      DO 270 LL=1,NRCM
      IF(IPOLD(LONCM+LL).EQ.IPONEW(LNNCM+LL)) GO TO 180
      WRITE(IPR,8170) LL,J
 8170 FORMAT(1H0,10X,16H**WARNING** NCM(,I2,1H,,I2,34H) ON CARD NO. 22 H
     *AS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      GO TO 260
C
C                  CHECK TO SEE IF MANNING'S N TABLE IS THE SAME
C
C        FIND THE MAXIMUM INITIAL ELEVATION OR DISCHARGE (YQ) IN THE
C        MANNING'S N REACH
C
  180 YQMAXO=COLD(IST+IY)
      IF(NNYQ.EQ.1) YQMAXO=COLD(IST+IQ)
      YQMAXN=CONEW(IST+IY)
      IF(NNYQ.EQ.1) YQMAXN=CONEW(IST+IQ)
C
      IEND=IPOLD(LL+LONCM)
      DO 190 I=IST,IEND
      IF(NNYQ.EQ.1) GO TO 185
      IF(COLD(I+IY).GT.YQMAXO) YQMAXO=COLD(I+IY)
      IF(CONEW(I+IY).GT.YQMAXN) YQMAXN=COLD(I+IY)
      GO TO 190
  185 IF(COLD(I+IQ).GT.YQMAXO) YQMAXO=COLD(I+IQ)
      IF(CONEW(I+IQ).GT.YQMAXN) YQMAXN=COLD(I+IQ)
  190 CONTINUE
C
C        FIND THE MAXIMUM TABLE VALUE OF YQ IN THE OLD PARAMETER ARRAY
C
      DO 195 K=1,NCMLO
      KO=K
      IF(YQMAXO.LT.POLD(K+LOYCM)) GO TO 200
  195 CONTINUE
C
C        FIND THE MAXIMUM TABLE VALUE OF YQ IN THE NEW PARAMETER ARRAY
C
  200 DO 225 K=1,NCMLN
      KN=K
      IF(YQMAXN.LT.PONEW(K+LNYCM)) GO TO 230
  225 CONTINUE
C
C        CHECK TO SEE IF SAME NO. OF POINTS IN BOTH TABLES
C
  230 IF(KO.EQ.KN) GO TO 235
      IF(NCMLO.EQ.NCMLN.AND.KN.GT.KO) KO=KN
      IF(NCMLO.EQ.NCMLN) GO TO 235
      WRITE(IPR,8230)
 8230 FORMAT(1H0,10X,62H**WARNING** THE NCML PARAMETER ON CARD NO. 4 HAS
     * BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      GO TO 260
C
C        CHECK TO SEE IF YQ VALUES ARE THE SAME IN BOTH TABLES
C
  235 DO 250 L=1,KO
      IF(ABS(POLD(L+LOYCM)-PONEW(L+LNYCM)).LE.0.00001) GO TO 240
      WRITE(IPR,8235) L,I,J
 8235 FORMAT(1H0,10X,17H**WARNING** YQCM(,I2,1H,,I2,1H,,I2,34H) ON CARD
     *NO. 22 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF MANNING'S N VALUES ARE THE SAME IN BOTH TABLES
C
  240 IF(ABS(POLD(LOCM+L)-PONEW(LNCM+L)).LE.0.0001) GO TO 250
      WRITE(IPR,8240) L,I,J
 8240 FORMAT(1H0,10X,15H**WARNING** CM(,I2,1H,,I2,1H,,I2,34H) ON CARD NO
     *. 23 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
  250 CONTINUE
C
  260 LOYCM=LOYCM+NCMLO
      LNYCM=LNYCM+NCMLN
      LOCM =LOCM +NCMLO
      LNCM =LNCM +NCMLN
      IST=IEND+1
  270 CONTINUE
C
  275 LONCM=LONCM+NRCM
      LNNCM=LNNCM+NRCM
C
      NCSO=POLD(30)
      NCSN=PONEW(30)
      NCSSO=POLD(31)
      NCSSN=PONEW(31)
      NCSJO=IPOLD(LONS1+J)
      NCSJN=IPONEW(LNNS1+J)
C
      DO 500 I=1,N
      YO=COLD(IY+I)
      QO=COLD(IQ+I)
C
C        CHECK TO SEE IF RIVER MILES ARE SAME ON EACH RIVER
C
      IF(ABS(POLD(LOX+I)-PONEW(LNX+I)).LE.0.0001) GO TO 280
      WRITE(IPR,8275) I,J
 8275 FORMAT(1H0,10X,14H**WARNING** X(,I2,1H,,I2,34H) ON CARD NO. 25 HAS
     * BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF EXPANSION-CONTRACTION COEFFICIENTS ARE SAME ON
C        EACH RIVER
C
  280 IF(ABS(POLD(LOFKC+I)-PONEW(LNFKC+I)).LE.0.0001) GO TO 290
      WRITE(IPR,8280) I,J
 8280 FORMAT(1H0,10X,16H**WARNING** FKC(,I2,1H,,I2,34H) ON CARD NO. 26 H
     *AS BEEN CHANGED.)
       CALL WARN
       IWARN=IWARN+1
C
C        CHECK TO SEE IF TABLES OF TOP WIDTH VS ELEVATION ARE THE SAME
C        FOR EACH CROSS SECTION
C
C        FIND THE MAXIMUM TABLE VALUE OF HS IN THE OLD PARAMETER ARRAY
C
  290 DO 295 K=1,NCSO
      KO=K
      IF(YO.LT.POLD(K+LOHS)) GO TO 300
  295 CONTINUE
C
C        FIND THE MAXIMUM TABLE VALUE OF HS IN THE NEW PARAMETER ARRAY
C
  300 DO 305 K=1,NCSN
      KN=K
      IF(YO.LT.PONEW(K+LNHS)) GO TO 310
  305 CONTINUE
C
C        CHECK TO SEE IF SAME NO. OF POINTS IN BOTH TABLES
C
  310 IF(KO.EQ.KN) GO TO 320
      IF(NCSO.EQ.NCSN.AND.KN.GT.KO) KO=KN
      IF(NCSO.EQ.NCSN) GO TO 320
      WRITE(IPR,8310)
 8310 FORMAT(1H0,10X,62H**WARNING** THE NCS PARAMETER ON CARD NO. 5 HAS
     * BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
      GO TO 365
C
C        CHECK TO SEE IF TOP WIDTHS ARE THE SAME IN BOTH TABLES
C
  320 DO 350 L=1,KO
      IF(ABS(POLD(LOBS+L)-PONEW(LNBS+L)).LE.0.0001) GO TO 330
      WRITE(IPR,8320) L,I,J
 8320 FORMAT(1H0,10X,15H**WARNING** BS(,I2,1H,,I2,1H,,I2,34H) ON CARD NO
     *. 26 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF ELEVATIONS ARE THE SAME IN BOTH TABLES
C
  330 IF(ABS(POLD(LOHS+L)-PONEW(LNHS+L)).LE.0.0001) GO TO 340
      WRITE(IPR,8330) L,I,J
 8330 FORMAT(1H0,10X,15H**WARNING** HS(,I2,1H,,I2,1H,,I2,34H) ON CARD NO
     *. 27 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF ACTIVE AREAS ARE THE SAME IN BOTH TABLES
C
  340 IF(ABS(POLD(LOAS+L)-PONEW(LNAS+L)).LE.0.0001) GO TO 350
      WRITE(IPR,8340) L,I,J
 8340 FORMAT(1H0,10X,15H**WARNING** AS(,I2,1H,,I2,1H,,I2,34H) ON CARD NO
     *. 28 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
  350 CONTINUE
C
      LOHS=LOHS+NCSO
      LNHS=LNHS+NCSN
      LOBS=LOBS+NCSO
      LNBS=LNBS+NCSN
      LOAS=LOAS+NCSO
      LNAS=LNAS+NCSN
C
C        CHECK TO SEE IF OLD SECTION HAS OFF-CHANNEL STORAGE (OCS)
C        AT THE INITIAL ELEVATION
C
      ISSO=0
      IF(NCSJO.EQ.0) GO TO 365
      ICKVAL=999999
      IF (NCSJO.GT.ICKVAL) THEN
         WRITE (IPR,364) 'NCSJO',NCSJO,ICKVAL
364   FORMAT ('0**WARNING** IN COX21 - VALUE OF VARIABLE ',A,' (',I10,
     *   ') IS GREATER THAN ',I6,'.')
         CALL WARN
         IWARN=IWARN+1
         GO TO 365
         ENDIF
      DO 355 II=1,NCSJO
      IF(I.EQ.IPOLD(LONSS+II)) GO TO 360
  355 CONTINUE
      GO TO 365
  360 IF(YO.GT.POLD(LOHSS+1)) ISSO=1
C
C        CHECK TO SEE IF NEW SECTION HAS OFF-CHANNEL STORAGE (OCS)
C        AT THE INITIAL ELEVATION
C
  365 ISSN=0
      IF(NCSJN.EQ.0) GO TO 380
      ICKVAL=999999
      IF (NCSJN.GT.ICKVAL) THEN
         WRITE (IPR,364) 'NCSJN',NCSJN,ICKVAL
         CALL WARN
         IWARN=IWARN+1
         GO TO 380
         ENDIF
      DO 370 II=1,NCSJN
      IF(I.EQ.IPONEW(LNNSS+II)) GO TO 375
  370 CONTINUE
      GO TO 380
  375 IF(YO.GT.PONEW(LNHSS+1)) ISSN=1
C
C        CHECK TO SEE IF OCS HAS BEEN ADDED TO OMITTED FROM THE SECTION
C
  380 IF(ISSO.EQ.0.AND.ISSN.EQ.0) GO TO 500
      IF(ISSO.EQ.1.AND.ISSN.EQ.1) GO TO 390
      IF(ISSO.EQ.0) WRITE(IPR,8380) I,J
 8380 FORMAT(1H0,10X,67H**WARNING** OFF CHANNEL STORAGE HAS BEEN ADDED T
     *O CROSS SECTION NO.,I3,14H ON RIVER NO. ,I2,1H.)
      IF(ISSN.EQ.0) WRITE(IPR,8385) I,J
 8385 FORMAT(1H0,10X,71H**WARNING** OFF CHANNEL STORAGE HAS BEEN OMITTED
     * FROM CROSS SECTION NO.,I3,14H ON RIVER NO. ,I2,1H.)
      CALL WARN
      IWARN=IWARN+1
      GO TO 460
C
C        CHECK TO SEE IF THE TABLES OF INACTIVE TOPWIDTH VS ELEVATION
C        ARE THE SAME FOR EACH CROSS SECTION WITH OCS
C
C        FIND THE MAXIMUM TABLE VALUE OF HSS IN THE OLD PARAMETER ARRAY
C
  390 DO 395 K=1,NCSSO
      KO=K
      IF(YO.LT.POLD(K+LOHSS)) GO TO 400
  395 CONTINUE
C
C        FIND THE MAXIMUM TABLE VALUE OF HSS IN THE NEW PARAMETER ARRAY
C
  400 DO 405 K=1,NCSSN
      KN=K
      IF(YO.LT.PONEW(K+LNHSS)) GO TO 410
  405 CONTINUE
C
C        CHECK TO SEE IF SAME NO. OF POINTS IN BOTH TABLES
C
  410 IF(KO.EQ.KN) GO TO 420
      IF(NCSSO.EQ.NCSSN.AND.KN.GT.KO) KO=KN
      IF(NCSSO.EQ.NCSSN) GO TO 420
      WRITE(IPR,8410)
 8410 FORMAT(1H0,10X,62H**WARNING** THE NCSS PARAMETER ON CARD NO. 5 HAS
     * BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF INACTIVE TOP WIDTHS ARE SAME IN BOTH TABLES
C
  420 DO 450 L=1,KO
      IF(ABS(POLD(LOBSS+L)-PONEW(LNBSS+L)).LE.0.0001) GO TO 430
      WRITE(IPR,8420) L,I,J
 8420 FORMAT(1H0,10X,16H**WARNING** BSS(,I2,1H,,I2,1H,,I2,34H) ON CARD N
     *O. 32 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF ELEVATIONS ARE SAME IN BOTH TABLES
C
  430 IF(ABS(POLD(LOHSS+L)-PONEW(LNHSS+L)).LE.0.0001) GO TO 440
      WRITE(IPR,8430) L,I,J
 8430 FORMAT(1H0,10X,16H**WARNING** HSS(,I2,1H,,I2,1H,,I2,34H) ON CARD N
     *O. 33 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
C
C        CHECK TO SEE IF INACTIVE AREAS ARE SAME IN BOTH TABLES
C
  440 IF(ABS(POLD(LOASS+L)-PONEW(LNASS+L)).LE.0.0001) GO TO 450
      WRITE(IPR,8440) L,I,J
 8440 FORMAT(1H0,10X,16H**WARNING** ASS(,I2,1H,,I2,1H,,I2,34H) ON CARD N
     *O. 34 HAS BEEN CHANGED.)
      CALL WARN
      IWARN=IWARN+1
  450 CONTINUE
C
  460 LOBSS=LOBSS+NCSSO
      LNBSS=LNBSS+NCSSN
      LOHSS=LOHSS+NCSSO
      LNHSS=LNHSS+NCSSN
      LOASS=LOASS+NCSSO
      LNASS=LNASS+NCSSN
C
  500 CONTINUE
      LOX=LOX+N
      LNX=LNX+N
      LOFKC=LOFKC+N
      LNFKC=LNFKC+N
      LONSS=LONSS+NCSJO
      LNNSS=LNNSS+NCSJN
      IY=IY+N
      IQ=IQ+N
  550 CONTINUE
C
  600 NUMC=POLD(126)
C
      IF(IWARN.GT.0) GO TO 700
C
C        TRANSFER THE OLD CARRYOVER VALUES INTO THE NEW CARRYOVER VALUES
C
      DO 610 I=1,NUMC
      CONEW(I)=COLD(I)
  610 CONTINUE
      GO TO 800
C
  700 WRITE(IPR,750)
  750 FORMAT(1H0,10X,91H**WARNING** CARRYOVER CANNOT BE TRANSFERRED IN T
     1HIS OPERATION BECAUSE OF PREVIOUS WARNINGS.)
      CALL WARN
C
  800 IF(IBUG.EQ.0) GO TO 900
      WRITE(IODBUG,8900)
 8900 FORMAT(1H0,10X,35HCONTENTS OF THE OLD CARRYOVER ARRAY)
      CALL ARRY21(COLD,COLD,NUMC)
      NUMC=PONEW(126)
      WRITE(IODBUG,8910)
 8910 FORMAT(//1H0,10X,35HCONTENTS OF THE NEW CARRYOVER ARRAY)
      CALL ARRY21(CONEW,CONEW,NUMC)
C
  900 IF(ITRACE.EQ.1) WRITE(IODBUG,9000) SNAME
 9000 FORMAT(1H0,'** ',A8,' EXITED.')
      RETURN
      END

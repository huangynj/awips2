C MODULE EDEX02
C
C         THIS IS THE EXECUTION SUBROUTINE FOR THE
C         FREQUENCY TABLE DISPLAY.
C
C   THIS SUBROUTINE WAS ORIGINALLY WRITTEN BY JIM SMITH (ICPRB).
C
C
C
      SUBROUTINE EDEX02(NVAR,HEAD,VARNAM,IWIND,TDSP,DSP,NYRS,
     X  NBYRS,IHYRD,IBHYRD,YRWT,A,KODE,VALUE,UNITS,IPAGE,PRIN,
     X    IP,IPP)
C
      DIMENSION YRWT(50),Y(50),LOC(6),DSP(*),TDSP(*),A(*),
     X  PROB(20),PRIN(12,20),XHD(36),YHD(36),AHD(48),BHD(48),
     X  DHD(3),S(2),PP(20),PX(20),ITTS(12),VARNAM(*),
     X   YBWT(50),HEAD(5),IP(6,51),IPP(6,51,3),IPLTTS(6)
      CHARACTER*4   FMT(11),FVAL(15)
      DIMENSION SBNAME(2),OLDOPN(2)
C
      LOGICAL LBUG
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/etime'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/evar'
      INCLUDE 'common/where'
      INCLUDE 'common/eoutpt'
      COMMON/EPARM/AVG(6),STD(6),YMIN(6),YMAX(6),LBUG
C
      REAL   P3(3),P5(1)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_esp/RCS/edex02.f,v $
     . $',                                                             '
     .$Id: edex02.f,v 1.2 2000/12/19 16:01:45 jgofus Exp $
     . $' /
C    ===================================================================
C
      DATA   P3,P5 / .1, .5, .9, .5 /
      DATA FVAL/4H(   ,4H5X, ,4HF3. ,4H2,  ,4H10X,,4H6(F1,
     X  4H0.1,,4H0.2,,4H0.3,,4H9X) ,4H3X,F,4H5.0,,4H1X) ,
     X  4H)   ,4H    /
      DATA NAME,SBNAME/4HEDEX,4HEDEX,4H02  /
C
C SET ERROR TRACES AND DEBUG
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 15 I=1,2
      OLDOPN(I)=OPNAME(I)
15    OPNAME(I)=SBNAME(I)
C
      LBUG=.FALSE.
      IF (IFBUG(NAME).EQ.1) LBUG=.TRUE.
C
      IF (ITRACE.GE.1) WRITE(IODBUG,98)
98    FORMAT(1H0,14HEDEX02 ENTERED)
C
C  IF FREQUENCY TABLE IS PRINTED ON A NEW PAGE THEN PRINT PAGE HEADER.
C
      IF (IPAGE.EQ.0) GO TO 10
      CALL EHEAD(NVAR,HEAD,VARNAM,IWIND,TDSP,UNITS,KODE,VALUE,17)
 10   WRITE(IPR,900)
C
C  INITIALIZE AND DEFINE VARIABLES.
C
      IDIST=DSP(3)
      IF (IDIST.GE.3) IDIST=3
      NUMFR=DSP(4)
      DO 12 I=1,NUMFR
      PROB(I)=DSP(4+I)
      PX(I)=1.0-PROB(I)
 12   CONTINUE
      II=NUMFR+5
      IPLT=DSP(II)
      IF (IFPLT.EQ.0) IPLT=0
      IF (IPLT.EQ.0) GO TO 13
      II=II+1
      ISAMP=DSP(II)
      II=II+6
      ISUM=DSP(II)
      GO TO 14
 13   II=NUMFR+12
      ISUM=DSP(II)
 14   NUM=TDSP(1)
      IBASE=0
      DO 16 I=1,NUM
      II=6+8*(I-1)
      ITTS(I)=TDSP(II)
      LOC(I)=TDSP(II+1)
      IF (ITTS(I).NE.5) GO TO 16
      IBASE=1
 16   CONTINUE
      NUMB=NUM
      IF (IBASE.EQ.1) NUMB=NUMB-1
      NUM2=2*NUMB
      NUM3=3*NUMB
      NUM4=4*NUMB
C
C  PRINT COLUMN HEADERS.
C
      JJ=1
      DO 18 J=1,NUM
      IF (ITTS(J).EQ.5) GO TO 18
      CALL EHEAD1(ITTS(J),XHD(JJ),YHD(JJ))
      JJ=JJ+3
 18   CONTINUE
C
      CALL EHEAD2(NVAR,NUMB,AHD,BHD,KODE,UNITS)
      WRITE(IPR,880)
      CALL EDIS(IDIST,DHD)
      WRITE(IPR,885) (DHD(I),I=1,3)
      WRITE(IPR,900)
C
      WRITE(IPR,910) (XHD(I),I=1,NUM3)
      WRITE(IPR,910) (YHD(I),I=1,NUM3)
      WRITE(IPR,920) (AHD(I),I=1,NUM4)
      WRITE(IPR,922) (BHD(I),I=1,NUM4)
      WRITE(IPR,863)
C
      DO 20 I=1,11
      FMT(I)=FVAL(15)
  20  CONTINUE
C  MAIN LOOP FOR SINGLE-VALUED OUTPUT VARIABLES (NVPV=1).
C  EXCLUDING BASE-PERIOD TIME SERIES.
C
      IF (NVPV(NVAR).EQ.2) GO TO 200
      K=1
      DO 100 I=1,NUM
      IPLTTS(I)=1
      IF (ITTS(I).EQ.5) GO TO 100
      II=LOC(I)
      CALL EDSPA(Y,A,NYRS,II,1,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1.OR.INOR.EQ.1) IPLTTS(I)=0
      CALL EMNX(Y,NYRS,I)
      IF (IMIS.EQ.1) GO TO 90
C
      GO TO (22,24,28),IDIST
      WRITE(IPR,930)
      CALL WARN
 22   CALL EMPFIT(Y,NYRS,PP,NUMFR,PX,NVAR,PNE)
      DO 23 KK=1,NUMFR
 23   PRIN(K,KK)=PP(KK)
      K=K+1
      GO TO 100
 24   CALL ELTFIT(Y,NYRS,I,YRWT)
      GO TO 50
 28   CALL ENFIT(Y,NYRS,I,YRWT)
      GO TO 70
C
 50   CONTINUE
      DO 55 KK=1,NUMFR
      PRIN(K,KK)=EDFLTI(PX(KK),I)
 55   CONTINUE
      K=K+1
      GO TO 100
 70   CONTINUE
      DO 75 KK=1,NUMFR
      PRI=ECDFNI(PX(KK))
      PRIN(K,KK)=AVG(I)+STD(I)*PRI
 75   CONTINUE
      K=K+1
      GO TO 100
 90   DO 95 KK=1,NUMFR
      PRIN(K,KK)=-999.0
 95   CONTINUE
      K=K+1
C
 100  CONTINUE
      IFMT=7
      IF(YMAX(1).LT.-998.) GO TO 110
      IF (YMAX(1).LT.100.) IFMT=8
      IF (YMAX(1).LT.1.) IFMT=9
  110 FMT(1)=FVAL(1)
      FMT(2)=FVAL(2)
      FMT(3)=FVAL(3)
      FMT(4)=FVAL(4)
      FMT(5)=FVAL(5)
      FMT(6)=FVAL(6)
      FMT(7)=FVAL(IFMT)
      FMT(8)=FVAL(10)
      FMT(9)=FVAL(14)
      DO 150 I=1,NUMFR
      WRITE(IPR,FMT)  PROB(I),(PRIN(J,I),J=1,NUMB)
 150  CONTINUE
C
CEW   CHANGED TO 451 TO SKIP TO AFTER SECOND DO LOOP
      GO TO 451
C
C  MAIN LOOP FOR OUTPUT VARIABLES WITH NVPV=2
C  EXCLUDING BASE-PERIOD TIME SERIES.
C
 200  CONTINUE
      K=1
      DO 400 I=1,NUM
      IPLTTS(I)=1
      IF (ITTS(I).EQ.5) GO TO 400
      II=LOC(I)
      DO 300 J=1,2
      L=3-J
      CALL EDSPA(Y,A,NYRS,II,L,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1.OR.INOR.EQ.1) IPLTTS(I)=0
      IF (L.EQ.1) CALL EMNX(Y,NYRS,I)
      IF (LBUG) WRITE(IODBUG,700) (YMIN(KK),YMAX(KK),KK=1,5)
 700  FORMAT(10F10.2)
C
      JJ=2*(K-1)+L
      IF (IMIS.EQ.1) GO TO 290
      IF (J.EQ.1) GO TO 222
      GO TO (222,224,228),IDIST
      WRITE(IPR,930)
 222  CALL EMPFIT(Y,NYRS,PP,NUMFR,PX,NVAR,PNE)
      DO 223 KK=1,NUMFR
 223  PRIN(JJ,KK)=PP(KK)
      GO TO 300
 224  CALL ELTFIT(Y,NYRS,I,YRWT)
      GO TO 250
 228  CALL ENFIT(Y,NYRS,I,YRWT)
      GO TO 270
C
C
 250  CONTINUE
      DO 255 KK=1,NUMFR
      PRIN(JJ,KK)=EDFLTI(PX(KK),I)
 255  CONTINUE
      GO TO 300
 270  CONTINUE
      DO 275 KK=1,NUMFR
      PRI=ECDFNI(PX(KK))
      PRIN(JJ,KK)=AVG(I)+STD(I)*PRI
 275  CONTINUE
      GO TO 300
 290  DO 295 KK=1,NUMFR
      PRIN(JJ,KK)=-999.0
 295  CONTINUE
C
 300  CONTINUE
      K=K+1
 400  CONTINUE
C
      IFMT=7
      IF(YMAX(1).LT.-998.) GO TO 410
      IF (YMAX(1).LT.100.) IFMT=8
      IF (YMAX(1).LT.1.) IFMT=9
  410 FMT(1)=FVAL(1)
      FMT(2)=FVAL(2)
      FMT(3)=FVAL(3)
      FMT(4)=FVAL(4)
      FMT(5)=FVAL(2)
      FMT(6)=FVAL(6)
      FMT(7)=FVAL(IFMT)
      FMT(8)=FVAL(11)
      FMT(9)=FVAL(12)
      FMT(10)=FVAL(13)
      FMT(11)=FVAL(14)
      DO 450 I=1,NUMFR
      WRITE(IPR,FMT)  PROB(I),(PRIN(J,I),J=1,NUM2)
 450  CONTINUE
CEW ADDED SECOND CONINUE TO STOP ROUTINE GOING INTO
CEW SECOND DO LOOP
 451  CONTINUE
C
C  BASE PERIOD
C
      IF (IBASE.NE.1) GO TO 999
      WRITE(IPR,863)
      FNBYRS=NBYRS
      FNBYRS=1./FNBYRS
      DO 505 I=1,NBYRS
      YBWT(I)=FNBYRS
 505  CONTINUE
      DO 510 I=1,NUM
      IF (ITTS(I).EQ.5) GO TO 520
 510  CONTINUE
 520  IB=I
      II=LOC(IB)
      IF (NVPV(NVAR).EQ.2) GO TO 600
      WRITE(IPR,900)
      CALL EHEAD1(5,XHD(1),YHD(1))
      CALL EHEAD2(NVAR,1,AHD,BHD,KODE,UNITS)
      WRITE(IPR,910) (XHD(I),I=1,3)
      WRITE(IPR,910) (YHD(I),I=1,3)
      WRITE(IPR,920) (AHD(I),I=1,4)
      WRITE(IPR,922) (BHD(I),I=1,4)
      WRITE(IPR,863)
      CALL EDSPA(Y,A,NBYRS,II,1,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1.OR.INOR.EQ.1) IPLTTS(IB)=0
      IF (IPLTTS(IB).EQ.0) GO TO 530
      IF (IPLT.EQ.1) CALL EMNX(Y,NBYRS,IB)
C
C        COMPUTE PROBABILITY VALUES FOR BASE PERIOD.
C
      GO TO (522,524,526),IDIST
      WRITE(IPR,930)
      CALL WARN
 522  CALL EMPFIT(Y,NBYRS,PP,NUMFR,PX,NVAR,PNE)
      DO 523 KK=1,NUMFR
 523  PRIN(1,KK)=PP(KK)
      GO TO 590
 524  CALL ELTFIT(Y,NBYRS,IB,YBWT)
      DO 525 KK=1,NUMFR
 525  PRIN(1,KK)=EDFLTI(PX(KK),IB)
      GO TO 590
 526  CALL ENFIT(Y,NBYRS,IB,YBWT)
      DO 527 KK=1,NUMFR
      PRI=ECDFNI(PX(KK))
 527  PRIN(1,KK)=AVG(IB)+STD(IB)*PRI
      GO TO 590
 530  DO 535 KK=1,NUMFR
 535  PRIN(1,KK)=-999.
 590  DO 595 I=1,NUMFR
      WRITE(IPR,FMT)  PROB(I),PRIN(1,I)
 595  CONTINUE
      GO TO 999
 600  CONTINUE
      DO 660 J=1,2
      L=3-J
      CALL EDSPA(Y,A,NBYRS,II,L,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1.OR.INOR.EQ.1) IPLTTS(IB)=0
      IF (IPLTTS(IB).EQ.0) GO TO 650
      IF (L.EQ.1.AND.IPLT.EQ.1) CALL EMNX(Y,NBYRS,IB)
      IF (J.EQ.1) GO TO 610
      GO TO (610,620,630),IDIST
      WRITE(IPR,930)
 610  CALL EMPFIT(Y,NBYRS,PP,NUMFR,PX,NVAR,PNE)
      DO 612 KK=1,NUMFR
 612  PRIN(L,KK)=PP(KK)
      GO TO 660
 620  CALL ELTFIT(Y,NBYRS,IB,YBWT)
      DO 622 KK=1,NUMFR
 622  PRIN(L,KK)=EDFLTI(PX(KK),IB)
      GO TO 660
 630  CALL ENFIT(Y,NBYRS,IB,YBWT)
      DO 632 KK=1,NUMFR
      PRI=ECDFNI(PX(KK))
 632  PRIN(L,KK)=AVG(IB)+STD(IB)*PRI
      GO TO 660
 650  DO 655 KK=1,NUMFR
 655  PRIN(L,KK)=-999.
 660  CONTINUE
 690  DO 695 I=1,NUMFR
      WRITE(IPR,FMT)  PROB(I),(PRIN(J,I),J=1,2)
 695  CONTINUE
 999  CONTINUE
C
C  SUMMARY TABLE.
C
      IF (ISUM.NE.1) GO TO 850
      CALL ECNV(ITTS,NUM,IBASE,I3,I4,I5,LOC,IL3,IL4,IL5,IOBS)
      GO TO (802,804,808),IDIST
 802  CALL EDSPA(Y,A,NYRS,IL3,1,NVAR,IMIS,INOR)
      CALL EMPFIT(Y,NYRS,PP,3,P3,NVAR,PNE)
      VAL1=PP(1)
      VAL5=PP(2)
      VAL9=PP(3)
      IF (IOBS.EQ.1.AND.INOR.NE.1) GO TO 702
 701  OAVG=-999.
      O50=-999.
      GO TO 703
 702  CALL EDSPA(Y,A,NYRS,IL4,1,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1) GO TO 701
      CALL EMPFIT(Y,NYRS,PP,1,P5,NVAR,PNE)
      CALL EMOM2(Y,NYRS,S,YRWT)
      OAVG=S(1)
      O50=PP(1)
 703  IF (IBASE.EQ.1) GO TO 803
 713  BAVG=-999.
      B50=-999.
      GO TO 840
 803  CALL EDSPA(Y,A,NBYRS,IL5,1,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1) GO TO 713
      CALL EMPFIT(Y,NBYRS,PP,1,P5,NVAR,PNE)
      CALL EMOM2(Y,NBYRS,S,YRWT)
      BAVG=S(1)
      B50=PP(1)
      GO TO 840
 804  VAL1=EDFLTI(.1,I3)
      VAL5=EDFLTI(.5,I3)
      VAL9=EDFLTI(.9,I3)
      IF (IOBS.EQ.1) GO TO 704
 714  OAVG=-999.
      O50=-999.
      GO TO 705
 704  CALL EDSPA(Y,A,NYRS,IL4,1,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1) GO TO 714
      CALL EMOM2(Y,NYRS,S,YRWT)
      O50=EDFLTI(.5,I4)
      OAVG=S(1)
 705  IF (IBASE.EQ.1) GO TO 805
 715  BAVG=-999.
      B50=-999.
      GO TO 840
 805  B50=EDFLTI(.5,I5)
      CALL EDSPA(Y,A,NBYRS,IL5,1,NVAR,IMIS,INOR)
      CALL EMOM2(Y,NBYRS,S,YRWT)
      BAVG=S(1)
      GO TO 840
 808  VAL1=AVG(I3)+STD(I3)*ECDFNI(.1)
      VAL5=AVG(I3)
      VAL9=AVG(I3)+STD(I3)*ECDFNI(.9)
      IF (IOBS.NE.1) GO TO 721
      CALL EDSPA(Y,A,NYRS,IL4,1,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1) GO TO 721
      OAVG=AVG(I4)
      O50=AVG(I4)
      GO TO 723
 721  OAVG=-999.
      O50=-999.
 723  IF (IBASE.EQ.1) GO TO 809
 725  BAVG=-999.
      B50=-999.
      GO TO 840
 809  CALL EDSPA(Y,A,NBYRS,IL5,1,NVAR,IMIS,INOR)
      IF (IMIS.EQ.1) GO TO 725
      B50=AVG(I5)
      BAVG=AVG(I5)
 840  CONTINUE
      CALL ESTABL(VARNAM,NVAR,UNITS,VAL1,VAL5,VAL9,IWIND,OAVG,BAVG,
     X   O50,B50,IHYRD,IBHYRD)
 850  IF (IPLT.NE.1) GO TO 860
      CALL EPLOT(IDIST,A,NYRS,NBYRS,DSP,ITTS,IPLTTS,NVAR,LOC,NUM,IP,IPP,
     X   HEAD,VARNAM,IWIND,TDSP,KODE,VALUE,UNITS)
C
C RESET ERROR TRACES
C
860   IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
 870  FORMAT(1H1)
 863  FORMAT(1H )
 880  FORMAT(5X,15HFREQUENCY TABLE / 5X,15(1H*))
 885  FORMAT(5X,22HFITTING DISTRIBUTION: ,3A4)
 900  FORMAT(1H0)
 910  FORMAT(19X,6(3A4,7X))
 920  FORMAT(/ 2X,10HEXCEEDANCE,6X,6(4A4,3X))
 922  FORMAT(2X,11HPROBABILITY,4X,6(4A4,3X))
 930  FORMAT(5X,35H**WARNING** IDIST HAS INVALID VALUE)
C
CC
C
      RETURN
      END

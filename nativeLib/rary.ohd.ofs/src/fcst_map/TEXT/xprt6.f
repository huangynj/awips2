C MODULE XPRT6
C.......................................
C     THIS SUBROUTINE PRINTS OBSERVED AND ESTIMATED AMOUNTS
C       FOR STATION WITH LESS THAN 24 HOUR DATA.
C.......................................
C     WRITTEN BY--ERIC ANDERSON,HRL--FEBRUARY 1983
C.......................................
      SUBROUTINE XPRT6(STA,STAN,STATE,P24,IEST,IPC,NM6,INM,ITITLE,
     1  NPRT,N6)
C
      INTEGER*2 P24,IPC,NM6(4)
      INTEGER*2 MSNG24,MSNG6,MSGMDR,MSNGSR
      DIMENSION STA(2),STAN(5),UNIT(2),ENGL(2),UMET(2)
C
      CHARACTER*4  FMTB(27),FMTP(2,4)
      CHARACTER*4  FMT
      CHARACTER*4  FMTE,FMTM
      CHARACTER*4  FA3,F32,F31
C
C     COMMON BLOCKS
      COMMON/PUDBUG/IOPDBG,IPTRCE,NDBUG,PDBUG(20),IPALL
      COMMON/IONUM/IN,IPR,IPU
      COMMON/XDISPL/MDRPRT,MDRCOM,IPRT24,IPLT24,IPRT6,IPRSSR,
     1 IPRSRW,MAPPRT,METRIC,LASTDY,IPRDAY,IPLTMP
      COMMON/XTIME/KZDA,KDA,KHR,LSTMO,KMO,KID,KYR,KIH,TZCODE,ISW,
     1 IUTMP,NSSR,IDAY
C
      COMMON/XPRA6/ ST(2,2),SN(5,2),SC(2),PP(2),ES(2),PN(4,2),CD(2),
     $              FMT(27)
      COMMON/XSIZE/NMAP,NDUPL,NSLT24,NSLOT6,LDATA6,LMDR,LPPSR,
     1  MSNG24,MSNG6,MSGMDR,MSNGSR,NRECTP,MXTEMP,SMALL
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_map/RCS/xprt6.f,v $
     . $',                                                             '
     .$Id: xprt6.f,v 1.2 2000/12/19 16:03:03 jgofus Exp $
     . $' /
C    ===================================================================
C
C
C     DATA STATEMENTS
      DATA ENGL,UMET/4HINCH,4HES  ,4HMM  ,4H    /
      DATA BNK,CC,CZ,CM,CE/1H ,1HC,1HZ,1HM,1HE/
      DATA BNK2,SZ,SZM,SM,SE,SU/2H  ,2H Z,2HZM,2H M,2H E,2H U/
      DATA FMTB/4H(1H ,4H,5A4,4H,1X,,4HA2, ,4H2X, ,4H2A4,,4H    ,
     1  4H,A1,,4H    ,4H(1X,,4H    ,4H    ,4HX,A2,4H,7X,,4H5A4,,
     2  4H1X, ,4HA2, ,4H2X, ,4H2A4,,4H    ,4H,A1,,4H    ,4H(1X,,
     3  4H    ,4H    ,4HX,A2,4H)   /
      DATA FMTE,FMTM/4HF6.2,4HF6.0/
      DATA FA3,F31,F32/4HA3  ,4HF3.1,4HF3.2/
      DATA FMTP/4H2X,1,4H),14,4H2X,2,4H),10,4H2X,3,4H), 6,4H2X,4,4H), 2/
      DATA BLNK3/3H   /
      DATA SME,CG/2HME,1HG/
C.......................................
C     CHECK TRACE LEVEL
      IF(IPTRCE.GE.3) WRITE(IOPDBG,900)
 900  FORMAT(1H0,16H** XPRT6 ENTERED)
C.......................................
C     CHECK TO SEE IF CALL IS JUST TO FLUSH THE PRINT ARRAY.
      IF(ITITLE.LT.0) GO TO 140
C.......................................
C     PRINT TITLE IF REQUESTED
      IF(ITITLE.EQ.0) GO TO 100
      FMTB(9)=FMTP(1,N6)
      FMTB(22)=FMTP(1,N6)
      FMTB(12)=FMTP(2,N6)
      FMTB(25)=FMTP(2,N6)
      WRITE(IPR,901) KMO,KID,KYR,KIH,TZCODE
 901  FORMAT(1H1,10X,83HPRECIPITATION DISPLAY FOR STATIONS WITH LESS THA
     1N 24 HOUR REPORTS FOR DAY ENDING ON,
     2 I3,1H/,I2,1H/,I4,1H-,I2,A4)
      IF(METRIC.EQ.1) GO TO 101
      UNIT(1)=ENGL(1)
      UNIT(2)=ENGL(2)
      FMTB(7)=FMTE
      FMTB(20)=FMTE
      GO TO 102
 101  UNIT(1)=UMET(1)
      UNIT(2)=UMET(2)
      FMTB(7)=FMTM
      FMTB(20)=FMTM
 102  WRITE(IPR,902)UNIT
 902  FORMAT(1H0,46X,29HOBSERVED AND ESTIMATED VALUES,//16X,
     1 19HDAILY TOTALS ARE IN,1X,2A4,2X,27HSIX HOUR IN NORMALIZED FORM,
     2  4X,29HBLANK INDICATES NOT ESTIMATED)
      WRITE(IPR,903)
 903  FORMAT(1H0,50X,23HSYMBOLS USED IN DISPLAY,//21X,
     1 19HDAILY VALUE SYMBOLS,36X,28HSIX HOUR(NORMALIZED) SYMBOLS)
      WRITE(IPR,904)
 904  FORMAT(1H0,15X,20HC=CORRECTION APPLIED,35X,
     129H Z=MISSING VALUES SET TO ZERO,/16X,
     213HZ=SET TO ZERO,42X,29HZM=MISSING SET TO ZERO BY MDR,/16X,
     320HM=ESTIMATED FROM MDR,35X,21H M=ESTIMATED FROM MDR,/16X,
     437HE=ESTIMATED FROM SURROUNDING STATIONS,18X,
     538H E=ESTIMATED FROM SURROUNDING STATIONS,/16X,
     627HG=VALUE FROM COLOCATED GAGE,28X,27HME=MISSING VALUES ESTIMATED,
     7/71X,30H U=SET TO UNIFORM DISTRIBUTION)
      WRITE(IPR,905)
 905  FORMAT(1H0,//1X,12HSTATION NAME,6X,5HSTATE,3X,2HID,7X,5HDAILY,
     1  5X,10HNORMALIZED,4X,4HCODE,6X,12HSTATION NAME,6X,5HSTATE,3X,
     2  2HID,7X,5HDAILY,5X,10HNORMALIZED,4X,4HCODE)
      WRITE(IPR,906)
 906  FORMAT(1H ,12H------------,6X,5H-----,3X,2H--,7X,5H-----,5X,
     1  10H----------,4X,4H----,6X,12H------------,6X,5H-----,3X,
     2  2H--,7X,5H-----,5X,10H----------,4X,4H----)
      DO 103 J=1,27
  103 FMT(J)=FMTB(J)
      ITITLE=0
C.......................................
C     STORE CURRENT VALUE IN PRINT ARRAY
 100  I=NPRT+1
      K=11+(I-1)*13
      ST(1,I)=STA(1)
      ST(2,I)=STA(2)
      DO 105 J=1,5
 105  SN(J,I)=STAN(J)
      SC(I)=STATE
      PP(I)=P24*0.01
      IF(METRIC.EQ.1) PP(I)=PP(I)*25.4
      IF(IEST) 106,107,108
 106  ES(I)=CZ
      GO TO 115
 107  ES(I)=BNK
      IF (P24.EQ.0) GO TO 115
      J=IPC
      IF(J.LT.0) J=-J
      IW=J/100
      IS=J-IW*100
      IF(IS.EQ.0) GO TO 109
      IF(ISW.EQ.1) GO TO 109
      ICF=IS*5
      GO TO 110
 109  ICF=IW*5
 110  IF(ICF.NE.100) ES(I)=CC
      GO TO 115
  108 J=IEST-2
      IF (J) 112,111,113
  112 ES(I)=CE
      GO TO 115
 111  ES(I)=CM
      GO TO 115
  113 ES(I)=CG
  115 IF (INM.GT.-4) GO TO 117
      DO 118 J=1,N6
  118 PN(J,I)=BLNK3
      FMT(K)=FA3
      CD(I)=BNK2
      GO TO 130
  117 FMT(K)=F32
      DO 116 J=1,N6
      IF (NM6(J).EQ.100) FMT(K)=F31
      PN(J,I)=NM6(J)*0.01
 116  CONTINUE
      IF(INM) 120,128,123
  128 CD(I)=BNK2
      GO TO 130
  120 IF (INM+2) 122,121,127
  127 CD(I)=SZ
      GO TO 130
 121  CD(I)=SZM
      GO TO 130
 122  CD(I)=SME
      GO TO 130
 123  IF(INM-2) 124,125,126
 124  CD(I)=SE
      GO TO 130
 125  CD(I)=SM
       GO TO 130
 126  CD(I)=SU
 130  NPRT=I
C
C     IF TWO VALUES STORED, PRINT RESULTS
      IF(NPRT.LT.2) GO TO 99
C.......................................
C     DUMP PRINT ARRAY
  140 WRITE(IPR,FMT) ((SN(J,I),J=1,5),SC(I),(ST(J,I),J=1,2),PP(I),
     1 ES(I),(PN(J,I),J=1,N6),CD(I),I=1,NPRT)
      NPRT=0
C     PRINT COMPLETE
C.......................................
  99  IF(IPTRCE.GE.3) WRITE(IOPDBG,909)
 909  FORMAT(1H0,13H** EXIT XPRT6)
      RETURN
      END

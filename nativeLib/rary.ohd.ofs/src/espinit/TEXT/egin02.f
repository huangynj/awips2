C MODULE EGIN02
C-----------------------------------------------------------------------
C
      SUBROUTINE EGIN02 (TTS,MTTS,ILOC,NUSE,GTYPE,TS,MTS,NWORK,IER)
C
C INPUT ROUTINE FOR GENERATE 02 (BLEND TS).
C
C THIS ROUTINE IS PART OF ESP INTIALIZATION.
C IT WILL READ INFORMATION AND STORE IT IN THE TTS ARRAY (TO BE LATER
C STORED IN TSESP BY CALLING ROUTINE).
C
C THE INFO READ IS VALUES FOR WEIGHTING AND BLENDING OF
C HISTORICAL AND FUTURE DATA AND TIME SERIES(TS) INFO FOR THE PROCESS
C DATA BASE(PDB) TS AND CALIBRATION FIILE TS.
C   1ST VALUE= WEIGHT OF FUTURE DATA AT START
C   2ND   "  =   "    "    "      "   "  END
C   3RD   "  = LENGTH OF WEIGHTING PERIOD (HRS.)
C   4TH   "  =   "    "   BLEND      "    (DAYS)
C   5TH   "  = INDICATOR IF WE HAVE TEMP OR PRECIP. 0= TEMP, 1= PRECIP
C 6-7TH   "  = ID FOR PDB TS
C   8TH  "   = DATA TYPE CODE FOR PDB TS
C   9TH  "   = (BLANK)
C 10-25TH "  = INFO FOR CALIBRATION TS
C
C THE INFO STORED IS NECESSARY AT EXECUTION TIME FOR
C BLENDING TIME SERIES. IT IS STORED IN THE EXTERNAL LOCATION
C INFORMATION ELEMENTS OF TSESP. THE ASSOCIATED TIME SERIES INFO
C HAS ALREADY BEEN DEFINED BY THE CALLING PROGRAM.
C
C ROUTINE ORIGINALLY BY ED VANBLARGAN - HRL - 12/1981
C
      CHARACTER*8 OLDOPN,FTSID
C
      DIMENSION TTS(MTS),GTYPE(2),DTS(5),IHEAD(22)
      DIMENSION FNAME(3),STAID(3),DESCR(5),TS(1),TSID(2),TSIDF(2)
      DIMENSION EXTLOC(50),TSNAME(8)
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fcsegn'
      INCLUDE 'clbcommon/crwctl'
      INCLUDE 'prdcommon/pdatas'
      COMMON/BHTIME/IBHREC,CMONTH,CDAY,CYEAR,CHRMN,CSCNDS,LSTHDR
      INTEGER CMONTH,CDAY,CYEAR,CHRMN,CSCNDS
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/espinit/RCS/egin02.f,v $
     . $',                                                             '
     .$Id: egin02.f,v 1.7 2002/02/11 20:14:37 dws Exp $
     . $' /
C    ===================================================================
C
      DATA NAME/4HEINP/,SAME/4HSAME/
      DATA FTYPE/4HFPDB/
      DATA DTS/4HMAT ,4HTAVG,4HMAP ,4HPTPX,4HRAIM/
C
C
      IOPNUM=0
      CALL FSTWHR ('EGIN02  ',IOPNUM,OLDOPN,IOLDOP)
C
      IF (ITRACE.GE.1) WRITE(IODBUG,*) 'ENTER EGIN02'
C
      IBUG=IFBUG(NAME)
C
C  SET VARIABLES - NUSE=NUMBER OF VALUES OF EXTERNAL INFO LOCATIONS USED
      IER=0
      NUSE=29
C
      TSID(1)=TTS(ILOC-10)
      TSID(2)=TTS(ILOC-9)
      DTYPE=TTS(ILOC-8)
      IDT=TTS(ILOC-7)
C
C  CHECK SPACE IN TTS ARRAY
      IF ((ILOC+NUSE-1).LE.MTTS) GO TO 200
99       WRITE(IPR,100) MTTS
100   FORMAT('0**ERROR** NO ROOM IN TTS ARRAY ',
     * ' TO PUT THE GENERATE PE INFORMATION. MTTS=',I5)
         IER=1
         CALL ERROR
         GO TO 999
C
C PUT GENERATE TYPE INFO INTO TTS ARRAY
200   TTS(ILOC)=GTYPE(1)
      TTS(ILOC+1)=GTYPE(2)
      TTS(ILOC-1)=NUSE+0.01
C
C READ INFO ON WEIGHTS AND TIME PERIODS FOR BLENDING.
      READ (IN,300) TTS(ILOC+2),TTS(ILOC+3),LWP,LBP
300   FORMAT(2F5.2,2I5)
      TTS(ILOC+4)=LWP+0.01
      TTS(ILOC+5)=LBP+0.01
C
C CHECK THAT WEIGHT 1(W1) IS GREATER THAN WEIGHT 2(W2). AND
C THAT W1 IS LESS THAN 1.0
C
      IF (TTS(ILOC+2).GT.TTS(ILOC+3)) GO TO 350
         WRITE(IPR,310) TTS(ILOC+2),TTS(ILOC+3)
310   FORMAT('0**WARNING** INITIAL WEIGHT (',F5.2,
     * ') IS LESS THAN OR EQUAL TO ENDING WEIGHT (',F5.2,').')
         CALL WARN
C
350   IF (TTS(ILOC+2).LE.1.0) GO TO 390
      WRITE (IPR,360) TTS(ILOC+2)
360   FORMAT(1H0,10X,26H**WARNING** INITIAL WEIGHT,F5.2,
     * 19H IS GREATER THAN 1.)
      CALL WARN
C
C CHECK IF DATA TYPE (TTS(ILOC-8)) IS A PRECIP OR TEMP. THEN PUT
C TEMP-PRECIP INDICATOR IN 5TH LOCATION.
C
390   TTS(ILOC+6)=0.01
      DO 400 I=1,2
         IF (DTS(I).EQ.TTS(ILOC-8)) GO TO 700
400      CONTINUE
C
      TTS(ILOC+6)=1.01
      DO 500 I=3,5
         IF(DTS(I).EQ.TTS(ILOC-8)) GO TO 700
500      CONTINUE
C
C  INVALID DATA TYPE
      WRITE(IPR,600) TTS(ILOC-8),TTS(ILOC-10),TTS(ILOC-9)
600   FORMAT('0**ERROR** TIME SERIES MUST BE TEMP OR PRECIP ',
     * 34H FOR BLEND-TS.  INVALID DATA TYPE-,A4,10H- FOR ID -,2A4)
      IER=1
      CALL ERROR
C
C  GET INFO FOR PDB TIME SERIES
  700 CALL FINDTS (TSID,DTYPE,IDT,LD,LTS,DIM)
      IF (LD.GT.0) GO TO 610
      WRITE(IPR,605) TSID,DTYPE,IDT
  605    FORMAT(1H0,10X,30H**ERROR** FORECAST TIME SERIES,2X,2A4,
     1 2X,A4,I5,2X,13HWAS NOT FOUND)
         CALL ERROR
         IER=1
         GO TO 999
  610 ITSTYP=TS(LTS)
      IF(ITSTYP.LE.2.AND.TS(LTS+9).EQ.FTYPE) GO TO 620
         WRITE(IPR,615) TSID,DTYPE,IDT
  615 FORMAT(1H0,10X,30H**ERROR** FORECAST TIME SERIES,2X,2A4,
     1 2X,A4,I5,2X,23HWILL NOT ALLOW BLENDING)
         IER=1
         CALL ERROR
         GO TO 999
  620 DO 630 I=1,3
         TTS(ILOC+6+I)=TS(LTS+11+I)
  630    CONTINUE
C
C  COMPUTE SPACE NEEDED IN THE WORK PART OF THE D ARRAY FOR FUTURE DATA
      CALL UMEMST (0,IHEAD,LENHED)
      CALL UMEMOV (TTS(ILOC+7),TSIDF,2)
      MXBUF=1
      CALL RPRDH (TSIDF,TTS(ILOC+9),MXBUF,IHEAD,NXBUF,XBUF,FTSID,
     *   ISTAT)
      IF (ISTAT.NE.0) THEN
         IF (ISTAT.EQ.1) THEN
            WRITE (IPR,721) TSIDF,DTYPE
721   FORMAT ('0**ERROR** IN EGEX02 - ',
     *   'TIME SERIES FOR IDENTIFIER ',2A4,
     *   ' AND DATA TYPE ',A4,' NOT FOUND.')
            CALL ERROR
            IER=1
            GO TO 830
            ELSE
               WRITE (IPR,722) TSIDF,DTYPE,ISTAT
722   FORMAT ('0**ERROR** IN EGIN02 - STATUS CODE FROM ROUTINE RPRDH ',
     *   'FOR TIME SERIES FOR IDENTIFIER ',2A4,
     *   ' AND DATA TYPE ',A4,' IS ',I2,'.')
               CALL ERROR
               IER=1
               GO TO 830
            ENDIF
         ENDIF
      ITX=IHEAD(2)
      NPDT=TTS(ILOC-6)
      MAXDAY=IPRDMD(TTS(ILOC+9))
      LWORKB=LENHED+(24/ITX)*NPDT*MAXDAY+NXBUF+LRECLT
      IF (IWKLOC.GT.0) THEN
C     SEGMENT EXISTS SO VALUE OF IWKLOC IS KNOWN
         LF1=IWKLOC+LWORKB
         TTS(ILOC+10)=LF1+.01
         ELSE
C        SEGMENT DOES NOT EXIST SO VALUE OF IWKLOC IS NOT KNOWN
            LF1=-LWORKB
            TTS(ILOC+10)=LF1-.01
         ENDIF
      IF (IBUG.EQ.1) WRITE (IPR,*) 'IN EGIN02 - LWORKB=',LWORKB,
     *   ' IWKLOC=',IWKLOC,' LF1=',LF1
      TTS(ILOC+11)=0.01
      TTS(ILOC+12)=0.01
C
      IF(IBUG.NE.0) WRITE(IODBUG,802) ITX,NPDT,MAXDAY,NXBUF,LRECLT,
     1 NWORK,LWORKB,IWKLOC,LF1
  802 FORMAT(' ITX,NPDT,MAXDAY,NXBUF,LRECLT,NWORK,LWORKB,',
     1 10HIWKLOC,LF1/11X,9I10)
C
      LWORKF=31*NPDT*24/IDT
      NWKNED=LWORKB+LWORKF
      IF (NWKNED.LE.NWORK) GO TO 830
         NLEFT=NWORK-LWORKB
         NHRS=NLEFT*IDT/NPDT
         IF (TTS(ILOC+6).NE.0) GO TO 810
C        TEMPERATURE
            WRITE(IPR,805) TSID,DTYPE,IDT,NHRS,LWP
  805 FORMAT('0**WARNING** TIME SERIES ',2A4,2X,A4,I5,2X,
     1    ' THE WEIGHTING IS LIMITED TO ',I5,' HOURS.' /
     2 12X,'THE LENGTH OF THE WEIGHTING PERIOD REQUESTED IS ',I5,
     3    ' HOURS.')
            CALL WARN
            GO TO 830
C        PRECIPITATION
  810       WRITE(IPR,815) TSID,DTYPE,IDT,NHRS,LWP,LBP
  815 FORMAT('0**WARNING** TIME SERIES ',2A4,2X,A4,I5,2X,
     1    '. THE WEIGHTING AND BLENDING ARE LIMITED TO ',I5,' HOURS.' /
     2 12X,'THE LENGTH OF THE WEIGHTING PERIOD REQUESTED IS ',I5,
     3     'HOURS AND THE LENGTH OF THE BLEND PERIOD REQUESTED IS ',I5,
     4     'DAYS.')
         CALL WARN
C
C  READ CALIBRATION TS INFO BY CALLING LOCATE
830   KMO1=0
      KYR1=0
      KMO2=0
      KYR2=0
      UNITS=SAME
C  ZERO OUT THE NUMBER OF READS
      CALL CZRORD
      CALL LOCATE(KMO1,KYR1,KMO2,KYR2,UNITS,FNAME,DTYPEH,IDTH,STAID,
     * DESCR,NXTRD,LPTR)
CEW  ON HP'S LOCATE IS REWRITTEN TO RETURN KMO1= -1000
      IF (KMO1 .EQ. -1000) GO TO 930
      IF (IERROR.EQ.0) GO TO 850
         WRITE(IPR,840)
840   FORMAT('0**ERROR** UNABLE TO LOCATE TIME SERIES.')
         CALL ERROR
         GO TO 999
850   DO 870 I=1,3
         TTS(ILOC+12+I)=FNAME(I)
         TTS(ILOC+18+I)=STAID(I)
870      CONTINUE
      TTS(ILOC+16)=DTYPEH
      TTS(ILOC+17)=IDTH
      TTS(ILOC+18)=IBHREC+0.01
      TTS(ILOC+22)=CMONTH+0.01
      TTS(ILOC+23)=CDAY+0.01
      TTS(ILOC+24)=CYEAR+0.01
      TTS(ILOC+25)=CHRMN+0.01
      TTS(ILOC+26)=CSCNDS+0.01
      TTS(ILOC+27)=0.01
      TTS(ILOC+28)=0.01
      GO TO 970
C
930   NCTS=1
      CALL CARDIO (NCTS,NUMEXT,EXTLOC,DTYPE,UNITS,DIM,IDT,
     *   NPDT,TSNAME,IERR)
      IF (IERR.NE.0) THEN
         IER=IERR
         GO TO 999
         ENDIF
C CHECK THAT THERE IS ROOM IN TTS ARRAY
cew   increased to 13 from 9
      NUSE=NUMEXT+13
      IF ((ILOC+NUSE-1).GT.MTTS) GO TO 99
      TTS(ILOC-1)=NUSE+0.01
      KYR1=EXTLOC(2)/12
      KYR2=EXTLOC(3)/12
      KMO1=EXTLOC(2)- KYR1*12
      KMO2=EXTLOC(3)- KYR2*12
      IF (KMO1.NE.0) GO TO 932
         KYR1=KYR1-1
         KMO1=12
932   IF (KMO2.NE.0) GO TO 940
         KYR1=KYR1-1
         KMO1=12
940   IDTH=EXTLOC(6)
      NPDT=EXTLOC(7)
      DTYPEH=DTYPE
      DO 956 I=1,NUMEXT
         J=ILOC+12+I
         TTS(J)=EXTLOC(I)
956      CONTINUE
cew close card file 
      iunit=tts(iloc+12+1)
      call clfile ('DATACARD',iunit,ierr)
cew set the unit number position (first external position) to
cew -99 so that it may be used in the ecardf card reading routine
      tts(ILOC+12+1)=-99
      NUMESP=0
      TTS(ILOC+13+NUMEXT)=NUMESP+0.01
C
C  CHECK THAT TIME INTERVALS ARE EQUAL OR COMPATIBLE AND THAT THE DATA
C  TYPE OF THE HISTORICAL DATA IS COMPATIBLE WITH THE FC TIME SERIES
C  DATA TYPE.
970   IF (IHEAD(2).GT.0) THEN
         IDT=TTS(ILOC-7)
         IF (MOD(IDT,IHEAD(2)).EQ.0.AND.IDT.EQ.IDTH) GO TO 880
            WRITE (IPR,875) IDT,IHEAD(2),IDTH
875   FORMAT ('0**ERROR** DATA TIME INTERVALS ARE NOT COMPATIBLE : ',
     * ' BLENDED=',I2,' FUTURE=',I2,' HISTORICAL=',I2)
            CALL ERROR
            IER=1
         ENDIF
C
  880 ITTS = TTS(ILOC+6)
      IF(ITTS.EQ.1) GO TO 885
C
C   TS IS TEMPERATURE
      DO 882 I=1,2
         IF(DTS(I).EQ.DTYPEH) GO TO 900
  882    CONTINUE
      GO TO 890
  885 CONTINUE
C
C   TS IS PRECIPITATION
      DO 887 I=3,5
         IF(DTS(I).EQ.DTYPEH) GO TO 900
  887    CONTINUE
  890 WRITE(IPR,895) DTYPEH,TSID,DTYPE,IDT
  895 FORMAT('0**ERROR** THE DTYPE FOR THE HISTORICAL DATA ',
     1 2X,A4,' IS NOT COMPATIBLE WITH TS ',2A4,2X,A4,I5)
      IER=1
      CALL ERROR
C
900   IF (IBUG.EQ.1) THEN
         WRITE(IODBUG,910) (TTS(I+ILOC-1),I=1,NUSE)
910   FORMAT(' INFORMATION STORED FOR BLEND TIME SERIES IS:' /
     * 1X,2A4,2X,5F5.1,3(1X,A4),3F10.0,4(1X,A4) /
     * 1X,F4.0,F6.0,3(1X,A4),7F5.0)
         WRITE(IODBUG,920) ILOC,NUSE,GTYPE
920   FORMAT(1H0,20HILOC, NUSE, GTYPE = ,I5,1X,I3,1X,2A4)
         ENDIF
C
999   CALL FSTWHR (OLDOPN,IOLDOP,OLDOPN,IOLDOP)
C
      RETURN
C
      END

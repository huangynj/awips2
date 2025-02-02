C MODULE FSTGQ
C  NOTE:  Any changes that is made to this file, must be included
C         to the fcfstgq.f as well. fcfstgq.f is used in ifp program
C-----------------------------------------------------------------------
C
C  ROUTINE TO CONVERT GIVEN INPUT ARRAY OF STAGE(DISCHARGE) VALUES.
C
      SUBROUTINE FSTGQ (RCID,ICONV,ITSPOS,NVALS,TSDELT,QDATA,
     1   HDATA,LOCPTR,T1,CURVLO,CURVUP,XSECLO,XSECUP,METHOD,
     2   FLSTAG,NEEDEX,CARRYO,JULDAY,INITHR,IRCHNG,IERROR,
     3   IPRWRN)
C
C  ROUTINE FSTGQ CONVERTS THE STAGE(DISCHARGE) VALUES STORED IN THE
C  HDATA(QDATA) ARRAY BY INTERPOLATION WITHIN A SINGLE VALUE RATING 
C  CURVE EXTRAPOLATING LOGARITHMICALLY OR HYDRAULICALLY AS NECESSARY.
C  THE CONVERSIONS MAY ALSO BE MADE BY EMPLOYING A DYNAMIC LOOP RATING
C  CURVE PROGRAM FIRST DEVELOPED BY D.FREAD.  THE CONVERTED VALUES ARE
C  STORED IN THE QDATA(HDATA) ARRAY.
C
C  ARGUMENT LIST:
C  RCID - 8-CHAR RATING CURVE IDENTIFIER
C  ICONV - CONVERSION INDICATOR
C          =0, NO CONVERSION--RETURN INFO ABOUT RATING CURVE AND X-SECT
C          =1, CONVERT STAGE TO DISCHARGE
C          =2, CONVERT DISCHARGE TO STAGE
C  ITSPOS - LOCATION OF FIRST VALUE IN INPUT ARRAY TO BE CONVERTED
C  NVALS  - NUMBER OF VALUES TO BE CONVERTED
C  TSDELT - TIME INTERVAL BETWEEN INPUT DATA VALUES
C  QDATA  - DISCHARGE ARRAY
C  HDATA  - STAGE ARRAY
C  LOCPTR - POINTER ARRAY FOR LOOP RATING CURVE PROGRAM
C  T1     - TIMING ARRAY FOR LOOP RATING CURVE PGM
C  CURVLO - LOWEST RATING CURVE STAGE
C  CURVUP - HIGHEST RATING CURVE STAGE
C  XSECLO - BOTTOM-MOST GIVEN X-SECTION ELEVATION
C  XSECUP - UPPER-MOST GIVEN X-SECTION ELEVATION
C  METHOD - METHOD OF CONVERSION
C           =0, SIMPL INTERPOLATION /EXTRAPOLATION OF RATING CURVE
C           =1, DYNAMIC LOOP
C  FLSTAG - FLOOD STAGE (M) WRT GAGE ZERO
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
C  CARRYO - CARRYOVER ARRAY
C           1ST ELEMENT = PREVIOUS STAGE
C           2ND ELEMENT = PREVIOUS DISCHARGE
C           3RD ELEMENT = DQ (ICONV=1);  DH (ICONV=2)
C           4TH ELEMENT = NUMBER OF MISSING VALUES BETW PREV AND ITSPOS
C  JULDAY - JULIAN DAY(INTERNAL CLOCK) OF INITIAL VALUE TO BE CONVERTED
C  INITHR - HOUR OF INITIAL VALUE TO BE CONVERTED
C  IRCHNG - COMMON BLOCK /FRATNG/ TRANSFER INDICATOR
C           =0, NO CHANGE
C           =1, CALIB. RUN EXCEEDED LAST APPLICABLE DAY OF R.C. IN
C               /FRATNG/ AND TRANSFER FROM SCRATCH FILE WAS MADE
C  IERROR - ERROR FLAG
C           =0, NORMAL RETURN, NO ERRORS
C           =1, ERROR OCCURRED -- OUTPUT TIME SERIES COULD NOT BE FILLED
C  IPRWRN - WARNING MESSAGE FLAG
C           =0, NO MESSAGE PRINTED
C           =1, MESSAGE PRINTED IF Q TO STAGE CONVRSION PRODUCED A STAGE
C               BELOW MIN ALLOWABLE AND STAGE WAS RESET TO MIN ALLOWED.C
C.......................................................................
C
C  ORIGINALLY WRITTEN BY - JONATHAN WETMORE - HRL - 801031
C  MODIFICATIONS:
C   EJV 3/87 - TO ACCOMODATE USGS OFFSETS
C   EAA 5/88 - CLEAN-UP AND CORRECT CARRYOVER UPDATE
C   JML 5/95 - ADD RATING CURVE SHIFT
C   DP 12/98 - ADDED WARNING MESSAGE IF OVER TOP OF RATING CURVE
C.......................................................................
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/where'
      INCLUDE 'common/fprog'
      INCLUDE 'common/fengmt'
      INCLUDE 'common/fratng'
      INCLUDE 'common/facxsc'
      INCLUDE 'common/fxsctn'
      INCLUDE 'common/fchgrc'
      INCLUDE 'common/modrcs'
c      COMMON /RCSHF/ QSHIFT,QORG(100),HORG(100),NRCPTO
c      COMMON /RCNEW/ QMOD(100),HMOD(100),NRCPMD
      INCLUDE 'common/rcshf'
      INCLUDE 'common/rcnew'
C
      CHARACTER*8 RTNNAM,OLDNAM
C
      DIMENSION RCID(2),QDATA(*),HDATA(*),LOCPTR(*),CARRYO(*),T1(*)
      DIMENSION ALLRV(2),AUNIT(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_rc/RCS/fstgq.f,v $
     . $',                                                             '
     .$Id: fstgq.f,v 1.7 2002/02/11 13:31:46 michaelo Exp $
     . $' /
C    ===================================================================
C
      DATA AUNIT/4H FT.,4H M. /
      DATA BLANK/4H    /
      DATA ALLRV/4HALLR,4HC   /
C
C
      IF (ITRACE.GE.1) WRITE (IODBUG,*) 'ENTER FSTGQ'
C
      RTNNAM='FSTGQ'
      IOPNUM=0      
      CALL FSTWHR (RTNNAM,IOPNUM,OLDNAM,IOLDOP)
C
      IBUG=IFBUG('STGQ')
C
      IERROR=0
      NW=0
      NRANGE=0
C
C  IF RATING CURVE ID IS BLANK USE RATING CURVE IN /FRATNG/
      IF (RCID(1).EQ.BLANK.AND.RCID(2).EQ.BLANK) GO TO 120
C
C  CHECK IF RATING CURVE INFO IS AVAILABLE AND IN /FRATNG/.
      IF (RTCVID(1).EQ.RCID(1).AND.RTCVID(2).EQ.RCID(2)) GO TO 30
         WRITE (IPR,20) (RCID(I),I=1,2),(RTCVID(I),I=1,2)
20    FORMAT ('0**ERROR** SPECIFIED RATING CURVE ID (',2A4,
     * ') DOES NOT MATCH THAT IN COMMON BLOCK FRATNG (',2A4,').')
         IERROR=1
         CALL ERROR
         GO TO 370

30    IF (IBUG.EQ.1.AND.NUMRC.GT.0) THEN
         WRITE (IODBUG,40) NUMRC
40    FORMAT (/5X,'====== CONTENTS OF MODRCS COMMON BLOCK ====='/
     .  5X,'NUMBER OF RATING CURVES WITH SHIFTS (NUMRC) =',I5)
         DO 80 I=1,NUMRC
            WRITE (IODBUG,50) I,RCSID(1,I),RCSID(2,I),NSHIFT(I)
50    FORMAT (5X,'R.C. NO. ',I1,':   RCSID=',2A4,3X,'NSHIFT=',I2/
     . 7X,'SHFT NO.  IJHSHF  LJHSHF  ISTYPE',6X,'HNEW',6X,'QNEW',8X,
     . 'HL',8X,'HU')
            DO 70 L=1,NSHIFT(I)
               WRITE (IODBUG,60) L,IJHSHF(L,I),LJHSHF(L,I),ISTYPE(L,I),
     .            HNEW(L,I),QNEW(L,I),HL(L,I),HU(L,I)
60    FORMAT (7X,4I8,F10.2,F10.2,2F10.2)
70          CONTINUE
80       CONTINUE
         ENDIF
C
C  CHECK IF RATING CURVE NEEDS TO BE SHIFTED
      NOSHFT=0
      IF (NUMRC.EQ.0) GO TO 110
      DO 90 I=1,NUMRC
         IF (RCID(1).EQ.RCSID(1,I).AND.RCID(2).EQ.RCSID(2,I)) GO TO 120
         IF (RCSID(1,I).EQ.ALLRV(1).AND.RCSID(2,I).EQ.ALLRV(2)) 
     *      GO TO 120
90       CONTINUE
      WRITE (IPR,100) RCID
100   FORMAT ('0**WARNING** RATING CURVE ID IN COMMON FRATNG (',
     * 2A4,') DOES NOT MATCH ANY OF THE RATING CURVES IN COMMON ',
     *  'MODRCS.' /
     * 13X,'NO RATING CURVE SHIFT WILL BE APPLIED.')
      CALL WARN
110   NOSHFT=1
C
120   IF (NOSHFT.EQ.0) IRCS=I
C
C  THE PROPER RATING CURVE IS IN COMMON FRATNG - FILL ARG LIST WITH DATA
      CURVLO=XRC(LOCH)
      CURVUP=XRC(LOCH-1+NRCPTS)
      XSECLO=-999.
      XSECUP=-999.
      METHOD = 0
      NEEDEX=0
      IF (NCROSS.LE.0) GO TO 130
      XSECLO=XRC(LXELEV)
      XSECUP=XRC(LXELEV-1+NCROSS)
      IF (IFMSNG(FRLOOP).EQ.0) METHOD=1
C
C  PRINT DBUG INFO
130   IF (IBUG.GE.1) WRITE (IODBUG,140) CURVLO,CURVUP,XSECLO,XSECUP,
     1 METHOD,NEEDEX,FLDSTG
140   FORMAT (1H0,5X,7HCURVLO=,F10.2,5X,7HCURVUP=,F10.2,5X,7HXSECLO=,
     1F10.2,5X,7HXSECUP=,F10.2 /5X,7HMETHOD=,I3,5X,7HNEEDEX=,I3,5X,
     1 7HFLDSTG=,F10.2)
C
C  COPY RATING CURVE INTO TEMPORARY SPACE
      NRCPMD=NRCPTS
      NRCPTO=NRCPTS
      DO 150 L=1,NRCPMD
         QMOD(L)=XRC(LOCQ+L-1)
         HMOD(L)=XRC(LOCH+L-1)
         QORG(L)=XRC(LOCQ+L-1)
         HORG(L)=XRC(LOCH+L-1)
150      CONTINUE
      ICHGRC=1
C
C CHECK ICONV; IF ICONV=0, RETURN TO CALLING PGM
      IF (ICONV.LT.1) GO TO 370
C
C  LOCATE LAST POSITION IN T.S. ARRAY
      LASPOS=ITSPOS+NVALS-1
C
      IF (NOSHFT.EQ.1) GO TO 160
      IJULHR=(JULDAY-1)*24+INITHR
      JULHR=IJULHR
160   ICURDA=JULDAY
      IIHR=INITHR
      IRCHNG=0
      IF (IBUG.GE.1) THEN
         WRITE (IODBUG,170) ITSPOS,LASPOS,NVALS,JULHR
170   FORMAT (1H0,5X,7HITSPOS=,I5,5X,7HLASPOS=,I5,5X,6HNVALS=,I5,
     * 5X,6HJULHR=,I10)
         WRITE (IPR,180) RTCVID,RIVERN,RIVSTA,RLAT,RLONG,
     *      FPTYPE,AREAT,AREAL,FLDSTG,FLOODQ,PVISFS,SCFSTG,
     *      WRNSTG,GZERO,NRCPTS,LOCQ,LOCH,STGMIN,NCROSS,LXTOPW,
     *      LXELEV,ABELOW,FLOODN,SLOPE,FRLOOP,SHIFT,OPTION,
     *      LASDAY,IPOPT,RFSTG,RFQ,IRFDAY,RFCOMT,
     *      NOCS,LXELOC,LXTWOC,QMIN,HMIN
180   FORMAT (' CONTENTS OF COMMON FRATNG FOLLOW: ' /
     * 1X,10(9X,1H+) /
     * 1X,2A4,2X,10A4,2F10.2,5A4,3F10.2 /
     * 1X,F10.2,6X,A4,3F10.2,3I10,F10.2,3I10 /
     * 1X,2F10.2,F10.6,2F10.2,6X,A4,2I10,2F10.2 /
     * 1X,I10,5A4,3I10,F10.1,F10.2)
         ENDIF
C  HYDRAULIC EXTENSION OR LOOP RATING USED
C  FIRST MUST DETERMINE THE MANNING N VALUE AND CONVEYANCE COEFFICIENT
C  ASSOC. WITH EACH STAGE
       IF (NCROSS.GT.0) CALL XSARCK(IBUG)
C
C  CAN LOOP RATING BE USED?  IF SO TRANS CONTROL TO LOOP RATING ROUTINE
      IF (METHOD.EQ.0)GO TO 220
      IF (NOSHFT.NE.0) GO TO 200
         WRITE (IPR,190) (RCID(L),L=1,2)
190   FORMAT ('0**WARNING** LOOP RATING CURVE OPTION WAS SELECTED. ',
     *  'NO SHIFTING WILL BE DONE FOR RATING CURVE ',2A4,'.')
         CALL WARN
         NOSHFT=1
200   JEROR=0
      CALL FLOOPR (RCID,ICONV,ITSPOS,NVALS,TSDELT,
     * QDATA,HDATA,LOCPTR,T1,METHOD,NEEDEX,CARRYO,JULDAY,
     * INITHR,IRCHNG,JEROR,IBUG)
      IF (JEROR.EQ.0) GO TO 370
         WRITE (IPR,210) (RCID(L),L=1,2)
210   FORMAT ('0**ERROR** ERROR ENCOUNTERED IN LOOP RATING ROUTINE ',
     * 'FOR RATING CURVE ',2A4,'.')
         CALL ERROR
         IERROR=1
         GO TO 370
C  LOOP RATING NOT USED
220   LOWEXT=0
      IUPEXT=0
C
C  HYDRAULIC EXTENSION USED
C
      IF (NOSHFT.EQ.0) ISHF=1
      IUNSHF=0
      JSHF=0
      DO 360 I=ITSPOS,LASPOS
      ORGQ=QDATA(I)
C
C  CHECK TO SEE IF LAST APPLICABLE DAY HAS BEEN EXCEEDED WHEN 
C  RUNNING CALIBRATION PROGRAM
      IF (MAINUM.LT.3) GO TO 270
      IF (LASDAY.EQ.0) GO TO 270
      ITIME=IIHR+IFIX(TSDELT)
      IF (ITIME/24) 270,270,230
230   ICURDA=ICURDA+1
      IIHR=IIHR-24
      IF (ICURDA.LE.LASDAY) GO TO 270
      IRCHNG=1
      IF (IBUG.GE.1) WRITE (IODBUG,240) ICURDA,LASDAY
240   FORMAT (1H0,5X,40H/FRATNG/ COMMON BLOCK TRANSFER NECESSARY /5X,
     113HCURRENT DAY: ,I10,5X,24HLAST APPLIC. DAY OF RC: ,I10)
      IERR=0
      CALL FGETRC (RCID,IERR)
C
C  IF NO ERROR ENCOUNTERED BY FGETRC, MUST GO BACK AND RECOMPUTE
C  MANNING'S N'S BASED ON NEW RATING CURVE DATA
      IF (IERR.EQ.0.AND.NCROSS.GE.2) CALL XSARCK (IBUG)
      IF (IERR.NE.0) THEN
         WRITE (IPR,250) ICURDA,I
250   FORMAT ('0**ERROR** ERROR ENCOUNTERED IN FGETRC. '
     * 'CURRENT DATE = ',I6,' TIME SERIES POSITION = ',I4)
         CALL ERROR
         IERROR=1
         GO TO 370
         ENDIF
C
C  IF NEW RATING CURVE HAS BEEN READ IN WILL NEED TO RECHECK WHETHER
C  HYDRAULIC EXTENSION MAY BE USED
C
C  CHECK TO SEE IF THE RATING CURVE NEEDS TO BE ADJUSTED
270   IF (NOSHFT.NE.0) GO TO 300
      IF (IBUG.GE.1) WRITE (IODBUG,280) IUNSHF,JSHF,ISHF,NOSHFT,NRCPTS,
     .NRCPTO,NRCPMD
280   FORMAT (10X,'    IUNSHF      JSHF      ISHF    NOSHFT    NRCPTS
     .NRCPTO    NRCPMD'/10X,7I10)
      IF (JULHR.GE.IJHSHF(ISHF,IRCS).AND.JULHR.LE.LJHSHF(ISHF,IRCS))
     * GO TO 290
      IUNSHF=IUNSHF+1
      IF (IUNSHF.GT.1) GO TO 300
      IF (JULHR.LT.IJHSHF(ISHF,IRCS).AND.ISHF.EQ.1) THEN
        QSHIFT=0.
        GO TO 300
      ENDIF
CC    CALL FUNSRC(XRC(LOCH),XRC(LOCQ),ISTYPE(ISHF,IRCS),NRCPTS,IBUG)
      CALL FUNSRC(HMOD,QMOD,ISTYPE(ISHF,IRCS),NRCPMD,IBUG)
      ISHF=ISHF+1
      JSHF=0
      IF (ISHF.GT.NSHIFT(IRCS)) NOSHFT=2
      GO TO 270

290   JSHF=JSHF+1
      IF (JSHF.EQ.1) CALL FSHFRC(IBUG,NEEDEX,LOWEXT,IUPEXT,NW,NRANGE,
     * MISING,CARRYO,ISTYPE(ISHF,IRCS),EMPTY(4),HMOD,QMOD,NRCPMD,
     * HNEW(ISHF,IRCS),QNEW(ISHF,IRCS),HL(ISHF,IRCS),HU(ISHF,IRCS))
      IUNSHF=0
C
C  MAKE CONVERSION
300   QSHFT=QDATA(I)
      IF (ICONV.NE.2) GO TO 310
      IF (IFMSNG(QSHFT).EQ.1) GO TO 310
      IF (NOSHFT.NE.0) GO TO 310
      IF (ABS(QSHIFT).LE.0.0001) GO TO 310
      IF (ISTYPE(ISHF,IRCS).EQ.0) QSHFT=QSHFT-QSHIFT
      IF (ISTYPE(ISHF,IRCS).EQ.1) QSHFT=QSHFT/QSHIFT
310   CONTINUE

cfan2007 
c    DR18437: IFP halts When a value largely out of range is met 
c 
      iwarn=0
      if (hdata(I).gt.curvup*3. .and. iconv.eq.1) then
       iwarn=1
       oldhdata=hdata(I)
       hdata(I)=curvup
      endif
cfan2007

      CALL FHQS1(HDATA(I),QSHFT,ICONV,IBUG,NEEDEX,LOWEXT,IUPEXT,
     1   NW,NRANGE,MISING,CARRYO)
      IF (MISING.EQ.1) GO TO 320
      IF (NOSHFT.NE.0) GO TO 320
      IF (ABS(QSHIFT).LE.0.0001) GO TO 320
      IF (ICONV.EQ.1.AND.ISTYPE(ISHF,IRCS).EQ.0) QSHFT=QSHFT+QSHIFT
      IF (ICONV.EQ.1.AND.ISTYPE(ISHF,IRCS).EQ.1) QSHFT=QSHFT*QSHIFT
C
C  INCREMENT R.C. TIME (JULIAN HOURS)
320   IF (NOSHFT.NE.1) JULHR=JULHR+IFIX(TSDELT)
C
       QDATA(I)=QSHFT

cfan2007
c    DR18437: IFP halts When a value largely out of range is met 
c
       if (iwarn .eq. 1) then
         QDATA(I)=QSHFT*3.
         WRITE (IPR,325) oldhdata, curvup, RCID, qdata(I)
325   FORMAT ('0**WARNING** STAGE VALUE ',F8.3, ' HAS BEEN '
     * 'EXTRAPOLATED TOO FAR BEYOND THE MAXIMUM VALUE OF THE RATING '
     + 'CURVE',F8.3, ' for ', 2A4,'. THE DISCHARGE WILL BE SET TO ',
     +  F8.3,'.')
         CALL WARN
       endif
cfan2007

       IF (IBUG.GE.1) WRITE (IODBUG,330) I,HDATA(I),QDATA(I),QSHFT
330    FORMAT (1H0,2X,14HT.S. POSITION:,I4,2X,9HHDATA(I)=,F10.2,
     1  2X,9HQDATA(I)=,F10.0,2X,'QSHFT=',F10.0)
C
C  UPDATE CARRYOVER
      IF (MISING.EQ.1) GO TO 340
C
C  H AND Q ARE AVAILABLE
      IF (ICONV.EQ.1) CARRYO(3)=(QDATA(I)-CARRYO(2))/(CARRYO(4)+1.0)
      IF (ICONV.EQ.2) CARRYO(3)=(HDATA(I)-CARRYO(1))/(CARRYO(4)+1.0)
      CARRYO(1)=HDATA(I)
      CARRYO(2)=QDATA(I)
      CARRYO(4)=0.0
      GO TO 350
C
C  H AND Q ARE MISSING
340   CARRYO(4)=CARRYO(4)+1.0
C
350   IF (ICONV.EQ.2) QDATA(I)=ORGQ
360   CONTINUE
C
      IF (NOSHFT.EQ.1) GO TO 370
         ISHF=NSHIFT(IRCS)
         IF (ISTYPE(ISHF,IRCS).EQ.2) THEN
            CALL FUNSRC (HMOD,QMOD,ISTYPE(ISHF,IRCS),NRCPMD,IBUG)
            ENDIF
         NRCPTS=NRCPTO
         ICHGRC=0
370   IF (NRANGE.LT.1) GO TO 390
      IF (ICONV.EQ.1) WRITE (IPR,380) NRANGE,'DISCHARGE','INPUT',RTCVID
      IF (ICONV.EQ.2) WRITE (IPR,380) NRANGE,'STAGE','COMPUTED',RTCVID
380   FORMAT ('0**WARNING** ',I4,' ',A,' VALUES COMPUTED BY ',
     *  'THE HYDRAULIC RATING CURVE EXTENSION ROUTINE MAY BE ',
     *  'INCORRECT.' /
     * 13X,'MANNING N ASSOCIATED WITH THE ',A,' STAGES WERE OUTSIDE ',
     *  'THE RANGE 0.015 < N < 0.15 AND THE N VALUE WAS RESET TO ' /
     * 13X,'THE CLOSEST END POINT OF THAT RANGE BEFORE COMPUTATIONS ',
     *  'CONTINUED.' /
     * 13X,'YOU MAY WANT TO ADJUST THE CROSS SECTIONAL DATA ',
     *  'AND REDEFINE RATING CURVE ',2A4,'.')
       CALL WARN
C
390   IF (NW.GT.0) THEN
         IF (ICONV.EQ.2.AND.IPRWRN.EQ.0) GO TO 440
         XSTDAT=STGMIN
         IF (METRIC.EQ.0) THEN
C        CONVERT TO ENGLISH UNITS
            CALL FCONVT ('M   ','L   ',IENGUN,XMULT,XDUM,IDUM)
            XSTDAT=XSTDAT*XMULT
            ENDIF
         IF (ICONV.EQ.1) THEN
            WRITE (IPR,400) NW,'INPUT TO',XSTDAT,AUNIT(METRIC+1)
            CALL WARN
            ENDIF
         IF (ICONV.EQ.2) THEN
            WRITE (IPR,400) NW,'COMPUTED BY',XSTDAT,AUNIT(METRIC+1)
            CALL WARN
            ENDIF
400   FORMAT ('0**WARNING** ',I4,' STAGE VALUES ',A,' THE ',
     *  'STAGE TO DISCHARGE CONVERSION ROUTINE WERE LESS THAN THE ',
     *  'MINIMUM ALLOWED' /
     * 13X,'AND HAVE BEEN SET TO ',F8.3,A4)
        ENDIF
C
440   IF (NEEDEX.GE.1.AND.NEEDEX.LE.6.AND.IUPEXT.EQ.1) THEN
         WRITE (IPR,450) RCID
450   FORMAT ('0**WARNING** STAGE/DISCHARGE VALUES HAVE BEEN '
     * 'EXTRAPOLATED ABOVE THE TOP OF RATING CURVE ', 2A4,'.')
         CALL WARN
         ENDIF
C
      CALL FSTWHR (OLDNAM,IOLDOP,OLDNAM,IOLDOP)
C
      IF (ITRACE.GE.1) WRITE (IODBUG,*) 'EXIT FSTGQ'
      
c      
      if (NOSHFT.eq.1) then 
        iqcqp = 0
      else
        iqcqp = 1
      endif
C
      RETURN
C
      END

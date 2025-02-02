C     MODULE MZRODF
C----------------------------------------------------------------------
C
C     DESC - THIS SUBROUTINE PERFORMS THE ZERODIF MOD
C
      SUBROUTINE MZRODF(MP,P,MC,C,NCARDS,MODCRD,IIDATE,IHZERO)
C
      LOGICAL FIRST
      CHARACTER*8 OPNAME,OPN,BLANK8
C
      INCLUDE 'ufreex'
      INCLUDE 'common/ionum'
      INCLUDE 'common/fctime'
      INCLUDE 'common/fctim2'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fpwarn'
      INCLUDE 'common/fmodft'
C
      DIMENSION P(MP),C(MC),IFIELD(3)
      DIMENSION OLDOPN(2),MODCRD(20,NCARDS)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_mods/RCS/mzrodf.f,v $
     . $',                                                             '
     .$Id: mzrodf.f,v 1.2 1998/07/02 21:01:16 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA ISLASH/4H/   /,BLANK8/'        '/
C
C  INITIALIZE VARIABLE
C
      CZERO=0.0
      IDATE=IABS(IIDATE)
C
      CALL FSTWHR(8HMZRODF  ,0,OLDOPN,IOLDOP)
C
C  SET DEBUG SWITCH
C
      IBUG=IFBUG(4HMODS)+IFBUG(4HZERO)
C
      IF (IBUG.GT.0) WRITE(IODBUG,10) IDATE
10    FORMAT(1H0,10X,'**** SUBROUTINE MZRODF ENTERED ****, IDATE=',I11)
C
      ISTATT=1
C
C  SEE IF DATE IS WITHIN RUN PERIOD
C
      ISTHR=(IDA-1)*24+IHZERO
      IENHR=(LDA-1)*24+LHR
C
      IMATCH=0
      IF (ISTHR.LE.IDATE.AND.IENHR.GE.IDATE) THEN
         IF (IDATE.EQ.ISTHR) GOTO 40
         IMATCH=1
         ENDIF
C
C  DATE NOT WITHIN ALLOWABLE WINDOW
C
      CALL MDYH2(IDA,IHZERO,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
      CALL MDYH2(LDA,LHR,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
      IXDA=IDATE/24+1
      IXHR=IDATE-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM3,ID3,IY3,IH3,DUM1,DUM2,MODTZC)
C
      IF (MODWRN.EQ.1.AND.IMATCH.EQ.1) THEN
         WRITE(IPR,20)IM3,ID3,IY3,IH3,MODTZC,IM1,ID1,IY1,IH1,MODTZC
         CALL WARN
         GOTO 260
         ENDIF
20    FORMAT(1H0,10X,'**WARNING** THE DATE FOR CHANGES ENTERED IN THE ',
     1 'ZERODIFF MOD (',I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/11X,
     2 'DOES NOT MATCH THE START TIME OF THE RUN (',I2,1H/,I2,
     3 1H/,I4,1H-,I2,1X,A4,1H),/,11X,'THESE CHANGES WILL BE IGNORED.')
C
      IF(MODWRN.EQ.1)
     .WRITE(IPR,30)IM3,ID3,IY3,IH3,MODTZC,IM1,ID1,IY1,IH1,MODTZC,
     1IM2,ID2,IY2,IH2,MODTZC
30    FORMAT(1H0,10X,'**WARNING** THE DATE FOR CHANGES ENTERED IN THE ',
     1 'ZERODIFF MOD (',I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/11X,
     2 'IS NOT WITHIN THE CURRENT RUN PERIOD (',I2,1H/,I2,
     3 1H/,I4,1H-,I2,1X,A4,4H TO ,I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/
     4 11X,'THESE CHANGES WILL BE IGNORED.')
      IF (MODWRN.EQ.1) CALL WARN
      GO TO 260
C
40    CONTINUE
C
C     READ CARD - IF COMMAND, LEAVE - IF COMMAND AND 1ST CARD, ERROR
C
      OPNAME=BLANK8
      OPN=BLANK8
      FIRST=.TRUE.
C
      IF(NRDCRD.EQ.NCARDS) GOTO 60
C
50    IF(NRDCRD.EQ.NCARDS) GOTO 260
C
      IF(MISCMD(NCARDS,MODCRD).EQ.0) GOTO 80
C
      IF(.NOT.FIRST)GO TO 260
C
C     HAVE FOUND COMMAND AS FIRST SUBSEQUENT CARD - ERROR
C
60    IF (MODWRN.EQ.1) WRITE(IPR,70)
70    FORMAT(1H0,10X,'**WARNING** NO SUBSEQUENT CARDS FOUND FOR THE ',
     1  'ZERODIF MOD.  PROCESSING CONTINUES')
      IF (MODWRN.EQ.1) CALL WARN
      GOTO 260
C
80    FIRST=.FALSE.
      NRDCRD=NRDCRD+1
C
C     LOOK FOR ADJUST-Q OPERATIONS IN THIS SEGMENT WITH NAME OPNAME
C     IF OPNAME BLANK - CHANGE FOR ALL ADJUST-Q OPERS IN THIS SEGMENT
C
C     READ NEXT FIELD - IF NONE CHANGE ALL ADJUST-Q OPERS IN SEGMENT
C     IF A SLASH FOUND - READ OPERATION NAME IN FOLLOWING FIELD
C
      NFLD=1
      ISTRT=-3
      NCHAR=3
      ICKDAT=0
C
      CALL UFIEL2(NCARDS,MODCRD,NFLD,ISTRT,LEN,ITYPE,NREP,INTEGR,REAL,
     1  NCHAR,IFIELD,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,ISTAT)
C
      IF(ISTRT.EQ.-2)GO TO 200
C
C     FIELD FOUND - MUST BE A SLASH
C
      IF (LEN.EQ.1.AND.IFIELD(1).EQ.ISLASH) GOTO 100
C
C     FIELD IS NOT SLASH - ERROR
C
      IF (MODWRN.EQ.1) WRITE(IPR,90) (MODCRD(I,NRDCRD),I=1,20)
90    FORMAT(1H0,10X,'**WARNING** A SLASH WAS EXPECTED ON THE SECOND ',
     1 'FIELD OF THE INPUT CARD.  THIS CARD WILL BE IGNORED.',/,11X,
     2 'THE CURRENT CARD IMAGE IS : ',20A4)
      IF (MODWRN.EQ.1) CALL WARN
      GO TO 50
C
100   CONTINUE
C
C     SLASH FOUND - NOW READ OPERATION NAME
C
      ISTRT=-3
      NCHAR=2
      ICKDAT=0
C
      CALL UFIEL2(NCARDS,MODCRD,NFLD,ISTRT,LEN,ITYPE,NREP,INTEGR,REAL,
     1  NCHAR,OPNAME,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,ISTAT)
C
      IF(ISTRT.NE.-2)GO TO 120
C
C     NO FIELD FOUND FOR OPERATION NAME - ERROR
C
      IF (MODWRN.EQ.1) WRITE(IPR,110) (MODCRD(I,NRDCRD),I=1,20)
110   FORMAT(1H0,10X,'**WARNING** NO OPERATION NAME WAS FOUND AFTER ',
     1 'THE SLASH.  THIS CARD WILL BE IGNORED.',/,11X,'THE CURRENT ',
     2 'CARD IMAGE IS : ',20A4)
      IF (MODWRN.EQ.1) CALL WARN
      GO TO 50
C
C     HAVE A SPECIFIC OPERATION NAME - FIND THAT OPERATION
C
120   LOCP=0
      CALL FSERCH(14,OPNAME,LOCP,P,MP)
C
      IF (LOCP.GT.0) GOTO 140
C
C     HAVE NOT FOUND THE REQUESTED OPERATION - ERROR
C
      IF (MODWRN.EQ.1) WRITE(IPR,130) OPNAME,(MODCRD(I,NRDCRD),I=1,20)
130   FORMAT(1H0,10X,'**WARNING** A ADJUST-Q OPERATION WITH NAME ',
     1 A8,' HAS NOT BEEN FOUND.  THIS CARD WILL BE IGNORED.'/11X,
     2 'THE CURRENT CARD IMAGE IS : ',20A4)
      IF (MODWRN.EQ.1) CALL WARN
      GO TO 50
C
140   CONTINUE
C
C     HAVE FOUND OPERATION - CHANGE VALUE IN P ARRAY
C
      LC=LOCP-1
      IF ((LC.GT.0).AND.(P(LC).GT.0)) GOTO 160
C
C     POINTER VALUE IN P(LOCP-1) LE ZERO - CANNOT USE ZERODIFF
C
      IF (MODWRN.EQ.0) GOTO 50
      WRITE(IPR,150) P(LC),OPNAME,(MODCRD(I,NRDCRD),I=1,20)
150   FORMAT(1H0,10X,'**WARNING** IN ZERODIF MOD - POINTER VALUE IN ',
     1 'LOCATION P(LOCP-1) IS ',G10.3,' IN ADJUST-Q OPERATION ',A8,/,
     2 11X,'THE CURRENT CARD IMAGE IS : ',20A4)
      CALL WARN
      GOTO 50
C
C     RESET ADJUST-Q CARRYOVER AT START OF RUN
C
160   IDT=P(LOCP+11)
      ICPOS=P(LC)
      IF (IDT .GT. 0) GOTO 180
      WRITE (IPR,170) IDT,OPNAME,(MODCRD(I,NRDCRD),I=1,20)
170   FORMAT(1HO,10X,'**WARNING** IN ZERODIFF MOD - POINTER VALUE IN ',
     1'LOCATION PADJ(12) IS ',I4,' IN ADJUST-Q OPERATION ',A8,/,11X,
     2'THE CURRENT CARD IMAGE IS : ',20A4)
      CALL WARN
      GOTO 50
180   N=(24/IDT)+1
      C(ICPOS+N+0)=CZERO
      C(ICPOS+N+1)=CZERO
      C(ICPOS+N+2)=CZERO
      ISTATT=0
C
      J1=ICPOS+N+0
      J2=ICPOS+N+1
      J3=ICPOS+N+2
      IF (IBUG.GT.0) WRITE(IODBUG,190) CZERO,J1,J2,J3,OPNAME
190   FORMAT(11X,'IN SUBROUTINE MZRODF - A VALUE OF ',F4.1, ' HAS ',
     1'BEEN STORED IN LOCATION ',I5,1X,I5,1X,I5,' OF THE C ARRAY FOR ',
     2 'OPERATION ',A8)
      GOTO 50
C
200   CONTINUE
C
C     CHANGE ALL OCCURENCES OF ADJUST-Q OPERATION IN THIS SEGMENT
C
      NCHNGE=0
      LOCP=1
210   CALL FSERCH(14,OPN,LOCP,P,MP)
C
      IF (LOCP.EQ.0.AND.NCHNGE.GT.0) GOTO 50
      IF (LOCP.GT.0) GOTO 230
C
C     IF GET HERE HAVE NOT FOUND ANY ADJUST-Q OPERATIONS IN THIS SEGMENT
C
      IF (MODWRN.EQ.1) WRITE(IPR,220) (MODCRD(I,NRDCRD),I=1,20)
220   FORMAT(1H0,10X,'**WARNING** A ZERODIFF MOD WAS REQUESTED FOR ',
     1 'THIS SEGMENT BUT NO ADJUST-Q OPERATIONS WERE FOUND.',/,11X,
     2 'THE CURRENT CARD IMAGE IS : ',20A4)
      IF (MODWRN.EQ.1) CALL WARN
      GOTO 260
C
230   CONTINUE
C
C     HAVE FOUND A ADJUST-Q OPERATION - CHANGE P ARRAY
C
      LC=LOCP-1
      IF ((LC.GT.0).AND.(P(LC).GT.0)) GOTO 240
C
C     VALUE IN P(LC) LE ZERO - CANNOT USE ZERODIFF
C
      IF (MODWRN.EQ.0) GOTO 210
      WRITE(IPR,150)P(LC),OPN
      CALL WARN
      GOTO 210
C
C     RESET ADJUST-Q CARRYOVER AT START OF RUN
C
240   IDT=P(LOCP+11)
      ICPOS=P(LC)
      IF (IDT.GT.0) GOTO 250
      WRITE(IPR,170) IDT,OPN
      CALL WARN
      GOTO 50
250   NCHNGE=NCHNGE+1
      N=(24/IDT)+1
      C(ICPOS+N+0)=CZERO
      C(ICPOS+N+1)=CZERO
      C(ICPOS+N+2)=CZERO
      ISTATT=0
C
      J1=ICPOS+N+0
      J2=ICPOS+N+1
      J3=ICPOS+N+2
      IF (IBUG.GT.0) WRITE(IODBUG,190) CZERO,J1,J2,J3,OPN
      GOTO 210
C
260   CALL FSTWHR(OLDOPN,IOLDOP,OLDOPN,IOLDOP)
      IF (IBUG.GT.0) WRITE(IODBUG,270)
270   FORMAT(11X,'*** LEAVING MZRODF ***')
C
      RETURN
      END

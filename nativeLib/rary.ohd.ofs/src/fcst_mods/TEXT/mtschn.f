C MEMBER MTSCHN
C-----------------------------------------------------------------------
C                             LAST UPDATE: 07/06/95.14:54:16 BY $WC21DT
C
C @PROCESS LVL(77)
C
C     DESC - THIS SUBROUTINE PERFORMS THE TSCHNG MOD
C
      SUBROUTINE MTSCHN(MTS,TS,MD,D,NCARDS,MODCRD,IIDATE,LLDATE,
     1  NXTOPN,NXTNAM,IHZERO)
C
      LOGICAL FIRST
      CHARACTER*8 OPTYPE,OPNAME,NXTNAM,MODNAM
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fctime'
      INCLUDE 'common/fctim2'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fpwarn'
      INCLUDE 'common/fmodft'
      INCLUDE 'common/modctl'
C
      DIMENSION TS(MTS),D(MD),VALUES(744),TSID(2),TEMP1(744)
      DIMENSION OLDOPN(2),MODCRD(20,NCARDS)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob81/ohd/ofs/src/fcst_mods/RCS/mtschn.f,v $
     . $',                                                             '
     .$Id: mtschn.f,v 1.7 1997/09/22 17:44:54 page Exp jgofus $
     . $' /
C    ===================================================================
C
C
      DATA MODNAM/'TSCHNG  '/
C
      CALL FSTWHR(8HMTSCHN  ,0,OLDOPN,IOLDOP)
C
C     SET DEBUG FLAG
C
      IBUG=IFBUG(4HMODS)+IFBUG(4HTSCH)
C
      IF(IBUG.GT.0)WRITE(IODBUG,10) IIDATE
10    FORMAT(11X,'*** SUBROUTINE MTSCHN ENTERED *** IIDATE = ',I10)
C
      IPRWRN=0
      IF (IWHERE.LE.1 .AND. MODWRN.EQ.1) IPRWRN=1
      FIRST=.TRUE.
      IDATE=IABS(IIDATE)
      LDATE=IABS(LLDATE)
C
C   CHECK IF DATE IS LESS THAN OR EQUAL TO LASTCMPDATE OR LSTCMPDY VALUE
C
      ICOMP=((LDACPD-1)*24)+LHRCPD
cc      IF ((IDATE.LE.LDATE).OR.(IDATE.LE.ICOMP)) GOTO 20
cc      IF (LDATE.EQ.ICOMP) GOTO 20
      IF (LDATE.GE.ICOMP) GOTO 20
      IF (IDATE.LE.LDATE) GOTO 20
         IF (IPRWRN.EQ.0) GOTO 290
         ITYPE=6
         CALL MODS1(NCARDS,ICMND,MODNAM,MODCRD,ITYPE)
         GOTO 290
C
C     SEE IF DATE IS WITHIN RUN PERIOD
C
20    ISTHR=(IDA-1)*24+IHZERO
      IENHR=(LDA-1)*24+LHR
C
C      IF(IENHR.GE.IDATE.AND.ISTHR.LE.IDATE)GO TO 40
cc      IF(IENHR.GE.IDATE) GOTO 40
      IF(LDATE.LE.ISTHR) GO TO 25
      IF(IENHR.LE.IDATE) GO TO 29
      GO TO 40
C
C     START DATE FOR CHANGES AFTER ALLOWABLE WINDOW
C
25    CALL MDYH2(IDA,IHZERO,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
cc      CALL MDYH2(LDA,LHR,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
      IXDA=IDATE/24+1
      IXHR=IDATE-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM3,ID3,IY3,IH3,DUM1,DUM2,MODTZC)
      IF(IPRWRN.EQ.0)GO TO 290
      WRITE(IPR,26)IM3,ID3,IY3,IH3,MODTZC,IM1,ID1,IY1,IH1,MODTZC
 26   FORMAT(1H0,10X,'**WARNING** THE VALID DATE FOR ',
     1 'TSCHNG MOD (',I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/11X,
     2 'IS AT OR BEFORE START RUN PERIOD (',I2,1H/,I2,
     3 1H/,I4,1H-,I2,1X,A4,1H),' CHANGES ARE IGNORED.')
      CALL WARN
      GO TO 290
 29   IF(IPRWRN.EQ.0)GO TO 290

      CALL MDYH2(LDA,IHZERO,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
      LXDA=LDATE/24+1
      LXHR=LDATE-(LXDA-1)*24
      IF(LXHR.EQ.0)LXDA=LXDA-1
      IF(LXHR.EQ.0)LXHR=24
      CALL MDYH2(LXDA,LXHR,IM3,ID3,IY3,IH3,DUM1,DUM2,MODTZC)
      IF(IPRWRN.EQ.0)GO TO 290
C
cc      WRITE(IPR,30)IM3,ID3,IY3,IH3,MODTZC,IM1,ID1,IY1,IH1,MODTZC,
cc     1IM2,ID2,IY2,IH2,MODTZC
cc30    FORMAT(1H0,10X,'**WARNING** THE STARTING DATE FOR CHANGES ',
cc     1 'ENTERED IN THE ',
cc     1 'TSCHNG MOD (',I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/11X,
cc     2 'IS NOT WITHIN THE CURRENT RUN PERIOD (',I2,1H/,I2,
cc     3 1H/,I4,1H-,I2,1X,A4,4H TO ,I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/
cc     4 11X,'THESE CHANGES WILL BE IGNORED.')
      WRITE(IPR,30)IM3,ID3,IY3,IH3,MODTZC,IM1,ID1,IY1,IH1,MODTZC
 30   FORMAT(1H0,10X,'**WARNING** THE VALID DATE FOR ',
     1 'TSCHNG MOD (',I2,1H/,I2,1H/,I4,1H-,I2,1X,A4,1H)/11X,
     2 'IS AFTER END OF RUN PERIOD (',I2,1H/,I2,
     3 1H/,I4,1H-,I2,1X,A4,1H),' CHANGES ARE IGNORED.')
      CALL WARN
      GO TO 290
C
C     CALL SUBROUTINE TO READ INFO FOR CHANGING ONE TIME SERIES
C
40    MXVALS=744
C
50    CALL MRDA2(NCARDS,MODCRD,TSID,DTYPE,IDT,
     1 MXVALS,NVALS,VALUES,KEY,OPTYPE,OPNAME,ISTAT)
C
      IF(IBUG.GT.0)WRITE(IODBUG,60)TSID,DTYPE,IDT,MXVALS,NVALS,KEY,
     1OPTYPE,OPNAME,ISTAT
60    FORMAT(11X,'BACK FROM MRDA2'/11X,'TSID,DTYPE,IDT,MXVALS,NVALS,',
     1 'KEY, OPTYPE, OPNAME, ISTAT ='/9X,2A4,1X,A4,I3,I7,I6,I4,1X,A8,
     2 1X,A8,I5)
      IF(IBUG.GT.0.AND.NVALS.GT.0.AND.ISTAT.NE.-1)WRITE(IODBUG,70)
     1(VALUES(I),I=1,NVALS)
70    FORMAT(11X,'VALUES='/(11X,10G10.2))
C
      IF(ISTAT.EQ.0)GO TO 90
      IF(ISTAT.EQ.1)GO TO 50
      IF(.NOT.FIRST)GO TO 290
C
      IF(IPRWRN.EQ.0)GO TO 290
      WRITE(IPR,80)
80    FORMAT(1H0,10X,'**WARNING** NO SUBSEQUENT CARDS FOUND FOR ',
     1  'TSCHNG MOD')
      CALL WARN
      GO TO 290
C
90    CONTINUE 
C
      IF(IBUG.LT.1)GO TO 120
C
      WRITE(IODBUG,100)IDATE,TSID,DTYPE,IDT,NVALS,KEY,OPTYPE,OPNAME
100   FORMAT(11X,'IN SUBROUTINE MTSCHN - TSCHNG MOD'/11X,
     1 'IDATE, TSID, DTYPE, IDT, NVALS, KEY, OPTYPE, OPNAME ='/5X,
     1 I11,1X,2A4,1X,A4,1X,I3,1X,I3,1X,I3,1X,A8,1X,A8)
      IF(NVALS.GT.0)WRITE(IODBUG,110)(VALUES(I),I=1,NVALS)
110   FORMAT(11X,'VALUES ='/(11X,10G9.2))
C
120   CONTINUE
C
      IF (IDATE.GT.ISTHR) GOTO 123
      NDEL=(ISTHR-IDATE+(IDT/2))/IDT+1
      IDATE=ISTHR
      IF(NDEL.LT.NVALS) GO TO 1201
      NDEL=NVALS
      NVALS=0
      GO TO 1221
 1201 DO 121 III=1,MXVALS
         TEMP1(III)=0.0
121   CONTINUE
      JJ=0
      DO 122 IIII=NDEL+1,NVALS
         TEMP1(JJ+1)=VALUES(IIII)
         JJ=JJ+1
122   CONTINUE
C
      CALL UMEMOV(TEMP1,VALUES,MXVALS)
      NVALS=JJ
C
C     IF (MODWRN.EQ.0) GOTO 123
C
 1221 IXDA=(IABS(IIDATE)/24)+1
      IXHR=IABS(IIDATE)-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
c
      CALL MDYH2(IDA,IHZERO,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
      IF(IPRWRN.EQ.0) GOTO 4442
c
      WRITE(IPR,444)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC
444   FORMAT(1H0,10X,'** WARNING ** IN TSCHNG MOD - START DATE (',I2,
     1 '/',I2,'/',I4,'-',I2,1X,A4,') IS AT OR BEFORE START RUN DATE (',
     2 I2,'/',I2,'/',I4,'-',I2,1X,A4,')')
      IF(NDEL.GE.1) WRITE(IPR,4441) NDEL
 4441 FORMAT(1H0,25X,'THE FIRST ',I2,' VALUE(S)',
     & ' AT OR BEFORE START DATE ON THE MOD CARD ARE IGNORED.')
      IF(NVALS.GE.1) CALL WARN
 4442 IF (NVALS.GE.1) GOTO 123
C
      IF(IPRWRN.EQ.0) GOTO 290
cc      IF(LDATE.LT.ISTHR) THEN
cc        IDATE=IABS(IIDATE)
cc        GOTO 25
cc        ENDIF 
      WRITE(IPR,131)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC 
131   FORMAT(1H0,10X,'** WARNING ** IN TSCHNG MOD - THERE ARE NO ',
     1'VALUES AFTER RESETTING THE START DATE ON THE MOD CARD (',I2,
     2'/',I2,'/',I4,'-'I2,1X,A4,')',/,25X,'TO THE STARTRUN ',
     3'TECHNIQUE (',I2,'/',I2,'/',I4,'-',I2,1X,A4,')')
      CALL WARN
      GOTO 290
C
123   CONTINUE
      IF (LDATE.GE.ICOMP) GOTO 128
C
cc      NOFF=(ICOMP-LDATE+(IDT/2))/IDT
c jgg changed the next line to fix hsd r27-9  2/06
c jgg      NKEEP=(LDATE-IDATE+(IDT/2))/IDT 
      NKEEP=((LDATE-IDATE+(IDT/2))/IDT)+1
c jgg end fix      
      if (ldate.eq.idate.and.nvals.eq.1) goto 128
      IF(NKEEP.GE.NVALS) NKEEP=NVALS
cc      DO 125 LL=1,MXVALS
cc         TEMP1(LL)=0.0
cc125   CONTINUE
cc      DO 126 MM=1,NOFF
cc         TEMP1(MM)=VALUES(MM)
cc126   CONTINUE
C
cc      CALL UMEMOV(TEMP1,VALUES,MXVALS)
cc      NVALS=NOFF
      NOFF=NVALS-NKEEP
      NVALS=NKEEP
      IXDA=ICOMP/24+1
      IXHR=ICOMP-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM1,ID1,IY1,IH1,DUM1,DUM2,MODTZC)
      IXDA=LDATE/24+1
      IXHR=LDATE-(IXDA-1)*24
      IF(IXHR.EQ.0)IXDA=IXDA-1
      IF(IXHR.EQ.0)IXHR=24
      CALL MDYH2(IXDA,IXHR,IM2,ID2,IY2,IH2,DUM1,DUM2,MODTZC)
      IF(IPRWRN.EQ.0) GOTO 1272
      WRITE(IPR,127)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC
127   FORMAT(1H0,10X,'** WARNING ** IN TSCHNG MOD - LSTCMPDY (',I2,'/',
     1  I2,'/',I4,'-',I2,1X,A4,') IS BEYOND VALID DATE (',I2,'/',I2,
     2  '/',I4,'-',I2,1X,A4,')')
      IF(NOFF.GE.1) WRITE(IPR,1271) NOFF
 1271 FORMAT(1H0,25X,
     & 'THE ',I2,' VALUE(S) AFTER VALID DATE ARE IGNORED.')
      IF(NVALS.GE.1) CALL WARN
 1272 IF(NVALS.GE.1) GO TO 128
      IF(IPRWRN.EQ.0) GOTO 290
cc      IF(LDATE.LT.ISTHR) THEN
cc        IDATE=IABS(IIDATE)
cc        GOTO 25
cc        ENDIF 
      WRITE(IPR,131)IM1,ID1,IY1,IH1,MODTZC,IM2,ID2,IY2,IH2,MODTZC 
      CALL WARN
      GOTO 290
C
128   IF(IBUG.LT.1) GOTO 129
      WRITE(IODBUG,70) (VALUES(I),I=1,NVALS)
C
129   CONTINUE
C
      FIRST=.FALSE.
C
      CALL MCHKTS(8HTSCHNG  ,TSID,DTYPE,IDT,KEY,MTS,TS,
     1 OPTYPE,OPNAME,NXTOPN,NXTNAM,IBUG,
     2 UNITS,DIMS,LOCD,MISALW,NVPDT,ISTATT)
C
      IF(ISTATT.EQ.1)GO TO 50
C
C     CHECK TIME PERIOD AGAINST RUN PERIOD - PRINT WARNING ONLY IF
C     ENTIRE PERIOD BEING CHANGED IS OUTSIDE OF RUN PERIOD
C
C     IF START HOUR NOT ENTERED - USE DEFAULT VALUE OF 12Z
C     IF START HOUR ENTERED - SET TO CLOSEST DT OF TIME SERIES
C
C     IF HOUR ENTERED IIDATE LESS THAN ZERO
C
      IF(IIDATE.LT.0)GO TO 130
C
C     HOUR NOT ENTERED - IDATE SHOULD BE DIVISIBLE BY 24
C
      JSTHR=IDATE
      GO TO 140
C
130   CONTINUE
C
C     HOUR ENTERED - SET TO NEAREST DT
C
      JSTHR=MISTDT(IDATE,IDT)
C
140   CONTINUE
C
C     NOW COMPUTE ENDING HOUR FOR TIME SERIES VALUES ENTERED
C
      ISPAN=IDT*(((NVALS-1)/NVPDT)*NVPDT)
      JENHR=JSTHR+ISPAN
C
C  GET LOCATIONS TO START CHANGES AND NUMBER OF VALUES TO MOVE
C
      CALL MLOCCH(8HTSCHNG  ,ISTHR,IENHR,JSTHR,JENHR,
     1 TSID,DTYPE,IDT,NVALS,NVPDT,LOCD,IBUG,
     2 IOFFST,LDSTRT,NMOVE,ISTART,ISTATT)
C
      IF(ISTATT.EQ.1)GO TO 50
C
C     GET UNITS CONVERSION FACTORS IF NEEDED
C
      IF(IUMGEN.EQ.0)CALL FCONVT(UNITS,DIMS,EUNITS,XMULT,XADD,IER)
C
      IGOTO = (IUMGEN*4 + MISALW*2)/2 + 1
C
C     GO TO ONE OF FOUR CASES
C      IGOTO = 1,    UNITS CONVERSION, MISSING NOT ALLOWED
C              2,    UNITS CONVERSION, MISSING ALLOWED
C              3, NO UNITS CONVERSION, MISSING NOT ALLOWED
C              4, NO UNITS CONVERSION, MISSING ALLOWED
C
      IF(IBUG.GT.0)WRITE(IODBUG,150)NMOVE,TSID,DTYPE,IDT,LDSTRT,
     1 IOFFST,IGOTO,NXTOPN,NXTNAM
150   FORMAT(11X,'ABOUT TO MOVE ',I4,' VALUES INTO TIME SERIES ',
     1 2A4,1X,A4,I3/11X,'LDSTRT,IOFFST,IGOTO,NXTOPN,NXTNAM ='/
     2 5X,I11,I7,I6,I7,2X,A8)
C
      GO TO (230,260,170,210) , IGOTO
C
      IF(MODWRN.EQ.1)
     .WRITE(IPR,160)IUMGEN,MISALW
160   FORMAT(1H0,10X,'** WARNING ** IN TSCHNG MOD - ILLEGAL VALUE ',
     1 'FOR IUMGEN (',I5,') OR MISALW (',I5,').'/11X,
     2 'NO VALUES CHANGED.')
      GO TO 280
C
170   DO 190 I=1,NMOVE
      IF(IFMSNG(VALUES(IOFFST+I)).EQ.0)GO TO 190
      IF(MODWRN.EQ.1)
     .WRITE(IPR,180)I,TSID,DTYPE,IDT,DTYPE
180   FORMAT(1H0,10X,'** WARNING ** IN TSCHNG MOD - VALUE NUMBER ',
     1 I3,' FOR TIME SERIES ',2A4,1X,A4,I3,' IS A MISSING VALUE.'/
     2 11X,'MISSING VALUES ARE NOT ALLOWED FOR DATA TYPE ',A4,1H./
     3 11X,'NO VALUES WILL BE CHANGED FOR THIS TIME SERIES.')
      GO TO 280
190   CONTINUE
C
      DO 200 I=1,NMOVE
200   D(LDSTRT+I)=VALUES(IOFFST+I)
      GO TO 50
C
210   DO 220 I=1,NMOVE
220   D(LDSTRT+I)=VALUES(IOFFST+I)
      GO TO 50
C
230   DO 240 I=1,NMOVE
      IF(IFMSNG(VALUES(IOFFST+I)).EQ.0)GO TO 240
      IF(MODWRN.EQ.1)
     .WRITE(IPR,180)I,TSID,DTYPE,IDT,DTYPE
      GO TO 280
240   CONTINUE
C
      DO 250 I=1,NMOVE
      D(LDSTRT+I)=(VALUES(IOFFST+I)-XADD)/XMULT
250   CONTINUE
      GO TO 50
C
260   DO 270 I=1,NMOVE
      TEMP=VALUES(IOFFST+I)
      IF(IFMSNG(TEMP).EQ.0)TEMP=(TEMP-XADD)/XMULT
270   D(LDSTRT+I)=TEMP
      GO TO 50
C
280   CONTINUE
      IF(MODWRN.EQ.1)CALL WARN
      GO TO 50
C
290   CALL FSTWHR(OLDOPN,IOLDOP,OLDOPN,IOLDOP)
C
      IF(IBUG.GT.0)WRITE(IODBUG,300)
300   FORMAT(11X,'*** LEAVING SUBROUTINE MTSCHN ***')
C
      RETURN
      END

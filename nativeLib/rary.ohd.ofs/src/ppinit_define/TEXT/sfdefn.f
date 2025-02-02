C MODULE SFDEFN
C-----------------------------------------------------------------------
C
C  ROUTINE TO DEFINE PARAMETERS.
C
      SUBROUTINE SFDEFN (LARRAY,ARRAY,NFLD,ISTAT)
C
      CHARACTER*4 DISP,PLOT,PRPARM,PRNOTE,PRBASN
      CHARACTER*8 SEQNUM/' '/
      PARAMETER (MOPTN=8)
      CHARACTER*8 OPTN(MOPTN)
     *   /'NEW     ','OLD     ','PLOT    ','PRNTPARM',
     *    'PRNTNOTE','PRNTBASN','CHECKREF        ','        '/
      PARAMETER (MGROUP=8)
      CHARACTER*8 GROUP(MGROUP)
     *   /'AREA    ','BASIN   ','STATION ','STA     ',
     *    'USER    ','GRIDBOX ','RFROCNST','        '/
      CHARACTER*20 STRNG/' '/,STRNG2/' '/
C
      DIMENSION ARRAY(LARRAY)
C
      INCLUDE 'uiox'
      INCLUDE 'ufreex'
      INCLUDE 'scommon/stypax'
      INCLUDE 'scommon/stypsx'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/suerrx'
      INCLUDE 'scommon/suoptx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_define/RCS/sfdefn.f,v $
     . $',                                                             '
     .$Id: sfdefn.f,v 1.6 2001/06/13 14:00:07 dws Exp $
     . $' /
C    ===================================================================
C
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,*) 'ENTER SFDEFN'
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('DEFN')
C
      ISTAT=0
C
      STRNG=' '
      STRNG2=' '
      LSTRNG=-LEN(STRNG)
      LSTRNG2=-LEN(STRNG2)
      ISTRT=1
C
      LGROUP=0
      ILPFND=0
      IRPFND=0
      NCWARN=NTWARN
      NCERR=NTERR
      ICMERR=0
      NUMERR=0
      NUMWRN=0
C
C  SET DEFAULT OPTIONS
      DISP='NEW'
      PLOT=' '
      PRPARM='YES'
      PRNOTE='NO'
      PRBASN=' '
      ICKREF=1
C
C  CHECK IF RUNCHECK OPTION SPECIFIED
      IRUNCK=0
      IF (IOPRCK.EQ.0) GO TO 10
         WRITE (LP,470)
         WRITE (LP,470)
         CALL SULINE (LP,1)
         WRITE (LP,480)
         IF (IOPOVP.EQ.1) THEN
            WRITE (LP,480)
            WRITE (LP,480)
            ENDIF
         CALL SULINE (LP,1)
         IRUNCK=1
C
C  PRINT CARD
10    CALL SUPCRD
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK FIELDS FOR DEFINE OPTIONS
C
20    CALL UFIELD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LSTRNG,
     *   STRNG,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (NFLD.EQ.-1) GO TO 440
      IF (LDEBUG.GT.0) THEN
         CALL UPRFLD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LSTRNG,
     *      STRNG,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
         ENDIF
C
C  CHECK IF ERROR ON PREVIOUS COMMAND
      IF (ICMERR.EQ.1) THEN
         IF (LATSGN.EQ.0.AND.NFLD.EQ.1) CALL SUPCRD
         IF (LATSGN.EQ.0) GO TO 20
         ICMERR=0
         NSCARD=NRDCRD-NCSKIP
         IF (NSCARD.GT.0) THEN
            WRITE (LP,500) NSCARD
            CALL SULINE (LP,2)
            ENDIF
         ENDIF
C
C  CHECK FOR NULL FIELD
      IF (IERR.EQ.1) THEN
         IF (LDEBUG.GT.0) THEN
            WRITE (IOSDBG,590) NFLD
            CALL SULINE (IOSDBG,1)
            ENDIF
         GO TO 20
         ENDIF
C
C  CHECK FOR COMMAND
      IF (LATSGN.EQ.1) GO TO 440
C
C  CHECK FOR PAIRED PARENTHESES
      IF (ILPFND.GT.0.AND.IRPFND.EQ.0) THEN
         WRITE (LP,530) NFLD
         CALL SULINE (LP,2)
         ILPFND=0
         IRPFND=0
         ENDIF
      IF (LLPAR.GT.0) ILPFND=1
C
C  CHECK FOR PARENTHESIS IN FIELD
      STRNG2=' '
      IF (LLPAR.EQ.1) CALL SUBSTR (STRNG,1,LENGTH,STRNG2,1)
      IF (LLPAR.GT.1) CALL UFPACK (LSTRNG2,STRNG2,ISTRT,1,LLPAR-1,IERR)
      IF (LLPAR.EQ.0) CALL UFPACK (LSTRNG2,STRNG2,ISTRT,1,LENGTH,IERR)
C
C  CHECK FOR OPTION
      DO 70 IOPTN=1,MOPTN
         IF (STRNG2.EQ.OPTN(IOPTN)) GO TO 100
70       CONTINUE
C
C  CHECK FOR GROUP
      DO 80 IGROUP=1,MGROUP
         IF (STRNG2.EQ.GROUP(IGROUP)) THEN
            LGROUP=IGROUP
            IF (LDEBUG.GT.0) THEN
               WRITE (IOSDBG,*) 'GROUP(LGROUP)=',GROUP(LGROUP)
               CALL SULINE (IOSDBG,1)
               ENDIF
            IF (NFLD.EQ.1) CALL SUPCRD
            GO TO 20
            ENDIF
80       CONTINUE
C
C  CHECK FOR KEYWORD
      CALL SUIDCK ('DEFN',STRNG2,NFLD,0,IKEYWD,IERR)
      IF (IERR.EQ.0) GO TO 90
      GO TO 280
C
90    CALL SUPCRD
      WRITE (LP,560) NFLD,STRNG
      CALL SUERRS (LP,2,NUMERR)
      ILPFND=0
      GO TO 20
C
100   IF (NFLD.EQ.1) CALL SUPCRD
      ILPFND=0
      IRPFND=0
      GO TO (110,110,120,160,
     *       200,240,275,105),IOPTN
C      
105   WRITE (LP,580) OPTN(IOPTN)
      CALL SUERRS (LP,2,NUMERR)
      GO TO 20
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  DISPOSITION OPTION
C
110   DISP=STRNG2
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,*) 'DISP=',DISP
         CALL SULINE (LP,1)
         ENDIF
      IF (DISP.EQ.'OLD') THEN
         IF (ISUPRT('OLD ').EQ.0) THEN
            WRITE (LP,470)
            WRITE (LP,470)
            CALL SULINE (LP,1)
            WRITE (LP,510)
            IF (IOPOVP.EQ.1) THEN
               WRITE (LP,510)
               WRITE (LP,510)
               ENDIF
            CALL SUERRS (LP,1,NUMERR)
            ICMERR=1
            NCSKIP=NRDCRD
            ENDIF
         ENDIF
      GO TO 20
C
C  PLOT OPTION
C
120   IF (LLPAR.EQ.0) THEN
         STRNG2='YES'
         WRITE (LP,540) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 150
         ENDIF
      IF (LRPAR.GT.0) IRPFND=1
      IF (LRPAR.EQ.0) THEN
         WRITE (LP,530) NFLD
         CALL SULINE (LP,2)
         LRPAR=LENGTH+1
         ENDIF
      CALL UFPACK (LSTRNG2,STRNG2,ISTRT,LLPAR+1,LRPAR-1,IERR)
      IF (STRNG2.EQ.'YES'.OR.STRNG2.EQ.'NO') GO TO 150
         WRITE (LP,570) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUERRS (LP,2,NUMERR)
         GO TO 20
150   PLOT=STRNG2
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,550) OPTN(IOPTN),PLOT
         CALL SULINE (IOSDBG,1)
         ENDIF
      GO TO 20
C
C  PRNTPARM OPTION
C
160   IF (LLPAR.EQ.0) THEN
         STRNG2='YES'
         WRITE (LP,540) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 190
         ENDIF
      IF (LRPAR.GT.0) IRPFND=1
      IF (LRPAR.EQ.0) THEN
         WRITE (LP,530) NFLD
         CALL SULINE (LP,2)
         LRPAR=LENGTH+1
         ENDIF
      CALL UFPACK (LSTRNG2,STRNG2,ISTRT,LLPAR+1,LRPAR-1,IERR)
      IF (STRNG2.EQ.'YES'.OR.STRNG2.EQ.'NO') GO TO 190
         WRITE (LP,570) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUERRS (LP,2,NUMERR)
         GO TO 20
190   PRPARM=STRNG2
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,550) OPTN(IOPTN),PRPARM
         CALL SULINE (IOSDBG,1)
         ENDIF
      GO TO 20
C
C  PRNTNOTE OPTION
C
200   IF (LLPAR.EQ.0) THEN
         STRNG2='YES'
         WRITE (LP,540) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 230
         ENDIF
      IF (LRPAR.GT.0) IRPFND=1
      IF (LRPAR.EQ.0) THEN
         WRITE (LP,530) NFLD
         CALL SULINE (LP,2)
         LRPAR=LENGTH+1
         ENDIF
      CALL UFPACK (LSTRNG2,STRNG2,ISTRT,LLPAR+1,LRPAR-1,IERR)
      IF (STRNG2.EQ.'YES'.OR.STRNG2.EQ.'NO') GO TO 230
         WRITE (LP,570) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUERRS (LP,2,NUMERR)
         GO TO 20
230   PRNOTE=STRNG2
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,550) OPTN(IOPTN),PRNOTE
         CALL SULINE (IOSDBG,1)
         ENDIF
      GO TO 20
C
C  PRNTBASN OPTION
C
240   IF (LLPAR.EQ.0) THEN
         STRNG2='YES'
         WRITE (LP,540) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 270
         ENDIF
      IF (LRPAR.GT.0) IRPFND=1
      IF (LRPAR.EQ.0) THEN
         WRITE (LP,530) NFLD
         CALL SULINE (LP,2)
         LRPAR=LENGTH+1
         ENDIF
      CALL UFPACK (LSTRNG2,STRNG2,ISTRT,LLPAR+1,LRPAR-1,IERR)
      IF (STRNG2.EQ.'YES'.OR.STRNG2.EQ.'NO') GO TO 270
         WRITE (LP,570) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUERRS (LP,2,NUMERR)
         GO TO 20
270   PRBASN=STRNG2
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,550) OPTN(IOPTN),PRBASN
         CALL SULINE (IOSDBG,1)
         ENDIF
      GO TO 20
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C       
C  CHECKREF OPTION
C
275   IF (LLPAR.EQ.0) THEN
         STRNG2='YES'
         WRITE (LP,540) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SULINE (LP,2)
         GO TO 51
         ENDIF
      IF (LRPAR.GT.0) IRPFND=1
      IF (LRPAR.EQ.0) THEN
         WRITE (LP,530) NFLD
         CALL SULINE (LP,2)
         LRPAR=LENGTH+1
         ENDIF
      CALL UFPACK (LSTRNG2,STRNG2,ISTRT,LLPAR+1,LRPAR-1,IERR)
      IF (STRNG2.EQ.'NO'.OR.STRNG2.EQ.'YES') GO TO 51
         WRITE (LP,570) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SUERRS (LP,2,NUMERR)
         GO TO 10
51    IF (STRNG2.EQ.'NO') ICKREF=0
      IF (STRNG2.EQ.'YES') ICKREF=1
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,550) OPTN(IOPTN),STRNG2(1:LENSTR(STRNG2))
         CALL SULINE (IOSDBG,2)
         ENDIF
      GO TO 20
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK WHICH PARAMETER TYPE IS TO BE DEFINED
C
280   IF (LGROUP.GT.0) GO TO 290
         WRITE (LP,630)
         CALL SUERRS (LP,2,NUMERR)
         ISTAT=2
         GO TO 20
C
C  WRITE TO PROGRAM LOG
290   NPAGE=0
      ISTART=1
      CALL SUWLOG ('OPTN',GROUP(LGROUP),SEQNUM,NPAGE,ISTART,IERR)
C
      GO TO (300,320,330,330,350,370,390),LGROUP
C      
      WRITE (LP,580) GROUP(LGROUP)
      CALL SUERRS (LP,2,NUMERR)
      GO TO 20
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  DEFINE AREA
300   IF (DISP.EQ.'OLD'.AND.
     *   (ISUPRT('OLD ').EQ.0.OR.ISUPRT('OLDA').EQ.0)) GO TO 410
      DO 305 I=1,MATYPE
         IF (STRNG2.EQ.ATYPE(I)) GO TO 310
305      CONTINUE
         GO TO 420
310   CALL SFAREA (LARRAY,ARRAY,DISP,PRPARM,PRNOTE,PRBASN,PLOT,
     *   NFLD,IRUNCK,IERR)
      GO TO 430
C
C  DEFINE BASIN
320   IF (DISP.EQ.'OLD'.AND.
     *   (ISUPRT('OLD ').EQ.0.OR.ISUPRT('OLDB').EQ.0)) GO TO 410
      IF (STRNG2.EQ.'BASN') THEN
         CALL SFBASN (LARRAY,ARRAY,DISP,PRPARM,PRNOTE,PLOT,NFLD,
     *      IRUNCK,IERR)
         GO TO 430
         ENDIF
      GO TO 420
C
C  DEFINE STATION
330   IF (DISP.EQ.'OLD'.AND.
     *   (ISUPRT('OLD ').EQ.0.OR.ISUPRT('OLDS').EQ.0)) GO TO 410
      DO 335 I=1,MSTYPE
         IF (STRNG2.EQ.STYPE(I)) GO TO 340
335      CONTINUE
         GO TO 420
340   CALL SFSTA (LARRAY,ARRAY,DISP,PRPARM,PRNOTE,NFLD,
     *   IRUNCK,ICKREF,IERR)
      GO TO 430
C
C  DEFINE USER
350   IF (DISP.EQ.'OLD'.AND.
     *   (ISUPRT('OLD ').EQ.0.OR.ISUPRT('OLDU').EQ.0)) GO TO 410
      IF (STRNG2.EQ.'UGNL'.OR.
     *    STRNG2.EQ.'URRS'.OR.
     *    STRNG2.EQ.'STBN') THEN
         CALL SFUSER (LARRAY,ARRAY,DISP,PRNOTE,NFLD,
     *      IRUNCK,IERR)
         GO TO 430
         ENDIF
      GO TO 420
C
C  DEFINE GRID BOXES
370   IF (DISP.EQ.'OLD'.AND.
     *   (ISUPRT('OLD ').EQ.0.OR.ISUPRT('OLDG').EQ.0)) GO TO 410
      IF (STRNG2.EQ.'GBOX') THEN
         CALL SFGBOX (LARRAY,ARRAY,DISP,PRPARM,PRNOTE,NFLD,
     *      IRUNCK,IERR)
         GO TO 430
         ENDIF
      GO TO 420
C
C  DEFINE RAINFALL-RUNOFF RELATIONSHIP PARAMETERS
390   IF (DISP.EQ.'OLD'.AND.
     *   (ISUPRT('OLD ').EQ.0.OR.ISUPRT('OLDG').EQ.0)) GO TO 410
      IF (STRNG2.EQ.'RFRO') THEN
         CALL SFRFRO (LARRAY,ARRAY,DISP,PRPARM,PRNOTE,NFLD,
     *      IRUNCK,IERR)
         GO TO 430
         ENDIF
      GO TO 420
C
C  NON-SUPPORTED FEATURE SPECIFIED - SKIP TO NEXT COMMAND
410   IF (NFLD.EQ.1) CALL SUPCRD
      WRITE (LP,470)
      WRITE (LP,470)
      CALL SULINE (LP,1)
      WRITE (LP,520) GROUP(LGROUP)
      IF (IOPOVP.EQ.1) THEN
         WRITE (LP,520) GROUP(LGROUP)
         WRITE (LP,520) GROUP(LGROUP)
         ENDIF
      CALL SUERRS (LP,1,NUMERR)
      ICMERR=1
      NCSKIP=NRDCRD
      GO TO 20
C
C  KEYWORD FOUND IS NOT VALID FOR GROUP SPECIFIED
420   IF (NFLD.EQ.1) CALL SUPCRD
      WRITE (LP,640) STRNG2,GROUP(LGROUP)
      CALL SUERRS (LP,2,NUMERR)
      ICMERR=1
      NCSKIP=NRDCRD
      GO TO 20
C
C  WRITE TO PROGRAM LOG
430   NPAGE=0
      ISTART=0
      CALL SUWLOG ('OPTN',GROUP(LGROUP),SEQNUM,NPAGE,ISTART,IERR)
C
C  SET INDICATOR TO REREAD CURRENT FIELD
      ISTRT=-1
      GO TO 20
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  PRINT NUMBER OF ERRORS AND WARNINGS ENCOUNTERED
440   NWARN=NTWARN-NCWARN
      NERR=NTERR-NCERR
      IF (NWARN.GT.0) THEN
         WRITE (LP,650) NWARN
         CALL SULINE (LP,2)
         ENDIF
      IF (NERR.GT.0) THEN
         WRITE (LP,660) NERR
         CALL SULINE (LP,2)
         ENDIF
C
C  CHECK IF RUNCHECK OPTION SPECIFIED
      IF (IOPRCK.EQ.0) GO TO 450
         WRITE (LP,470)
         WRITE (LP,470)
         CALL SULINE (LP,1)
         WRITE (LP,490)
         IF (IOPOVP.EQ.1) THEN
            WRITE (LP,490)
            WRITE (LP,490)
            ENDIF
         CALL SULINE (LP,1)
C
450   IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,*) 'EXIT SFDEFN'
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
470   FORMAT (' ')
480   FORMAT ('+*** NOTE - RUNCHECK OPTION HAS BEEN SPECIFIED. INPUT ',
     *   'WILL BE CHECKED FOR ERRORS.')
490   FORMAT ('+*** NOTE - RUNCHECK OPTION HAS BEEN SPECIFIED. INPUT ',
     *   'HAS BEEN CHECKED FOR ERRORS.')
500   FORMAT ('0*** NOTE - ',I4,' CARD IMAGES NOT PROCESSED BECAUSE ',
     *   'INVALID OPTION FOUND.')
510   FORMAT ('+*** ERROR - USE OF THE DISPOSITION OF OLD IS NOT ',
     *   'CURRENTLY ALLOWED. ',
     *   'COMMAND WILL NOT BE PROCESSED.')
520   FORMAT ('+*** ERROR - USE OF THE DISPOSITION OF OLD IS NOT ',
     *   'CURRENTLY ALLOWED FOR DEFINE ',A,'. ',
     *   'COMMAND WILL NOT BE PROCESSED.')
530   FORMAT ('0*** NOTE - RIGHT PARENTHESIS ASSUMED IN FIELD ',I2,'.')
540   FORMAT ('0*** WARNING - NO LEFT PARENTHESIS FOUND. ',A,
     *   'OPTION SET TO ',A,'.')
550   FORMAT (' ',A,' OPTION SET TO ',A)
560   FORMAT ('0*** ERROR - INVALID DEFINE OPTION IN CARD FIELD ',
     *   I2,' : ',A)
570   FORMAT ('0*** ERROR - INVALID ',A,' VALUE : ',A)
580   FORMAT ('0*** ERROR - ERROR PROCESSING OPTION : ',A)
590   FORMAT (' BLANK STRING FOUND IN FIELD ',I2)
630   FORMAT ('0*** ERROR - NO GROUP NAME FOUND.')
640   FORMAT ('0*** ERROR - KEYWORD FOUND (',A,') IS NOT VALID FOR ',
     *   'GROUP NAME SPECIFIED (',A, '). ',
     *   'COMMAND WILL NOT BE PROCESSED.')
650   FORMAT ('0*** NOTE - ',I4,' TOTAL WARNINGS ENCOUNTERED BY ',
     *   'DEFINE COMMAND.')
660   FORMAT ('0*** NOTE - ',I4,' TOTAL ERRORS   ENCOUNTERED BY ',
     *   'DEFINE COMMAND.')
C
      END

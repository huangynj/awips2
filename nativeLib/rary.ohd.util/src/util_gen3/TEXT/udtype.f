C MODULE UDTYPE
C-----------------------------------------------------------------------
C
      SUBROUTINE UDTYPE (SRCH,MTYPE,NTYPE,TYPE,DIMN,UNIT,MISS,
     *   NVAL,TIME,NADD,IWRT,ISTAT)
C
C  ROUTINE TO READ THE FILE CONTAINING THE VALID NWSRFS DATA TYPE
C  CODES AND THE ATTRIBUTES ASSOCIATED WITH EACH TYPE.
C
C  INPUT ARGUMENTS:
C       SRCH  - FOUR CHARACTER SEARCH CODE:
C               'ALL'  = RETURN ALL DATA TYPES
C               'CALB' = RETURN ALL CALIBRATION SYSTEM DATA TYPES
C               'FCST' = RETURN ALL FORECAST SYSTEM DATA TYPES
C               'BOTH' = RETURN ALL DATA TYPES USED IN BOTH THE
C                          CALIBRATION AND FORECAST SYSTEMS
C       MTYPE - MAXIMUM NUMBER OF DATA TYPES THAT CAN BE STORED IN
C               CALLING PROGRAM
C
C  OUTPUT ARGUMENTS:
C       NTYPE - NUMBER OF DATA TYPES FOUND
C       TYPE  - VALID DATA TYPE CODES (4-CHARACTER)
C       DIMN  - DIMENSION CODE FOR EACH DATA TYPE (4-CHARACTER).
C               IF DIMN(1)='NONE' WHEN UDTYPE IS CALLED, ARRAY WILL NOT
C               BE FILLED.
C       UNIT  - CODE FOR THE STANDARD FORECAST SYSTEM INTERNAL UNITS
C               FOR EACH DATA TYPE (4-CHARACTER).
C               IF UNIT(1)='NONE' WHEN UDTYPE IS CALLED, ARRAY WILL NOT
C               BE FILLED.
C       MISS  - MISSING DATA INDICATOR FOR EACH DATA TYPE.
C               IF MISS(1)=-99 WHEN UDTYPE IS CALLED, ARRAY WILL NOT
C               BE FILLED. IF FILLED, VALUES ARE AS FOLLOWS:
C                 0 = NO MISSING DATA ALLOWED
C                 1 = MISSING DATA ALLOWED
C       NVAL  - NUMBER OF VALUES PER TIME INTERVAL FOR EACH DATA TYPE
C               IF NVAL(1)=-99 WHEN UDTYPE IS CALLED, ARRAY WILL NOT
C               BE FILLED. IF FILLED, VALUES ARE AS FOLLOWS:
C                >-1= NUMBER OF VALUES
C                 -1 = NUMBER MAY VARY
C       TIME  - CODE FOR TIME SCALE OF EACH DATA TYPE (4-CHARACTER).
C               IF TIME(1)='NONE' WHEN UDTYPE IS CALLED, ARRAY WILL NOT
C               BE FILLED.
C       NADD  - NUMBER OF PIECES OF ADDITIONAL INFORMATION THAT ARE
C               ASSOCIATED WITH EACH DATA TYPE.
C               IF NADD(1)=-99 WHEN UDTYPE IS CALLED, ARRAY WILL NOT
C               BE FILLED.
C       IWRT  - INDICATOR SPECIFYING WHICH COMPONENT CAN WRITE EACH
C               DATA TYPE.
C               IF IWRT(1)=-99 WHEN UDTYPE IS CALLED, ARRAY WILL NOT
C               BE FILLED. IF FILLED, VALUES ARE AS FOLLOWS:
C                -1 = NOT DEFINED
C                 0 = PREPROCESSOR
C                 1 = FORECAST
C       ISTAT - STATUS INDICATOR:
C                 0 = NO ERROR
C                 1 = MAXIMUM DATA TYPES EXCEEDED
C                 2 = INVALID SEARCH CODE
C                 3 = ERROR IN DECODING INPUT FILE
C                 4 = UNEXPECTED END OF FILE ENCOUNTERED
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
      CHARACTER*2 DLIM
      CHARACTER*4 SRCH
      CHARACTER*4 INITC
      CHARACTER*4 TYPE1,TYPE2,TYPE3,TYPE4
      CHARACTER*4 DIMNZ,SPACEZ,TIMEZ,APPL,DATACDZ
      CHARACTER*4 FCSTZ,UNITZ,MISSZ,WRTZ
      CHARACTER*4 CALBZ
      CHARACTER*4 TYPE(MTYPE),DIMN(MTYPE),UNIT(MTYPE),TIME(MTYPE)
      CHARACTER*8 TMBR
      CHARACTER*8 DDNAME/' '/
      CHARACTER*8 MBR/'DATATYPE'/
      CHARACTER*20 DESC1,DESC2,DESC3
      CHARACTER*80 RECORD
      DIMENSION MISS(MTYPE),NVAL(MTYPE),NADD(MTYPE),IWRT(MTYPE)
C
      INCLUDE 'uiox'
      INCLUDE 'ucmdbx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/util/src/util_gen3/RCS/udtype.f,v $
     . $',                                                             '
     .$Id: udtype.f,v 1.3 1999/07/06 12:59:47 page Exp $
     . $' /
C    ===================================================================
C
C
      IF (ICMTRC.GT.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,100)
         ENDIF
C
      ISTAT=0
C
      LDEBUG=0
C
      NTYPE=0
      NTYPEA=0
      NRECORD=0
C
C  CHECK FOR VALID SEARCH CODE
      IF (SRCH.NE.'ALL'.AND.
     *    SRCH.NE.'BOTH'.AND.
     *    SRCH.NE.'CALB'.AND.
     *    SRCH.NE.'FCST') THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,110) SRCH
         ISTAT=2
         GO TO 70
         ENDIF
C
C  CHECK FOR INDICATOR NOT TO FILL ARRAYS
      IDIMN=1
      IF (DIMN(1).EQ.'NONE') IDIMN=0
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0.AND.IDIMN.EQ.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,120) 'DIMN'
         ENDIF
      IUNIT=1
      IF (UNIT(1).EQ.'NONE') IUNIT=0
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0.AND.IUNIT.EQ.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,120) 'UNIT'
         ENDIF
      IMISS=1
      IF (MISS(1).EQ.-99) IMISS=0
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0.AND.IMISS.EQ.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,120) 'MISS'
         ENDIF
      INVAL=1
      IF (NVAL(1).EQ.-99) INVAL=0
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0.AND.INVAL.EQ.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,120) 'NVAL'
         ENDIF
      ITIME=1
      IF (TIME(1).EQ.'NONE') ITIME=0
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0.AND.ITIME.EQ.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,120) 'TIME'
         ENDIF
      INADD=1
      IF (NADD(1).EQ.-99) INADD=0
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0.AND.INADD.EQ.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,120) 'NADD'
         ENDIF
      IIWRT=1
      IF (IWRT(1).EQ.-99) IIWRT=0
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0.AND.IIWRT.EQ.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,120) 'IWRT'
         ENDIF
C
      INITC='----'
      INITI=-1
      DO 10 I=1,MTYPE
         TYPE(I)=INITC
         IF (IDIMN.EQ.1) DIMN(I)=INITC
         IF (IUNIT.EQ.1) UNIT(I)=INITC
         IF (IMISS.EQ.1) MISS(I)=INITI
         IF (INVAL.EQ.1) NVAL(I)=INITI
         IF (ITIME.EQ.1) TIME(I)=INITC
         IF (INADD.EQ.1) NADD(I)=INITI
         IF (IIWRT.EQ.1) IWRT(I)=INITI
10       CONTINUE
C
C  CHECK IF FILE IS ALLOCATED
      IPRERR=1
      CALL UDDNST (DDNAME,LSYS,IPRERR,IERR)
      IF (IERR.GT.0) THEN
         ISTAT=1
         GO TO 90
         ENDIF
C
      IPRERR=0
      IF (ICMDBG.GT.3) IPRERR=1
      TMBR=MBR
C
C  READ RECORD
20    CALL URDPDS (DDNAME,TMBR,IPRERR,RECORD,LRECL,NRECORD,IFLAG,IERR)
      NRECORD1=NRECORD
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,*) 'IERR=',IERR
         ENDIF
      IF (IERR.EQ.2) GO TO 70
      IF (IERR.NE.0) THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,130) IERR
         GO TO 80
         ENDIF
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,'(A,A)') ' RECORD=',RECORD
         ENDIF
C
C  CHECK FOR BLANK RECORD
       IF (RECORD(1:72).EQ.' ') GO TO 20
C
C  CHECK FOR COMMENT CARD
      IF (RECORD(1:1).EQ.'*'.OR.RECORD(1:1).EQ.'$') THEN
         IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
            CALL ULINE (ICMPRU,1)
            WRITE (ICMPRU,140) NRECORD1,RECORD(1:LENSTR(RECORD))
            ENDIF
         GO TO 20
         ENDIF
      CALL SUBSTR (RECORD,1,4,TYPE1,1)
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
         IBEG=6
         MCHAR=LENSTR(RECORD)-IBEG+1
         DLIM='  '
         MDLIM=-LEN(DLIM)
         NSCAN=1
         CALL USCAN (RECORD(IBEG:IBEG),MCHAR,DLIM,MDLIM,NSCAN,
     *      DESC1,LEN(DESC1),LDESC1,IERR)
         NSCAN=NSCAN+1
         CALL USCAN (RECORD(IBEG:IBEG),MCHAR,DLIM,MDLIM,NSCAN,
     *      DESC2,LEN(DESC2),LDESC2,IERR)
         NSCAN=NSCAN+1
         CALL USCAN (RECORD(IBEG:IBEG),MCHAR,DLIM,MDLIM,NSCAN,
     *      DESC3,LEN(DESC3),LDESC3,IERR)
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,*) 'NRECORD1=',NRECORD,' TYPE1=',TYPE1,
     *      ' DESC1=',DESC1(1:LENSTR(DESC1)),
     *      ' DESC2=',DESC2(1:LENSTR(DESC2)),
     *      ' DESC3=',DESC3(1:LENSTR(DESC2))
         ENDIF
C
C  READ TYPE, DIMENSION, SPACE, TIME AND APPLICATION CODE AND NUMBER
C  OF VALUES PER TIME INTERVAL
      CALL URDPDS (DDNAME,TMBR,IPRERR,RECORD,LRECL,NRECORD,IFLAG,IERR)
      IF (IERR.EQ.2) THEN
         ISTAT=4
         GO TO 70
         ENDIF
      NRECORD2=NRECORD
      IPRERR=1
      CALL SUBSTR (RECORD,1,4,TYPE2,1)
      CALL SUBSTR (RECORD,6,4,DIMNZ,1)
      CALL SUBSTR (RECORD,11,4,SPACEZ,1)
      CALL SUBSTR (RECORD,16,4,TIMEZ,1)
      CALL SUBSTR (RECORD,21,4,APPL,1)
      CALL UFA2I (RECORD,27,1,NVALZ,IPRERR,LP,IERR)
      CALL SUBSTR (RECORD,29,4,DATACDZ,1)
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,*) 'NRECORD2=',NRECORD2,' TYPE2=',TYPE2,
     *      ' DIMNZ=',DIMNZ,' SPACEZ=',SPACEZ,' TIMEZ=',TIMEZ,
     *      ' APPL=',APPL,' NVALZ=',NVALZ
         ENDIF
      IF (TYPE1.NE.TYPE2) THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,150) TYPE2,NRECORD2,TYPE1,NRECORD1
         ISTAT=3
         ENDIF
      IF (APPL.NE.'CALB'.AND.APPL.NE.'FCST'.AND.APPL.NE.'BOTH') THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,160) APPL,TYPE1,NRECORD2
         ISTAT=3
         ENDIF
C
      IF (APPL.NE.'FCST'.AND.APPL.NE.'BOTH') GO TO 30
C
C  READ TYPE, APPLICATION, STANDARD UNITS, MISSING DATA AND PROCESS
C  CODES FOR FORECAST SYSTEM
      IPRERR=0
      CALL URDPDS (DDNAME,TMBR,IPRERR,RECORD,LRECL,NRECORD,IFLAG,IERR)
      IF (IERR.EQ.2) THEN
         ISTAT=4
         GO TO 70
         ENDIF
      NRECORD3=NRECORD
      CALL SUBSTR (RECORD,1,4,TYPE3,1)
      CALL SUBSTR (RECORD,6,4,FCSTZ,1)
      CALL SUBSTR (RECORD,11,4,UNITZ,1)
      CALL SUBSTR (RECORD,16,4,MISSZ,1)
      CALL SUBSTR (RECORD,21,4,WRTZ,1)
      IPRERR=1
      CALL UFA2I (RECORD,27,1,NADDZ,IPRERR,LP,IERR)
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,*) 'NRECORD3=',NRECORD3,' TYPE3=',TYPE3,
     *      ' FCSTZ=',FCSTZ,' UNITZ=',UNITZ,' MISSZ=',MISSZ,
     *      ' WRTZ=',WRTZ,' NADDZ=',NADDZ
         ENDIF
      IF (TYPE1.NE.TYPE3) THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,150) TYPE3,NRECORD3,TYPE1,NRECORD1
         ISTAT=3
         ENDIF
      IF (FCSTZ.NE.'FCST') THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,160) FCSTZ,TYPE1,NRECORD3
         ISTAT=3
         ENDIF
C
30    IF (APPL.NE.'CALB'.AND.APPL.NE.'BOTH') GO TO 40
C
C  READ TYPE, APPLICATION, UNITS AND STANDARD CARD FORMAT CODE FOR
C  CALIBRATION SYSTEM
      IPRERR=0
      CALL URDPDS (DDNAME,TMBR,IPRERR,RECORD,LRECL,NRECORD,IFLAG,IERR)
      IF (IERR.EQ.2) THEN
         ISTAT=4
         GO TO 70
         ENDIF
      NRECORD4=NRECORD
      CALL SUBSTR (RECORD,1,4,TYPE4,1)
      CALL SUBSTR (RECORD,6,4,CALBZ,1)
      IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,*) 'NRECORD4=',NRECORD4,' TYPE4=',TYPE4,
     *      ' CALBZ=',CALBZ
         ENDIF
      IF (TYPE1.NE.TYPE4) THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,150) TYPE4,NRECORD4,TYPE1,NRECORD1
         ISTAT=3
         ENDIF
      IF (CALBZ.NE.'CALB') THEN
         CALL UEROR (LP,1,-1)
         WRITE (LP,160) CALBZ,TYPE1,NRECORD4
         ISTAT=3
         ENDIF
C
40    IF (SRCH.EQ.'ALL') GO TO 50
C
      IF (APPL.NE.SRCH.AND.APPL.NE.'BOTH') GO TO 60
C
C  CHECK FOR MAXIMUM NUMBER OF DATA TYPES THAT CAN BE STORED
50    IF (NTYPE+1.GT.MTYPE) THEN
         IF (NTYPEA.EQ.0) THEN
            CALL UEROR (LP,1,-1)
            WRITE (LP,170) MTYPE
            ENDIF
         NTYPEA=NTYPEA+1
         ISTAT=1
         GO TO 60
         ENDIF
C
C  STORE TYPE CODE AND ATTRIBUTES IN ARRAYS
      NTYPE=NTYPE+1
      TYPE(NTYPE)=TYPE1
      IF (IDIMN.EQ.1.AND.DIMNZ.NE.' ') DIMN(NTYPE)=DIMNZ
      IF (IUNIT.EQ.1.AND.UNITZ.NE.' ') UNIT(NTYPE)=UNITZ
      IF (ITIME.EQ.1) TIME(NTYPE)=TIMEZ
      IF (INVAL.EQ.1) NVAL(NTYPE)=NVALZ
      IF (INADD.EQ.1) NADD(NTYPE)=NADDZ
C
C  CHECK IF TO FILL MISSING DATA INDICATOR ARRAY
      IF (IMISS.EQ.1) THEN
         IF (MISSZ.EQ.'YES') MISS(NTYPE)=1
         IF (MISSZ.EQ.'NO') MISS(NTYPE)=0
         IF (MISS(NTYPE).EQ.INITI) THEN
            IF (SRCH.NE.'CALB') THEN
               CALL UEROR (LP,1,-1)
               WRITE (LP,180) MISSZ,TYPE1,NRECORD
               ISTAT=3
               ENDIF
            ENDIF
         ENDIF
C
C  CHECK IF TO FILL WRITE INDICATOR ARRAY
      IF (IIWRT.EQ.1) THEN
         IF (WRTZ.EQ.'PP') IWRT(NTYPE)=0
         IF (WRTZ.EQ.'FC') IWRT(NTYPE)=1
         IF (IWRT(NTYPE).EQ.INITI) THEN
            IF (SRCH.NE.'CALB') THEN
               CALL UEROR (LP,1,-1)
               WRITE (LP,190) WRTZ,TYPE1,NRECORD
               ISTAT=3
               ENDIF
            ENDIF
         ENDIF
C
60    IF (IERR.NE.2) GO TO 20
C
C  CHECK IF MAXIMUM NUMBER OF TYPES EXCEEDED
70    IF (ISTAT.EQ.1) THEN
         IF (ICMDBG.GT.0.OR.LDEBUG.GT.0) THEN
            CALL ULINE (ICMPRU,1)
            WRITE (ICMPRU,*) 'NTYPE=',NTYPE,' NTYPEA=',NTYPEA
            ENDIF
         NTYPE=NTYPE+NTYPEA
         ENDIF
C
C  CLOSE FILE
80    TMBR=' '
      IPRERR=1
      CALL URDPDS (DDNAME,TMBR,IPRERR,RECORD,LRECL,NRECORD,IFLAG,IERR)
C
90    IF (ICMTRC.GT.0) THEN
         CALL ULINE (ICMPRU,1)
         WRITE (ICMPRU,200)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
100   FORMAT (' ENTER UDTYPE')
110   FORMAT ('+*** ERROR - IN UDTYPE - INVALID ',
     *   'SEARCH CODE (',A,') SPECIFIED.')
120   FORMAT (' ARRAY ',A,' WILL NOT BE FILLED')
130   FORMAT ('+*** ERROR - IN UDTYPE - URDPDS STATUS CODE=',I3)
140   FORMAT (' COMMENT RECORD FOUND AT RECORD ',I3,' : ',A)
150   FORMAT ('+*** ERROR - IN UDTYPE - '
     *   'DATA TYPE ',A,' AT RECORD ',I3,
     *   ' DOES NOT MATCH ',
     *   'DATA TYPE ',A,' AT RECORD ',I3,'.')
160   FORMAT ('+*** ERROR - IN UDTYPE - INVALID ',
     *   'APPLICATION CODE (',A,') FOR ',
     *   'DATA TYPE ',A,' AT RECORD ',I3,'.')
170   FORMAT ('+*** ERROR - IN UDTYPE - MAXIMUM NUMBER OF DATA TYPES (',
     *   I3,') EXCEEDED.')
180   FORMAT ('+*** ERROR - IN UDTYPE - INVALID ',
     *   'CODE FOR MISSING DATA ALLOWED (',A,') FOR ',
     *   'DATA TYPE ',A,' AT RECORD ',I3,'.')
190   FORMAT ('+*** ERROR - IN UDTYPE - INVALID ',
     *   'PROCESS CODE (',A,') FOR ',
     *   'DATA TYPE ',A,' AT RECORD ',I3,'.')
200   FORMAT (' EXIT UDTYPE')
C
      END

C MODULE SRUGNL
C-----------------------------------------------------------------------
C
C  ROUTINE TO READ USER GENERAL PARAMETERS.
C
      SUBROUTINE SRUGNL (LARRAY,ARRAY,IVUGNL,UGNLID,ISEASN,MDRSUB,
     *   ULLMTS,ELLMTS,NBLEND,ICUGNL,DPOWER,DPCNMN,STMNWT,SORTBY,
     *   NHPSUB,UNUSED,IPRERR,ISTAT)
C
      CHARACTER*8 BLNKID/' '/
C
      DIMENSION ARRAY(LARRAY)
      DIMENSION UGNLID(2),ISEASN(2),MDRSUB(4),ULLMTS(4),ELLMTS(2)
      DIMENSION NBLEND(2),ICUGNL(2),DPOWER(3),NHPSUB(4)
      DIMENSION UNUSED(1)
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_s/RCS/srugnl.f,v $
     . $',                                                             '
     .$Id: srugnl.f,v 1.2 1998/04/07 11:45:59 page Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,150)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG('UGNL')
C
      IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,160) LARRAY
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      ISTAT=0
C
C  READ PARAMETER RECORD
      CALL SUDOPN (1,'PPP ',IERR)
      IPTR=0
      CALL RPPREC (BLNKID,'USER',IPTR,LARRAY,ARRAY,NFILL,IPTRNX,
     *     IERR)
      IF (IERR.NE.0) THEN
         ISTAT=IERR
         IF (IPRERR.EQ.1) THEN
            CALL SRPPST (BLNKID,'USER',IPTR,LARRAY,NFILL,IPTRNX,IERR)
            ENDIF
         GO TO 140
         ENDIF
C
      NPOS=0
C
C  SET PARAMETER ARRAY VERSION NUMBER
      NPOS=NPOS+1
      IVUGNL=ARRAY(NPOS)
C
C  SET USER NAME
      DO 20 I=1,2
         NPOS=NPOS+1
         UGNLID(I)=ARRAY(NPOS)
20       CONTINUE
C
C  SET BEGINNING MONTH OF SUMMER AND WINTER
      DO 30 I=1,2
         NPOS=NPOS+1
         ISEASN(I)=ARRAY(NPOS)
30       CONTINUE
C
C  SET MDR GRID SUBSET
      DO 40 I=1,4
         NPOS=NPOS+1
         MDRSUB(I)=ARRAY(NPOS)
40       CONTINUE
C
C  SET LATITUDE AND LONGITUDE LIMITS
      DO 50 I=1,4
         NPOS=NPOS+1
         ULLMTS(I)=ARRAY(NPOS)
50       CONTINUE
C
C  SET MAXIMUM AND MINIMUM ELEVATION LIMITS
      DO 60 I=1,2
         NPOS=NPOS+1
         ELLMTS(I)=ARRAY(NPOS)
60       CONTINUE
C
C  SET MAT AND MAPE BLEND PERIODS
      DO 70 I=1,2
         NPOS=NPOS+1
         NBLEND(I)=ARRAY(NPOS)
70       CONTINUE
C
C  SET MAP AND MAT COMPLETE INDICATORS
      DO 80 I=1,2
         NPOS=NPOS+1
         ICUGNL(I)=ARRAY(NPOS)
80       CONTINUE
C
C  SET DEFAULT POWER IN 1/D**POWER FOR MAP, MAT AND MAPE
      DO 90 I=1,3
         NPOS=NPOS+1
         DPOWER(I)=ARRAY(NPOS)
90       CONTINUE
C
C  SET MINIMUM DAILY PCPN AT <24 HOUR STATIONS
      NPOS=NPOS+1
      DPCNMN=ARRAY(NPOS)
C
C  SET MINIMUM WEIGHT OF STATIONS TO BE KEPT FOR STATION WEIGHTING
      NPOS=NPOS+1
      STMNWT=ARRAY(NPOS)
C
C  SET INDICATOR HOW STATION INFORMATION IS TO BE SORTED
      NPOS=NPOS+1
      SORTBY=ARRAY(NPOS)
C
C  NEXT 6 POSITIONS ARE USED FOR OPTIONS SAVED BY SETOPT COMMAND
      DO 100 I=1,6
         NPOS=NPOS+1
         UNUSED(I)=ARRAY(NPOS)
100      CONTINUE
C
      IF (IVUGNL.LT.2) GO TO 120
C
C  SET HRAP GRID SUBSET
      DO 110 I=1,4
         NPOS=NPOS+1
         NHPSUB(I)=ARRAY(NPOS)
110      CONTINUE
C
120   IF (LDEBUG.GT.0) THEN
         WRITE (IOSDBG,180) NPOS,NFILL,IPTRNX,IVUGNL
         CALL SULINE (IOSDBG,1)
         CALL SUPDMP ('USER','BOTH',0,NPOS,ARRAY,ARRAY)
         ENDIF
C
      IF (LDEBUG.GT.0) THEN
         IF (ISTAT.EQ.0) THEN
            WRITE (IOSDBG,190)
            CALL SULINE (IOSDBG,1)
            ENDIF
         IF (ISTAT.GT.0) THEN
            WRITE (IOSDBG,200)
            CALL SULINE (IOSDBG,1)
            ENDIF
         ENDIF
C
140   IF (ISTRCE.GT.0) THEN
         WRITE (IOSDBG,210)
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
150   FORMAT (' *** ENTER SRUGNL')
160   FORMAT (' LARRAY=',I5)
180   FORMAT (' NPOS=',I3,3X,'NFILL=',I3,3X,'IPTRNX=',I3,3X,
     *   'IVUGNL=',I3)
190   FORMAT (' USER PARAMETERS SUCCESSFULLY READ')
200   FORMAT (' USER PARAMETERS NOT SUCCESSFULLY READ')
210   FORMAT (' *** EXIT SRUGNL')
C
      END

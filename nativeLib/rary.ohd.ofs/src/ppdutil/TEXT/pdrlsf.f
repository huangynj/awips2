C MEMBER PDRLSF
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 06/10/94.15:53:00 BY $WC20SV
C
C @PROCESS LVL(77)
C
      SUBROUTINE PDRLSF
C
C  THIS ROUTINE RELEASES ALL THE FREEPOOL RECORDS FOR A DATA TYPE FOR
C  A STATION
C
      CHARACTER*72 XSTRNG
C
      DIMENSION IRBUF(16),ISTAID(2)
C
      INCLUDE 'uio'
      INCLUDE 'udebug'
      INCLUDE 'ufreei'
      INCLUDE 'pdbcommon/pdunts'
      INCLUDE 'pdbcommon/pdrrsc'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppdutil/RCS/pdrlsf.f,v $
     . $',                                                             '
     .$Id: pdrlsf.f,v 1.1 1995/09/17 19:09:30 dws Exp $
     . $' /
C    ===================================================================
C
C
C
      LRECL=16
C
C  READ CARD
10    CALL RPCARD (IBUF,IERR)
      CALL WPCARD (IBUF)
C
C  FIND FIELDS ON CARD
      CALL UFREE (1,72)
C
C  CHECK IF NO FIELDS ON CARD
      IF (NFIELD.EQ.0) GO TO 10
C
C  GET FIRST FIELD
      XSTRNG=' '
      NFLD=1
      NCHAR=IFSTOP(NFLD)-IFSTRT(NFLD)+1
      IF (NCHAR.GT.LEN(XSTRNG)) NCHAR=LEN(XSTRNG)
      CALL UPACK1 (IBUF(IFSTRT(NFLD)),XSTRNG,NCHAR)
      IF (IPDDB.GT.0) THEN
         CALL ULINE (LPD,1)
         WRITE (LPD,*) 'XSTRNG=',XSTRNG
         ENDIF
C
      IF (XSTRNG.EQ.'END') GO TO 110
C
      CALL SUBSTR (XSTRNG,1,8,ISTAID,-1)
      IF (NCHAR.GT.8) THEN
         CALL SUBSTR (XSTRNG,9,4,IDTYPE,-1)
         ELSE
            NFLD=2
            NCHAR=IFSTOP(NFLD)-IFSTRT(NFLD)+1
            CALL UPACK1 (IBUF(IFSTRT(NFLD)),IDTYPE,NCHAR)
         ENDIF
C
      IF (IPDDB.GT.0) THEN
         CALL ULINE (LPD,1)
         WRITE (LPD,'(1X,A,2A4)') 'ISTAID=',ISTAID
         WRITE (LPD,'(1X,A,A4)') 'IDTYPE=',IDTYPE
         ENDIF
C
C  READ PRIMARY FILE CONTROL RECORD
      IREC=1
      CALL UREADT (KPDRRS,IREC,IRBUF,IERR)
      IF (IERR.GT.0) GO TO 80
      LASTRC=IRBUF(2)-1
      IF (LASTRC.GT.2) GO TO 20
         WRITE (LP,120)
         GO TO 110
C
C  READ PRIMARY FILE DATA RECORDS
20    IREC=2
30    CALL UREADT (KPDRRS,IREC,IRBUF,IERR)
      IF (IERR.GT.0) GO TO 80
C
C  CHECK IF AT END OF PRIMARY RRS FILE
      LPRIM=IRBUF(1)
      IF (LPRIM.GT.0) GO TO 40
         WRITE (LPE,130) IDTYPE,ISTAID
         GO TO 10
C
40    NXREC=IREC+1+(LPRIM-1)/LRECL
C
C  CHECK STATION IDENTIFIER AND DATA TYPE
      IF (IRBUF(2).EQ.ISTAID(1).AND.IRBUF(3).EQ.ISTAID(2).AND.
     *   IRBUF(5).EQ.IDTYPE) GO TO 50
         IREC=NXREC
         IF (IREC.LE.LASTRC) GO TO 30
            WRITE (LPE,130) IDTYPE,ISTAID
            GO TO 10
C
50    IF (IRBUF(13).GT.0) GO TO 60
C
C  STATION HAS NO FREEPOOL RECORDS
      WRITE (LPE,140) IDTYPE,ISTAID
      GO TO 10
C
C  SET RECORD NUMBER OF FREEPOOL CONTINUATION RECORD TO ZERO
60    IFREC=IRBUF(13)
      IRBUF(13)=0
C
C  SET TIME OF FIRST FREEPOOL DATA VALUE TO ZERO
      IRBUF(15)=0
C
C  WRITE PRIMARY RECORD TO FILE
      CALL UWRITT (KPDRRS,IREC,IRBUF,IERR)
      IF (IERR.GT.0) GO TO 100
      WRITE (LP,150) IDTYPE,ISTAID
C
      IF (IFREC.LT.1) GO TO 10
C
C  SET FREEPOOL RECORDS TO UNUSED
      KUNIT=KPDDDF(LUFREE)
70    CALL UREADT (KUNIT,IFREC,IRBUF,IERR)
      IF (IERR.GT.0) GO TO 90
      NEXTFP=IRBUF(1)
      IF (NEXTFP.LT.0) GO TO 10
      IRBUF(1)=-1
      CALL UWRITT (KUNIT,IFREC,IRBUF,IERR)
      IF (IERR.GT.0) GO TO 100
      WRITE (LP,160) IFREC
      IFREC=NEXTFP
      IF (IFREC.GT.0) GO TO 70
      GO TO 10
C
80    WRITE (LPE,170) 'READING PRIMARY',IREC
      GO TO 110
90    WRITE (LPE,170) 'READING FREEPOOL',IFREC
      GO TO 110
100   WRITE (LPE,170) 'WRITING FREEPOOL',IFREC
      GO TO 110
C
110   RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
120   FORMAT ('0**WARNING** NO RRS STATIONS ARE DEFINED.')
130   FORMAT ('0**WARNING** NO RRS DATA RECORDS FOUND ',
     *   'FOR DATA TYPE ',A4,' FOR STATION ',2A4,'.')
140   FORMAT ('0**NOTE** NO FREEPOOL RECORDS FOUND ',
     *   'FOR DATA TYPE ',A4,' FOR STATION ',2A4,'.')
150   FORMAT ('0**NOTE** FREEPOOL REFERENCE REMOVED FROM PRIMARY ',
     *   'RECORD ',
     *   'FOR DATA TYPE ',A4,' FOR STATION ',2A4,'.')
160   FORMAT (' **NOTE** FREEPOOL RECORD ',I7,' SET TO UNUSED.')
170   FORMAT ('0**ERROR** ',A,' RECORD ',I7,'.')
C
      END

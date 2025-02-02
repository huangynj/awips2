C MODULE PDRRSF
C-----------------------------------------------------------------------
C
      SUBROUTINE PDRRSF (IDTAIL,IRLSE,ISTREC,MSTREC)
C
C  THIS ROUTINE ANALYZES RRS PRIMARY AND FREE POOL FILES IN THE
C  PREPROCESSOR DATA BASE AND LISTS ALL FREE POOL CHAINS FOUND.
C  ANY CHAINS THAT END WITH A RECORD MARKED NOT IN USE ARE NOTED.
C  ALL FREE POOL RECORDS MARKED IN USE BUT NOT REFERENCED ARE NOTED.
C
C  ARRAY ISTREC IS ORGANIZED AS FOLLOWS:
C    1. RECORD NUMBER OF PRIMARY RECORD IN RRS FILE
C    2. RECORD NUMBERS OF FREEPOOL RECORDS IN CHAIN
C    POSITION 2 IS REPEATED FOR EACH FREEPOOL RECORD IN CHAIN INCLUDING
C               THE LAST ONE (WHICH SHOULD ALWAYS BE ZERO)
C    POSITIONS 1 AND 2 ARE REPEATED FOR EACH CHAIN OF FREEPOOL RECORDS
C              IN THE FILE
C
C  ARRAY ISTLST IS ORGANIZED FOR EACH STATION (X) WITH A CHAIN
C    ISTLST(1,X) AND ISTLST(2,X) CONTAIN THE STATION NAME (IDENTIFIER)
C    ISTLST(3,X) CONTAINS THE DATA TYPE
C    ISTLST(4,X) CONTAINS THE NUMBER OF FREEPOOL RECORDS IN THE CHAIN+2
C        (ONE FOR THE PRIMARY RECORD RECORD NUMBER AND ONE FOR
C         THE LAST FREEPOOL RECORD POINTED TO (SHOULD ALWAYS BE ZERO))
C
      CHARACTER*4 CHAR1,CHAR2
      CHARACTER*8 USRNAM,STAID
C
      DIMENSION ISTREC(MSTREC)
      DIMENSION IBUF(16)
      PARAMETER (MSTLST=3000)
      DIMENSION ISTLST(4,MSTLST)
C
      INCLUDE 'uiox'
      INCLUDE 'pdbcommon/pdunts'
      INCLUDE 'pdbcommon/pdrrsc'
C
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppdutil/RCS/pdrrsf.f,v $
     . $',                                                             '
     .$Id: pdrrsf.f,v 1.2 2002/02/11 20:50:12 dws Exp $
     . $' /
C    ===================================================================
C
C
      LDEBUG=0
C
      IF (LDEBUG.GT.0) THEN
         CALL ULINE (LP,1)
         WRITE (LP,*) 'IDTAIL=',IDTAIL,
     *      ' IRLSE=',IRLSE
         ENDIF
C
      CHAR1='NO'
      CHAR2='NO'
      IF (IDTAIL.EQ.1) CHAR1='YES'
      IF (IRLSE.EQ.1) CHAR2='YES'
      IF (LDEBUG.GT.0) THEN
         CALL ULINE (LP,1)
         WRITE (LP,*) 'CHAR1=',CHAR1,
     *     ' CHAR2=',CHAR2
         ENDIF
      CALL ULINE (LP,2)
      WRITE (LP,170) CHAR1,CHAR2
C
      NSTLST=0
      NSTREC=0
      NPRIM=0
      NTOTCH=0
C
C  READ CONTROL RECORD
      IREC=1
      CALL UREADT (KPDRRS,IREC,IBUF,IERR)
      IF (IERR.GT.0) THEN
         CALL ULINE (LP,2)
         WRITE (LP,190) IREC,KPDRRS
         GO TO 160
         ENDIF
C
      IFIRST=IBUF(3)
      LAST=IBUF(7)
      NTOT=IBUF(7)-IBUF(3)+1
      CALL UMEMOV (IBUF(11),USRNAM,2)
      IREC=2
      KUNIT=KPDDDF(LUFREE)
C
C  CHECK RECORD NUMBER
10    IF (IREC.GT.MXRRSF) THEN
         CALL ULINE (LP,2)
         WRITE (LP,180) IREC,MXRRSF
         GO TO 40
         ENDIF
C
C  READ RRS RECORD
      CALL UREADT (KPDRRS,IREC,IBUF,IERR)
      IF (IERR.GT.0) THEN
         CALL ULINE (LP,2)
         WRITE (LP,190) IREC,KPDRRS
         GO TO 160
         ENDIF
C
C  AT END OF PRIMARY RRS FILE IF IBUF(1) LT 1
      LPRIM=IBUF(1)
      IF (LPRIM.LT.1) GO TO 40
C
C  CHECK IF STATION IS DELETED
      CALL UMEMOV (IBUF(2),STAID,2)
      IF (STAID.EQ.'DELETED') GO TO 30
      NPRIM=NPRIM+1
C
C  CHECK IF RECORDS CHAINED
      IF (IBUF(13).LT.1) GO TO 30
C
      IF (LDEBUG.GT.0) THEN
         WRITE (LP,*) 'NSTLST=',NSTLST,' STAID=',STAID,' MSTREC=',MSTREC
         ENDIF
C
C  STORE STATION INFORMATION
      IF (NSTLST.EQ.MSTLST) THEN
         CALL ULINE (LP,2)
         WRITE (LP,200) 'ISTLST',IREC
         GO TO 40
         ENDIF
      NSTLST=NSTLST+1
      IF (NSTLST.GT.MSTLST) THEN
         CALL UEROR (LP,2,-1)
         WRITE (LP,205) MSTLST
         GO TO 160
         ENDIF
      CALL UMEMOV (IBUF(2),ISTLST(1,NSTLST),2)
      CALL UMEMOV (IBUF(5),ISTLST(3,NSTLST),1)
C
C  STORE RECORD NUMBER OF STATION IN PRIMARY RRS FILE
      NSTREC=NSTREC+1
      IF (NSTREC+1.GT.MSTREC) THEN
         CALL UEROR (LP,2,-1)
         WRITE (LP,200) MSTREC
         GO TO 160
         ENDIF
      ISTREC(NSTREC)=IREC
      IFREC=IBUF(13)
C
C  STORE OLDEST CHAINED FREE POOL RECORD NUMBER
      NSTREC=NSTREC+1
      ISTREC(NSTREC)=IFREC
      NUMCHN=2
C
C  LOOP THROUGH CHAIN IN FREE POOL FILE
20    CALL UREADT (KUNIT,IFREC,IBUF,IERR)
      IF (IERR.GT.0) THEN
         CALL ULINE (LP,2)
         WRITE (LP,190) IREC,KUNIT
         GO TO 160
         ENDIF
      IF (NSTREC+1.GT.MSTREC) THEN
         CALL UEROR (LP,2,-1)
         WRITE (LP,200) MSTREC
         GO TO 160
         ENDIF
      IFREC=IBUF(1)
      NSTREC=NSTREC+1
      ISTREC(NSTREC)=IFREC
      NUMCHN=NUMCHN+1
      IF (LDEBUG.GT.0) THEN
         WRITE (LP,*) 'STAID=',STAID,' NSTREC=',NSTREC,' IFREC=',IFREC
         ENDIF
      IF (IFREC.GT.0) GO TO 20
C
C  STORE LENGTH OF CHAIN FOR THIS STATION
C  FIRST VALUE IS RECORD NUMBER OF STATION IN PRIMARY RRS FILE
C  LAST VALUE IS EITHER ZERO OR MINUS ONE, MARKING END OF CHAIN
      ISTLST(4,NSTLST)=NUMCHN
      NTOTCH=NTOTCH+NUMCHN-2
C
30    IREC=IREC+1+(LPRIM-1)/16
      GO TO 10
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  PRINT SUMMARY
40    MAXPCT=95
      IPCT=0
      IF (NPRIM.GT.0) IPCT=(FLOAT(NSTLST)/FLOAT(NPRIM))*100.+0.5
      CALL ULINE (LP,2)
      WRITE (LP,210) NSTLST,NPRIM,IPCT
      IF (IPCT.GT.MAXPCT) THEN
         CALL ULINE (LP,2)
         WRITE (LP,230) 'FREE POOL',IPCT,MAXPCT
         ENDIF
      IPCT=0
      IF (NTOT.GT.0) IPCT=(FLOAT(NTOTCH)/FLOAT(NTOT))*100.+0.5
      CALL ULINE (LP,2)
      WRITE (LP,220) NTOTCH,NTOT,IPCT
      IF (IPCT.GT.MAXPCT) THEN
         CALL ULINE (LP,2)
         WRITE (LP,230) 'PRIMARY',IPCT,MAXPCT
         ENDIF
C
      NFPNIU=0
      IF (NSTLST.LT.1) GO TO 100
C
C  PRINT FREE POOL INFORAMTION FOR EACH STATION AND DATA TYPE
      NSTREC=0
      DO 50 I=1,NSTLST
         NCHAIN=ISTLST(4,I)
         NCM1=NCHAIN-1
         NCM2=NCHAIN-2
         NSTREC=NSTREC+1
         IF (IDTAIL.EQ.1) THEN
            CALL ULINE (LP,2)
            WRITE (LP,240) (ISTLST(J,I),J=1,3),ISTREC(NSTREC),NCM2
            CALL ULINE (LP,1)
            WRITE (LP,250)
            ENDIF
         IS=NSTREC+1
         IE=IS+NCM2
         NSTREC=NSTREC+NCM1
         IF (IDTAIL.EQ.1) THEN
            NVAL=IE-IS+1
            NPER=15
            NLINES=(NVAL+NPER-1)/NPER
            CALL ULINE (LP,NLINES)
            WRITE (LP,260) (ISTREC(L),L=IS,IE)
            ENDIF
C     CHECK IF CHAIN ENDS WITH A MINUS ONE
         IF (ISTREC(IE).GT.-1) GO TO 50
            NFPNIU=NFPNIU+1
            IF (IDTAIL.EQ.0) THEN
               CALL ULINE (LP,2)
               WRITE (LP,270) (ISTLST(J,I),J=1,3)
               ENDIF
            IF (IDTAIL.EQ.1) THEN
               CALL ULINE (LP,1)
               WRITE (LP,280) (ISTLST(J,I),J=1,3)
               ENDIF
50       CONTINUE
      CALL ULINE (LP,2)
      WRITE (LP,290) NFPNIU
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF A FREEPOOL RECORD IS SHARED BY TWO CHAINS
C
      IF (NSTLST.LT.2) GO TO 100
C
      NSTREC=1
      IE=NSTLST-1
C
      DO 90 I=1,IE
         NCM2=ISTLST(4,I)-2
         KREC=NSTREC
C     CHECK IF RECORDS IN SUBSEQUENT CHAINS MATCH ANY RECORD IN CURRENT
C     CHAIN
         IS=I+1
         DO 80 K=IS,NSTLST
            KREC=KREC+ISTLST(4,K-1)
C        KREC POINTS TO WORD IN ISTREC CONTAINING PRIM REC NUMBER
C        OF KTH CHAIN
            KCM2=ISTLST(4,K)-2
            DO 70 L=1,KCM2
C        LOOP ON RECORD NUMBERS IN ITH CHAIN
               DO 60 J=1,NCM2
                  IF (ISTREC(NSTREC+J).EQ.ISTREC(KREC+L)) THEN
                     CALL ULINE (LP,2)
                     WRITE (LP,300)
     *                  (ISTLST(N,I),N=1,3),ISTREC(NSTREC),
     *                  (ISTLST(N,K),N=1,3),
     *                  ISTREC(KREC),ISTREC(NSTREC+J)
                     ENDIF
60                CONTINUE
70             CONTINUE
80          CONTINUE
            NSTREC=NSTREC+ISTLST(4,I)
90       CONTINUE
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  SCAN FOR FREE POOL RECORDS THAT ARE MARKED IN USE
C  BUT ARE NOT REFERENCED IN RRS CHAINS
C
100   NUNREF=0
C
      DO 150 I=IFIRST,LAST
         CALL UREADT (KUNIT,I,IBUF,IERR)
         IF (IERR.GT.0) THEN
            CALL ULINE (LP,2)
            WRITE (LP,190) IREC,KUNIT
            GO TO 160
            ENDIF
         IF (IBUF(1).EQ.-1) GO TO 150
         NSTREC=0
         IF (NSTLST.LT.1) GO TO 130
         DO 120 J=1,NSTLST
C        SKIP ONE FOR RECORD NUMBER OF STATION IN PRIMARY RRS FILE
            NSTREC=NSTREC+1
            NCH=ISTLST(4,J)-2
C        GO THROUGH CHAIN CHECKING FOR CURRENT RECORD NUMBER
            DO 110 K=1,NCH
               NSTREC=NSTREC+1
               IF (I.EQ.ISTREC(NSTREC)) GO TO 150
110            CONTINUE
C        SKIP ONE FOR ZERO OR MINUS ONE AT END OF CHAIN
            NSTREC=NSTREC+1
120         CONTINUE
C        NOT REFERENCED FREE POOL RECORD WHICH IS IN USE IF GET HERE
130         IF (IRLSE.EQ.1) THEN
               IBUF(1)=-1
               CALL UWRITT (KUNIT,I,IBUF,IERR)
               IF (IERR.NE.0) THEN
                  CALL ULINE (LP,2)
                  WRITE (LP,310) I
                  GO TO 150
                  ENDIF
               CALL ULINE (LP,2)
               WRITE (LP,320) I
               GO TO 140
               ENDIF
            CALL ULINE (LP,2)
            WRITE (LP,330) I
140         NUNREF=NUNREF+1
150      CONTINUE
C
      CHAR1='ARE'
      IF (IRLSE.EQ.1) CHAR1='WERE'
      CALL ULINE (LP,2)
      WRITE (LP,340) NUNREF,CHAR1(1:LENSTR(CHAR1))
C
160   RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
170   FORMAT ('0- OPTIONS IN EFFECT : ',
     *   'DETAIL=',A,3X,
     *   'RLSE=',A,3X)
190   FORMAT ('0**ERROR** DAIO ERROR READING RECORD ',I6,
     *   ' OF UNIT ',I2.2,'.')
180   FORMAT ('0**ERROR** RECORD TO BE READ (',I6,
     *   ') IS GREATER THAN MAXIMUM RECORDS IN FILE (',I6,').')
205   FORMAT ('0**ERROR** MAXIMUM NUMBER OF STATIONS THAT CAN BE ',
     *   'PROCESSED (',I5,') EXCEEDED.')
200   FORMAT ('0**ERROR** MAXIMUM NUMBER OF FREE POOL RECORDS THAT ',
     *   'CAN BE PROCESSED (',I5,') EXCEEDED.')
210   FORMAT ('0**NOTE** ',I5,' OF THE ',I5,' RRS STATIONS (',
     *   I3,' PERCENT) HAVE FREE POOL RECORDS.')
220   FORMAT ('0**NOTE** ',I5,' OF THE ',I5,' FREE POOL RECORDS (',
     *   I3,' PERCENT) ARE USED.')
230   FORMAT ('0**WARNING** PERCENT OF ',A,' RECORDS USED (',I3,
     *   ') EXCEEDS ',I3,'.')
240   FORMAT ('0STATION = ',2A4,3X,
     *   'DATA TYPE = ',A4,3X,
     *   'RECORD NUMBER IN PRIMARY FILE = ',I6,3X,
     *   'NUMBER OF FREE POOL RECORDS = ',I5)
250   FORMAT (' FREE POOL RECORD NUMBERS:')
260   FORMAT (15(1X,I6),1X)
270   FORMAT ('0**WARNING** FREE POOL CHAIN ',
     *   'ENDS WITH A RECORD MARKED NOT IN USE FOR ',
     *   'STATION ',2A4,' AND DATA TYPE ',A4,'.')
280   FORMAT (' **WARNING** THE ABOVE FREE POOL CHAIN ',
     *   'ENDS WITH A RECORD MARKED NOT IN USE. ',
     *   '(STATION =',2A4,1X,'DATA TYPE=',A4,').')
290   FORMAT ('0**NOTE** ',I5,' FREE POOL CHAINS END WITH RECORDS ',
     *   'MARKED NOT IN USE.')
300   FORMAT ('0**WARNING** STATIONS ',2A4,1X,A4,' (AT RECORD',I6,
     *   ') AND ',2A4,1X,A4,' (AT RECORD',I6,') SHARE FREEPOOL ',
     *   'RECORD',I6,'.')
310   FORMAT ('0**ERROR** WRITING FREE POOL RECORD ',I6,'.')
320   FORMAT ('0**NOTE** FREE POOL RECORD ',I6,' IS MARKED IN ',
     *   'USE BUT IS NOT REFERENCED AND HAS BEEN RELEASED.')
330   FORMAT ('0**WARNING** FREE POOL RECORD ',I6,' IS MARKED IN ',
     *   'USE BUT IS NOT REFERENCED.')
340   FORMAT ('0**NOTE** ',I5,' FREE POOL RECORDS ',A,
     *   ' MARKED IN USE BUT NOT REFERENCED IN A FREE POOL CHAIN.')
C
      END

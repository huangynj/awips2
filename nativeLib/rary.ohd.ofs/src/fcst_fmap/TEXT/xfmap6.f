C MODULE XFMAP6
C-----------------------------------------------------------------------
C
      SUBROUTINE XFMAP6 (FMAPIN,LFMAPIN,MAXMOD,NUMMOD,IMGMOD,IERR)
C
C  *********************************************************************
C  XFMAP6 DECODES THE FMAP6 MOD
C  *********************************************************************
C
C  IMPORTANT VARIABLES INCLUDE:
C
C       ICMDCD = FLAG TO INDICATE WHETHER A COMMAND CARD IS BEING
C                DECODED; ICMDCD=1=COMMAND CARD,ICMDCD=0=IDENTIFIER CARD
C       NFIELD = FIELD NUMBER OF IBUF ARRAY BEING PROCESSED
C       IMGMOD = MOD CARDS RETURNED FROM HMODCK
C       FMAPIN = DECODED INPUT ARRAY
C       LIDENT = LOCATION OF THE NUMBER OF IDENTIFIER CARDS ASSOCIATED
C                WITH A COMMAND CARD IN THE FMAPIN ARRAY
C        LNPX6 = LOCATION OF THE NUMBER OF INPUT 6 HOUR PRECIP VALUES
C                ASSOCIATED WITH AN IDENTIFIER (OR RANGE OF IDENTIFIERS)
C                IN THE FMAPIN ARRAY
C       MAXMOD = MAXIMUM MOD CARDS ALLOWED
C       NIDENT = NUMBER OF IDENTIFIER CARDS ASSOCIATED WITH A COMMAND
C                CARD
C         NPX6 = NUMBER OF INPUT 6 HOUR PRECIP VALUES ASSOCIATED WITH AN
C                IDENTIFIER OR RANGE OF IDENTIFIERS
C         NMOD = NUMBER OF MODS THAT HAVE BEEN PROCESSED
C         NTID = TOTAL NUMBER OF VALID IDENTIFIER CARDS DECODED
C        NTPX6 = TOTAL NUMBER OF VALID INPUT 6 HOUR PRECIP VALUES
C                DECODED
C
C  CONTENTS OF FMAPIN ARE AS FOLLOWS:
C   POSITION     CONTENTS
C   --------     --------
C       1        NUMBER OF .FMAP6 MODS IN RUN
C     2-5        CONTENTS OF FIRST COMMAND CARD.
C       2        NUMBER OF IDENTIFIER CARDS FOR FIRST MOD
C       3        JULIAN HOUR FOR FIRST MOD (INTERNAL TIME --
C                  END OF FIRST SIX-HOUR PERIOD)
C       4        TYPE OF IDENTIFIERS
C                  0.01 = CHARACTERS
C                  1.01 = NUMBERS
C       5        UNITS
C                  0.01 = ENGLISH
C                  1.01 = METRIC
C     6-11+
C (VALUE IN 6)   CONTENTS OF FIRST IDENTIFIER CARD
C       6        NUMBER OF PRECIP VALUES (INCLUDING CONTINUATIONS)
C       7        0.01 = SINGLE ID   --   1.01 = RANGE OF IDS
C     8-9        IDENTIFIER (FIRST IF RANGE)
C                  BOTH POSITIONS IF CHARACTER, JUST 9 IF NUMBER
C   10-11        SECOND IDENTIFIER (FILLED FOR RANGE ONLY)
C     12+        SIX-HOUR PRECIP VALUES.
C  REPEAT 6-12+ FOR EACH IDENTIFIER
C  REPEAT 2-12+ FOR EACH MOD CARD
C
      CHARACTER*8 OLDOPN
      CHARACTER*80 IMGMOD(MAXMOD)
C
      DIMENSION FMAPIN(LFMAPIN)
C
      INCLUDE 'ufreei'
      INCLUDE 'common/ionum'
      INCLUDE 'common/pudbug'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_fmap/RCS/xfmap6.f,v $
     . $',                                                             '
     .$Id: xfmap6.f,v 1.4 2002/02/11 20:37:07 dws Exp $
     . $' /
C    ===================================================================
C
      DATA DOT/4H.   /,M/4HM   /
C
C
      IOPNUM=-1
      CALL FSTWHR ('XFMAP6  ',IOPNUM,OLDOPN,IOLDOP)
C
      IF (IPTRCE.GT.0) WRITE (IOPDBG,*) 'ENTER XFMAP6'
C
      IBUG=IPBUG('XF6 ')
C
C  GET FMAP6 MODS
      CALL HMODCK ('FMAP6   ',MAXMOD,IMGMOD,NUMMOD,ISTAT)
      IF (IBUG.EQ.1) WRITE (IOPDBG,*) 'NUMMOD=',NUMMOD
      IF (ISTAT.NE.0) THEN
         IF (ISTAT.EQ.1) THEN
            WRITE (IPR,580) MAXMOD,MAXMOD
            CALL WARN
            GO TO 10
            ENDIF
         IF (ISTAT.EQ.2) THEN
            WRITE (IPR,590)
            CALL ERROR
            ENDIF
         IERR=1
         GO TO 690
         ENDIF
C
C  CHECK IF ANY FMAP6 MOD CARDS FOUND
10    IF (NUMMOD.EQ.0) GO TO 690
C
      ICMDCD=0
      NMOD=0
      NIDENT=0
      NTID=0
      LIDENT=2
      NPX6=0
      NTPX6=0
      ICONT=0
      NUSE=1
      DO 60 K=1,LFMAPIN
         FMAPIN(K)=.01
60       CONTINUE
C
C  PROCESS EACH MOD CARD
      DO 520 I=1,NUMMOD
         IF (IBUG.GT.0) WRITE (IOPDBG,*) 'I=',I,
     *      ' IMGMOD(I)=',IMGMOD(I)
         CALL UNPAKS (IMGMOD(I),IBUF,20,80,ISTAT)
         IBEG=1
         IEND=72
         CALL UFREE (IBEG,IEND)
         IF (IBUG.GT.0) WRITE (IOPDBG,*) 'NFIELD=',NFIELD
         IF (NFIELD.EQ.0) THEN
C        NO FIELDS FOUND ON THE MOD CARD
            WRITE (IPR,600)
            CALL WARN
            GO TO 520
            ENDIF
C     CHECK FOR A CONTINUATION CARD
         IF (ICONT.NE.1) GO TO 100
            ICONT=0
            IFIELD=1
            GO TO 410
C     SEARCH FOR A COMMAND CARD
100      IFIELD=1
         ISTART=IFSTRT(IFIELD)
         IEND=IFSTOP(IFIELD)
         CALL USRCHR (DOT,ISTART,IEND,INDEX)
         IF (INDEX.EQ.0) GO TO 250
C     THIS IS A COMMAND CARD
         IFIELD=2
         ISTART=IFSTRT(IFIELD)
         IEND=IFSTOP(IFIELD)
         ICMDCD=0
C     CHECK DATE FIELD FOR AN ASTERISK - NOT VALID FOR FUTURE MAP
         CALL USRAST (IBUF,ISTART,IEND,INDEX)
         IF (INDEX.EQ.(IEND+1)) GO TO 110
            WRITE (IPR,610)
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 520
C     DECODE THE DATE FIELD
110      CALL HDATEC (ISTART,IEND,-18,1,1,JDAY,IHR,JHR,ISTAT)
         IF (ISTAT.NE.0) THEN
            WRITE (IPR,675)
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 520
            ENDIF
C     CHECK IF THE INPUT DATE IS FOR THE END OF A 6 HOUR PERIOD
         IRMAIN=MOD(JHR,6)
         IF (IRMAIN.EQ.0) GO TO 150
            IF (IRMAIN.GE.3) GO TO 130
               JHR=JHR-IRMAIN
               WRITE (IPR,620) NFIELD
               WRITE (IPR,680) IBUF
               CALL WARN
               GO TO 150
130         JHR=JHR-IRMAIN+6
            WRITE (IPR,630) NFIELD
            WRITE (IPR,680) IBUF
            CALL WARN
C     BEGIN FILLING THE DECODED INPUT ARRAY (FMAPIN)
150      N=4*NMOD+6*NTID+NTPX6+3
         IUSE=NUSE+11
         CALL XFCKIN (LFMAPIN,IUSE,ISTAT)
         IF (ISTAT.NE.0) THEN
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 530
            ENDIF
         LCON=N+1
         IF (IBUG.GT.0) WRITE (IOPDBG,*) 'N=',N
         FMAPIN(N)=JHR+.01
C     CHECK FOR COMPUTATIONAL ORDER FLAG
         IF (NFIELD.LT.3) GO TO 240
         IFIELD=3
         ISTART=IFSTRT(3)
         IEND=IFSTOP(3)
         CALL USRCHR (4HN   ,ISTART,ISTART,INDEX)
         IF (IBUG.GT.0) WRITE (IOPDBG,190) INDEX
190   FORMAT (' THE VALUE OF INDEX AFTER SEARCH FOR AN N = ',I2)
         IF (INDEX.NE.0) FMAPIN(LCON)=1.01
C     CHECK FOR METRIC FLAG
         IF (INDEX.EQ.0) GO TO 210
            IF (NFIELD.LT.4) GO TO 240
            IFIELD=4
            ISTART=IFSTRT(4)
            IEND=IFSTOP(4)
210      CALL USRCHR (M,ISTART,ISTART,INDEX)
         IF (IBUG.GT.0) WRITE (IOPDBG,220) INDEX
220   FORMAT (' THE VALUE OF INDEX AFTER SEARCH FOR AN M= ',I2)
         IF (INDEX.NE.0) FMAPIN(N+2)=1.01
C     CHECK IF NUMBER OF FIELDS DOES EXCEEDS THE NUMBER EXPECTED
         IF (NFIELD.LE.4) GO TO 240
            WRITE (IPR,640)
            WRITE (IPR,680) IBUF
            CALL WARN
240      ICMDCD=1
         NMOD=NMOD+1
         IF (NMOD.GT.1) LIDENT=N-1
         NIDENT=0
         NUSE=NUSE+4
         GO TO 520
C     THIS IS NOT A COMMAND CARD
C     CHECK IF A COMMAND CARD HAS BEEN SUCCESSFULLY DECODED
250      IF (ICMDCD.EQ.1) GO TO 260
            WRITE (IPR,650)
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 520
C     DECODE THE IDENTIFIER FIELD
260      IFIELD=1
         ISTART=IFSTRT(1)
         IEND=IFSTOP(1)
         IUSE=NUSE+7
         CALL XFCKIN (LFMAPIN,IUSE,ISTAT)
         IF (ISTAT.NE.0) THEN
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 530
            ENDIF
C     CHECK THE IDENTIFIER FIELD FOR A RANGE OF IDENTIFIERS
         CALL USRDSH (IBUF,ISTART,IEND,IDASH)
         IF (IBUG.GT.0) WRITE (IOPDBG,*) 'IDASH=',IDASH
         N=4*(NMOD-1)+6*NTID+NTPX6+7
         LNPX6=N-1
         IF (IDASH.NE.(IEND+1)) FMAPIN(N)=1.01
C     CHECK THE COMPUTATIONAL ORDER FLAG TO SEE IF IDENTIFIERS ARE
C     COMPUTATIONAL ORDER NUMBERS
         IF (FMAPIN(LCON).LT.1.0) GO TO 330
C     COMPUTATIONAL ORDER NUMBERS ARE BEING USED
         IF (FMAPIN(N).LT.1.0) GO TO 310
C     A RANGE HAS BEEN SPECIFIED
         CALL UNUMIC (IBUF,ISTART,IDASH-1,NUM)
         FMAPIN(N+2)=NUM+.01
         CALL UNUMIC (IBUF,IDASH+1,IEND,NUM)
         FMAPIN(N+4)=NUM+.01
         IF (IBUG.GT.0) WRITE (IOPDBG,300) FMAPIN(N+2),FMAPIN(N+4)
300   FORMAT (' FMAPIN(N+2) = ',F7.2,' FMAPIN(N+4) = ',F7.2)
         GO TO 380
C     A RANGE WAS NOT SPECIFIED
310      CALL UNUMIC (IBUF,ISTART,IEND,NUM)
         FMAPIN(N+2)=NUM+.01
         IF (IBUG.GT.0) WRITE (IOPDBG,320) FMAPIN(N+2)
320   FORMAT (' FMAPIN(N+2) = ',F5.2)
         GO TO 380
C     FMAP AREA IDENTIFIERS ARE BEING USED
330      IF (FMAPIN(N).LT.1.0) GO TO 360
C     A RANGE HAS BEEN SPECIFIED
         MAXLEN=8
         LENGTH=IDASH-ISTART
         IF (LENGTH.GT.MAXLEN) THEN
            WRITE (IPR,660) NFIELD,MAXLEN
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 520
            ENDIF
         CALL FMDPK8 (IBUF,ISTART,LENGTH,FMAPIN(N+1))
         LENGTH=IEND-IDASH
         IF (LENGTH.GT.8) THEN
            WRITE (IPR,660) NFIELD,MAXLEN
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 520
            ENDIF
         CALL FMDPK8 (IBUF,IDASH+1,LENGTH,FMAPIN(N+3))
         GO TO 380
C     A RANGE WAS NOT SPECIFIED
360      MAXLEN=8
         LENGTH=IEND-ISTART+1
         IF (LENGTH.GT.MAXLEN) THEN
            WRITE (IPR,660) NFIELD,MAXLEN
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 520
            ENDIF
         CALL FMDPK8 (IBUF,ISTART,LENGTH,FMAPIN(N+1))
C     DECODE THE SIX HOUR PRECIP VALUES
380      IF (IBUG.GT.0) WRITE (IOPDBG,*) 'DECODING PRECIP VALUES'
         IFIELD=IFIELD+1
         JJ=N+5
         NPX6=0
         NUSE=NUSE+6
410      IUSE=NUSE+NFIELD-IFIELD+1
         CALL XFCKIN (LFMAPIN,IUSE,ISTAT)
         IF (ISTAT.NE.0) THEN
            WRITE (IPR,680) IBUF
            CALL ERROR
            GO TO 530
            ENDIF
         DO 450 II=IFIELD,NFIELD
            ISTART=IFSTRT(II)
            IEND=IFSTOP(II)
            CALL UFIXED (IBUF,FMAPIN(JJ),ISTART,IEND,2,0,ISTAT)
            IF (ISTAT.NE.0) THEN
C           CHECK FOR A CONTINUATION CHARACTER
               CALL USRCHR (4H&   ,ISTART,IEND,IX)
               IF (IX.GT.0) THEN
                  ICONT=1
                  FMAPIN(JJ)=.01
                  GO TO 460
                  ENDIF
               WRITE (IPR,670) II
               WRITE (IPR,680) IBUF
               FMAPIN(JJ)=.01
               CALL WARN
               ENDIF
            NPX6=NPX6+1
            NTPX6=NTPX6+1
            JJ=JJ+1
450         CONTINUE
460      IF (ICONT.NE.1) GO TO 480
         IF (IBUG.GT.0) WRITE (IOPDBG,*) 'A CONTINUATION HAS BEEN FOUND'
         GO TO 510
480      IF (IBUG.GT.0) WRITE (IOPDBG,*) 'PRECIP VALUES DECODED'
         NTID=NTID+1
         NIDENT=NIDENT+1
         FMAPIN(LIDENT)=NIDENT+.01
         FMAPIN(LNPX6)=NPX6+.01
510      NUSE=NUSE+NPX6
520      CONTINUE
C
530   FMAPIN(1)=NMOD+.01
C
      IF (IBUG.GT.0) THEN
         N=4*NMOD+NTID*6+NTPX6+1
         WRITE (IOPDBG,540)
540   FORMAT (' CONTENTS OF FMAPIN AFTER DECODING .FMAP6 MODS:')
         WRITE (IOPDBG,550) (FMAPIN(J),J=1,N)
550   FORMAT (' ',10F10.2)
         WRITE (IOPDBG,560) (FMAPIN(J),J=1,N)
560   FORMAT (' ',10(6X,A4))
         ENDIF
C
690   CALL FSTWHR (OLDOPN,IOLDOP,OLDOPN,IOLDOP)
      IF (IPTRCE.GT.0) WRITE (IOPDBG,*) 'EXIT XFMAP6'
C
      RETURN
C
580   FORMAT ('0**WARNING** MAXIMUM NUMBER OF .FMAP6 MOD CARDS (',I4,
     * ') EXCEEDED. ONLY THE FIRST ',I4,' WILL BE PROCESSED.')
590   FORMAT ('0**ERROR** FMAP6 NOT ALLOWED FOR THIS ',
     * 'ROUTINE OR INVALID MOD COMMAND.')
600   FORMAT ('0**WARNING** NO FIELDS ENCOUNTERED ON THE MOD ',
     * 'CARD. CARD SKIPPED.')
610   FORMAT ('0**ERROR** AN ASTERISK CANNOT BE USED AS A ',
     * 'DATE FOR FUTURE MAP MODS.')
620   FORMAT ('0**WARNING** INPUT DATE IN FIELD ',I2,' DOES ',
     * 'NOT END ON A SIX HOUR PERIOD. THE DATE HAS BEEN RESET ',
     * 'TO THE END OF THE PRECEDING SIX HOUR PERIOD.')
630   FORMAT ('0**WARNING** INPUT DATE IN FIELD ',I2,' DOES ',
     * 'NOT END ON A SIX HOUR PERIOD. THE DATE HAS BEEN RESET ',
     * 'TO THE END OF THE NEXT SIX HOUR PERIOD.')
640   FORMAT ('0**WARNING** UNEXPECTED FIELDS ENCOUNTERED ON ',
     * 'AN FMAP6 MOD. EXTRA FIELDS IGNORED.')
650   FORMAT ('0**ERROR** AN IDENTIFIER CARD WAS ',
     * 'ENCOUNTERED BEFORE A VALID FMAP6 CARD WAS FOUND. ',
     * 'THE IDENTIFIER CARD WILL NOT BE PROCESSED.')
660   FORMAT ('0**ERROR** THE IDENTIFIER IN FIELD ',I2,
     * ' HAS MORE THAN ',I2,' CHARACTERS. CARD SKIPPED.')
670   FORMAT ('0**WARNING** THE PRECIP IN FIELD ',I2,
     * ' CONTAINS AN INVALID CHARACTER. THE PRECIP ',
     * 'AMOUNT AND HAS BEEN SET TO ZERO.')
675   FORMAT ('0**ERROR** INVALID DATE FIELD FOUND. CARD SKIPPED.')
680   FORMAT ('0THE FOLLOWING CARD CAUSED THIS MESSAGE:' /
     * 1X,80A1)
C
      END

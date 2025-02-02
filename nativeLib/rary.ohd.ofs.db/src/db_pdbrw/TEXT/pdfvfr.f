C MODULE PDFVFR
C-----------------------------------------------------------------------
C
      SUBROUTINE PDFVFR (IFLAG,ITIM,VAL,IPER,ISKIP,MIN,IFUT,IREV,
     *   IRRBUF,IFRBUF,ISTAT)
C
C  THIS ROUTINE FINDS THE LOCATION OF AN OBSERVATION SET IN AN
C  FREE POOL RECORD. IF ITIM IS NEGATIVE, IT DELETES THE VALUE.
C  IF IT FINDS THE SAME TIME AND PERIOD, IT REPLACES THE VALUE.
C  IF IT CANNOT FIND THE TIME, IT INSERTS THE VALUE.
C
C  ARGUMENT LIST:
C
C     NAME    TYPE   I/O   DIM   DESCRIPTION
C     ----    ----   ---   ---   -----------
C     IFLAG     I     I     1    FLAG TO DO STATISTICS
C     ITIM      I     I     1    TIME OF DATA (JULIAN HOUR)
C     VAL       R     I     1    DATA VALUE
C     IPER      I     I     1    TIME PERIOD OF DATA
C     ISKIP     I     I     1    NUMBER OF WORDS FOR OBSERVATION
C     MIN       I     I     1    MINUTES OF DATA
C     IFUT      I     I     1    FUTURE FLAG
C     IREV      I     I     1    REVISION FLAG
C     IRRBUF    I    I/O    ?    ARRAY TO HOLD RRS RECORD
C     IFRBUF    I    I/O    ?    ARRAY TO HOLD FREE POOL RECORD
C     ISTAT     I     O     1    STATUS INDICATOR:
C                                  0=NORMAL RETURN
C                                  1=DATA NOT WRITTEN OR DELETED
C                                  2=READ/WRITE ERROR
C
      DIMENSION IRRBUF(1),IFRBUF(1)
C
      INCLUDE 'uio'
      INCLUDE 'udebug'
      COMMON /PDBREV/ IREVSN
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/db_pdbrw/RCS/pdfvfr.f,v $
     . $',                                                             '
     .$Id: pdfvfr.f,v 1.2 1999/01/19 19:41:40 page Exp $
     . $' /
C    ===================================================================
C
C
      IF (IPDTR.GT.1) WRITE (IOGDB,10)
10    FORMAT(' *** ENTER PDFVFR')
C
      ITIME=IABS(ITIM)
      IREC=IRRBUF(13)
      IREVSN=IREV
C
C  READ A FREE POOL RECORD
20    CALL PDRDFR (IREC,IFRBUF,ISTAT)
      IF (ISTAT.NE.0) GO TO 80
C
C  SEARCH THE RECORD
      NUM=IFRBUF(2)
      IPOS=3
      DO 40 I=1,NUM
         IF (ITIME.LT.JULMIN(ISKIP,IFRBUF(IPOS))) GO TO 50
         IF (ITIME.GT.JULMIN(ISKIP,IFRBUF(IPOS))) GO TO 30
C        TIME IS SAME - CHECK PERIOD
            IF (ISKIP.EQ.2.OR.IFRBUF(IPOS+2).EQ.IPER) GO TO 60
            IF (IPER.GT.IFRBUF(IPOS+2)) GO TO 50
30       IPOS=IPOS+ISKIP
40       CONTINUE
C
C  SEARCH NEXT FREE POOL RECORD
      IF (IFRBUF(1).EQ.0) GO TO 50
         IREC=IFRBUF(1)
         GO TO 20
C
50    IF (ITIM.LT.0) GO TO 100
C         
C  TIME NOT FOUND - INSERT A VALUE
      CALL PDMVFR (ITIME,VAL,IPER,ISKIP,MIN,IREC,IPOS,IFRBUF,ISTAT)
      IF (ISTAT.NE.0) GO TO 80
      IF (IFLAG.EQ.1) GO TO 110
      CALL PDSTAR (1,ITIME,VAL,0,MIN,IFUT,IRRBUF,IFRBUF,ISTAT)
      IF (ISTAT.EQ.1) GO TO 100
      IF (ISTAT.NE.0) GO TO 80
      GO TO 110
C
C  REPLACE VALUE
60    IF (ITIM.LT.0) GO TO 70
      CALL PDSTAR (IREC,ITIME,VAL,IPOS,MIN,IFUT,IRRBUF,IFRBUF,ISTAT)
      IF (ISTAT.EQ.1) GO TO 100
      IF (ISTAT.NE.0) GO TO 80
      GO TO 110
C
C  DELETE A VALUE
70    IF (IREV.NE.1) GO TO 100
      IOVAL=IFRBUF(IPOS+1)
      CALL PDDELF (IREC,IPOS,IFUT,ITIME,IRRBUF,IFRBUF,ISTAT)
      IF (ISTAT.NE.0) GO TO 80
      CALL PDSTAR (1,ITIME,IOVAL,-IPOS,MIN,IFUT,IRRBUF,IFRBUF,ISTAT)
      IF (ISTAT.EQ.1) GO TO 100
      IF (ISTAT.EQ.0) GO TO 110
C
C  SYSTEM ERROR
80    WRITE (LP,90) ITIM
90    FORMAT ('0**ERROR** IN PDFVFR - SYSTEM ERROR FOR TIME OF ',I8)
      ISTAT=2
      GO TO 110
C
C  DATA NOT WRITTEN OR DELETED
100   ISTAT=1
C
110   IF (IPDTR.GT.1) WRITE (IOGDB,120) ISTAT
120   FORMAT (' *** EXIT PDFDFR : ISTAT=',I2)
C
      RETURN
C
      END

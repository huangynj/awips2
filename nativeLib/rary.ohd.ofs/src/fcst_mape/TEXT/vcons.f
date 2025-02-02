C MODULE VCONS
C-----------------------------------------------------------------------
C
C  THIS ROUTINE CONTINUALLY UPDATES THE TOTAL PE FOR THE MONTH
C  FOR THE LAST 12 MONTHS FOR EACH STATION FOR EACH MONTH.  THIS
C  THIS ROUTINE ALSO COMPUTES FOR EACH STATION THE NUMBER OF
C  OBSERVATIONS FOR EACH MONTH.
C
C  INPUTS:
C    - FROM THE PREPROCESSOR PARM FILE, THE SUMS OF PE FOR THE PAST
C      ELEVEN MONTHS AND THE TOTAL FOR THE CURRENT MONTH.
C      ALSO FROM THE PRPROCESSOR FILE, THE NUMBER OF OBSERVATIONS
C      FOR THE PAST ELEVEN MONTHS AND THE NUMBER FOR THE CURRENT MO.
C      AND THE LAST JULIAN DATE ON WHICH AN OBSERVATION WAS ENTERED
C      INTO A SUM.
C  OUTPUTS:
C    - THE SUM OF THE PE OBSERVATIONS FOR THE CURRENT MONTH
C    - THE NUMBER OF OBSERVATIONS SO FAR THIS MONTH
C    - THE LAST DATE ON WHICH AN OBERVATION WAS ENTERED INTO
C      A SUMMATION
C
      SUBROUTINE VCONS (PECOMP,PEPARM,JDA,JSTA,
     1 MXPDIM,MXDDIM,MOS2,JCRDAO,JPIDX,JPRMPR)
C
      DIMENSION PECOMP(MXDDIM),PEPARM(MXPDIM),PPARRY(106)
      COMMON /VMODAS/ LSTDAM(13)
      COMMON /VFIXD/ LRY,MRY,NDAYS,NDAYOB,LARFIL,LPDFIL
      COMMON /VTIME/ JDAYO,IYRS,MOS,JDAMOS,IHRO,IHRS,JDAMO,JDAYYR
      INCLUDE 'common/ionum'
      INCLUDE 'common/pudbug'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_mape/RCS/vcons.f,v $
     . $',                                                             '
     .$Id: vcons.f,v 1.4 2000/07/21 19:16:36 page Exp $
     . $' /
C    ===================================================================
C
C
      IF (IPTRCE.GT.0) WRITE (IOPDBG,*) 'ENTER VCONS'
C
      IBUG=IPBUG('VCON')
C
      IOPNUM=-1
      CALL FSTWHR ('VCONS   ',IOPNUM,OLDOPN,IOLDOP)
C
      MOS2=MOS
      IF (IBUG.GT.0) WRITE (IOPDBG,10)JPIDX,MOS,MOS2
10    FORMAT (' IN VCONS : JPIDX=',I5,' MOS=',I5,' MOS2=',I5)
C
      JPTR=58*(JPIDX-1)
      NVAL=PEPARM(JPTR+35+MOS2)
      PESUM=PEPARM(JPTR+23+MOS2)
      JDAOB=PEPARM(JPTR+48)
      JDAMOJ=JDAMOS
      IF (IBUG.GT.0) WRITE (IOPDBG,20) JPTR,JDAYO,JDA,JDAOB
20    FORMAT (' IN VCONS : JPTR=',I5,' JDAYO=',I8,' JDA=',I5,
     *   ' JDAOB=',I8)
C
C  IF JDAOB IS NEGATIVE SET IT TO THE FIRST DAY OF THE CURRENT MONTH
      IF (JDAOB.LT.0) JDAOB=JDAYO-JDAMO+1
      IF (JDAOB.GT.JDAYO+35) JDAOB=0
C
C  CHECK FOR NEW ENTRIES IN THE OLD MONTH
      IF (JDAYO+JDA-1.LE.JDAOB) GO TO 190
      JPEPTR=NDAYOB*(JSTA-1)+JDA
      IF (IBUG.GT.0) WRITE (IOPDBG,40)NVAL,PESUM,MOS2,NDAYS,JSTA
40    FORMAT (' IN VCONS : NVAL=',I5,' PESUM=',F8.2,
     1 ' MOS2=',I5,' NDAYS=',I5,' JSTA=',I5)
      IF (MOS.NE.2.AND.MOS2.NE.2) GO TO 60
	 ILEAP=0
         IF (IYRS/4*4.EQ.IYRS) ILEAP=1
         IF (ILEAP.EQ.1) THEN
	    IF (MOS.EQ.2) MOS2=13
            IF (MOS2.EQ.2) MOS2=13
	    ENDIF
         IF (IBUG.GT.0) WRITE (IOPDBG,50) NVAL,PESUM,MOS2
50    FORMAT (' IN VCONS FEBRUARY LOOP : NVAL=',I5,
     *  ' PESUM=',F8.2,' MOS2=',I4)
         MOS2=MOS
C
C  SET UP SUMATIONS FOR RUNS THAT PASS THE END OF A MONTH
60    DO 140 J=1,JDA
         NOWDA=JDAYO+J-1
         IF (NVAL.GE.LSTDAM(MOS)) GO TO 110
         MODA=JDAMOJ+J-1
         IF (IBUG.GT.0) WRITE (IOPDBG,65)NVAL,MODA,MOS,MOS2
   65 FORMAT (' IN VCONS 1ST DEBUG IN DAILY LOOP: NVAL=',I5,
     1' MODA=',I5,' MOS=',I5,' MOS2=',I5)
         IF (NVAL.GT.MODA) GO TO 140
         IF (NVAL.GT.LSTDAM(MOS)) GO TO 90
            IF (IBUG.GT.1) WRITE (IOPDBG,70) JDAMOS,J,NOWDA,JDAOB,
     *         JDAYO,JDAMO
70    FORMAT (' IN VCONS AFTER TEST FOR NVAL GT DAYOFTHE MONTH.  ',
     1 ' JDAMOS=',I7,' J=',I4,' NOWDA=',I8,' JDAOB=',I8 /
     2 ' IF NOWDA IS LESS THAN OR EQUAL TO THE LAST OB, THE PE ',
     3 ' SUM WILL NOT ACCUMULATE' /
     4 ' JDAYO=',I8,' JDAMO=',I8)
            IF (NOWDA.LE.JDAOB) GO TO 140
            JPEPTR=NDAYOB*(JSTA-1)+J
            IF (PECOMP(JPEPTR).LT.-0.01) GO TO 140
            PESUM=PESUM+PECOMP(JPEPTR)
            NVAL=NVAL+1
            PPARRY(48)=NOWDA
            PEPARM(JPTR+48)=NOWDA
            JDAOB=NOWDA
            IF (IBUG.GT.1) WRITE (IOPDBG,80) NVAL,PESUM,JDAOB
80    FORMAT (' IN END OF MONTH ADDING LOOP : NEW VALUES ARE NVAL ',
     *   I5,' PESUM ',F6.2,' JDAOB ',I5)
90       PEPARM(JPTR+23+MOS2)=PESUM
         PEPARM(JPTR+35+MOS2)=NVAL
         IF (IBUG.GT.0) WRITE (IOPDBG,100) JDAOB,PESUM,NVAL,MODA
100   FORMAT (' IN VCONS AFTER A SUCCESSFUL INCREMENT: JDAOB=',I5,
     *   ' SUM=',F6.2,' NUMBER OF OBS=',I5,' MODA=',I5)
         IF (MODA.LT.LSTDAM(MOS)) GO TO 140
110      IF (IBUG.GT.0) WRITE (IOPDBG,120)JDA,JDAOB,NVAL,LSTDAM(MOS)
120   FORMAT (' IN THE ZEROING LOOP OF VCONS. ',
     1   ' THE JDA OF THE LAST DAY OF THE LAST MONTH WAS ',I4/
     2   ' JDAOB IS THE LAST DAY OF AN OBSERVED VALUE. ',I7,' NVAL=',I5,
     4   ' LSTDAM=',I5)
         PESUM=0.
         NVAL=0
         JDAMOJ=1-J
         MOS2=MOS+1
         IF (MOS2.EQ.14) MOS2=3
         IF (MOS2.EQ.13) MOS2=1
         IF (IBUG.GT.0) WRITE (IOPDBG,130) JDAOB,NDAYOB
130   FORMAT (' IN VCONS BEFORE FILLING FIRST OF MONTH LOOP : ',
     *   ' JDAOB=',I8,' NDAYOB=',I5)
      IF (IBUG.GT.0) WRITE (IOPDBG,135) NDAYOB,NOWDA,
     *    JDAOB,JSTA,JPEPTR,PECOMP(JPEPTR),MOS2,MOS,JPTR,PESUM,NVAL
135   FORMAT (' IN THE BEGINNING A MONTH LOOP OF VCONS : '
     1   ' NDAYOB=',I5,' NOWDA=',I8 /
     2   ' JDAOB OR THE LAST DAY FOR WHICH AN OB WAS TAKEN=',I8 /
     3   ' JSTA=',I5,' PECOMP(',I5,')=',F6.2,' MOS2=',I6,' MOS=',I5,
     4   ' JPTR=',I5,' PESUM=',F8.2,' NVAL=',I5)
140      CONTINUE
C
      DO 170 K=1,47
         PPARRY(K)=PEPARM(JPTR+K)
170      CONTINUE
      CALL WPPREC (PPARRY(2),'PE  ',48,PPARRY,JPRMPR,ISTAT)
      IF (ISTAT.NE.0) THEN
         IF (ISTAT.EQ.1) THEN
            WRITE(IPR,171)
171   FORMAT ('0**ERROR** SYSTEM ERROR ENCOUNTERED ',
     1 'ACCESSING THE PARAMETER FILE DURING A CALL TO WPPREC.')
            CALL ERROR
            ENDIF
         IF (ISTAT.EQ.2) THEN
            WRITE(IPR,172)
172   FORMAT ('0**ERROR** CANNOT WRITE PE PARAMETERS BECAUSE FILE IS ',
     1 ' FULL.')
            CALL ERROR
            ENDIF
         IF (ISTAT.EQ.3) THEN
            WRITE(IPR,173) PPARRY(2),PPARRY(3)
173   FORMAT ('0**ERROR** '2A4,' IS AN INVALID IDENTIFIER. ',
     1 'THIS INDICATES AN ERROR EITHER IN THE PARAMETRIC DATA BASE OR ',
     2 'THE CALL TO WPPREC.')
            CALL ERROR
            ENDIF
         ENDIF
C
190   CALL FSTWHR (OLDOPN,IOLDOP,OLDOPN,IOLDOP)
C
      IF (IPTRCE.GT.0) WRITE (IOPDBG,*) 'EXIT VCONS'
C
      RETURN
C
      END

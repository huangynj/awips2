C MEMBER PRTS21
C  (from old member FCPRTS21)
C DESC -- THIS SUBROUTINE PRINTS THE OUTPUT TIME SERIES ARRAYS.
C
C                             LAST UPDATE: 03/01/94.13:12:10 BY $WC30JL
C
C @PROCESS LVL(77)
C
      SUBROUTINE PRTS21(NPO,TO,QSTR,LOQSR,NSTR,NST,STNAM,JN)
C
C           THIS SUBROUTINE WAS WRITTEN BY:
C           JANICE LEWIS      HRL   NOVEMBER,1982     VERSION NO. 1
C
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU
C
      DIMENSION TO(*),QSTR(*),LOQSR(*),NSTR(*),NST(*),STNAM(3,*)
      DIMENSION SNAME(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_dwoper/RCS/prts21.f,v $
     . $',                                                             '
     .$Id: prts21.f,v 1.2 1996/01/16 11:34:34 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA SNAME/4HPRTS,4H21  /
C
C
      CALL FPRBUG(SNAME,1,21,IBUG)
      IF(IBUG.EQ.0) GO TO 1000
C
C         FIND THE TOTAL NUMBER OF OUTPUT TIME SERIES
C
      NSRR=0
      DO 10 J=1,JN
      NSRR=NSRR+NSTR(J)
   10 CONTINUE
C
      IF(NSRR.EQ.0) GO TO 1000
C
C        WRITE THE TIME ARRAY FOR THE OUTPUT TIME SERIES.
C
      WRITE(IODBUG,100)
  100 FORMAT(1H0,10X,45HTIME ARRAY FOR OUTPUT TIME SERIES HYDROGRAPH./)
      WRITE(IODBUG,110) (TO(K),K=1,NPO)
  110 FORMAT(1H ,10X,10F10.2)
C
C        WRITE OUTPUT TIME SERIES HYDROGRAPHS.
C
      DO 200 J=1,JN
      NSR=NSTR(J)
      IF(NSR.EQ.0) GO TO 200
      WRITE(IODBUG,120) J
  120 FORMAT(1H0,10X,43HOUTPUT TIME SERIES HYDROGRAPH FOR RIVER NO.,
     *I5//)
      DO 150 K=1,NSR
      LKJ=LCAT21(K,J,NSTR)
      LOQR=LOQSR(LKJ)-1
      WRITE(IODBUG,130) NST(LKJ),(STNAM(KK,LKJ),KK=1,3)
  130 FORMAT(1H0,10X,17HCROSS SECTION NO.,I4,5X,6HI.D.= ,2A4,5X,
     *6HTYPE= ,A4/)
      WRITE(IODBUG,140) (QSTR(L+LOQR),L=1,NPO)
  140 FORMAT(1H ,10X,10F12.2)
  150 CONTINUE
  200 CONTINUE
C
 1000 IF(ITRACE.EQ.1) WRITE(IODBUG,9000) SNAME
 9000 FORMAT(1H0,2H**,1X,2A4,8H EXITED.)
      RETURN
      END

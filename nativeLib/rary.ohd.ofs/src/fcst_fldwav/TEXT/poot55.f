C  LAD AND KRCH ARE ADDED INTO THE ARGUMENT LIST IN ORDER TO COUNT LOCK&DAM
C      SUBROUTINE POOT55(J,I,KL,L1,L2,L3,L4,II,II2,C,D,QU,QD,YU,YD,CHTW,
C     . POLH,LTPOLH,ITWT,LTITWT,T1,LTT1,PLTI,IWTI,NUMLAD,QN,NU,TT,
C     . RHI,RQI,K1,K2,K15,K16)
      SUBROUTINE POOT55(J,I,KL,L1,L2,L3,L4,II,II2,C,D,QU,QD,YU,YD,CHTW,
     . POLH,LTPOLH,ITWT,LTITWT,T1,LTT1,PLTI,IWTI,NUMLAD,LAD,KRCH,
     . QN,NU,TT,RHI,RQI,K1,K2,K15,K16)

C   *jms*   UPDATED 01/29/03  to allow various lock&dam options
C
       INCLUDE 'common/ofs55'
      INCLUDE 'common/fdbug'

      DIMENSION D(4,K15),C(K15),QU(K2,K1),QD(K2,K1),YU(K2,K1),YD(K2,K1)
      DIMENSION CHTW(K16,K1),POLH(*),LTPOLH(*),ITWT(*),LTITWT(*),PLTI(*)
C  NEW ADDED MATRICES LAD AND KRCH NEED TO BE DECLARED
C      DIMENSION T1(*),LTT1(*),IWTI(*),NUMLAD(K1)
      DIMENSION T1(*),LTT1(*),IWTI(*),NUMLAD(K1),LAD(K16,K1),KRCH(K2,K1)
      DIMENSION RHI(112,K16,K1),RQI(112,K16,K1)

      CHARACTER*8 SNAME
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_fldwav/RCS/poot55.f,v $
     . $',                                                             '
     .$Id: poot55.f,v 1.4 2004/09/23 19:43:50 wkwock Exp $
     . $' /
C    ===================================================================
C
C     THIS SUBROUTINE TREATS KRA=28 SITUATION (POOL TIME SERIES)
C     ITW=0  AUTOMATICALLY SWITCHING BETWEEN POOL AND CHANNEL
C            BASED ON TAILWATER CONDITION COMPARED WITH CHTW
C     ITW=1  FORCE TO OPEN-CHANNEL-FLOW CONDITION
C     ITW=2  FORCE TO POOL-IN-CONTROL CONDITION
C     ITW=10000 USE POOL RATING CURVE - H=f(Q)
C     CHTW>0   CRITICAL TAIL ELEVATION USED
C     CHTW<0   CRITICAL TAIL DISCHARGE USED


      DATA SNAME/ 'POOT55  '  /
C
      CALL FPRBUG(SNAME,1,55,IBUG)


C  THE FOLLOWING LINE COUNTS ALL DAMS WHILE KLJ IS SUPPOSED 
C  TO COUNT LOCK&DAM ONLY
C      KLJ=LCAT21(KL,J,NUMLAD)
C  KL IS THE COUNTER FOR ALL DAMS ON EACH RIVER
C  NEED KLJ TO KEEP TRACK OF LOCK&DAM ON ALL RIVERS
      KLJ=0
      DO 5 ILJ=1,J
      IEND=NUMLAD(ILJ)
      IF(ILJ.EQ.J) IEND=KL
      DO 4 ILI=1,IEND
      ILII=LAD(ILI,ILJ)
      IF(ABS(KRCH(ILII,ILJ)).EQ.28) KLJ=KLJ+1
    4 CONTINUE
    5 CONTINUE

      IF(TT.LE.0.00001.AND.KIT.LE.1) THEN
        YD(I,J)=PLTI(KLJ)
        YU(I,J)=YD(I,J)
        QU(I,J)=QD(I,J)
        QN=QU(I,J)
cc        QN=QD(I,J)
cc        QOTHR(KL,J)=QN
        GOTO 999
      ENDIF

      IF(IWTI(KLJ).EQ.10000) GOTO 500

      LT1=LTT1(J)
      CALL INTERP55(T1(LT1),NU,TT,IT1,IT2,TINP)

      LPOLH=LTPOLH(KLJ)-1
      LITWT=LTITWT(KLJ)-1
      ITW=0
      ITWW=ITWT(IT1+LITWT)
      IF(TT.LT.T1(LT1)) ITWW=IWTI(KLJ)
      IF(ITWW.EQ.1) ITW=1
      IF(ITWW.EQ.2) ITW=2
      CTAIL=CHTW(KL,J)
      IF(ITW.EQ.2) GO TO 100
      IF(ITW.EQ.1) GO TO 200
      IF(CTAIL.GE.0.0.AND.YD(I+1,J).GE.CTAIL) GO TO 200
      IF(CTAIL.LT.0.0.AND.QD(I+1,J).GE.-1.0*CTAIL) GO TO 200

C POOL-IN-CONTROL CONDITION (ITW=2 AND 0 FOR ABOVE CONDITION)
 100  IF(TT.GE.T1(LT1)) THEN
        POLT=POLH(IT1+LPOLH)+TINP*(POLH(IT2+LPOLH)-POLH(IT1+LPOLH))
      ELSE
        POLT=PLTI(KLJ)+(POLH(1+LPOLH)-PLTI(KLJ))*(TT/T1(LT1))
      ENDIF
      C(II)=-(YU(I,J)-POLT)
      D(L1,II)=1.0
      D(L2,II)=0.0
      D(L3,II)=0.0
      D(L4,II)=0.0
      C(II2)=-(QU(I,J)-QU(I+1,J))
      D(L1,II2)=0.0
      D(L2,II2)=1.0
      D(L3,II2)=0.0
      D(L4,II2)=-1.0
      QN=QU(I,J)
      IF(JNK.LT.100.OR.IBUG.EQ.0) GO TO 999
      WRITE(IODBUG,888)
     &I,II,C(II),D(L1,II),D(L2,II),D(L3,II),D(L4,II)
      WRITE(IODBUG,888)
     &I,II2,C(II2),D(L1,II2),D(L2,II2),D(L3,II2),D(L4,II2)
  888 FORMAT(5X,'DAM: I,II,C,D= ',2I5,5F15.5)
      GOTO 999

C  OPEN-CHANNEL-FLOW (ITW=1 AND 0 FOR CERTAIN CONDITION)
C  SWITCH TO CHANNEL FLOW (BACK TO INTER AND TREAT THIS REACH AS CHANNEL)
  200 QN= -0.3
      GOTO 999

C POOL RATING CURVE USED
  500 C(II2)=-(QU(I,J)-QU(I+1,J))
      D(L1,II2)=0.0
      D(L2,II2)=1.0
      D(L3,II2)=0.0
      D(L4,II2)=-1.0
      QN=QU(I,J)

C RATING Hp=f(Qp) IS USED FOR POOL CONTROL SIMULATION
      QA=0.5*(QD(I,J)+QU(I,J))
      DO 540 K=2,8
      I1=K-1
      IF (QA.LE.RQI(K,KL,J)) GOTO 541
      I1=7
  540 CONTINUE
  541 I2=I1+1
      H1=RHI(I1,KL,J)
      Q1=RQI(I1,KL,J)
      DHDQ=(RHI(I2,KL,J)-RHI(I1,KL,J))/(RQI(I2,KL,J)-RQI(I1,KL,J))
      POOLE=H1+DHDQ*(QA-Q1)
      IF(POOLE.LT.(YD(I,J)-0.05)) POOLE=YD(I,J)-0.05
      C(II)=-(YU(I,J)-POOLE)
      D(L1,II)=1.0
      D(L2,II)=0.0
      D(L3,II)=0.0
      D(L4,II)=0.0

  999 RETURN
      END























C MEMBER EX30
C  (FROM OLD MEMBER FCEX30)
C-----------------------------------------------------------------------
C                             LAST UPDATE: 10/24/95.11:36:06 BY $WC21DT
C
C @PROCESS LVL(77)
C
      SUBROUTINE EX30(PO,OUT,LOCD,D)
C
C     THE FUNCTION OF THIS ROUTINE IS TO COMPUTE AN OUTPUT TIME
C     SERIES BY MERGING THE INPUT TIME SERIES.
C
C     THIS ROUTINE WAS WRITTEN BY:
C     ROBERT M. HARPER     HRL     NOVEMBER, 1990    VERSION NO. 1
C**************************************
C
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
C
      COMMON/FCTIME/IDARUN,IHRRUN,LDARUN,LHRRUN,LDACPD,LHRCPD,NOW(5),
     &LOCAL,NOUTZ,NOUTDS,NLSTZ,IDA,IHR,LDA,LHR,IDADAT
C
      COMMON/MOD130/NDT30,KEY30(10),OPN30(10),IDT30(10),LDT30(10)
      COMMON/WHERE/ISEG(2),IOPNUM,OPNAME(2)
C
      CHARACTER*8 OPN30
      REAL*4 KEY30,PCPN,INSQ
      DIMENSION PO(*),OUT(*),LOCD(*),D(*),SNAME(2)
      CHARACTER*8 BLANK,TEMP1,TEMP2
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_ex/RCS/ex30.f,v $
     . $',                                                             '
     .$Id: ex30.f,v 1.3 1996/01/16 12:17:50 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA SNAME/4HEX30,4H    /,BLANK/'        '/
      DATA PCPN/4HPCPN/,INSQ/4HINSQ/
C
      CALL FPRBUG(SNAME,1,30,IBUG)
C
      NTS=PO(2)
      INTRVL=PO(6)
      NVALS=PO(7)
      ISWICH=PO(11)
C**************************************
C
C     COMPUTE THE TOTAL NUMBER OF PERIODS
C
      NPD=(LDA-IDA)*24/INTRVL+(LHR-IHR)/INTRVL+1
C**************************************
C
C     FIND STARTING LOCATION OF COMPUTED VALUE
C
      ILOC=(IDA-IDADAT)*24/INTRVL*NVALS+(IHR-1)/INTRVL*NVALS
      ILOCS=ILOC+1
C
C     DEBUG OUTPUT
C
      IF(IBUG .EQ. 0) GO TO 25
      WRITE(IODBUG,1001) IDA,IHR,INTRVL,NVALS,ILOC,LDA,LHR,IDADAT,NPD
 1001 FORMAT(/ 10X,'DEBUG EXECUTION ROUTINE FOR MERGE-T.S. OPERATION',
     &//,10X,'IDA=',I5,3X,'IHR=',I5,2X,'INTRVL=',I5,2X,'NVALS=',I5,2X,
     &'ILOC=',I5,2X,/,10X,'LDA=',I5,3X,'LHR=',I5,2X,'IDADAT=',I5,2X,
     &'NPD=',I5)
      WRITE(IODBUG,1002)
 1002 FORMAT(/,10X,'PO ARRAY')
      WRITE(IODBUG,1003) (PO(K),K=1,12)
 1003 FORMAT(/,10X,F5.0,2X,F6.2,2X,A4,2X,A4,2X,A4,2X,F6.2,2X,F6.2,2X,
     &A4,2X,A4,2X,F6.2,2X,F6.2,2X,F6.2)
      K=13
      DO 10 I=1,NTS
        WRITE(IODBUG,1004) PO(K),PO(K+1),PO(K+2),PO(K+3)
 1004   FORMAT(10X,A4,2X,A4,2X,A4,2X,A4)
        K=K+4
   10 CONTINUE
      WRITE(IODBUG,1005)
 1005 FORMAT(/,10X,'STARTING LOCATIONS OF THE INPUT TIME SERIES IN THE D
     & ARRAY')
      WRITE(IODBUG,1006) (LOCD(I),I=1,NTS)
 1006 FORMAT(/,10X,14I5)
      DO 20 I=1,NTS
        J=ILOC+LOCD(I)
        KK=NPD*NVALS+J-1
        WRITE(IODBUG,1007) I
 1007   FORMAT(/,10X,'VALUES OF INPUT TIME SERIES NO.',I5)
        WRITE(IODBUG,1008) (D(IK),IK=J,KK)
 1008   FORMAT(1X,10X,10F10.2)
   20 CONTINUE
C
C*************************************
C
C     MERGE INPUT T.S.
C
   25 IF (ISWICH.LT.1) THEN
      DO 50 I=1,NPD
        DO 40 J=1,NVALS
          DO 30 K=1,NTS
            I1=LOCD(K)+ILOC
            L=IFMSNG(D(I1))
            IF(L .EQ. 0) GO TO 35
   30     CONTINUE
   35     ILOC=ILOC+1
          OUT(ILOC)=D(I1)
   40   CONTINUE
   50 CONTINUE
      GO TO 999
      END IF
C**************************************
C
C     SWITCH INPUT TIME SERIES
C
      IF (ISWICH.GE.1) THEN
C
C  DEBUG OUTPUT OF MOD130 SWITCH TIME SERIES.
      IF (IBUG.GT.0) THEN
        WRITE(IODBUG,100)
        WRITE(IODBUG,105)NDT30,(KEY30(J),J=1,NDT30)
        WRITE(IODBUG,110)(OPN30(J),J=1,NDT30)
        WRITE(IODBUG,115)(IDT30(J),J=1,NDT30)
        WRITE(IODBUG,120)(LDT30(J),J=1,NDT30)
 100    FORMAT(/,10X,'DEBUG OUTPUT OF THE MERGE-TS MOD130 PARAMETERS')
 105    FORMAT(10X,'NDT30=',I5,'        KEY WORD=',10(A4,1X))
 110    FORMAT(10X,'OPERATION NAME ASSOC. W/MOD=',10(A8,2X))
 115    FORMAT(10X,'STARTING DATE OF SWITCH    =',10(I10,2X))
 120    FORMAT(10X,'ENDING DATE OF SWITCH      =',10(I10,2X))
      END IF
C
C FILL THE OUTPUT T.S. WITH THE PRIMARY T.S.
      ILOC=ILOCS-1
      DO 500 I=1,NPD
        I1=LOCD(1)+ILOC
        ILOC=ILOC+1
        OUT(ILOC)=D(I1)
C
        IF (IBUG.GT.0) WRITE(IODBUG,170)I,ILOC,I1,OUT(ILOC)
 170    FORMAT(/,10X,'I,ILOC,I1,OUT(ILOC)=',3(2X,I8),F12.2)
C
  500 CONTINUE
C
C   DEBUG PRINT OF NEW SWITCHED OUTPUT TIME SERIES.
         IF (IBUG.GT.0) THEN
           WRITE(IODBUG,165)
 165       FORMAT(/,10X,'OUTPUT=PRIMARY T.S. BEFORE ANY SWITCHES')
           NN=NPD*NVALS+ILOCS-1
           WRITE(IODBUG,1008) (OUT(I),I=ILOCS,NN)
         END IF
C
      IF (NDT30.GE.1) THEN
C
      DO 400 J=1,NDT30
C
C  CHECK IF OPERATION BEING EXECUTED IS TO HAVE SWITCHED T.S.
C       IF (IOPNUM.GT.0) THEN
         CALL UMEMOV(OPN30(J),TEMP1,2)
         CALL UMEMOV(OPNAME,TEMP2,2)
C
         IF (IBUG.GT.0) WRITE(IODBUG,125)J,TEMP1,BLANK,TEMP2
 125     FORMAT(/,10X,'J=',I3,'  TEMP1=',A8,'  BLANK=',A8,'  TEMP2=',A8)
C
         IF ((TEMP1.NE.BLANK).AND.(TEMP1.NE.TEMP2)) GO TO 400
         IF ((KEY30(J).NE.PCPN).AND.(KEY30(J).NE.INSQ)) GO TO 400
         IF ((KEY30(J).EQ.PCPN).AND.(ISWICH.NE.1)) GO TO 400
         IF ((KEY30(J).EQ.INSQ).AND.(ISWICH.NE.2)) GO TO 400
C
C  CHECK IF KEY WORD APPLIES, AND FIX TIME INTERVAL ACCORDINGLY
         IHRS=IDT30(J)
         LHRS=LDT30(J)
         IIDA=(IHRS-1)/24 + 1
         LLDA=(LHRS-1)/24 + 1
         IIHR=IHRS-24*(IIDA-1)
         LLHR=LHRS-24*(LLDA-1)
C
         IF (IBUG.GT.0) THEN
           WRITE(IODBUG,130)J,IHRS,IIDA,IIHR
           WRITE(IODBUG,135)J,LHRS,LLDA,LLHR
 130       FORMAT(/,10X,'J,IHRS,IIDA,IIHR=',4(I10,2X))
 135       FORMAT(10X,'J,LHRS,LLDA,LLHR=',4(I10,2X))
         END IF
C
         IF (KEY30(J).EQ.PCPN) THEN
           IFSTHR=((IIHR+INTRVL/2)/INTRVL)*INTRVL
           ILSTHR=((LLHR+INTRVL/2)/INTRVL)*INTRVL
C
           IF (IBUG.GT.0) WRITE(IODBUG,140)J,KEY30(J),IFSTHR,ILSTHR
 140       FORMAT(/,10X,'J,KEY30,IFSTHR,ILSTHR= ',I5,2X,A4,2I10)
         END IF
C
         IF (KEY30(J).EQ.INSQ) THEN
           IFSTHR=(IIHR/INTRVL)*INTRVL
           ILSTHR=(((LLHR-1)/INTRVL)+1)*INTRVL
C
           IF (IBUG.GT.0) WRITE(IODBUG,145)J,KEY30(J),IFSTHR,ILSTHR
 145       FORMAT(/,10X,'J,KEY30,IFSTHR,ILSTHR= ',I5,2X,A4,2I10)
         END IF
C
C  COMPUTE NUMBER OF PERIODS AND START AND END LOCATIONS OF OUTPUT
C  T.S. TO SWITCH IN THE SECONDARY T.S.
         NPD2=(LLDA-IIDA)*24/INTRVL + (ILSTHR-IFSTHR)/INTRVL + 1
         IILOC=(IIDA-IDADAT)*24/INTRVL + (IFSTHR-1)/INTRVL
         IILOCS=IILOC+1
C
         IF (IBUG.GT.0) WRITE(IODBUG,150)J,NPD2,IILOC
 150     FORMAT(/,10X,'J,NPD2,IILOC= ',I5,2I10)
C
C  MERGE SECONDARY T.S. INTO OUTPUT T.S.
C
         DO 600 K=1,NPD2
           I2=LOCD(2)+IILOC
           IILOC=IILOC+1
           OUT(IILOC)=D(I2)
C
           IF (IBUG.GT.0) WRITE(IODBUG,175)K,IILOC,I2,OUT(IILOC)
 175       FORMAT(/,10X,'K,IILOC,I2,OUT(IILOC)=',3(2X,I8),F12.2)
C
 600     CONTINUE
C
C   DEBUG PRINT OF NEW SWITCHED OUTPUT TIME SERIES.
         IF (IBUG.GT.0) THEN
           WRITE(IODBUG,160)J
 160       FORMAT(/,10X,'OUTPUT T.S. AFTER SWITCH MOD#',I3)
           NN=NPD*NVALS+ILOCS-1
           WRITE(IODBUG,1008) (OUT(I),I=ILOCS,NN)
         END IF
C
C       END IF
C
  400 CONTINUE
      END IF
      END IF
C
C     DEBUG OUTPUT
C
 999  IF(IBUG .EQ. 0) GO TO 60
      WRITE(IODBUG,1009)
 1009 FORMAT(/,10X,'VALUES OF THE OUTPUT TIME SERIES')
      NN=NPD*NVALS+ILOCS-1
      WRITE(IODBUG,1008) (OUT(I),I=ILOCS,NN)
C
   60 IF(ITRACE .EQ. 1) WRITE(IODBUG,1010) SNAME
 1010 FORMAT(/,10X,'**',1X,2A4,1X,'EXITED',//)
      RETURN
      END

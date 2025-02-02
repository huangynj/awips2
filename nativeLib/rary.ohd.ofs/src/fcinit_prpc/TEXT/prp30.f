C MEMBER PRP30
C  (FROM OLD MEMBER FCPRP30)
C-----------------------------------------------------------------------
C                             LAST UPDATE: 10/24/95.11:22:38 BY $WC21DT
C
C @PROCESS LVL(77)
C
      SUBROUTINE PRP30(PO)
C
C     THE FUNCTION OF THIS SUBROUTINE IS TO PRINT THE CONTENTS OF THE
C     PO ARRAY FOR THE MERGE-TS OPERATION.
C
C     THIS SUBROUTINE WAS WRITTEN BY:
C     ROBERT M. HARPER     HRL     NOVEMBER, 1990     VERSION NO. 1
C
C     MODIFICATIONS BY:
C     BRYCE FINNERTY     HRL  MAY, 1995               VERSION NO. 2
C
C**************************************
C
      COMMON/IONUM/IN,IPR,IPU
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
C
      DIMENSION PO(*),TSOUT(2),TSINP(2),SNAME(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_prpc/RCS/prp30.f,v $
     . $',                                                             '
     .$Id: prp30.f,v 1.2 1995/11/14 19:35:20 erb Exp $
     . $' /
C    ===================================================================
C
C
      DATA SNAME/4HPRP3,4H0   /
C
      WRITE(IPR,1001)
      NTS=PO(2)
      ISWICH=PO(11)
      WRITE(IPR,1002) NTS
      IF (ISWICH.LT.1) WRITE(IPR,102)
      IF (ISWICH.GE.1) WRITE(IPR,103)
      WRITE(IPR,1003)
      INTRVL=PO(6)
      WRITE(IPR,1004) INTRVL
      NVALS=PO(7)
      WRITE(IPR,1005) NVALS
      OUTUNT=PO(8)
      WRITE(IPR,1006) OUTUNT
      WRITE(IPR,1008)
      WRITE(IPR,1009) PO(3),PO(4)
      WRITE(IPR,1010) PO(5)
      WRITE(IPR,1007) PO(9)
      WRITE(IPR,1011)
      WRITE(IPR,1012)
      WRITE(IPR,1013)
      K=12
      DO 20 I=1,NTS
        K=K+1
        TSINP(1)=PO(K)
        K=K+1
        TSINP(2)=PO(K)
        K=K+1
        DTINP=PO(K)
        K=K+1
        FLAG=PO(K)
        IF(I .EQ. 1) WRITE(IPR,1014) TSINP,DTINP,FLAG
        IF(I .EQ. 2) WRITE(IPR,1015) TSINP,DTINP,FLAG
        IF(I .EQ. 3) WRITE(IPR,1016) TSINP,DTINP,FLAG
        IF(I .LT. 4) GO TO 20
        WRITE(IPR,1017) I,TSINP,DTINP,FLAG
   20 CONTINUE
C
 1001 FORMAT(/,10X,'MERGE TIME SERIES OPERATION',/)
 1002 FORMAT(11X,I5,5X,'TIME SERIES ARE TO BE MERGED')
 102  FORMAT(10X,'CASE 1:  MISSING DATA ALLOWED IN ALL T.S. EXCEPT',
     &' THE LAST ONE')
 103  FORMAT(10X,'CASE 2:  2 T.S. WITH NO MISSING DATA FOR USE WITH',
     &' THE SWITCH T.S. MOD')
 1003 FORMAT(/,10X,'GENERAL TIME SERIES INFORMATION')
 1004 FORMAT(/,15X,'TIME INTERVAL (HOURS)',10X,I2)
 1005 FORMAT(15X,'VALUES PER TIME INTERVAL',7X,I2)
 1006 FORMAT(15X,'UNITS',26X,A4)
 1007 FORMAT(15X,'MISSING DATA ALLOWED',11X,A4)
 1008 FORMAT(/,10X,'OUTPUT TIME SERIES INFORMATION')
 1009 FORMAT(/,15X,'ID.',28X,2A4)
 1010 FORMAT(15X,'DATA TYPE',22X,A4)
 1011 FORMAT(/,10X,'INPUT TIME SERIES INFORMATION')
 1012 FORMAT(/,46X,'DATA',8X,'MISSING DATA')
 1013 FORMAT(15X,'T.S. RANK',9X,'ID.',10X,'TYPE',10X,'ALLOWED')
 1014 FORMAT(/,15X,'PRIMARY',9X,2A4,7X,A4,12X,A4)
 1015 FORMAT(15X,'SECONDARY',7X,2A4,7X,A4,12X,A4)
 1016 FORMAT(15X,'TERTIARY',8X,2A4,7X,A4,12X,A4)
 1017 FORMAT(15X,I2,14X,2A4,7X,A4,12X,A4)
C
      IF(ITRACE .EQ. 1) WRITE(IODBUG,1018) SNAME
 1018 FORMAT(/,10X,'**',2A4,' EXITED',//)
C
      RETURN
      END

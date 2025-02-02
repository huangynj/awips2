C MEMBER PIN6
C  (from old member FCPIN6)
C
      SUBROUTINE PIN6 (PO,LEFTP,IUSEP,CO,LEFTC,IUSEC)
C.......................................................................
C     THIS IS THE INPUT SUBROUTINE FOR THE MEAN DISCHARGE
C     OPERATION. THIS SUBROUTINE INPUTS ALL CARDS FOR THE
C     OPERATION AND FILLS THE PO AND CO ARRAYS.
C.......................................................................
C     SUBROUTINE INITIALLY WRITTEN BY
C          LARRY BRAZIL - HRL   SEPTEMBER 1979 VERSION 1
C.......................................................................
      DIMENSION PO(*),CO(*),QID(2),QBID(2)
      CHARACTER*80 CARD
C     COMMON BLOCKS
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/pin6.f,v $
     . $',                                                             '
     .$Id: pin6.f,v 1.2 2002/02/11 19:03:12 dws Exp $
     . $' /
C    ===================================================================
C
C
C     DATA STATEMENTS
      DATA DL3T,DL3/4HL3/T,4HL3  /
C.......................................................................
C     CHECK TRACE LEVEL -- TRACE LEVEL FOR THIS SUBROUTINE=1.
      IF (ITRACE.GE.1) WRITE (IODBUG,900)
  900 FORMAT (1H0,15H** PIN6 ENTERED)
C.......................................................................
C     CHECK TO SEE IF DEBUG OUTPUT IS NEEDED FOR THIS OPERATION.
      IBUG=0
      IF (IDBALL.GT.0) IBUG=1
      IF (NDEBUG.EQ.0) GO TO 100
      DO 10 I=1,NDEBUG
      IF (IDEBUG(I).EQ.6) GO TO 11
   10 CONTINUE
      GO TO 100
   11 IBUG=1
  100 CONTINUE
C.......................................................................
C     INITIALIZE VARIABLES
      IVER=1
      NOFILL=0
      IUSEP=0
      IUSEC=0
      IPOQB=11
      NCO=0
C.......................................................................
C     READ INPUT AND MAKE CHECKS
C
C     INPUT CARD NO. 1
      READ (IN,901) QID,QTYPE,IDTQ,QBID,QBTYPE,IDTQB,NCO
  901 FORMAT (2X,2A4,1X,A4,3X,I2,2X,2A4,1X,A4,3X,I2,3X,I2)
      IVALUE=1
      IDIMEN=1
      CALL FDCODE(QTYPE,DUM1,DUM2,IMISS,IDUM,DUM3,DUM4,IERR)
      CALL CHEKTS(QID,QTYPE,IDTQ,IDIMEN,DL3T,IMISS,IVALUE,IERR)
      CALL FDCODE(QBTYPE,DUM1,DUM2,IMISS1,IDUM,DUM3,DUM4,IERR)
      CALL CHEKTS(QBID,QBTYPE,IDTQB,IDIMEN,DL3,IMISS1,IVALUE,IERR)
C       CHECK THAT IF INPUT TS ALLOWS MISSING THEN OUTPUT TS MUST
C       ALLOW MISSING DATA
      IF(IMISS.EQ.0) GO TO 105
      IF(IMISS.EQ.1.AND.IMISS1.EQ.1) GO TO 105
      WRITE(IPR,905)
  905 FORMAT(1H0,10X,70H**ERROR** THE INSTANTANEOUS DISCHARGE TIME SERIE
     1S ALLOWS MISSING DATA./20X,70HTHEREFORE THE MEAN DISCHARGE TIME SE
     2RIES MUST ALSO ALLOW MISSING DATA.)
      CALL ERROR
      GO TO 110
C     CHECK THAT INST. Q TIME INTERVAL LE MEAN Q TIME INTERVAL
  105 IF (IDTQ.LE.IDTQB) GO TO 107
      WRITE (IPR,906) IDTQB,IDTQ
  906 FORMAT(1H0,10X,62H**ERROR** THE TIME INTERVAL OF THE MEAN DISCHARG
     1E TIME SERIES(,I2,39H) IS LESS THAN THE TIME INTERVAL OF THE/21X,3
     26HINSTANTANEOUS DISCHARGE TIME SERIES(,I2,2H).)
      CALL ERROR
      GO TO 110
C     CHECK THAT THE MEAN Q TIME INTERVAL IS AN EVEN MULTIPLE OF
C     THE INST. Q TIME INTERVAL.
  107 IF((IDTQB/IDTQ)*IDTQ.EQ.IDTQB) GO TO 110
      WRITE (IPR,908) IDTQB,IDTQ
  908 FORMAT(1H0,10X,62H**ERROR** THE TIME INTERVAL OF THE MEAN DISCHARG
     1E TIME SERIES(,I2,25H) IS NOT AN EVEN MULTIPLE/21X,64HOF THE TIME
     2INTERVAL OF THE INSTANTANEOUS DISCHARGE TIME SERIES(,I2,2H).)
      CALL ERROR
C     CHECK THAT NO. OF INITIAL CO VALUES LE MAXIMUM ALLOWED.
  110 NCOMAX=IDTQB/IDTQ
      IF (NCO.LE.NCOMAX) GO TO 112
      WRITE (IPR,909)NCO,NCOMAX,NCOMAX
  909 FORMAT(1H0,10X,74H**WARNING** THE SPECIFIED NUMBER OF INITIAL CARR
     1YOVER VALUES TO BE INPUT (,I2,21H) EXCEEDS THE MAXIMUM/23X,
     226HNUMBER OF VALUES ALLOWED (,I2,19H).  ONLY THE FIRST ,I2,
     321H VALUES WILL BE READ.)
      CALL WARN
      NCO=NCOMAX
  112 CONTINUE
C
C.......................................................................
C     CHECK SPACE IN P AND C ARRAYS
      IF (LEFTP.GE.IPOQB) GO TO 120
      NOFILL=1
      WRITE (IPR,910)
  910 FORMAT(1H0,10X,75H**ERROR** THIS OPERATION NEEDS MORE SPACE THAN I
     1S AVAILABLE IN THE P ARRAY.)
      CALL ERROR
  120 IF (LEFTC.GE.NCOMAX) GO TO 121
      NOFILL=1
      WRITE(IPR,912)
  912 FORMAT(1H0,10X,75H**ERROR** THIS OPERATION NEEDS MORE SPACE THAN I
     1S AVAILABLE IN THE C ARRAY.)
      CALL ERROR
  121 CONTINUE
C
C.......................................................................
C
      IF(NOFILL.EQ.1) GO TO 800
C     SET DEFAULT INITIAL CARRYOVER VALUES
      DO 130 I=1,NCOMAX
      CO(I)=0.0
  130 CONTINUE
C
C     INPUT INITIAL CARRYOVER IF NEEDED (CARD NO.2) AND STORE IN CO
cew next ines taken from scv routine that
cew  had too many changes in it to work
      IF (NCO.GT.0) THEN
C     READ INITIAL CARRYOVER
         NPER=7
         NTIME=NCO/NPER
         IF (MOD(NCO,NPER).GT.0) NTIME=NTIME+1
         DO 135 I=1,NTIME
            READ (IN,'(A)') CARD
            J1=(I-1)*NPER+1
            J2=I*NPER
            IF (J2.GT.NCO) J2=NCO
            READ (CARD,916,ERR=125) (CO(J),J=J1,J2)
  916       FORMAT(7F10.4)
            GO TO 135
  125       CALL FRDERR (IPR,' ',CARD)
  135       CONTINUE
         ENDIF
cew end of change

      IUSEC=NCOMAX
      IUSEP=IPOQB
C.......................................................................
C
C     STORE INFORMATION IN PO ARRAY.
      PO(1)=IVER+0.01
      PO(2)=QID(1)
      PO(3)=QID(2)
      PO(4)=QTYPE
      PO(5)=IDTQ+0.01
      PO(6)=QBID(1)
      PO(7)=QBID(2)
      PO(8)=QBTYPE
      PO(9)=IDTQB+0.01
      PO(10)=NCO+0.01
      PO(11)=IUSEP+0.01
      IF(IBUG.EQ.0) GO TO 810
C.......................................................................
C     DEBUG OUTPUT-PRINT PO() AND CO().
      WRITE(IODBUG,940) IUSEP,IUSEC
  940 FORMAT(1H0,29HCONTENTS OF PO AND CO ARRAYS.,5X,22HNUMBER OF VALUES
     1-- PO=,I3,2X,3HCO=,I2)
      WRITE(IODBUG,942) (PO(I),I=1,IUSEP)
  942 FORMAT(1H0,15F8.3)
      WRITE(IODBUG,942) (CO(I),I=1,IUSEC)
  800 IF(IBUG.EQ.0) GO TO 810
      WRITE(IODBUG,944) NOFILL,NCO,NCOMAX
  944 FORMAT(1H0,7HNOFILL=,I1,2X,4HNCO=,I2,2X,7HNCOMAX=,I2)
C.......................................................................
C     DEFINITION OF SELECTED VARIABLES.
C     NOFILL=1 IF PO() AND CO() WERE NOT FILLED, OTHERWISE=0.
C     IVER = VERSION NUMBER FOR THIS OPERATION.
C     NCO = NUMBER OF CARRYOVER VALUES READ.
C     NCOMAX = MAXIMUM NUMBER OF CARRYOVER VALUES ALLOWED.
C.......................................................................
C
C     CONTENTS OF THE PO ARRAY - MEAN Q OPERATION
C
C     POSITION                   CONTENTS
C        1       VERSION NUMBER OF THE OPERATION
C        2-3     INSTANTANEOUS DISCHARGE TIME SERIES I.D.
C        4       INSTANTANEOUS DISCHARGE TIME SERIES DATA TYPE
C        5       INSTANTANEOUS DISCHARGE TIME SERIES TIME INTERVAL
C        6-7     MEAN DISCHARGE TIME SERIES I.D.
C        8       MEAN DISCHARGE TIME SERIES DATA TYPE
C        9       MEAN DISCHARGE TIME SERIES TIME INTERVAL
C        10      NUMBER OF INITIAL CARRYOVER VALUES (NCO)
C        11      NUMBER OF PO() VALUES
C.......................................................................
  810 RETURN
      END

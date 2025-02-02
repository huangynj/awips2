C MEMBER GDIST
C  (from old member PPGDIST)
C
      SUBROUTINE GDIST(GP6, W6, NUM, IGRID, IDIST, IFBUG, PCT)
C
C.....THIS SUBROUTINE PRODUCES A SET OF PERCENTAGE DISTRIBUTION
C.....CONSTANTS.  FROM THESE DISTRIBUTION CONSTANTS IS PRODUCED A
C.....SIX HOURLY BREAKDOWN OF THE MARO AND MAPG THAT OCCURRED IN
C.....A MARO AREA.
C
C.....ARGUMENTS:
C
C.....GP6    - ARRAY OF SIX-HOURLY PERCENTAGE DISTRIBUTION POINTERS
C.....         IF GP6(IGRID) = LOCATION, THEN GRID POINT IGRID HAS
C....          PERCENTAGE DISTRIBUTION VALUES BEGINNING AT ADDRESS
C.....         LOCATION OF THE W6 ARRAY.
C
C.....W6     - THE ARRAY OF PERCENTAGE DISTRIBUTIONS FOR THE SIX-HOURLY
C.....         VALUES.
C
C.....NUM    - NUMBER OF GRID POINTS IN THE GRID POINT ARRAY TO BE
C.....         SEARCHED FOR DISTRIBUTIONS.
C.....IGRID  - THE GRID POINT ADDRESS ARRAY.
C.....IDIST  - A DISTRIBUTION FLAG RETURNED BY THE SUBROUTINE.
C.....          = 1   A DISTRIBUTION WAS FOUND AT ONE OR MORE POINTS.
C.....          = 0   NO DISTRIBUTION WAS FOUND IN THE ARRAY.
C.....IFBUG  - A DEBUG FLAG THAT DETERMINES IF INTERMEDIATE CALCULATIONS
C.....         ARE TO BE DISPLAYED IN THIS SUBROUTINE.
C.....          = 1   DEBUG FOR MARO AND/OR MAPG IS ON. DISPLAY THE
C.....                INTERMEDIATE CALCULATIONS.
C.....          = 0   DEBUG FOR MARO AND FOR MAPG IS OFF. DO NOT DISPLAY
C.....                ANY INTERMEDIATE CALCULATIONS.
C.....PCT    - THE 4 ELEMENT ARRAY THAT STORES THE AVERAGE PERCENTAGE
C.....         SIX HOURLY DISTRIBUTIONS OF ALL THE GRID POINTS FOUND
C.....         ON THIS SEARCH.
C
C.....ORIGINALLY WRITTEN BY:
C
C.....JERRY M. NUNN       WGRFC, FT. WORTH, TEXAS       NOVEMBER 1986
C
      INTEGER*2 GP6(1), W6(1)
C
      DIMENSION IGRID(1), IPCT(4), SNAME(2), PCT(1)
C
      INCLUDE 'common/where'
      INCLUDE 'common/pudbug'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_maro/RCS/gdist.f,v $
     . $',                                                             '
     .$Id: gdist.f,v 1.1 1995/09/17 19:01:23 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA SNAME /4hGDIS, 4hT   /
C
  901 FORMAT(1H0, '*** GDIST ENTERED ***')
  902 FORMAT(1X,  '*** EXIT GDIST ***')
  903 FORMAT(1X,  'DISTRIBUTION FOUND. GP6(', I4, ') = ', I4, '. DISTRIB
     *UTION PERCENTAGES ARE ', 4I4, '.')
  904 FORMAT(1X,  'DISTRIBUTION PERCENTAGES FOR THIS MARO AREA ARE ',
     * 4F6.2)
  905 FORMAT(1X, '*** NO DISTRIBUTION FOUND ***')
  906 FORMAT(1H0, '*** WARNING ***   DISTRIBUTION FLAG IS SET TO 1, BUT
     *THE SUM OF THE W6 ENTRIES ARE ZERO.', /, 5X, 'NO DISTRIBUTION FAC
     *TORS FOR GRID POINT ', I5, ' WILL BE COMPUTED.')
C
      INCLUDE 'gcommon/setwhere'
      IF(IPTRCE .GE. 8) WRITE(IOPDBG,901)
C
C.....SET CONSTANTS.
C
      IDIST = 0
      TOTAL = 0.0
C
      DO 75 NP = 1, 4
      PCT(NP) = 0.0
   75 CONTINUE
C
C.....GO THRU THE LIST OF GRID POINT ADDRESSES SUBMITTED TO THIS ROUTINE
C.....TO SEE IF ANY DISTRIBUTIONS ARE PRESENT.
C
      DO 100 NP = 1, NUM
C
C.....GET THE GRID ADDRESS.
C
      NPGRID = IGRID(NP)
C
C.....CHECK IF THIS GRID ADDRESS CONTAINS SIX HOUR DISTRIBUTION
C.....PERCENTAGES.
C
      IF(GP6(NPGRID) .EQ. 0) GOTO 100
C
C.....SIX HOURLY DATA IS AVAILABLE. GET THE POINTER TO THE W6 WORK ARRAY
C.....WHERE THE FOUR PERCENTAGE VALUES ARE STORED.
C
      JP = GP6(NPGRID)
      IP = JP
C
C.....ACCUMULATE THE PERCENTAGES.
C
      DO 50 KP = 1, 4
      PCT(KP) = PCT(KP) + W6(JP)
      TOTAL   = TOTAL   + W6(JP)
      JP = JP + 1
   50 CONTINUE
C
C.....SET THE FLAG.
C
      IDIST = 1
C
C.....DUMP OUT DEBUG OUTPUT IF SO DESIRED.
C
      IF(IFBUG .EQ. 1) WRITE(IOPDBG,903) NPGRID, IP, W6(IP), W6(IP+1),
     * W6(IP+2), W6(IP+3)
C
  100 CONTINUE
C
C.....AFTER THE LOOP IS FINISHED...CHECK TO SEE IF ANY DISTRIBUTION
C.....HAS BEEN FOUND.
C
      IF(IDIST .EQ. 0) GOTO 150
      IF(TOTAL .GT. 0.01) GOTO 120
      WRITE(IPR,906) NPGRID
      CALL WARN
C
C.....COMPUTE THE AVERAGE OF ALL THE DISTRIBUTIONS.
C
  120 DO 125 NP = 1, 4
      PCT(NP) = PCT(NP)/TOTAL
  125 CONTINUE
C
      IF(IFBUG .EQ. 1) WRITE(IOPDBG,904) (PCT(NP), NP = 1, 4)
      GOTO 999
C
C.....NO DISTRIBUTION FOUND.
C
  150 IF(IFBUG .EQ. 1) WRITE(IOPDBG,905)
C
  999 IF(IPTRCE .GE. 8) WRITE(IOPDBG,902)
C
      RETURN
      END

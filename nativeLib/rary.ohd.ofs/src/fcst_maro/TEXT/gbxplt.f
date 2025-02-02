C MEMBER GBXPLT
C  (from old member PPGBXPLT)
C
      SUBROUTINE GBXPLT(NADJ, NPLOT, KEY)
C
C.....THIS SUBROUTINE DUMPS  GRID POINT PLOT DATA (INCLUDING ESTIMATES)
C.....IN A GIVEN DEGREE BOX AND SURROUNDING DEGREE BOXES.
C
C.....ARGUMENT LIST:
C
C.....NADJ   - THE ADJACENCY MATRIX...READ IN FROM THE PREPROCESSOR
C.....         PARAMETRIC DATA BASE.
C.....NPLOT  - THE ARRAY OF DATA TO BE PLOTTED.
C.....KEY    - A KEY FOR THE TYPE OF DATA DUMP WANTED.
C.....         = 1  DUMP OUT PRECIPITATION.
C.....         = 2  DUMP OUT API
C.....         = 3  DUMP OUT RUNOFF
C
C
C.....ORIGINALLY WRITTEN BY:
C
C.....JERRY M. NUNN       WGRFC FT. WORTH, TEXAS       OCTOBER 1986
C
      INTEGER*2 NPLOT
      INTEGER*2 IP, IPPOUT(20)
      INCLUDE 'common/where'
      INCLUDE 'gcommon/gsize'
      INCLUDE 'gcommon/gdate'
      INCLUDE 'gcommon/gopt'
      INCLUDE 'gcommon/gdispl'
      INCLUDE 'common/pudbug'
      INCLUDE 'common/ionum'
      INCLUDE 'gcommon/gboxot'
C
      DIMENSION N(4), NADJ(1), NPLOT(1), SNAME(2), TYPE(6)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_maro/RCS/gbxplt.f,v $
     . $',                                                             '
     .$Id: gbxplt.f,v 1.1 1995/09/17 19:01:10 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA GBOX /4hGBOX/
      DATA SNAME /4hGBXP, 4hLT  /
      DATA TYPE /4hPREC, 4hIP  , 4hAPIG, 4h    , 4hRUNO, 4hFF  /
C
  900 FORMAT(28X, I1, 1X, 1H*, 20(5H----*))
  901 FORMAT(30X, 1HI, 49X, 1HI, 49X, 1HI)
  902 FORMAT(28X, I1, 1X, 1H., 20(5H    .))
  903 FORMAT(30X, 1H0, 4X, 1H9, 4X, 1H8, 4X, 1H7, 4X, 1H6, 4X, 1H5, 4X,
     * 1H4, 4X, 1H3, 4X, 1H2, 4X, 1H1, 4X, 1H0, 4X, 1H9, 4X, 1H8, 4X,
     * 1H7, 4X, 1H6, 4X, 1H5, 4X, 1H4, 4X, 1H3, 4X, 1H2, 4X, 1H1, 4X,
     * 1H0)
  904 FORMAT(1H1)
  905 FORMAT(30X, 'GRID POINT DUMP OF ', 2A4, 3X, 2A4, I2, ', ', I4)
  906 FORMAT(30X, 1HI, 43X, 4HBOX , I2, 1HI, 43X, 4HBOX , I2, 1HI)
  907 FORMAT(30X, 1HI, 20I5)
  908 FORMAT(1H0, '*** GBXPLT ENTERED ***')
  909 FORMAT(1X, '*** EXIT GBXPLT ***')
  910 FORMAT(1X, 'LOOP COUNT = ', I4, 4X, 'DEGREE BOX NO. = ', I4)
  911 FORMAT(1X, 'STARTING ADDRESS IN HOLDING ARRAY OF PARAMETRIC ARRAY
     *INFORMATION = ', I4)
  912 FORMAT(1X, 'PASS NO. ', I4, ' - BOX NUMBERS TO PROCESS ARE ', 4I6)
  913 FORMAT(1X, 'NUMBER OF COPIES OF DEGREE BOX DUMP = ', I4)
      INCLUDE 'gcommon/setwhere'
C
      IF(IPTRCE .GE. 1) WRITE(IOPDBG,908)
      KGRBUG = IPBUG(GBOX)
C
C.....SET CONSTANTS.
C
      LPARAY = 17
      MP     = 20
      NN     =  4
      KP     =  0
      JP     =  0
      JX = (KEY-1)*2 + 1
C
      IF(KEY .EQ. 1) NUM = NUPCPN
      IF(KEY .EQ. 2) NUM = NUMAPI
      IF(KEY .EQ. 3) NUM = NURNOF
C
      IBXOUT = 0
C
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,913) NUM
      IF(NUM .LE. 0) GOTO 999
C
C.....THE NUMBERS OF THE BOXES TO DUMP OUT ARE GIVEN IN COMMON BLOCK
C...../BOXTRC/.
C
  117 DO 700 MX = 1, NBXDMP
C
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,910) MX, MPTBOX(MX)
C
      IF(MPTBOX(MX) .LE. 0) GOTO 700
      NBOX = MPTBOX(MX)
C
C.....GET THE POSITION IN THE PARAMETRIC ARRAY WHERE THIS INFORMATION
C.....FOR THIS BOX IS KEPT.
C
      IBOX = (NBOX-1)*LPARAY
C
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,911) IBOX
C
C.....DEFINE POINTERS TO SURROUNDING BOXES....SO OTHER BOXES NOT
C.....ADJACENT TO THE CENTRAL BOX WILL ALSO APPEAR. SOMETIMES WE MAY
C.....ALSO WANT THESE TO APPEAR, TOO.
C
      IBPT = NADJ(IBOX+11)
      IF(IBPT .LT. 1) GOTO 101
      JBOX = (IBPT-1)*LPARAY
      GOTO 102
C
  101 JBOX = -9
C
  102 IBPT = NADJ(IBOX+12)
      IF(IBPT .LT. 1) GOTO 103
      KBOX = (IBPT-1)*LPARAY
      GOTO 104
C
  103 KBOX = -9
C
  104 IBPT = NADJ(IBOX+13)
      IF(IBPT .LT. 1) GOTO 105
      LBOX = (IBPT-1)*LPARAY
      GOTO 106
C
  105 LBOX = -9
C
C.....WE WILL NEED 4 PASSES TO PRINT OUT THE CURRENT AND SURROUNDING
C.....BOXES WE NEED.
C
  106 DO 600 IPASS = 1, 4
C
C.....SET UP PRINT TABLES.
C
      IF(IPASS .EQ. 1) GOTO 120
      IF(IPASS .EQ. 2) GOTO 140
      IF(IPASS .EQ. 3) GOTO 160
      IF(IPASS .EQ. 4) GOTO 180
C
  120 N(1) = NADJ(IBOX+16)
      N(2) = NADJ(IBOX+9)
      N(3) = NADJ(IBOX+15)
      N(4) = NADJ(IBOX+4)
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,912) IPASS, (N(NP), NP = 1, 4)
      GOTO 200
C
  140 N(1) = NADJ(IBOX+10)
      N(3) = NADJ(IBOX+11)
C
      IF(JBOX .EQ. -9) GOTO 142
      N(2) = NADJ(JBOX+10)
      N(4) = NADJ(JBOX+11)
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,912) IPASS, (N(NP), NP = 1, 4)
      GOTO 200
C
  142 N(3) = 0
      N(4) = 0
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,912) IPASS, (N(NP), NP = 1, 4)
      GOTO 200
C
  160 N(1) = NADJ(IBOX+14)
      N(2) = NADJ(IBOX+13)
C
      IF(LBOX .EQ. -9) GOTO 162
      N(3) = NADJ(LBOX+14)
      N(4) = NADJ(LBOX+13)
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,912) IPASS, (N(NP), NP = 1, 4)
      GOTO 200
C
  162 N(3) = 0
      N(4) = 0
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,912) IPASS, (N(NP), NP = 1, 4)
      GOTO 200
C
  180 N(1) = NADJ(IBOX+12)
C
      IF(KBOX .EQ. -9) GOTO 182
      N(2) = NADJ(KBOX+11)
      N(3) = NADJ(KBOX+13)
      N(4) = NADJ(KBOX+12)
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,912) IPASS, (N(NP), NP = 1, 4)
      GOTO 200
C
  182 N(2) = 0
      N(3) = 0
      N(4) = 0
      IF(KGRBUG .EQ. 1) WRITE(IOPDBG,912) IPASS, (N(NP), NP = 1, 4)
C
C.....PRINT OUT THE HEADING.
C
  200 WRITE(IPR,904)
      WRITE(IPR,905) TYPE(JX), TYPE(JX+1), IHYDAY, IHYMON, IHYDAT, IHYYR
      WRITE(IPR,903)
      WRITE(IPR,900) KP
C
C.....SET THE X AND Y COORDINATES.
C
      KP = 9
      JP = 9
C
C.....LOOP THRU THE BOXES.
C
      DO 500 K = 1, NN, 2
      KX = K + 1
      NP = N(K)
C
C.....RETRIEVE THE PRECIP FOR THE GRID POINTS.
C
  350 DO 400 LP = 1, MP
C
C.....COMPUTE THE GRID POINT ADDRESS.
C
      NPGRID = NP*100 + KP*10 + JP
      IF(NPGRID .LT. 100) GOTO 320
      IP = NPLOT(NPGRID)
      GOTO 340
C
  320 IP = 0
C
C.....STORE THE PRECIP IN THE OUTPUT ARRAY.
C
  340 IPPOUT(LP) = IP
C
C.....GET THE NEXT POINT ALONG THE X AXIS.
C
      JP = JP - 1
C
C.....IF JP GOES BELOW ZERO...WE ARE NOW LOOKING AT ANOTHER DEGREE
C.....BOX...WHICH IS THE ONE TO THE EAST.
C
      IF(JP .GE. 0) GOTO 400
C
C.....RESET THE X COORDINATE...AND ALTER THE BOX POINTER SO IT POINTS TO
C.....THE DEGREE BOX TO THE EAST OF THE FIRST BOX.
C
      NP = N(KX)
      JP = 9
C
  400 CONTINUE
C
C.....NOW THAT WE HAVE FILLED UP THE OUTPUT LINE...PRINT OUT THE DATA.
C
      IF(KP .EQ. 0) GOTO 460
      WRITE(IPR,901)
  420 WRITE(IPR,901)
      WRITE(IPR,907) (IPPOUT(LP), LP = 1, MP)
C
      IF(KP .GT. 0) GOTO 440
      WRITE(IPR,900) KP
      GOTO 480
C
  440 WRITE(IPR,902) KP
      GOTO 480
C
C.....WRITE OUT THE BOX NUMBERS ON THE SOUTHERNMOST LINE IN THE BOX.
C
  460 WRITE(IPR,906) N(K), N(KX)
      GOTO 420
C
C.....DECREMENT THE VERTICAL COUNTER...AND TEST ITS MAGNITUDE.
C
  480 KP = KP - 1
      JP = 9
      NP = N(K)
      IF(KP .GE. 0) GOTO 350
C
C.....WHEN THE VERTICAL COUNTER HAS GONE BELOW ZERO...WE ARE READY TO
C.....PROCESS THE LOWER ROW OF BOXES.
C
      KP = 9
C
  500 CONTINUE
C
C.....END OF A PASS.
C
  600 CONTINUE
C
C.....END OF A BOX DUMP CHECK.
C
  700 CONTINUE
C
      IBXOUT = IBXOUT + 1
      IF(IBXOUT .LT. NUM) GOTO 117
C
  999 IF(IPTRCE .GE. 1) WRITE(IOPDBG,909)
C
      RETURN
      END


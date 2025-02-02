C MEMBER PIN57
C-----------------------------------------------------------------------
C
C                             LAST UPDATE:
C
C @PROCESS LVL(77)
C
      SUBROUTINE PIN57 (P,LEFTP,IUSEP,C,LEFTC,IUSEC)

C     THIS IS THE INPUT ROUTINE FOR CONSUMPTIVE USE.  THIS
C     ROUTINE INPUTS ALL CARDS FOR THE OPERATION AND FILLS THE
C     P ARRAY AND PLACES INITIAL VALUES OF THE STATE VARIABLES
C     IN THE C ARRAY

C     THIS ROUTINE ORIGINALLY WRITTEN BY
C        JOSEPH PICA  - NWRFC   MAY 1997

C     DEFINITION OF VARIABLES
C     IVERSN = I1     VERSION NUMBER OF OPERATION
C     CTITLE = C72    GENERAL NAME OR TITLE FOR OPERATION

C     TEMPERATURE INPUT FOR ESTIMATING ET
C     MATID  = C8     MEAN AREAL TEMPERATURE TIME SERIES IDENTIFIER
C     MATCD  = C4     MEAN AREAL TEMPERATURE DATA TYPE CODE

C     POTENTIAL EVAPORATION INPUT FOR ESTIMATING ET
C     PEID   = C8     POTENTIAL EVAPORATION TIME SERIES IDENTIFIER
C     PECD   = C4     POTENTIAL EVAPORATION DATA TYPE CODE

C     NATURAL FLOW WHICH IS AVAILABLE FOR DIVERSIONS
C     NATID  = C8     NATURAL FLOW TIME SERIES IDENTIFIER
C     NATCD  = C4     NATURAL FLOW DATA TYPE CODE

C     FLOW AFTER ACCOUNTING FOR DIVERSIONS AND RETURN FLOW OUT
C     ADJID  = C8     ADJUSTED FLOW TIME SERIES IDENTIFIER
C     ADJCD  = C4     ADJUSTED FLOW DATA TYPE CODE

C     WATER DIVERTED BASED ON CROP DEMAND AND IRRIGATION EFFICIENCY
C     DIVID  = C8     DIVERSION FLOW TIME SERIES IDENTIFIER
C     DIVCD  = C4     DIVERSION FLOW DATA TYPE CODE

C     RETURN FLOW STORAGE ACCUMULATION
C     RETURN FLOW IN IS A FRACTION OF THE DIVERSION FLOW
C     RFIID  = C8     RETURN FLOW IN TIME SERIES IDENTIFIER
C     RFICD  = C4     RETURN FLOW IN DATA TYPE CODE

C     RETURN FLOW STORAGE DECAY
C     RETURN FLOW OUT IS PART OF THE ADJUSTED FLOW
C     RFOID  = C8     RETURN FLOW OUT TIME SERIES IDENTIFIER
C     RFOCD  = C4     RETURN FLOW OUT DATA TYPE CODE

C     OTHER LOSSES ARE TRANSPORTATION AND SUBSURFACE LOSSES
C     OTHER LOSSES ARE A FRACTION OF THE DIVERSION FLOW
C     OLID   = C8     OTHER LOSSES FLOW TIME SERIES IDENTIFIER
C     OLCD   = C4     OTHER LOSSES FLOW DATA TYPE CODE

C     CROP DEMAND IS THE AMOUNT OF FLOW REQUIRED FOR THE CROPS
C     CROP DEMAND IS A FRACTION OF THE DIVERSION FLOW
C     CDID   = C8     CROP DEMAND FLOW TIME SERIES IDENTIFIER
C     CDCD   = C4     CROP DEMAND FLOW DATA TYPE CODE

C     ESTIMATED CROP EVAPOTRANSPIRATION SATISFIED
C     CEID   = C8     CROP EVAPOTRANSPIRATION TIME SERIES IDENTIFIER
C     CECD   = C4     CROP EVAPOTRANSPIRATION DATA TYPE CODE

C     OPTION = I1     ET ESTIMATION METHOD
C                        0 - WITH TEMPERATURE TIME-SERIES
C                        1 - WITH POTENTIAL ET TIME-SERIES

C     LAT    = R6     LATTITUDE OF IRRIGATED AREA(-90.00 to 90.00)
C     AREA   = R6     IRRIGATED AREA
C     EFF    = R4     IRRIGATION EFFICIENCY
C     MFLOW  = R4     MINIMUM STREAMFLOW

C     PI     = R6     PI CONSTANT
C     RLAT   = R6     LATTITUDE IN RADIANS
C     DEC    = R6     DECLINATION IN RADIANS
C     SSANGLE= R6     SUNSET ANGLE
C     H(365) = R4     DAILY DAYLIGHT HOURS
C     HYEAR  = R6     ANNUAL DAYLIGHT HOURS

C     K(380) = R4     DAILY EMPIRICAL CROP/METEOROLOGICAL
C                     COEFFICIENTS

C     RFIN   = R4     RETURN FLOW ACCUMULATION RATE
C     RFOUT  = R6     RETURN FLOW DECAY RATE
C     RFSTOR = R6     RETURN FLOW STORAGE

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

C     POSITION     CONTENTS OF P ARRAY

C      1           VERSION NUMBER OF OPERATION
C      2-19        GENERAL NAME OR TITLE

C     TEMPERATURE INPUT FOR ESTIMATING ET
C     20-21       MEAN AREAL TEMPERATURE TIME SERIES IDENTIFIER
C     22          MEAN AREAL TEMPERATURE DATA TYPE CODE

C     POTENTIAL EVAPORATION INPUT FOR ESTIMATING ET
C     23-24       POTENTIAL EVAPORATION TIME SERIES IDENTIFIER
C     25          POTENTIAL EVAPORATION DATA TYPE CODE

C     NATURAL FLOW WHICH IS AVAILABLE FOR DIVERSIONS
C     26-27       NATURAL FLOW TIME SERIES IDENTIFIER
C     28          NATURAL FLOW DATA TYPE CODE

C     FLOW AFTER ACCOUNTING FOR DIVERSIONS AND RETURN FLOW OUT
C     29-30       ADJUSTED FLOW TIME SERIES IDENTIFIER
C     31          ADJUSTED FLOW DATA TYPE CODE

C     WATER DIVERTED BASED ON CROP DEMAND AND IRRIGATION EFFICIENCY
C     32-33       DIVERSION FLOW TIME SERIES IDENTIFIER
C     34          DIVERSION FLOW DATA TYPE CODE

C     RETURN FLOW STORAGE ACCUMULATION
C     RETURN FLOW IN IS A FRACTION OF THE DIVERSION FLOW
C     35-36       RETURN FLOW IN TIME SERIES IDENTIFIER
C     37          RETURN FLOW IN DATA TYPE CODE

C     RETURN FLOW STORAGE DECAY
C     RETURN FLOW OUT IS PART OF THE ADJUSTED FLOW
C     38-39       RETURN FLOW OUT TIME SERIES IDENTIFIER
C     40          RETURN FLOW OUT DATA TYPE CODE

C     OTHER LOSSES ARE TRANSPORTATION AND SUBSURFACE LOSSES
C     OTHER LOSSES ARE A FRACTION OF THE DIVERSION FLOW
C     41-42       OTHER LOSSES FLOW TIME SERIES IDENTIFIER
C     43          OTHER LOSSES FLOW DATA TYPE CODE

C     CROP DEMAND IS THE AMOUNT OF FLOW REQUIRED FOR THE CROPS
C     CROP DEMAND IS A FRACTION OF THE DIVERSION FLOW
C     44-45       CROP DEMAND FLOW TIME SERIES IDENTIFIER
C     46          CROP DEMAND FLOW DATA TYPE CODE

C     CROP EVAPOTRANSPIRATION
C     47-48       CROP EVAPOTRANSPIRATION TIME SERIES IDENTIFIER
C     49          CROP EVAPOTRANSPIRATION DATA TYPE CODE

C     50              OPTION FOR ET ESTIMATION METHOD
C     51              LATTITUDE OF IRRIGATED AREA
C     52              IRRIGATED AREA
C     53              IRRIGATION EFFICIENCY
C     54              MINIMUM FLOW
C     55              RETURN FLOW ACCUMULATION RATE
C     56              RETURN FLOW DECAY RATE
C     57              ANNUAL DAYLIGHT HOURS

C     58-422          DAILY EMPIRICAL CROP/METEOROLOGICAL
C                     COEFFICIENTS

C     THE NUMBER OF ELEMENTS REQUIRED IN THE P ARRAY IS  422

C     POSITION     CONTENTS OF C ARRAY
C      1           RETURN FLOW STORAGE

C     THE NUMBER OF ELEMENTS REQUIRED IN THE C ARRAY IS   1

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

      CHARACTER *72 CTITLE
      CHARACTER * 8 NATID,ADJID,DIVID,RFIID,RFOID,OLID,CDID
      CHARACTER * 8 CEID,PEID,MATID
      CHARACTER * 4 NATCD,ADJCD,DIVCD,RFICD,RFOCD,OLCD,CDCD
      CHARACTER * 4 CECD,PECD,MATCD

      INTEGER OPTION
      REAL K(380), H(365), LAT, RLAT, DEC, MFLOW, HYEAR, PI, SSANGLE

      DIMENSION RTITLE(18)
      DIMENSION RNATID(2),RADJID(2),RDIVID(2),RRFIID(2),RRFOID(2)
      DIMENSION ROLID(2),RCDID(2),RCEID(2),RPEID(2),RMATID(2)
      DIMENSION P(*),C(*)

      EQUIVALENCE (CTITLE,RTITLE)
      EQUIVALENCE (NATID,RNATID),(NATCD,RNATCD)
      EQUIVALENCE (ADJID,RADJID),(ADJCD,RADJCD)
      EQUIVALENCE (DIVID,RDIVID),(DIVCD,RDIVCD)
      EQUIVALENCE (RFIID,RRFIID),(RFICD,RRFICD)
      EQUIVALENCE (RFOID,RRFOID),(RFOCD,RRFOCD)
      EQUIVALENCE (OLID,ROLID),(OLCD,ROLCD)
      EQUIVALENCE (CDID,RCDID),(CDCD,RCDCD)
      EQUIVALENCE (CEID,RCEID),(CECD,RCECD)
      EQUIVALENCE (PEID,RPEID),(PECD,RPECD)
      EQUIVALENCE (MATID,RMATID),(MATCD,RMATCD)

C     COMMON BLOCKS

      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/pin57.f,v $
     . $',                                                             '
     .$Id: pin57.f,v 1.1 1997/12/31 17:50:39 page Exp $
     . $' /
C    ===================================================================
C

C     CHECK TRACE LEVEL
      CALL FPRBUG('PIN57   ',1,57,IBUG)


C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

C                   NWRFS CARDS
C                   FREE FORMAT
C
C                   TEMPERATURE TIME SERIES INPUT
C
C POCATELLO DIVERSIONS
C 0
C BASIN MAT NAT SQME
C ADJ SQME DIV SQME
C RFIN SQME RFOUT SQME LOSS SQME CD SQME CE MAPE
C 43.00 120. 0.70 1.5
C 0.00 0.00 0.10 0.60 0.70 0.80
C 0.90 0.80 0.60 0.30 0.00 0.00
C 0.10 0.005 100.
C
C                   ET TIME SERIES INPUT
C
C POCATELLO DIVERSIONS
C 1
C BASIN MAPE NAT SQME
C ADJ SQME DIV SQME
C RFIN SQME RFOUT SQME LOSS SQME CD SQME CE MAPE
C 43.00 120. 0.70 1.5
C 0.00 0.00 0.10 0.60 0.70 0.80
C 0.90 0.80 0.60 0.30 0.00 0.00
C 0.10 0.005 100.
C


C     CARD 1 - GENERAL USER SUPPLIED INFORMATION
C     CARD 2 - ET ESTIMATION OPTION, TEMPERATURE OR ET TIME SERIES
C     CARD 3 - INPUT TIME SERIES DEFINITION
C        FIELD 1 - TEMPERATURE OR ET TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 2 - TEMPERATURE OR ET DATA TYPE CODE  - 4 CHAR
C        FIELD 3 - NATURAL FLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 4 - NATURAL FLOW DATA TYPE CODE  - 4 CHAR
C     CARD 4 - PRIMARY OUTPUT TIME SERIES DEFINITION
C        FIELD 1 - ADJUSTED FLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 2 - ADJUSTED FLOW DATA TYPE CODE  - 4 CHAR
C        FIELD 3 - DIVERSION FLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 4 - DIVERSION FLOW DATA TYPE CODE  - 4 CHAR
C     CARD 5 - SECONDARY OUTPUT TIME SERIES DEFINITION
C        FIELD 1 - RETURN FLOW IN TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 2 - RETURN FLOW IN DATA TYPE CODE  - 4 CHAR
C        FIELD 3 - RETURN FLOW OUT TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 4 - RETURN FLOW OUT DATA TYPE CODE  - 4 CHAR
C        FIELD 5 - OTHER LOSSES FLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 6 - OTHER LOSSES FLOW DATA TYPE CODE  - 4 CHAR
C        FIELD 7 - CROP DEMAND FLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 8 - CROP DEMAND FLOW DATA TYPE CODE  - 4 CHAR
C        FIELD 9 - CROP ET TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 10 - CROP ET DATA TYPE CODE  - 4 CHAR
C     CARD 6 - GENERAL IRRIGATION BASIN PARAMETERS
C        FIELD 1 - LATTITUDE OF IRRIGATED AREA
C        FIELD 2 - IRRIGATED AREA
C        FIELD 3 - IRRIGATION EFFICIENCY
C        FIELD 4 - MINIMUM STREAMFLOW
C     CARD 7 - MID-MONTH EMPIRICAL COEFFICIENTS, JANUARY-JUNE
C     CARD 8 - MID-MONTH EMPIRICAL COEFFICIENTS, JULY-DECEMBER
C     CARD 9 - RETURN FLOW PARAMETERS
C        FIELD 1 - RETURN FLOW ACCUMULATION RATE
C        FIELD 2 - RETURN FLOW DECAY RATE
C        FIELD 3 - RETURN FLOW INITIAL STORAGE

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

C     READ IN CARDS IN FREE FORMAT
      IUSEP = 0
      IUSEC = 0
      IERROR = 0

      READ(IN,FMT='(A)',ERR=9981) CTITLE
      IF (IBUG.GE.1) WRITE(IODBUG,801) CTITLE
 801  FORMAT(/,'PIN57:  CTITLE: ',A72)

      READ(IN,*,ERR=9982) OPTION
      IF (IBUG.GE.1) WRITE(IODBUG,802) OPTION
 802  FORMAT('PIN57:  OPTION: ',I1)

      IF (OPTION.EQ.0) THEN
         PEID = 'NONE'
         PECD = 'NONE'
         READ(IN,*,ERR=9983) MATID,MATCD,NATID,NATCD
         IF (IBUG.GE.1) WRITE(IODBUG,803)
     +                     MATID,MATCD,NATID,NATCD
 803     FORMAT('PIN57:  MATID,MATCD: ',2A8,/,
     +          '        NATID,NATCD: ',2A8)
      ELSE
         MATID = 'NONE'
         MATCD = 'NONE'
         READ(IN,*,ERR=9984) PEID,PECD,NATID,NATCD
         IF (IBUG.GE.1) WRITE(IODBUG,804)
     +                     PEID,PECD,NATID,NATCD
 804     FORMAT('PIN57:    PEID,PECD: ',2A8,/,
     +          '        NATID,NATCD: ',2A8)
      ENDIF

      READ(IN,*,ERR=9985) ADJID,ADJCD,DIVID,DIVCD
      IF (IBUG.GE.1) WRITE(IODBUG,805)
     +                  ADJID,ADJCD,DIVID,DIVCD
 805  FORMAT('PIN57:  ADJID,ADJCD: ',2A8,/,
     +       '        DIVID,DIVCD: ',2A8)

      READ(IN,*,ERR=9986) RFIID,RFICD,RFOID,RFOCD,
     +           OLID,OLCD,CDID,CDCD,CEID,CECD
      IF (IBUG.GE.1) WRITE(IODBUG,806)
     +                  RFIID,RFICD,RFOID,RFOCD,
     +                  OLID,OLCD,CDID,CDCD,
     +                  CEID,CECD
 806  FORMAT('PIN57:  RFIID,RFICD: ',2A8,/,
     +       '        RFOID,RFOCD: ',2A8,/,
     +       '          OLID,OLCD: ',2A8,/,
     +       '          CDID,CDCD: ',2A8,/,
     +       '          CEID,CECD: ',2A8)

      READ(IN,*,ERR=9987) LAT,AREA,EFF,MFLOW
      IF (IBUG.GE.1) WRITE(IODBUG,807) LAT,AREA,EFF,MFLOW
 807  FORMAT('PIN57:    LAT: ',F8.2,/,
     +       '         AREA: ',F6.0,/,
     +       '          EFF: ',F8.2,/,
     +       '        MFLOW: ',F8.2)

      READ(IN,*,ERR=9988) K(16),K(46),K(75),K(106),K(136),K(167)
      IF (IBUG.GE.1) WRITE(IODBUG,808) K(16),K(46),K(75),K(106),K(136),
     +                                 K(167)
 808  FORMAT('PIN57: JAN-JUN COEFFICIENTS: ',F4.2,1X,
     +       F4.2,1X,F4.2,1X,F4.2,1X,F4.2,1X,F4.2)

      READ(IN,*,ERR=9989) K(197),K(228),K(259),K(289),K(320),K(350)
      IF (IBUG.GE.1) WRITE(IODBUG,809) K(197),K(228),K(259),K(289),
     +                                 K(320),K(350)
 809  FORMAT('PIN57: JUL-DEC COEFFICIENTS: ',F4.2,1X,
     +       F4.2,1X,F4.2,1X,F4.2,1X,F4.2,1X,F4.2)

      READ(IN,*,ERR=9990) RFIN,RFOUT,RFSTOR
      IF (IBUG.GE.1) WRITE(IODBUG,810) RFIN,RFOUT,RFSTOR
 810  FORMAT('PIN57:   RFIN: ',F8.2,/,
     +       '        RFOUT: ',F10.4,/,
     +       '       RFSTOR: ',F6.0,/)

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

C     CHECK TS - NATID,NATCD
C                ADJID,ADJCD
C                DIVID,DIVCD
C                RFIID,RFICD
C                RFOID,RFOCD
C                OLID,OLCD
C                CDID,CDCD
C                CEID,CECD
C                PEID,PECD
C                MATID,MATCD

      CALL CHEKTS (NATID,NATCD,24,1,'L3  ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      CALL CHEKTS (ADJID,ADJCD,24,1,'L3  ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      CALL CHEKTS (DIVID,DIVCD,24,1,'L3  ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      CALL CHEKTS (RFIID,RFICD,24,1,'L3  ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      CALL CHEKTS (RFOID,RFOCD,24,1,'L3  ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      CALL CHEKTS (OLID,OLCD,24,1,'L3  ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      CALL CHEKTS (CDID,CDCD,24,1,'L3  ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      CALL CHEKTS (CEID,CECD,24,1,'L   ',0,1,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      IF (OPTION.EQ.0) THEN
         CALL CHEKTS (MATID,MATCD,6,1,'TEMP',0,1,IERFLG)
         IF (IERFLG.NE.0) IERROR = 1
      ELSE
         CALL CHEKTS (PEID,PECD,24,1,'L   ',0,1,IERFLG)
         IF (IERFLG.NE.0) IERROR = 1
      ENDIF

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

C     CHECK OF PARAMETER LIMITS

C     EFF MUST BE BETWEEN 0.00 AND 1.00

      IF (EFF.GT.1) THEN
         WRITE(IPR,FMT='(10X,''**ERROR** THE IRRIGATION EFFICIENCY'',
     +                 '' MUST BE BETWEEN 0.00 AND 1.00'')')
         IERROR = 1
         CALL ERROR
         GO TO 990
      ENDIF
      IF (EFF.LT.0) THEN
         WRITE(IPR,FMT='(10X,''**ERROR** THE IRRIGATION EFFICIENCY'',
     +                 '' MUST BE BETWEEN 0.00 AND 1.00'')')
         IERROR = 1
         CALL ERROR
         GO TO 990
      ENDIF


C     RFIN MUST BE LESS THAN (1-EFF)

      IF (RFIN.GT.(1-EFF)) THEN
         WRITE(IPR,FMT='(10X,''**ERROR** THE RETURN FLOW '',
     +                 ''ACCUMULATION RATE IS GREATER THAN ITS '',
     +                 ''MAXIMUM ALLOWED, 1 - EFFICIENCY'')')
         IERROR = 1
         CALL ERROR
         GO TO 990
      ENDIF

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

C  CALCULATE DAILY EMPIRICAL CROP/METEOROLOGICAL COEFFICIENTS FROM
C  MID-MONTH COEFFICIENTS SUPPLIED BY THE USER  ---  K ARRAY

C  INTERPOLATION OF LAST HALF OF MONTH WITH 31 DAYS AND FIRST HALF
C  OF NEXT MONTH EXCEPT JAN-FEB --->
C     MAR-APR, MAY-JUN, JUL-AUG, AUG-SEP, OCT-NOV, DEC-JAN

      DO I = 1,30
         K(I+75) = K(75)+(((K(106)-K(75))/31)*I)
         K(I+136) = K(136)+(((K(167)-K(136))/31)*I)
         K(I+197) = K(197)+(((K(228)-K(197))/31)*I)
         K(I+228) = K(228)+(((K(259)-K(228))/31)*I)
         K(I+289) = K(289)+(((K(320)-K(289))/31)*I)
         K(I+350) = K(350)+(((K(16)-K(350))/31)*I)
      END DO

C  FIRST HALF OF JANUARY ---> K(1) = K(366), K(2) = K(367), etc.
C  NOTICE THAT IN A LEAP YEAR, K(366) = K(1)

      DO I = 1,15
         K(I) = K(I+365)
      END DO

C  INTERPOLATION OF LAST HALF OF MONTH WITH 30 DAYS AND FIRST HALF
C  OF NEXT MONTH INCLUDING JAN-FEB --->
C     JAN-FEB, APR-MAY, JUN-JUL, SEP-OCT, NOV-DEC

      DO I = 1,29
         K(I+16) = K(16)+(((K(46)-K(16))/30)*I)
         K(I+106) = K(106)+(((K(136)-K(106))/30)*I)
         K(I+167) = K(167)+(((K(197)-K(167))/30)*I)
         K(I+259) = K(259)+(((K(289)-K(259))/30)*I)
         K(I+320) = K(320)+(((K(350)-K(320))/30)*I)
      END DO

C  INTERPOLATION OF LAST HALF OF FEBRUARY AND FIRST HALF OF MARCH
C     FEB-MAR

      DO I = 1,28
         K(I+46) = K(46)+(((K(75)-K(46))/29)*I)
      END DO

C  DEBUG OUTPUT FOR EMPIRICAL COEFFICIENT COMPUTATIONS

      IF (IBUG.EQ.1) THEN
         DO I = 1,365
            WRITE (IODBUG,1001) I,K(I)
 1001       FORMAT ('PIN57: DAILY EMPIRICAL COEFFICIENTS:',I4,F6.2)
         END DO
      END IF

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012

C  CALCULATION OF ANNUAL DAYTIME HOURS

      PI = 3.141592654
      RLAT = LAT*2*PI/360
      HYEAR = 0
      DO I = 1,365
         DEC = 0.4093*SIN(2*PI*(284+I)/365)
         SSANGLE = ACOS(-1*TAN(RLAT)*TAN(DEC))
         H(I) = SSANGLE*24/PI
         HYEAR = HYEAR+H(I)

C  DEBUG OUTPUT FOR DAYLIGHT HOUR COMPUTATIONS

         IF (IBUG.EQ.1) THEN
            WRITE (IODBUG,1002) I,H(I)
 1002       FORMAT ('PIN57: DAILY DAYLIGHT HOURS:',I4,F6.2)
         END IF

      END DO

C  DEBUG OUTPUT FOR ANNUAL DAYLIGHT HOURS

      IF (IBUG.EQ.1) THEN
         WRITE (IODBUG,1003) HYEAR
 1003    FORMAT (/,'PIN57: ANNUAL DAYLIGHT HOURS:',F6.0,/)
      END IF

C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012


C     CHECK SPACE IN P AND C ARRAYS
C     NUMBER POINTS REQUIRED IN THE P ARRAY IS 422
C     NUMBER POINTS REQUIRED IN THE C ARRAY IS 1
C     IF ICARRY IS NONZERO

      IUSEP = 422

      CALL CHECKP (IUSEP,LEFTP,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      IUSEC = 1

      CALL CHECKC (IUSEC,LEFTC,IERFLG)
      IF (IERFLG.NE.0) IERROR = 1

      IF (IERROR.GE.1) GO TO 990

C     SAVE TIME SERIES IDENTIFIERS AND PARAMETERS TO P AND C ARRAYS

      IVERSN = 1
      P(1) = REAL(IVERSN)
      DO 500 I=1,18
 500  P(I+1) = RTITLE(I)

      P(20) = RMATID(1)
      P(21) = RMATID(2)
      P(22) = RMATCD

      P(23) = RPEID(1)
      P(24) = RPEID(2)
      P(25) = RPECD

      P(26) = RNATID(1)
      P(27) = RNATID(2)
      P(28) = RNATCD

      P(29) = RADJID(1)
      P(30) = RADJID(2)
      P(31) = RADJCD

      P(32) = RDIVID(1)
      P(33) = RDIVID(2)
      P(34) = RDIVCD

      P(35) = RRFIID(1)
      P(36) = RRFIID(2)
      P(37) = RRFICD

      P(38) = RRFOID(1)
      P(39) = RRFOID(2)
      P(40) = RRFOCD

      P(41) = ROLID(1)
      P(42) = ROLID(2)
      P(43) = ROLCD

      P(44) = RCDID(1)
      P(45) = RCDID(2)
      P(46) = RCDCD

      P(47) = RCEID(1)
      P(48) = RCEID(2)
      P(49) = RCECD

      P(50) = REAL(OPTION)

      P(51) = LAT
      P(52) = AREA
      P(53) = EFF
      P(54) = MFLOW

      P(55) = RFIN
      P(56) = RFOUT

      P(57) = HYEAR

      DO 501 I=1,365
 501  P(I+57) = K(I)

      C(1) = RFSTOR

      GO TO 990

 9981 IERROR = 1
      WRITE(IPR,9901)
 9901 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 1 READ: USER SUPPLIED INFORMATION')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 1 READ: USER SUPPLIED INFORMATION
      CALL ERROR
      GO TO 990

 9982 IERROR = 1
      WRITE(IPR,9902)
 9902 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 2 READ: OPTION INFORMATION')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 2 READ: OPTION INFORMATION
      CALL ERROR
      GO TO 990

 9983 IERROR = 1
      WRITE(IPR,9903)
 9903 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 3 READ: INPUT TIME SERIES ',
     +              'OPTION 0 INFORMATION')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 3 READ: INPUT TIME SERIES (OPTION 0) INFORMATION
      CALL ERROR
      GO TO 990

 9984 IERROR = 1
      WRITE(IPR,9904)
 9904 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 3 READ: INPUT TIME SERIES ',
     +           'OPTION 1 INFORMATION')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 3 READ: INPUT TIME SERIES (OPTION 1) INFORMATION
      CALL ERROR
      GO TO 990

 9985 IERROR = 1
      WRITE(IPR,9905)
 9905 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 4 READ: PRIMARY OUTPUT TIME SERIES ',
     +           'INFORMATION')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 4 READ: PRIMARY OUTPUT TIME SERIES INFORMATION
      CALL ERROR
      GO TO 990

 9986 IERROR = 1
      WRITE(IPR,9906)
 9906 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 5 READ: SECONDARY OUTPUT TIME SERIES ',
     +           'INFORMATION')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 5 READ: SECONDARY OUTPUT TIME SERIES INFORMATION
      CALL ERROR
      GO TO 990

 9987 IERROR = 1
      WRITE(IPR,9907)
 9907 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 6 READ: GENERAL IRRIGATION BASIN ',
     +           'PARAMETERS')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 6 READ: GENERAL IRRIGATION BASIN PARAMETERS
      CALL ERROR
      GO TO 990

 9988 IERROR = 1
      WRITE(IPR,9908)
 9908 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 7 READ: JANUARY-JUNE MID-MONTH ',
     +           'EMPIRICAL COEFFICIENTS')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 7 READ: JANUARY-JUNE MID-MONTH EMPIRICAL
C                     COEFFICIENTS
      CALL ERROR
      GO TO 990

 9989 IERROR = 1
      WRITE(IPR,9909)
 9909 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 8 READ: JULY-DECEMBER MID-MONTH ',
     +           'EMPIRICAL COEFFICIENTS')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 8 READ: JULY-DECEMBER MID-MONTH EMPIRICAL
C                     COEFFICIENTS
      CALL ERROR
      GO TO 990

 9990 IERROR = 1
      WRITE(IPR,9910)
 9910 FORMAT(10X,'**ERROR** CONSUMPTIVE USE INPUT ERROR',/,
     +       10X,'CARD 9 READ: RETURN FLOW PARAMETERS')
C        **ERROR** CONSUMPTIVE USE INPUT ERROR
C        CARD 9 READ: RETURN FLOW PARAMETERS
      CALL ERROR
      GO TO 990

 990  IF (IERROR.GE.1) THEN
         IUSEP = 0
         IUSEC = 0
      ENDIF

      IF (ITRACE.GE.1) WRITE(IODBUG,999)
 999  FORMAT('PIN57 (CONSUMPTIVE USE) EXITED')

      RETURN
      END

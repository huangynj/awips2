C MEMBER PIN41
C  (from old member FCPIN41)
C
      SUBROUTINE PIN41(PO,LEFTP,IUSEP,CO,LEFTC,IUSEC)
C
C#######################################################################
C
C  THIS SUBROUTINE READS AND CHECKS ALL CARD INPUT FOR SEGMENT
C  DEFINITION FOR THE NEW EVENT-BASED API-HAR2 OPERATION.
C  IT THEN FILLS THE PO AND CO ARRAYS.
C
C#######################################################################
C
C  CONTENTS OF THE PO ARRAY
C
C
C
C     WORD    NAME       DESCRIPTION                            UNITS
C  ________   _______    _______________________________________________
C      1      IVERS      VERSION NUMBER
C    2 - 3    RID        RUNOFF ZONE ID
C    4 - 8    RNAME      RUNOFF ZONE NAME
C      9      IRNUM      RUNOFF ZONE NUMBER
C     10      RLAT       LATITUDE OF RUNOFF ZONE CENTROID       DEG DEC
C     11      RLNG       LONGITUDE OF RUNOFF ZONE CENTROID      DEG DEC
C
C ********** SEASON QUADRANT PARAMETERS IN POSITIONS 12 - 17 **********
C     12      AEIWET     WET CURVE AEI VALUE                    INCHES
C     13      BWET       WET CURVE AI INTERCEPT                 INCHES
C     14      CWET       WET CURVE CURVATURE
C     15      AEIDRY     DRY CURVE AEI VALUE                    INCHES
C     16      BDRY       DRY CURVE AI INTERCEPT                 INCHES
C     17      CDRY       DRY CURVE CURVATURE
C
C ******* PRECIPITATION QUADRANT PARAMETERS IN POSITIONS 18 - 22 ******
C     18      PA
C     19      PB
C     20      PC
C     21      PD
C     22      PE         NOTE:  THIS PARAMETER SET TO 1.00
C
C     23      FIXPEV     POTENTIAL ET ADJUSTMENT FACTOR
C     24      PMAX       MAX LIMIT FOR NEW STORM RAIN/MELT      INCHES
C     25      R24        24-HOUR API RECESSION FACTOR
C     26      IDELTA     COMPUTATIONAL TIME STEP                HOURS
C     27      NSW        NEW STORM WINDOW                       HOURS
C     28      NSPER      NUMBER OF PERIODS IN NSW
C     29      IUSEC      NUMBER OF WORDS NEEDED IN CO ARRAY
C     30      IOFAAA     API/AEI/AI TIME SERIES OUTPUT FLAG
C     31      ICOF       INITIAL CARRYOVER INPUT FLAG
C   32 - 33   TSIDRM     TIME SERIES ID FOR RAIN/MELT
C     34      DTCRM      DATA TYPE CODE FOR RAIN/MELT
C   35 - 36   TSIDPE     TIME SERIES ID FOR POTENTIAL ET
C     37      DTCPE      DATA TYPE CODE FOR POTENTIAL ET
C   38 - 39   TSIDRO     TIME SERIES ID FOR RUNOFF
C     40      DTCRO      DATA TYPE CODE FOR RUNOFF
C   41 - 42   TSIDAI     TIME SERIES ID FOR AI
C     43      DTCAI      DATA TYPE CODE FOR AI
C   44 - 45   TSIDAP     TIME SERIES ID FOR API
C     46      DTCAP      DATA TYPE CODE FOR API
C   47 - 48   TSIDAE     TIME SERIES ID FOR AEI
C     49      DTCAE      DATA TYPE CODE FOR AEI
C   50 - 55              EMPTY
C
C
C#######################################################################
C
C  CONTENTS OF THE CO ARRAY
C
C
C
C     WORD    NAME       DESCRIPTION                            UNITS
C  ________   _______    _______________________________________________
C      1      TAPI       12Z API VALUE                          INCHES
C      2      TAEI       12Z AEI VALUE                          INCHES
C      3      TAI        12Z AI VALUE
C      4      SAPI       STORM API VALUE AT 12Z                 INCHES
C      5      SAEI       STORM AEI VALUE AT 12Z                 INCHES
C      6      SAI        STORM AI VALUE AT 12Z
C      7      SRAIM      STORM RAIN/MELT                        INCHES
C      8      SRO        STORM RUNOFF                           INCHES
C      9      DRAIM      24-HOUR RAIN/MELT                      INCHES
C     10      DRO        24-HOUR RUNOFF                         INCHES
C     11 -    RNSP       RAIN/MELT IN EACH PERIOD OF THE        INCHES
C   10+NSPER             NEW STORM WINDOW
C
C#######################################################################
C
C
      DIMENSION RID(2),RNAME(5),TSIDRM(2),TSIDAE(2),TSIDRO(2),
     1TSIDAI(2),TSIDAP(2),TSIDPE(2),PO(1),CO(1),SUBNAM(2),RNSP(24)
      COMMON/IONUM/IN,IPR,IPU
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON /FCARY/ IFILLC,NCSTOR,ICDAY(20),ICHOUR(20)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/pin41.f,v $
     . $',                                                             '
     .$Id: pin41.f,v 1.1 1995/09/17 18:48:39 dws Exp $
     . $' /
C    ===================================================================
C
      DATA SUBNAM/4hPIN4,4h1   /,NOP/41/
      DATA DIML/4hL   /,DLES/4hDLES/,BLANK/4h    /
C
C  CALL DEBUG CHECK ROUTINE AND SET INITIAL VARIABLES
C
      CALL FPRBUG(SUBNAM,1,NOP,IFDEB)
      IVERS=1
      IUSEP=49
      ICHKDM=1
      IF(IFDEB)110,110,4100
C
C  READ 8 LETTER RUNOFF ZONE ID, 20 CHARACTER RUNOFF ZONE NAME,
C  RUNOFF ZONE NUMBER, AND LATITUDE AND LONGITUDE OF RUNOFF ZONE
C  CENTROID.
C
110   READ(IN,7110)RID,RNAME,IRNUM,RLAT,RLNG
      IF(IFDEB)115,115,4110
C
C  READ IN SEASON QUADRANT PARAMETERS
C
115   READ(IN,7115)AEIWET,BWET,CWET,AEIDRY,BDRY,CDRY
      IF(IFDEB)120,120,4115
C
C  READ IN PRECIP QUADRANT PARAMETERS
C
120   READ(IN,7120)PA,PB,PC,PD,PE
      IF(IFDEB)125,125,4120
C
C  READ IN MAPE ADJUSTMENT FACTOR, 24-HOUR API RECESSION
C  COEFFICIENT, NEW STORM RAIN/MELT LIMIT, COMPUTATIONAL TIME
C  STEP INTERVAL, NEW STORM WINDOW, I/O FLAG FOR AI, API AND AEI
C  TIME SERIES, AND CARRYOVER INPUT FLAG.
C
125   READ(IN,7125)FIXPEV,PMAX,R24,IDELTA,NSW,IOFAAA,ICOF
      IF(IFDEB)130,130,4130
C
C  READ IN TIME SERIES INFORMATION
C
130   READ(IN,7130)TSIDRM,DTCRM,TSIDPE,DTCPE,TSIDRO,DTCRO
      IF(IFDEB)132,132,4132
C
C  CHECK TO SEE IF THESE TIME SERIES ARE DEFINED FOR THIS OPERATION
C
C  TIME SERIES FOR THE API - HAR2 OPERATION CONTAIN NO
C  MISSING VALUES AND HAVE ONLY 1 VALUE PER TIME INTERVAL.
C
132   MISS=0
      NOVAL=1
      CALL CHEKTS(TSIDRM,DTCRM,IDELTA,ICHDKM,DIML,MISS,NOVAL,IERR)
      CALL CHEKTS(TSIDPE,DTCPE,24,ICHKDM,DIML,MISS,NOVAL,IERR)
      CALL CHEKTS(TSIDRO,DTCRO,IDELTA,ICHKDM,DIML,MISS,NOVAL,IERR)
C
C  READ IN INFORMATION FOR AI, API AND AEI TIME SERIES, IF REQUESTED.
C
      IF(IOFAAA)140,140,135
135   READ(IN,7130)TSIDAI,DTCAI,TSIDAP,DTCAP,TSIDAE,DTCAE
      IF(IFDEB)137,137,4135
137   CALL CHEKTS(TSIDAI,DTCAI,IDELTA,ICHKDM,DLES,MISS,NOVAL,IERR)
      CALL CHEKTS(TSIDAP,DTCAP,IDELTA,ICHKDM,DIML,MISS,NOVAL,IERR)
      CALL CHEKTS(TSIDAE,DTCAE,IDELTA,ICHKDM,DIML,MISS,NOVAL,IERR)
C
C  CHECK VALIDITY OF PARAMETRIC DATA JUST READ IN
C
140   IF((IRNUM.LT.0).OR.(IRNUM.GT.1000))GO TO 5140
150   IF((RLAT.LT.36.0).OR.(RLAT.GT.43.5))GO TO 5150
160   IF((RLNG.LT.73.5).OR.(RLNG.GT.83.5))GO TO 5160
180   IF((AEIWET.LE.0.).OR.(AEIWET.GT.6.0).OR.(BWET.LE.0.).OR.(BWET.GT.5
     1.0).OR.(CWET.LE.0.0).OR.(CWET.GE.1.0).OR.(AEIDRY.LE.0.).OR.(AEIDRY
     2.GT.12.0).OR.(BDRY.LE.0.).OR.(BDRY.GT.10.0).OR.(CDRY.LE.0.0).OR.(C
     3DRY.GE.1.0))GO TO 5180
200   IF((PA.LT.0.01).OR.(PB.LT.0.01).OR.(PC.LT.0.01).OR.(PD.LT.0.01).OR
     1.(PA.GT.5.0).OR.(PB.GT.5.0).OR.(PC.GT.5.0).OR.(PD.GT.5.0).OR.(PE.N
     2E.1.00))GO TO 5200
210   IF((FIXPEV.LE.0.5).OR.(FIXPEV.GT.2.0))GO TO 5210
220   IF((PMAX.LT.0.0).OR.(PMAX.GT.1.00))GO TO 5220
230   IF((R24.LT.0.8).OR.(R24.GT.0.99))GO TO 5230
240   IF((IDELTA.LT.1).OR.(IDELTA.GT.24))GO TO 5240
250   IF((NSW.LT.1).OR.(NSW.GT.24))GO TO 5250
C
C  CONSTRUCT ALL ADDITIONAL INFO NEEDED FOR THE API - HAR2 OPERATION
C  FROM THIS PARAMETRIC DATA.
C
C  FIRST, CHECK TO MAKE SURE THE NEW STORM WINDOW IS A POSITIVE,
C  NON-ZERO INTEGER MULTIPLE OF IDELTA.  IF NOT, PRINT A WARNING
C  MESSAGE.
C
300   RX1=FLOAT(NSW)/FLOAT(IDELTA)
      NSPER=NSW/IDELTA
      RX1=RX1*IDELTA
      RX2=NSPER*IDELTA
      IF(RX1-RX2)5310,310,5310
C
C  CHECK TO MAKE SURE NSPER IS GREATER THAN ZERO AND LESS THAN OR
C  EQUAL TO 24.
C
310   IF(NSPER)5320,5320,320
320   IF(24-NSPER)5330,330,330
330   IUSEC=NSPER+10
C
C  CHECK TO SEE IF CARRYOVER VALUES ARE BEING INPUT.  IF NOT,
C  USE DEFAULTS.
C
350   IF(ICOF)380,380,370
370   READ(IN,7150)TAPI,TAEI,TAI,SAPI,SAEI,SAI,SRAIM,SRO,DRAIM,DRO
      READ(IN,7151)(RNSP(I),I=1,NSPER)
      IF(IFDEB)610,610,4380
380   TAPI=1.00
      TAEI=5.00
      TAI=2.60
      SAPI=1.00
      SAEI=5.00
      SAI=2.60
      SRAIM=0.0
      SRO=0.0
      DRAIM=0.0
      DRO=0.0
      DO 390 I=1,NSPER
390   RNSP(I)=0.0
      IF(IFDEB)610,610,4390
C
C  CHECK VALIDITY OF CARRYOVER DATA
C
610   IF((TAPI.LT.0.00).OR.(TAPI.GT.15.0))GO TO 5610
620   IF((TAEI.LT.1.00).OR.(TAEI.GT.11.00))GO TO 5620
630   IF((TAI.LT.0.0).OR.(TAI.GT.8.0))GO TO 5630
640   IF((SAPI.LT.0.00).OR.(SAPI.GT.15.0))GO TO 5640
650   IF((SAEI.LT.1.00).OR.(SAEI.GT.11.00))GO TO 5650
660   IF((SAI.LT.0.0).OR.(SAI.GT.8.0))GO TO 5660
665   IF((SRAIM.LT.0.0).OR.(SRAIM.GT.60.0))GO TO 5665
670   IF((SRO.LT.0.0).OR.(SRO.GT.60.0))GO TO 5670
690   RNS=0.0
      DO 695 I=1,NSPER
695   RNS=RNSP(I)+RNS
      IF((RNS.LT.0.0).OR.(RNS.GT.60.0))GO TO 5685
C
C
C CHECK P ARRAY TO MAKE SURE SPACE IS AVAILABLE TO STORE PARAMETRIC DATA
C
710   CALL CHECKP(IUSEP,LEFTP,IERR)
      IF(IERR)730,730,720
720   CALL ERROR
      IUSEP=0
      GO TO 755
C
C  NOW STORE PARAMETRIC DATA IN PO ARRAY.
C
730   PO(1)=IVERS+0.01
      DO 740 I=1,2
740   PO(I+1)=RID(I)
      DO 750 I=1,5
750   PO(I+3)=RNAME(I)
      PO(9)=IRNUM+0.01
      PO(10)=RLAT
      PO(11)=RLNG
      PO(12)=AEIWET
      PO(13)=BWET
      PO(14)=CWET
      PO(15)=AEIDRY
      PO(16)=BDRY
      PO(17)=CDRY
      PO(18)=PA
      PO(19)=PB
      PO(20)=PC
      PO(21)=PD
      PO(22)=PE
      PO(23)=FIXPEV
      PO(24)=PMAX
      PO(25)=R24
      PO(26)=IDELTA
      PO(27)=NSW
      PO(28)=NSPER
      PO(29)=IUSEC
      PO(30)=IOFAAA
      PO(31)=ICOF
      PO(32)=TSIDRM(1)
      PO(33)=TSIDRM(2)
      PO(34)=DTCRM
      PO(35)=TSIDPE(1)
      PO(36)=TSIDPE(2)
      PO(37)=DTCPE
      PO(38)=TSIDRO(1)
      PO(39)=TSIDRO(2)
      PO(40)=DTCRO
      IF(IOFAAA)751,751,753
751   DO 752 I=41,49
752   PO(I)=BLANK
      GO TO 754
753   PO(41)=TSIDAI(1)
      PO(42)=TSIDAI(2)
      PO(43)=DTCAI
      PO(44)=TSIDAP(1)
      PO(45)=TSIDAP(2)
      PO(46)=DTCAP
      PO(47)=TSIDAE(1)
      PO(48)=TSIDAE(2)
      PO(49)=DTCAE
754   PO(50)=0.01
      PO(51)=0.01
      PO(52)=0.01
      PO(53)=0.01
      PO(54)=0.01
      PO(55)=0.01
C
C  CHECK C ARRAY TO MAKE SURE SPACE IS AVAILABLE TO STORE
C  CARRYOVER DATA
C
755   CALL CHECKC(IUSEC,LEFTC,IERR)
      IF(IERR)770,770,760
760   CALL ERROR
      IUSEC=0
      GO TO 10000
770   CO(1)=TAPI
      CO(2)=TAEI
      CO(3)=TAI
      CO(4)=SAPI
      CO(5)=SAEI
      CO(6)=SAI
      CO(7)=SRAIM
      CO(8)=SRO
      CO(9)=DRAIM
      CO(10)=DRO
      DO 780 I=1,NSPER
780   CO(I+10)=RNSP(I)
      GO TO 10000
C
C#######################################################################
C
C  DEBUG WRITE STATEMENTS
C
C#######################################################################
C
4100  WRITE(IODBUG,8100)SUBNAM,IVERS
      GO TO 110
4110  WRITE(IODBUG,8110)RID,RNAME,IRNUM,RLAT,RLNG
      GO TO 115
4115  WRITE(IODBUG,8115)AEIWET,BWET,CWET,AEIDRY,BDRY,CDRY
      GO TO 120
4120  WRITE(IODBUG,8120)PA,PB,PC,PD,PE
      GO TO 125
4130  WRITE(IODBUG,8130)FIXPEV,PMAX,R24,IDELTA,NSW,IOFAAA,ICOF
      GO TO 130
4132  WRITE(IODBUG,8132)TSIDRM,DTCRM,TSIDPE,DTCPE,TSIDRO,DTCRO
      GO TO 132
4135  WRITE(IODBUG,8135)TSIDAI,DTCAI,TSIDAP,DTCAP,TSIDAE,DTCAE
      GO TO 137
4380  WRITE(IODBUG,8380)TAPI,TAEI,TAI,SAPI,SAEI,SAI,SRAIM,SRO,DRAIM,DRO
      WRITE(IODBUG,8381)(RNSP(I),I=1,NSPER)
      GO TO 610
4390  WRITE(IODBUG,8390)
      WRITE(IODBUG,8380)TAPI,TAEI,TAI,SAPI,SAEI,SAI,SRAIM,SRO,DRAIM,DRO
      WRITE(IODBUG,8381)(RNSP(I),I=1,NSPER)
      GO TO 610
C
C#######################################################################
C
C  ERROR AND WARNING WRITE STATEMENTS
C
C#######################################################################
C
5140  WRITE(IPR,9140)IRNUM
      CALL WARN
      GO TO 150
5150  WRITE(IPR,9150)RLAT
      CALL WARN
      GO TO 160
5160  WRITE(IPR,9160)RLNG
      CALL WARN
      GO TO 180
5180  WRITE(IPR,9180)AEIWET,BWET,CWET,AEIDRY,BDRY,CDRY
      CALL ERROR
      GO TO 200
5200  WRITE(IPR,9200)PA,PB,PC,PD,PE
      CALL ERROR
      GO TO 210
5210  WRITE(IPR,9210)FIXPEV
      CALL ERROR
      GO TO 220
5220  WRITE(IPR,9220)PMAX
      CALL ERROR
      GO TO 230
5230  WRITE(IPR,9230)R24
      CALL ERROR
      GO TO 240
5240  WRITE(IPR,9240)IDELTA
      CALL ERROR
      GO TO 250
5250  WRITE(IPR,9250)NSW
      CALL ERROR
      GO TO 300
5310  WRITE(IPR,9310)NSW,IDELTA
      CALL ERROR
      GO TO 310
5320  WRITE(IPR,9320)NSPER
      CALL ERROR
      GO TO 330
5330  WRITE(IPR,9330)NSPER
      CALL ERROR
      GO TO 330
5610  WRITE(IPR,9610)TAPI
      CALL ERROR
      GO TO 620
5620  WRITE(IPR,9620)TAEI
      CALL ERROR
      GO TO 630
5630  WRITE(IPR,9630)TAI
      CALL ERROR
      GO TO 640
5640  WRITE(IPR,9640)SAPI
      CALL ERROR
      GO TO 650
5650  WRITE(IPR,9650)SAEI
      CALL ERROR
      GO TO 660
5660  WRITE(IPR,9660)SAI
      CALL ERROR
      GO TO 665
5665  WRITE(IPR,9665)SRAIM
      CALL ERROR
      GO TO 670
5670  WRITE(IPR,9670)SRO
      CALL ERROR
      GO TO 690
5685  WRITE(IPR,9685)RNS
      CALL ERROR
      GO TO 710
C
C#######################################################################
C
C  INPUT FORMAT STATEMENTS
C
C#######################################################################
C
7110  FORMAT(2A4,6X,5A4,5X,I4,6X,F5.2,5X,F5.2)
7115  FORMAT(6F5.2)
7120  FORMAT(5F5.2)
7125  FORMAT(3F5.2,4I5)
7130  FORMAT(2A4,3X,A4,4X,2A4,3X,A4,5X,2A4,3X,A4)
7150  FORMAT(10F5.2)
7151  FORMAT(12F5.2,/,12F5.2)
C
C#######################################################################
C
C  DEBUG FORMAT STATEMENTS
C
C#######################################################################
C
8100  FORMAT(/1X,2A4,' DEBUG OUTPUT.',5X,'VERSION: ',I4)
8110  FORMAT(///4X,'RID',14X,'RNAME',11X,'IRNUM',5X,'RLAT',5X,'RLNG',
     1      /2X,2A4,4X,5A4,4X,I4,4X,F5.2,4X,F5.2)
8115  FORMAT(/2X,'AEIWET',5X,'BWET',5X,'CWET',4X,'AEIDRY',5X,'BDRY',
     1      5X,'CDRY',/3X,F5.2,4X,F5.2,4X,F5.2,5X,F5.2,4X,F5.2,4X,F5.2)
8120  FORMAT(/3X,'PA',7X,'PB',7X,'PC',7X,'PD',7X,'PE',/2X,F5.2,
     1      4(4X,F5.2))
8130  FORMAT(/2X,'FIXPEV',5X,'PMAX',5X,'R24',5X,'IDELTA',5X,'NSW',4X,
     1      'IOFAAA',4X,'ICOF',/3X,F5.2,4X,F5.2,4X,F5.2,5X,I4,5X,I4,
     2      5X,I4,5X,I4)
8132  FORMAT(/2X,'TSIDRM= ',2A4,5X,'DTCRM= ',A4,
     1      /2X,'TSIDPE= ',2A4,5X,'DTCPE= ',A4,
     2      /2X,'TSIDRO= ',2A4,5X,'DTCRO= ',A4)
8135  FORMAT(/2X,'TSIDAI= ',2A4,5X,'DTCAI= ',A4,
     1      /2X,'TSIDAP= ',2A4,5X,'DTCAP= ',A4,
     2      /2X,'TSIDAE= ',2A4,5X,'DTCAE= ',A4)
8380  FORMAT(/3X,'TAPI',4X,'TAEI',4X,'TAI',5X,'SAPI',4X,'SAEI',4X,
     1      'SAI',4X,'SRAIM',4X,'SRO',4X,'DRAIM',4X,'DRO',/2X,
     2      F5.2,9(3X,F5.2))
8381  FORMAT(/3X,'RAIN/MELT FOR EACH PERIOD WITHIN THE NEW STORM ',
     1      'WINDOW (OLDEST PERIOD IS FIRST):',
     2      /3X,12(F5.2,3X),/3X,12(F5.2,3X))
8390  FORMAT(/3X,'DEFAULT VALUES WERE USED FOR THE ',
     1      'FOLLOWING CARRYOVER VARIABLES: ',/)
C
C#######################################################################
C
C  ERROR AND WARNING FORMAT STATEMENTS
C
C#######################################################################
C
9140  FORMAT(/10X,'** WARNING ** INVALID RUNOFF ZONE NUMBER :  ',I4,
     1      /24X,'RANGE IS 0 THROUGH 1000.',
     2      /24X,'NOTE:  RUNOFF ZONE NUMBER IS ENTERED FOR POSSIBLE ',
     3      'EXTERNAL USE,',/24X,'BUT IS NOT NEEDED BY THE API - HAR2',
     4      ' OPERATION ITSELF.')
9150  FORMAT(/10X,'** WARNING ** INVALID RUNOFF ZONE LATITUDE :  ',F6.2,
     1      /24X,'RANGE IS 36.00 THROUGH 43.50 DEG DECIMAL.',
     2      /24X,'NOTE:  RUNOFF ZONE LATITUDE IS ENTERED FOR POSSIBLE ',
     3      'EXTERNAL USE, ',/24X,'BUT IS NOT NEEDED BY THE API - HAR2',
     4      ' OPERATION ITSELF.')
9160  FORMAT(/10X,'** WARNING ** INVALID RUNOFF ZONE LONGITUDE :  ',
     1      F6.2,/24X,'RANGE IS 73.50 THROUGH 83.50 DEG DECIMAL.',
     2      /24X,'NOTE:  RUNOFF ZONE LONGITUDE IS ENTERED FOR ',
     3      'POSSIBLE EXTERNAL USE,',/24X,'BUT IS NOT NEEDED BY THE ',
     4      'API - HAR2 OPERATION ITSELF.')
9180  FORMAT(/10X,'** ERROR **   INVALID SEASON QUADRANT ',
     1      'COEFFICIENT(S).',/24X,'AT LEAST ONE OF THE FOLLOWING ',
     2      'VALUES IS OUT OF RANGE:',//24X,'COEFFICIENT',6X,'RANGE',
     3      6X,'VALUE ENTERED',/24X,'AEIWET',8X,'0.00 -  6.00',6X,F6.2,
     4      /24X,'BWET',10X,'0.00 -  5.00',6X,F6.2,
     5      /24X,'CWET',10X,'0.00 -  0.99',6X,F6.2,
     6      /24X,'AEIDRY',8X,'0.00 - 12.00',6X,F6.2,
     7      /24X,'BDRY',10X,'0.00 - 10.00',6X,F6.2,
     8      /24X,'CDRY',10X,'0.00 -  0.99',6X,F6.2)
9200  FORMAT(/10X,'** ERROR **   INVALID PRECIPITATION QUADRANT ',
     1      'COEFFICIENT(S).',/24X,'AT LEAST ONE OF THE FOLLOWING ',
     2      'VALUES IS OUT OF RANGE:',//24X,'COEFFICIENT',6X,
     3      'RANGE',6X,'VALUE ENTERED',
     4      /24X,'PA',13X,'0.01 - 5.00',6X,F6.2,
     5      /24X,'PB',13X,'0.01 - 5.00',6X,F6.2,
     6      /24X,'PC',13X,'0.01 - 5.00',6X,F6.2,
     7      /24X,'PD',13X,'0.01 - 5.00',6X,F6.2,
     8      /24X,'PE',17X,'1.00',9X,F6.2)
9210  FORMAT(/10X,'** ERROR **   INVALID POTENTIAL EVAPOTRANSPIRATION ',
     1      'ADJUSTMENT FACTOR :  ',F6.2,/24X,'PROGRAMMED RANGE IS ',
     2      '0.50 TO 2.00.')
9220  FORMAT(/10X,'** ERROR **   INVALID STORM BREAK THRESHOLD ',
     1      'VALUE :  ',F6.2,/24X,'PROGRAMMED RANGE IS 0.00 TO 1.00 ',
     2      'INCH.')
9230  FORMAT(/10X,'** ERROR **   INVALID 24-HOUR API RECESSION ',
     1      'COEFFICIENT :  ',F6.2,/24X,'PROGRAMMED RANGE IS 0.80 ',
     2      'TO 0.99.')
9240  FORMAT(/10X,'** ERROR **   INVALID COMPUTATIONAL TIME STEP ',
     1      'INTERVAL (IDELTA) :  ',I6,/24X,'PERMITTED VALUES :  ',
     2      '1, 2, 3, 4, 6, 8, 12, OR 24 HOURS.')
9250  FORMAT(/10X,'** ERROR **   INVALID NUMBER OF HOURS IN THE NEW ',
     1      'STORM WINDOW :  ',I6,/24X,'PERMITTED VALUES :  ',
     2      '1, 2, 3, 4, 6, 8, 12, OR 24 HOURS.')
9310  FORMAT(/10X,'** ERROR **   THE NUMBER OF HOURS USED TO DEFINE ',
     1      'THE NEW STORM WINDOW ',/24X,'IS NOT A POSITIVE, NON-ZERO ',
     2      'INTEGER MULTIPLE OF THE',/24X,'COMPUTATIONAL TIME STEP ',
     3      'INTERVAL.  THIS MEANS THAT THE TIME',/24X,'INTERVAL OVER ',
     4      'WHICH THE API-HAR2 OPERATION CHECKS FOR A STORM',/24X,
     5      'BREAK MAY NOT BE WHAT IS ACTUALLY DESIRED.  SUGGESTED ',
     6      'REMEDY:',/24X,'ADJUST THE NEW STORM WINDOW AND/OR THE ',
     7      'COMPUTATIONAL TIME',/24X,'STEP INTERVAL.  THE RESPECTIVE ',
     8      'VALUES OF THESE VARIABLES JUST ',/24X,'READ IN ARE ',I5,
     9      ' AND ',I5)
9320  FORMAT(/10X,'** ERROR **   THE NUMBER OF PERIODS CALCULATED ',
     1      'FROM THE SPECIFIED',/24X,'NEW STORM WINDOW IS LESS ',
     2      'THAN 1 :  ',F6.2,/24X,'PROGRAMMED RANGE IS 1 THROUGH ',
     3      '24.')
9330  FORMAT(/10X,'** ERROR **   THE NUMBER OF PERIODS CALCULATED ',
     1      'FROM THE SPECIFIED',/24X,'NEW STORM WINDOW IS GREATER ',
     2      'THAN 24 :  ',F6.2,/24X,'PROGRAMMED RANGE IS 1 THROUGH ',
     3      '24.')
9610  FORMAT(/10X,'** ERROR **   INVALID 12Z API CARRYVOVER VALUE :  ',
     1      F6.2,/24X,'PROGRAMMED RANGE IS 0.00 THROUGH 15.00 INCHES.')
9620  FORMAT(/10X,'** ERROR **   INVALID 12Z AEI CARRYOVER VALUE :  ',
     1      F6.2,/24X,'PROGRAMMED RANGE IS 1.00 THROUGH 11.00 INCHES.')
9630  FORMAT(/10X,'** ERROR **   INVALID 12Z AI CARRYOVER VALUE :  ',
     1      F6.2,/24X,'PROGRAMMED RANGE IS 0.00 THROUGH 8.00 INCHES.')
9640  FORMAT(/10X,'** ERROR **   INVALID 12Z STORM API CARRYOVER VALUE',
     1      ' :  ',F6.2,/24X,'PROGRAMMED RANGE IS 0.00 THROUGH 15.00 ',
     2      'INCHES.')
9650  FORMAT(/10X,'** ERROR **   INVALID 12Z STORM AEI CARRYOVER VALUE',
     1      ' :  ',F6.2,/24X,'PROGRAMMED RANGE IS 1.00 THROUGH 11.00 ',
     2      'INCHES.')
9660  FORMAT(/10X,'** ERROR **   INVALID 12Z STORM AI CARRYOVER VALUE ',
     1      ':  ',F6.2,/24X,'PROGRAMMED RANGE IS 0.00 THROUGH 8.00 ',
     2      'INCHES.')
9665  FORMAT(/10X,'** ERROR **   INVALID STORM RAIN/MELT CARRYOVER ',
     1      'VALUE :  ',F6.2,/24X,'PROGRAMMED RANGE IS 0.00 THROUGH ',
     2      '60.00 INCHES.')
9670  FORMAT(/10X,'** ERROR **   INVALID STORM RUNOFF CARRYOVER ',
     1      'VALUE :  ',F6.2,/24X,'PROGRAMMED RANGE IS 0.00 THROUGH ',
     2      '60.00 INCHES.')
9685  FORMAT(/10X,'** ERROR **   INVALID RAIN/MELT TOTAL IN THE ',
     1      'NEW STORM WINDOW :  ',F6.2,/24X,
     2      'PROGRAMMED RANGE IS 0.00 THROUGH 60.00 INCHES.')
10000 RETURN
      END

C MEMBER EDSUNT
C  (from old member EEDSUNT)
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 06/08/94.08:27:02 BY $WC20SV
C
C @PROCESS LVL(77)
C
      SUBROUTINE EDSUNT (PESP,LP,UNITS,VARTYP,IER)
C
C ....................................................................
C
C            DISPLAY UNITS ROUTINE
C
C THIS ROUTINE DETERMINES THE PROPER STANDARD METRIC UNITS FOR
C THE ACCUMULATED VALUES AND IS DEPENDENT ON THE OUTPUT VARIABLE
C AND DATA TYPE CODES OF THE 2 TIME SERIES.  ALSO IN CERTAIN CASES
C KODE IS MADE NEGATIVE (WHEN NVAR=7 OR 8 AND CONVERSION TO MEAN DAILY
C VALUES MUST TAKE PLACE).
C
C RULES:
C  1. EXCEPT FOR CASES 2 AND 4 BELOW THE UNITS OF DTYP1 AND DTYP2 MUST
C BE EQUAL AND THIS WILL BE THE UNITS RETURNED.
C  2.FOR NAVR=1,2,3,OR 4 UNITS CAN BE CMS AND CMSD IN WHICH CASE
C UNITS = CMSD
C  3. FOR NVAR=5 OR 6 TIME SCALES MUST BOTH BE INST.
C  4. FOR NVAR=7 OR 8 IF TIME SCALES ARE BOTH INST THEN JUST CHECK
C THAT UNITS ARE EQUAL. IF NOT INST, THEN CHECK IF TIME SCALES AND TIME
C INTERVALS ARE EQUAL. IF NOT THEN KODE=(-) KODE TO SIGNIFY ALL VALUES
C ARE CONVERTED TO MEAN DAILY VALUES (AND FOR FLOW UNITS=CMSD).
C
C
C ORIGINALLY BY  ED VANBLARGAN - HRL - FEB, 1981
C ......................................................................
C
C VARIABLES:
C NVAR  - NUMBER OF THE OUPUT VARIABLE (INPUT)
C DTYP1 - DATA TYPE CODE OF TIME SERIES 1 (INPUT)
C DTYP2 -   "   "    "   "    "    "    2 (INPUT)
C  IDT1 - TIME INTERVAL OF TS 1 (INPUT)
C  IDT2 - TIME INTERVAL OF TS 2 (INPUT)
C UNITS - STANDARD METRIC UNITS OF THE ACCUMULATED VALUES (OUTPUT)
C PESP(LP+5) - KODE OPTION. NEGATIVE ONLY IF VALUES MUST BE
C         MEAN DAILY FOR NVAR=7 OR 8. (INPUT AND/OR OUTPUT)
C UNIT1 - UNITS OF DTYP1
C UNIT2 - UNITS OF DTYP2
C ITSCL1- TIME SCALE OF DTYP1
C ITSCL2- TIME SCALE OF DTYP2
C VARTYP- ARRAY WITH 4 LETTER ABBREVIATIONS OF OUTPUT VARIABLES.
C
C
C
      DIMENSION SBNAME(2),OLDOPN(2),PESP(1),VARTYP(1)
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/where'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/espinit/RCS/edsunt.f,v $
     . $',                                                             '
     .$Id: edsunt.f,v 1.1 1995/09/17 18:46:21 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA NAME,SBNAME/4HEARY,4HEDSU,4HNT  /
      DATA BLANK,CMS,CMSD,TM3,INST/4H    ,4HCMS ,4HCMSD,4HTM3 ,4HINST/
      DATA IBLNK/4H    /
C
C
C PUT IN ERROR TRACES FOR THIS ROUTINE
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 10 I=1,2
        OLDOPN(I)=OPNAME(I)
        OPNAME(I)=SBNAME(I)
10    CONTINUE
C
C GET TRACE LEVEL .
C
      IF (ITRACE.GE.1) WRITE(IODBUG,90)
90    FORMAT(1H0,14HEDSUNT ENTERED)
C
C SET VARIABLES
C
      IER=0
      NVAR=PESP(LP+1)
      DTYP1=PESP(LP+15)
      DTYP2=PESP(LP+24)
      IDT1=PESP(LP+16)
      IDT2=PESP(LP+25)
C
C GET DEBUG CODE
C
      IBUG=0
      IF (IFBUG(NAME).EQ.0) GO TO 150
      IBUG=1
      WRITE(IODBUG,115) NVAR,DTYP1,DTYP2,IDT1,IDT2,PESP(LP+5)
115   FORMAT(1X,I3,1X,A4,1X,A4,2I5,F5.2)
C
C CALL FDCODE FOR EACH DATA TYPE TO GET UNIT AND TIME SCALE.
C BEFORE CALLING FDCODE FOR DTYP2 HOWEVER MUST CHECK IF DTYP2
C IS BLANK. IF SO, SKIP IT AND JUST USE DTYP1.
C
150   CALL FDCODE(DTYP1,UNIT1,DIM1,MS,NVT,ITSCL1,NADD,IER)
      IF (IER.EQ.0) GO TO 180
      WRITE(IPR,215) DTYP1
      GO TO 890
C
180   UNITS=UNIT1
      IF (DTYP2.NE.BLANK) GO TO 200
C HAVE ONLY 1 TS
      GO TO(190,190,190,190,185,185,999,999),NVAR
C HAVE INST NVAR
185   IF (ITSCL1.EQ.INST) GO TO 999
      ITSCL2=IBLNK
      WRITE(IPR,894) VARTYP(NVAR),PESP(LP+3),PESP(LP+4),ITSCL1,ITSCL2
      GO TO 890
C NVAR=1,2,3, OR 4.  IF EITHER CMS OR CMSD THEN UNITS=CMSD
C (EXCEPT IF NVAR=4 IN WHICH CASE UNITS=TMS), OTHERWISE,
C TIME SCALES CAN BE ANY.
190   IF (UNITS.EQ.CMS) UNITS=CMSD
      IF (NVAR.EQ.4 .AND. UNITS.EQ.CMSD) UNITS=TM3
      GO TO 999
C
200   CALL FDCODE(DTYP2,UNIT2,DIM2,MS,NVT,ITSCL2,NADD,IER)
      IF (IER.EQ.0) GO TO 300
      WRITE(IPR,215) DTYP2
215   FORMAT(1H0,10X,34H**ERROR** IN FDCODE FOR DATA TYPE ,A4)
      GO TO 890
C
C GO TO PROPER PLACE DEPENDING ON VALUE OF NVAR
C
300   GO TO(500,500,500,500,600,600,400,400),NVAR
C
      WRITE(IPR,315) NVAR
315   FORMAT(1H0,10X,26H**ERROR** IMPOSSIBLE NVAR=,I4,
     * ' IMPOSSIBLE GOTO.')
      GO TO 890
C
C NVAR=7 OR 8
C
400   IF (ITSCL1.EQ.INST .AND. ITSCL2.EQ.INST) GO TO 630
      IF (ITSCL1.NE.ITSCL2) GO TO 430
      IF (IDT1.EQ.IDT2) GO TO 500
C
430   PESP(LP+5)=-PESP(LP+5)
      WRITE(IPR,435) VARTYP(NVAR),PESP(LP+3),PESP(LP+4),DTYP1,DTYP2
435   FORMAT(1H0,10X,29H**WARNING** OUTPUT VARIABLE: ,A4,1X,2A4,
     * 8H DTYPES:,2(1X,A4),2X,31HWILL BE CONVERTED TO MEAN DAILY,
     * 8H VALUES.)
      CALL WARN
C
C NVAR=1,2,3, OR 4.  IF EITHER CMS OR CMSD THEN UNITS=CMSD
C (EXCEPT IF NVAR=4 IN WHICH CASE UNITS=TMS), OTHERWISE,
C UNITS OF THE TWO TS MUST BE EQUAL.
C
500   IF (UNIT1.EQ.CMS .AND. UNIT2.EQ.CMS) GO TO 510
      IF (UNIT1.EQ.CMSD .AND. UNIT2.EQ.CMSD) GO TO 510
      IF (UNIT1.EQ.CMS .AND. UNIT2.EQ.CMSD) GO TO 510
      IF (UNIT1.EQ.CMSD .AND. UNIT2.EQ.CMS) GO TO 510
      GO TO 520
510   UNITS=CMSD
      IF (NVAR.EQ.4) UNITS=TM3
      GO TO 999
520   IF (UNIT1.EQ.UNIT2) GO TO 999
C ERROR
550   WRITE(IPR,892) VARTYP(NVAR),PESP(LP+3),PESP(LP+4),UNIT1,UNIT2
      GO TO 890
C
C NVAR=5 OR 6
C
600   IF (ITSCL1.EQ.INST .AND. ITSCL2.EQ.INST) GO TO 630
      WRITE(IPR,894) VARTYP(NVAR),PESP(LP+3),PESP(LP+4),ITSCL1,ITSCL2
      GO TO 890
630   IF (UNIT1.EQ.UNIT2) GO TO 999
      WRITE(IPR,892) VARTYP(NVAR),PESP(LP+3),PESP(LP+4),UNIT1,UNIT2
      GO TO 890
C
C
C ERRORS
C
890   IER=1
      CALL ERROR
892   FORMAT(1H0,10X,27H**ERROR** OUTPUT VARIABLE: ,A4,1X,2A4,
     * 9H IGNORED.,20H INCOMPATIBLE UNITS ,A4,5H AND ,A4)
894   FORMAT(1H0,10X,27H**ERROR** OUTPUT VARIABLE: ,A4,1X,2A4,
     * 9H IGNORED.,30H TIME SCALES MUST BE INST NOT ,A4,5H AND ,A4)
C
C RESET ERROR TRACES
C
999   IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
C
      RETURN
      END

C MODULE CKNM26
C
C DESC OP26 - CHECK FOR VALID CODES IN IF CLAUSE DECODING
C
      SUBROUTINE CKNM26(CNAME,LNAME,IETYPE,NEWPHR,IPHRAS,STRING,INAMST,
     .   IPOS,ISYMB,CLAUSE,LUSED,LEFTC,JUMP,LHCODE,IRC)
C
C  JTOSTROWSKI - HRL - MARCH 1983
C---------------------------------------------------------------
C
C..........................................................
C
      INCLUDE 'common/cmpv26'
      INCLUDE 'common/comn26'
      INCLUDE 'common/suin26'
C
      DIMENSION CNAME(1),STRING(1),CLAUSE(1),FACTOR(12),STYPE(3,17),
     . RTYPE(6),UTYPE(2),TLYPE(2),OPS(4),NTY(4)
      DIMENSION SCODE(17),RCODE(6),UCODE(2),OPCDE(4),TLCODE(2)
      DIMENSION LST(17),LRT(6),LUT(2),LNK(2),LOPS(4)
      DIMENSION ACODE(61),ATYPE(61),LENT(61),IBPOS(4),DIGIT(10),
     . IERCDE(4),NDIM(4),IRHTYP(2),ILHCD(7)
C
      EQUIVALENCE (ATYPE(1),STYPE(1,1)),(ATYPE(52),RTYPE(1)),
     . (ATYPE(58),UTYPE(1)),(ATYPE(60),TLYPE(1))
      EQUIVALENCE (LENT(1),LST(1)),(LENT(52),LRT(1)),(LENT(58),LUT(1)),
     . (LENT(60),LNK(1))
      EQUIVALENCE (ACODE(1),SCODE(1)),(ACODE(52),RCODE(1)),
     . (ACODE(58),UCODE(1)),(ACODE(60),TLCODE(1))
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_res/RCS/cknm26.f,v $
     . $',                                                             '
     .$Id: cknm26.f,v 1.4 1999/04/22 14:40:54 page Exp $
     . $' /
C    ===================================================================
C
C
      DATA STYPE/
     .   4HQO  ,4H    ,4H    ,4HQI  ,4H    ,4H    ,4HPOOL,4H    ,4H    ,
     .   4HSTOR,4HAGE ,4H    ,4HDAY ,4H    ,4H    ,4HQOM ,4H    ,4H    ,
     .   4HQIM ,4H    ,4H    ,                     4HFLOO,4HD   ,4H    ,
     .   4HSURC,4HHARG,4HE   ,4HFORE,4HCAST,4H    ,4HGOFL,4HASH ,4H    ,
     .   4HNFLO,4HOD  ,4H    ,4HNSUR,4HCHAR,4HGE  ,4HOBSE,4HRVED,4H    ,
     .   4HNGOF,4HLASH,4H    ,4HRISI,4HNG  ,4H    ,4HFALL,4HING ,4H    /
      DATA RTYPE/2HEQ,2HNE,2HLT,2HGE,2HLE,2HGT/
      DATA UTYPE/4HRULE,4HMAXQ/
      DATA IRHTYP/2,1/
      DATA TLYPE/4HAND ,4HOR  /
      DATA OPS/1H+,1H-,1H*,1H//
      DATA DOT/1H./
      DATA RPAREN/1H)/
      DATA DIGIT/1H0,1H1,1H2,1H3,1H4,1H5,1H6,1H7,1H8,1H9/
C
      DATA LST/1,1,1,2,1,1,1,2,3,2,2,2,3,2,2,2,2/
      DATA LRT/1,1,1,1,1,1/
      DATA LUT/1,1/
      DATA LNK/1,1/
      DATA LOPS/1,1,1,1/
      DATA NTY/17,6,2,2/
      DATA IERCDE/29,30,31,32/
      DATA IBPOS/1,52,58,60/
      DATA NDIM/3,1,1,1/
C
      DATA SCODE/501.01,502.01,503.01,504.01,505.01,506.01,507.01,551.01
     .,552.01,553.01,554.01,555.01,556.01,557.01,558.01,559.01,560.01/
      DATA RCODE/169.01,168.01,167.01,166.01,165.01,164.01/
      DATA UCODE/610.01,1570.01/
      DATA TLCODE/149.01,139.01/
      DATA OPCDE/1.01,2.01,3.01,4.01/
C
      DATA ILHCD/1,1,2,3,0,1,1/
C
      JUMP = 0
      IRC = 0
C
C  DETERMINE WHERE WE SHOULD GO TO ANALYZE SITUATION
C
      LOC = IBPOS(IETYPE)
      IPHRAS = NEWPHR
      NWORD = (LNAME-1)/4 + 1
      INAME = IKEY26(CNAME,NWORD,ATYPE(LOC),LENT(LOC),NTY(IETYPE),
     .               NDIM(IETYPE))
C
C  IF WE GOT HERE BECAUSE OF A '(', THEN IT'S A SPECIAL CASE AND IS TO B
C  TREATED AS ONE.
C
      IF (ISYMB.EQ.1) GO TO 4000
      IF (INAME.NE.0) GO TO 100
      IF (IETYPE.EQ.3) GO TO 3000
C
C  VALID NAME NOT FOUND, BUT ONE IS REQUIRED (IETYPE=3 IS A 'UCOMP'
C  SITUATION AND STRING CAN BE EITHER A VALID NAME, A USER DEFINED
C  NAME OR A REAL NUMBER)
C
      CALL STER26(IERCDE(IETYPE),INAMST)
      GO TO 9900
C
C  SEND CONTROL TO PROPER AREA
C
  100 CONTINUE
      GO TO (2000,1000,3000,1000), IETYPE
C
C  SIMPLE COMPARISONS FOR RELOP TYPES AND LINK TYPES
C
 1000 CONTINUE
C
C  NAME MATCHED, SO JUST STORE CODE
C
      CALL FLWK26(CLAUSE,LUSED,LEFTC,ACODE(LOC+INAME-1),504)
      GO TO 9999
C
C  TYPE IS SCOMP
C NAME MATCHED, SEE IF IT'S A 'COMP' OR A 'PLOG'
C
 2000 CONTINUE
      CALL FLWK26(CLAUSE,LUSED,LEFTC,ACODE(LOC+INAME-1),504)
C
C  SET LEFT-HAND SIDE OF RELATION CODE.
C
      LHCODE = ACODE(LOC+INAME-1)
C
C  IF 'COMP' FOUND, PHRASE IS STILL INC(3)
C
CC **EV CHANGE** BELOW USED TO BE .GT.5 BUT THEN MISSED QIM
      IF (INAME.GT.7) GO TO 9999
C
      IPHRAS = 3
      GO TO 9999
C
C  A 'UCOMP' TYPE WAS FOUND OR NEITHER A SCOMP, RELOP OR LINK TYPE FOUND
C
 3000 CONTINUE
      FACT = 0.01
      OP = 0.01
      LOPR = 0
C
C  IF NAME MATCHED A UCOMP, JUST STORE THE CODE
C
      IF (INAME.GT.0) GO TO 3900
C
C  WE FOUND NO VALID TYPE, CHECK FOR REAL NUMBER
C
      CALL UFIXED(STRING,VALUE,INAMST,IPOS-1,2,0,IERN)
      IF (IERN.EQ.0) GO TO 3010
C
C  NOT A REAL NUMBER, LOOK FOR DEFINED SET VARIABLE NAMES
C
      GO TO 3100
C
 3010 CONTINUE
C
C  CURRENT STRING IS A REAL NUMBER. IF THE SYMBOL THAT PASSED CONTROL
C  TO THIS SUBROUTINE WAS A '.' WE MAY HAVE SOME TRAILING DIGITS TO ADD
C  TO THE VALUE.  IF A '.' WAS FOUND, SCAN STRING UNTIL WE FIND A
C  NON-NUMERIC CHARACTER
C
      IF (ISYMB.NE.3) GO TO 3050
C
      ITPOS = IPOS
 3020 ITPOS = ITPOS+1
      DO 3030 J=1,10
      IF (IUSAME(STRING(ITPOS),DIGIT(J),1).EQ.0) GO TO 3030
      JUMP = JUMP+1
      GO TO 3020
 3030 CONTINUE
C
C  IF NO MOR NUMERIC CHARACTERS FOUND, WE HAVE THE FULL NUMBER. STORE IT
C  OTHERWISE GET REAL VALUE OF EXTENDED NUMERIC STRING
C
      ISAME = IUSAME(STRING(ITPOS),DOT,1)
      ISAME2 = IUSAME(STRING(ITPOS),RPAREN,1)
      IF (ISAME.EQ.1 .OR. ISAME2.EQ.1 .OR. JUMP.GT.0) ISYMB = 2
      IF (JUMP.EQ.0) GO TO 3050
      CALL UFIXED(STRING,VALUE,INAMST,ITPOS-1,2,0,IERN)
C
 3050 CONTINUE
C
C  STORE REAL NUMBER IN /CMPV26/ AS TYPE 1
C
      NUMCMP = NUMCMP+1
      IF (NUMCMP.LE.MAXCMP) GO TO 3060
      CALL STER26(502,1)
      GO TO 9900
C
 3060 CONTINUE
C
C  MUST DETERMINE THE PROPER CONVERSION FACTOR DEPENDING ON THE TYPE OF
C  COMPARISON BEING MADE (I.E. - WHETHER AGAINST POOL, OR DISCHARGE,
C  OR STORAGE, ETC.). THE LEFT HAND SIDE IS HELD AS LHCODE.
C
      CONV = CONVLT
      IF (LHCODE.EQ.503) CONV = CONVL
      IF (LHCODE.EQ.504) CONV = CONVST
      IF (LHCODE.EQ.505) CONV = 1.0
C
      ICTARY(NUMCMP) = 1
      CMPVAL(NUMCMP) = VALUE/CONV
      ICMPTY(NUMCMP) = ILHCD(LHCODE-500)
      CCODE = -(IOFF26(NUMCMP)+0.01)
      CALL FLWK26(CLAUSE,LUSED,LEFTC,CCODE,504)
      GO TO 9999
C
C  LOOK FOR SET VARIABLE
C
 3100 CONTINUE
C
C  MUST SCAN /CMPV26/ AND SEEK TYPE 2 (I.E. SET) COMPARISON VARIABLES
C  TO TRY AND MATCH WITH NAME PASSED TO THIS ROUTINE.
C
      IF (NUMCMP.EQ.0) GO TO 3200
      DO 3150 J=1,NUMCMP
      IF (ICTARY(J).NE.2) GO TO 3150
      IF (IUSAME(CNAME,CMNAME(1,J),NWORD).EQ.0) GO TO 3150
C
C  MUST CHECK TO SEE IF WE'VE USED THIS SET VARIABLE BEFORE.
C  IF WE HAVEN'T, THEN WE JUST SET THE COMPARISON TYPE BASED ON THE LEFT
C  -HAND SIDE.
C  IF NOT, THEN CHECK TO SEE THAT THIS COMPARISON IS CONSISTENT WITH
C  THE PREVIOUS COMPARISON.
C
      ICDLH = LHCODE - 500
      IF (ICMPTY(J).LT.0) GO TO 3110
      IF (ICMPTY(J).EQ.ILHCD(ICDLH)) GO TO 3120
C
C  INCONSISTENT COMPARISON
C
      CALL STER26(90,INAMST)
      GO TO 3120
C
C  NO PREVIOUS COMPARISONS MADE WITH THIS 'SET' VARIABLE. SET THE COMP
C  TYPE AND CONVERT VALUE TO METRIC.
C
 3110 CONTINUE
      ICMPTY(J) = ILHCD(ICDLH)
C
C  COMPUTE CONVERSION FACTOR AND CONVERT VALUE.
C
      CONV = CONVLT
      IF (LHCODE.EQ.503) CONV = CONVL
      IF (LHCODE.EQ.504) CONV = CONVST
      IF (LHCODE.EQ.505) CONV = 1.0
      CMPVAL(J) = CMPVAL(J)/CONV
C
 3120 CONTINUE
      CCODE = - (IOFF26(J)+0.01)
      CALL FLWK26(CLAUSE,LUSED,LEFTC,CCODE,504)
      GO TO 9999
 3150 CONTINUE
C
C  NOT A SET VARIABLE OR A REAL NUMBER. IF A SFUNC W/OUT AN OPERATOR
C  CONTROL HAS ALREADY BEEN SENT TO 3900
C
C  LOOK FOR AN OPERATOR IN EXISTING STRING
C
 3200 CONTINUE
      DO 3210 J=1,4
      CALL USCH26(OPS(J),STRING,INAMST,IPOS-1,ISC)
      IF (ISC.EQ.0) GO TO 3210
      LOPR = J
      OP = OPS(J)
      GO TO 3220
C
 3210 CONTINUE
      CALL STER26(31,INAMST)
      GO TO 9900
C
C  OPERATOR FOUND, GET STRING BEFORE OPERATOR TO SEE IF IT'S SFUNC
C
 3220 CONTINUE
      LSOP = ISC-INAMST
      NWDPOP = (LSOP-1)/4+1
      CALL UPACKN(LSOP,STRING(INAMST),NWDPOP,FACTOR,IERP)
      IF (IERP.EQ.0) GO TO 3230
      CALL STER26(20,INAMST)
      GO TO 9900
C
C  COMPARE AGAINST VALID SFUNC NAMES
C
 3230 CONTINUE
      INAME = IKEY26(FACTOR,NWDPOP,ATYPE(LOC),LENT(LOC),NTY(IETYPE),
     .               NDIM(IETYPE))
      IF (INAME.GT.0) GO TO 3240
      CALL STER26(33,INAMST)
      GO TO 9900
C
C NOW HAVE VALID SFUNC NAME & VALID OPERATOR, LOOK FOR FACTOR
C  FOLLOWING THE OOPERATOR
C
 3240 CONTINUE
      IF (ISC.LT.IPOS-1) GO TO 3250
      CALL STER26(4,ISC+1)
      GO TO 9900
C
C GET VALUE OF FACTOR FOLLOWING OPERATOR
C
 3250 CONTINUE
      CALL UFIXED(STRING,FACT,ISC+1,IPOS-1,2,0,IERN)
      IF (IERN.EQ.0) GO TO 3260
      CALL STER26(4,ISC+1)
      GO TO 9900
C
C NOW HAVE REAL NUMBER. IF PASSED CHARACTER WAS '.', LOOK FOR ANY
C  TRAILING DIGITS. ELSE JUST STORE IT IN /CMPV26/ AND CLAUSE
C
 3260 CONTINUE
      IF (ISYMB.NE.3) GO TO 3900
C
      ITPOS = IPOS
 3270 ITPOS = ITPOS+1
      DO 3280 J=1,10
      IF (IUSAME(STRING(ITPOS),DIGIT(J),1).EQ.0) GO TO 3280
      JUMP = JUMP+1
      GO TO 3270
 3280 CONTINUE
C
      ISAME = IUSAME(STRING(ITPOS),DOT,1)
      ISAME2 = IUSAME(STRING(ITPOS),RPAREN,1)
      IF (ISAME.EQ.1 .OR. ISAME2.EQ.1 .OR. JUMP.GT.0) ISYMB = 2
      IF (JUMP.EQ.0) GO TO 3290
      CALL UFIXED(STRING,FACT,ISC+1,ITPOS-1,2,0,IERN)
 3290 CONTINUE
C
C  STORE IN /CMPV26/ AS TYPE 3
C
 3900 CONTINUE
      CODEMQ=611.01
      NUMCMP = NUMCMP+1
      IF (NUMCMP.LE.MAXCMP) GO TO 3910
      CALL STER26(502,1)
      GO TO 9900
C
 3910 CONTINUE
C
C  MUST CHECK TO SEE IF COMPARISON IS COMPATIBLE (RULE MUST BE USED WITH
C   POOL, AND MAXQ MUST BE USED WITH DISCHARGES.)
C
      LHCD = ILHCD( LHCODE - 500 )
      IF (LHCD.EQ.IRHTYP(INAME)) GO TO 3920
      CALL STER26(90,INAMST)
C
C  IF FUNCTION IS MAXQ, SEE IF IT'S DEFINED AT THIS LEVEL.
C
 3920 CONTINUE
      IF (INAME.NE.2) GO TO 3950
      IF (NSUIN.EQ.0) GO TO 3940
C
      CODEMQ = UCODE(INAME) + 1.00
      DO 3930 J=1,NSUIN
      DIFF = ABS(DEFCDE(J)-CODEMQ)
      IF (DIFF.GT.0.05) GO TO 3930
      GO TO 3950
 3930 CONTINUE
 3940 CONTINUE
      CALL STER26(8,INAMST)
C
 3950 CONTINUE
C
C  SET CONVERSION FACTOR FOR THE 'FACTOR' IF OPERATOR IS '+' OR '-'
C
      CONV = CONVL
      IF (INAME.EQ.2) CONV = CONVLT
      IF (OP.EQ.OPS(3).OR.OP.EQ.OPS(4).OR.OP.EQ.0.01) CONV = 1.0
C
      ICTARY(NUMCMP) = 3
      CMNAME(1,NUMCMP) = CODEMQ
      IF (LOPR.GT.0) OP = OPCDE(LOPR)
      CMNAME(2,NUMCMP) = OP
      CMNAME(3,NUMCMP) = FACT/CONV
      CCODE = - (IOFF26(NUMCMP)+0.01)
      CALL FLWK26(CLAUSE,LUSED,LEFTC,CCODE,504)
      GO TO 9999
C
C--------------------------------------------------------------
C  THIS IS THE SPECIAL CASE WHERE WE'RE ON THE RIGHT HAND SIDE OF THE
C  A.GT.B TYPE RELATION AND THE CHARACTER THAT SENT CONTROL TO CKNM26
C  IS THE LEFT PARENTHESIS '('.
C
 4000 CONTINUE
C
C  RIGHT NOW, THE ONLY SYSTEM FUNCTION WITH MULTIPLE REFERENCES (HENCE,
C  THE '(' ) IS 'MAXQ'.
C
      IF (INAME.EQ.2) GO TO 4005
      CALL STER26(91,INAMST)
C
C  SCAN FOR RIGHT PARENTHESIS. THIS WILL GIVE US THE LOCS TO COMPUTE THE
C  LEVEL.
C
 4005 CONTINUE
      ITPOS = IPOS
      NDIG = 0
C
 4010 CONTINUE
      ITPOS = ITPOS + 1
      IF (IUSAME(STRING(ITPOS),RPAREN,1).EQ.1) GO TO 4040
C
C  HAVEN'T FOUND RT. PAREN YET. SEE IF CHAR IS DIGIT
C
      DO 4020 J=1,10
      IF (IUSAME(STRING(ITPOS),DIGIT(J),1).EQ.0) GO TO 4020
      NDIG = NDIG + 1
      GO TO 4010
 4020 CONTINUE
C
C  NOT A ')' OR A DIGIT
C
      CALL STER26(5,ITPOS)
      GO TO 4010
C
C  ')' WAS FOUND. GET THE VALUE OF THE NUMBER BETWEEN THE PARENS IF ALL
C   CHARS WERE DIGITS.
C
 4040 CONTINUE
      JUMP = JUMP + ITPOS - IPOS
      IF (NDIG.NE.ITPOS-IPOS-1) GO TO 4100
C
      CALL UFIXED(STRING,LEVEL,IPOS+1,ITPOS-1,1,0,IERF)
      LEVEL = LEVEL + 0.01
C
C  SEE IF 'MAXQ' WAS DEFINED AT THIS LEVEL
C
      CODEMQ = UCODE(INAME) +  LEVEL
      IF (NSUIN.EQ.0) GO TO 4060
      DO 4050 J=1,NSUIN
      DIFF = ABS(DEFCDE(J)-CODEMQ)
      IF (DIFF.GT.0.05) GO TO 4050
C
C  WE'VE FOUND THE PROPER DEFINITION
C
      GO TO 4100
C
 4050 CONTINUE
 4060 CONTINUE
C
C  DEFINITION NOT FOUND.
C
      CALL STER26(8,INAMST)
C
C  HAVE NAME AND LEVEL. NOW LOOK FOR ANY OPERATOR AND FACTOR.
C
 4100 CONTINUE
      OP = 0.01
      FACT = 0.01
      ITPOS = ITPOS + 1
      IOP = 0
C
      DO 4110 I=1,4
      IF (IUSAME(OPS(I),STRING(ITPOS),1).EQ.0) GO TO 4110
       IOP = I
      OP = OPS(I)
      JUMP = JUMP + 1
      GO TO 4200
 4110 CONTINUE
C
C  IF WE HAVE AN OPERATOR WE MUST LOOK FOR A FACTOR
C  IF NOT, JUST STORE INTO /CMPV26/
C
 4200 CONTINUE
      IF (IOP.EQ.0) GO TO 4500
C
C  NOW LOOK FOR NUMERIC FACTOR. SCAN FOR NON-NUMERIC CHARACTER PAST A
C  '.'. AT LEAST ONE DIGIT MUST HAVE BEEN ENTERED.
C
      ITST = ITPOS
      NDIG = 0
      NDOT = 0
C
 4210 CONTINUE
      ITPOS = ITPOS + 1
      JUMP = JUMP + 1
      DO 4220 J=1,10
      IF (IUSAME(STRING(ITPOS),DIGIT(J),1).EQ.0) GO TO 4220
      NDIG = NDIG + 1
      GO TO 4210
 4220 CONTINUE
C
C  SEE IF CHARACTER IS DOT ('.') ON THE FIRST PASS FOR DOTS.
C
      IF (NDOT.EQ.1) GO TO 4250
      IF (IUSAME(STRING(ITPOS),RPAREN,1).EQ.1) GO TO 4250
      IF (IUSAME(STRING(ITPOS),DOT,1).EQ.1) GO TO 4230
      CALL STER26(4,ITPOS)
      GO TO 4500
C
C  SEE IF AT LEAST ONE DIGIT HAS BEEN ENTERED.
C
 4230 CONTINUE
      IF (NDIG.GT.0) GO TO 4240
C
      CALL STER26(4,ITPOS)
      GO TO 4500
C
C  IF WE'VE FOUND A DOT AND IT'S THE FIRST DOT, LOOK FOR MORE NUMBERS
C  IF IT'S THE SECOND DOT, GET THE VALUE OF THE FACTOR.
C
 4240 CONTINUE
      IF (IUSAME(STRING(ITPOS),DOT,1).EQ.0.OR.NDOT.EQ.1) GO TO 4250
      NDOT = 1
      GO TO 4210
C
C  GET VALUE OF FACTOR.
C
 4250 CONTINUE
      CALL UFIXED(STRING,FACT,ITST+1,ITPOS-1,2,0,IERN)
      IF (IERN.EQ.0) GO TO 4500
      CALL STER26(4,ITST+1)
C
C  STORE THE CODES FOR THE FUNCTION, OPERATOR AND FACTOR.
C  SET THE CONVERSION FACTOR FOR THE 'FACTOR'.
C  SET THE LAST SYMBOL FOR PROPER PROCESSING IN MPAR26.
C  CHECK FOR COMPATIBILITY OF COMPARISON.
C
 4500 CONTINUE
      IF (IOP .NE. 0) JUMP = JUMP - 1
      SLAST = STRING(ITPOS)
      ISYMB = 3
      IF (IUSAME(SLAST,DOT,1).EQ.1 .OR. IUSAME(SLAST,RPAREN,1).EQ.1)
     .   ISYMB = 2
C
C  CHECK FOR COMPARISON COMPATIBILITY
C
      LHCD = ILHCD( LHCODE - 500 )
      IF (LHCD.EQ.IRHTYP(INAME)) GO TO 4510
      CALL STER26(91,INAMST)
C
 4510 CONTINUE
      CONV = CONVLT
      IF (OP.EQ.OPS(3).OR.OP.EQ.OPS(4).OR.OP.EQ.0.01) CONV = 1.0
C
      NUMCMP = NUMCMP + 1
      IF (NUMCMP .LE. MAXCMP) GO TO 4520
      CALL STER26(502,1)
      GO TO 9900
C
 4520 CONTINUE
      ICTARY(NUMCMP) = 3
      CMNAME(1,NUMCMP) = CODEMQ
      IF (IOP.GT.0) OP = OPCDE(IOP)
      CMNAME(2,NUMCMP) = OP
      CMNAME(3,NUMCMP) = FACT/CONV
      CCODE = - (IOFF26(NUMCMP)+0.01)
      CALL FLWK26(CLAUSE,LUSED,LEFTC,CCODE,504)
      GO TO 9999
C
C  SET ERROR CODE
C
 9900 CONTINUE
      IRC = 1
C
 9999 CONTINUE
      RETURN
      END

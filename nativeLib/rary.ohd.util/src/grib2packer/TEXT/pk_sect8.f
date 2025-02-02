      SUBROUTINE PK_SECT8(KFILDO,IPACK,ND5,LOCN,IPOS,L3264B,IER,
     1                    ISEVERE,*)
C
C        APRIL   2000   GLAHN   TDL   FOR GRIB2
C        JANUARY 2001   GLAHN   COMMENTS; STANDARDIZED RETURN
C
C        PURPOSE
C            PACKS SECTION 8, THE END SECTION, OF A GRIB2 MESSAGE.
C            IT CONSISTS OF '7777'.
C
C        DATA SET USE
C           KFILDO - UNIT NUMBER FOR OUTPUT (PRINT) FILE. (OUTPUT)
C
C        VARIABLES
C              KFILDO = UNIT NUMBER FOR OUTPUT (PRINT) FILE. (INPUT)
C            IPACK(J) = THE ARRAY THAT HOLDS THE ACTUAL PACKED MESSAGE
C                       (J=1,ND5). (INPUT/OUTPUT)
C                 ND5 = THE SIZE OF THE ARRAY IPACK( ). (INPUT)
C                LOCN = INDICATES THE WORD POSITION TO PUT '7777'.
C                       (INPUT/OUTPUT)
C                IPOS = INDICATES THE BIT POSITION IN LOCN TO PUT
C                       '7777'.  (INPUT/OUTPUT)
C              L3264B = THE INTEGER WORD LENGTH IN BITS OF THE MACHINE
C                       BEING USED. VALUES OF 32 AND 64 ARE
C                       ACCOMMODATED. (INPUT)
C                 IER = RETURN STATUS CODE. (OUTPUT)
C                         0 = GOOD RETURN.
C                       1-4 = ERRORS GENERATED BY THE PKBG ROUTINE. SEE
C                             THE DOCUMENTATION FOR THE PKBG ROUTINE.
C             ISEVERE = THE SEVERITY LEVEL OF THE ERROR.  THE ONLY
C                       VALUE RETUNED IS:
C                       2 = A FATAL ERROR  (OUTPUT)
C                   * = ALTERNATE RETURN WHEN IER NE 0.
C
C             LOCAL VARIABLES
C               C7777 = ASCII 7777.
C               I7777 = EQUIVALENCED TO C7777.
C              I7777S = I7777 IN RIGHT HALF OF WORD.  THIS IS
C                       NECESSARY WHEN L3264B = 64.
C
C        NON SYSTEM SUBROUTINES CALLED
C           PKBG
C
      CHARACTER*4 C7777
C
      DIMENSION IPACK(ND5)
C
      EQUIVALENCE (C7777,I7777)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/util/src/grib2packer/RCS/pk_sect8.f,v $
     . $',                                                             '
     .$Id: pk_sect8.f,v 1.1 2004/09/16 16:52:29 dsa Exp $
     . $' /
C    ===================================================================
C
C
      DATA C7777/'7777'/
C
      I7777S=I7777
C
C        ALL ERRORS GENERATED BY THIS ROUTINE ARE FATAL.
      ISEVERE=2
C
      IF(L3264B.EQ.64)I7777S=ISHFT(I7777,-32)
C        THE ABOVE STATEMENT MOVES THE ASCII 7777 TO THE RIGHT
C        HALF OF THE WORK WHEN L3264B = 64.  PKBG WILL NOT
C        OVERFLOW IPACK( ).
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,I7777S,32,L3264B,
     1          IER,*900)
C
C        ERROR RETURN SECTION
 900  IF(IER.NE.0)RETURN 1
C
      RETURN
      END

C MODULE UPRIMO_MAP
C  =====================================================================
C  pgm: UPRIMO_MAP .. Initialize unit numbers for program "map"
C
C  use:     CALL UPRIMO_MAP()
C  =====================================================================
      SUBROUTINE UPRIMO_MAP()

      INCLUDE 'common/ionum'

      CHARACTER*39  INSTMT,OTSTMT
      CHARACTER*1   FM
      INTEGER       JSYS
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/calb/src/map/RCS/uprimo_map.f,v $
     . $',                                                             '
     .$Id: uprimo_map.f,v 1.4 2002/02/11 16:50:17 dws Exp $
     . $' /
C    ===================================================================
C

      DATA  FM     / 'F' /
      DATA  INSTMT / ' *** Enter input filename, TTY or Q:  ' /
      DATA  OTSTMT / ' *** Enter output filename, TTY or Q: ' /

C  Set standard units

        CALL UPINIO()

C  Get filenames for input, output, punch unit numbers;
C  Open them on units 9, 6, 8 respectively

        IN  = 5
        IPR = 6

        CALL UPRIMR(INSTMT,FM,9,IN)
          IF( IN .LE. 0 ) GO TO 800
CCC        CALL UPRIMW(OTSTMT,FM,6,IPR)
        CALL UPRIMW(OTSTMT,FM,98,IPR)
          IF( IPR .LE. 0) GO TO 800
        IPU = IPR

C  Set other unit numbers that may be involved (i.e. for debug stmts)

        JSYS = 3
        CALL UPRIMI(IN,IPR,IPU,IPR,IPR,JSYS)
          GOTO 900

  800   CONTINUE
        CALL EXIT

  900   CONTINUE

      RETURN
      END

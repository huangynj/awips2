c  =====================================================================
c  pgm:  prbug (sname,itrace)
c
c   in: sname  .... name of input routine
c   in: itrace .... trace flag
c  =====================================================================
c
      subroutine prbug2 (sname,itrace)
c
c.......................................................................
c
c  routine prints trace output
c
c.......................................................................
c  Initially written by
c       Tim Sweeney, HRL                                    Mar 1997
c.......................................................................
c
      character*(*) sname
c
      include 'ffg_inc/iuws'
      include 'ffg_inc/gdebug'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ffg/src/ffg_util/RCS/prbug2.f,v $
     . $',                                                             '
     .$Id: prbug2.f,v 1.1 2004/01/30 17:51:30 scv Exp $
     . $' /
C    ===================================================================
C
c
ccc      write (iutw,10) sname
      if (igtrac.ge.itrace) write (iud,10) sname
10    format (' EXIT ',a )
c
      return
c
      end

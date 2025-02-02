C$PRAGMA C (post_first_plot_atom,CacheUhgMods,inituhglist)
C$PRAGMA C (savebuhg)
C MEMBER FDRIVE
C  (from old member FCFDRIVE)
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 07/06/95.14:57:19 BY $WC21DT
C
C @PROCESS LVL(77)
C
      SUBROUTINE FDRIVE (P,MP,C,MC,T,MT,TS,MTS,D,MD,IHZERO)
C.......................................
C     THIS IS THE FORECAST COMPONENT ROUTINE THAT EXECUTES THE
C        OPERATIONS TABLE FROM INTERNAL TIME IDA,IHR TO LDA,LHR.
C.......................................
C     ROUTINE INITIALLY WRITTEN BY. . .
C            ERIC ANDERSON - HRL     JULY 1979
C
C     COMMON BLOCKS MOD102, MOD126, MOD129, MOD135, MOD138, AND
C      FIGNOR ADDED AND INITIALIZED.
C             GEORGE F. SMITH - JUNE 1988
C
C     UPDATED TO ADD VARIABLE OPN(2) BEFORE CALLS TO MODS
C            GEORGE SMITH - HRL - SEPTEMBER 1988
C
C     INITIALIZE VARIABLE NDT19 IN COMMON BLOCK MOD119
C            DAVID TRAN - HRL - DECEMBER 1993
C
C     INITIALIZE VARIABLE NDT219 IN COMMON BLOCK MOD219
C            RUSS ERB - HRL - FEBRUARY 1997
C
C     CHANGED NAME OF RTN KILL TO KILLPM - DWS - SEP 1994
C     
C     Initialize LOCP for use by FFG - DP - 29 Jan. 1995
C
C     Incorporated changes for ifp_nwsrfs - DP - 29 Jan. 1995
C     Added code to post first_plot atom - dp - 3 Aug. 1995
C.......................................
      DIMENSION P(MP),C(MC),TS(MTS),D(MD),PU(MP)
      INTEGER T(MT)
      DIMENSION SNAME(2),OPN(2)
      character*8 opernames
C
C     COMMON BLOCKS.
      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU
      COMMON/WHERE/ISEG(2),IOPNUM,OPNAME(2)
      COMMON/FPROG/MAINUM,VERS,VDATE(2),PNAME(5),NDD
      COMMON/FCTIME/IDARUN,IHRRUN,LDARUN,LHRRUN,LDACPD,LHRCPD,NOW(5),
     1LOCAL,NOUTZ,NOUTDS,NLSTZ,IDA,IHR,LDA,LHR,IDADAT
      COMMON/FCARY/IFILLC,NCSTOR,ICDAY(20),ICHOUR(20)
      COMMON/ERRDAT/IOERR,NWARN,NERRS
      COMMON/FCOPPT/LOCT,LPM,LCO
      INCLUDE 'common/fcpuck'
      INCLUDE 'common/ffgctl'
      INCLUDE 'common/modscb'
      INCLUDE 'common/mod138'
      INCLUDE 'common/modrcs'
      COMMON /MODCTL/ IWHERE,IBTWEN,IAFTER
      COMMON /FSACCO/ NUMCOS,SACCOS(15,10)
      COMMON /FAPICO/ NAPICS,APICOS(12,10)
      COMMON /FRARSW/ NRARSW,RARESW(6,10)
      COMMON /FRAKSW/ NRAKSW,RAREKW(6,10)
      COMMON /FCHGRS/ NCHGRS,ICHGRS(5,20)
      COMMON/MOD119/NDT19,IOP19(2,20),JDT19(2,20),MFC19(20)
      COMMON/MOD219/NDT219,IOP219(2,20),JDT219(2,20),UADJ19(20)
      COMMON/MOD127/NTS27,TSID27(2,10),DTYP27(10),IDT27(10),
     1 ISTR27(10),NVAL27(10)
C
      COMMON/MOD102/NDT02,IDT02(5),VAL02(5)
      COMMON/MOD126/M126ON,MJ126,NVM126,VM126(744)
      LOGICAL M126ON
      COMMON/MOD129/NDT29,IDT29(5),VAL29(5)
      CHARACTER*8 OPN30
      REAL*4 KEY30
      COMMON/MOD130/NDT30,KEY30(10),OPN30(10),IDT30(10),LDT30(10)
      COMMON/MOD135/NDT35,IDT35(5),VAL35(5)
      PARAMETER (NROWS=907)
      COMMON/MOD151/RRC(NROWS,2)
      COMMON/FIGNOR/NIGNOR,IGNOPT(10),IGSDAT(10),IGEDAT(10)
      INCLUDE 'common/fcassm'
      INCLUDE 'common/moduhg'
      common/rcflag/ircflg,iqcqp,ibuble
      common/rctemp/nloop,rcname(2,10),iset,npoint,nptrc(10),
     *              qtemp(10,744,112),htemp(10,744,112),ncount
      common/sacco1/ opernames(10), UZTWC_1(10),UZFWC_1(10),LZTWC_1(10),
     1                LZFSC_1(10),LZFPC_1(10),ADIMC_1(10), fgco_1(10)
c
c  The following common added 7/19/91 to pass the return code from
c   the event loop in cex25.
c    Valid return codes are:    rerun           1
c                               next            2
c                               continue        3
c                               go_upstream     4
c                               quit            5
c                               quit_no_save    6
c
      Integer event_loop_exit_status
      Common /cex_exit_status/ event_loop_exit_status
      
      integer    iuhgd
      
      integer    idx
  
C
C  =================================== RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ifp/src/Changed/RCS/fcfdrive.f,v $
     . $',                                                             '
     .$Id: fcfdrive.f,v 1.16 2004/11/16 19:16:26 hank Exp $
     . $' /
C  =====================================================================
C
c
C
C     DATA STATEMENTS
      DATA IBUG,JBUG,KBUG/4HSEGX,4HPCT ,4HPRD /
      DATA LBUG/4HCPU /,PRDO/4HPRDO/
      DATA SP,SC,ST,SD/2HP ,2HC ,2HT ,2HD /
      DATA BLANK/4H    /
      DATA SNAME/4HFDRI,4HVE  /
     
C.......................................
C     TRACE LEVEL FOR THIS ROUTINE=1.
      IF (ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT (1H0,17H** FDRIVE ENTERED)
C..............5/4/04.........................
cav initialize valuess for UH and UHGCDATE
      iuhgd = 0
      idx = 0
  
c..........5/4/04 end AiV.....................
ckwz initialize the uhglist in setUhgMod.c
      call inituhglist()
      NDTUHG=0
      MDTUHG=20
      MVLUHG=100
ckwz
C     INITIAL VALUES
      INASSIM = 0
      LOCT=1
cew initialize the operation name array used to store
cew  carryover for the sacco mod interface
cew  must be initialized before each segment
      do 15 ii=1,10
	write(opernames(ii),*) ""
 15   continue

c  For ifp_nwsrfs version, set IFILLC to 0 so
c    carryover from the start of run can be displayed.

      IFILLC=0
c      IFILLC=1
      IERR=0
      IF (MAINUM.GT.1) NCSTOR=0
      IWHERE=1
      IBTWEN=0
      IAFTER=0
      NUMCOS=0
      NAPICS=0
      NRARSW=0
      NRAKSW=0
      NUMRC=0
      NDT19=0
      NDT219=0
      NDT30=0
cc Added for UHG enhancement.
cc be able to set start and enddate
cc in uhg AV 12/03/02      
      MDTUHG=20
      NDTUHG=0
      MVLUHG=100
      do  5 i=1,20
         UHGOPN = ' '
5     continue      
      
  
cc 106   
      NCHGRS=0
      NTS27=0
      DO 104 I=1,10
      TSID27(1,I)=BLANK
      TSID27(2,I)=BLANK
      DTYP27(I)=BLANK
      IDT27(I)=0
      ISTR27(I)=0
      NVAL27(I)=0
 104  CONTINUE
C
      NDT02=0
      M126ON=.FALSE.
      MJ126=0
      NVM126=0
      NDT29=0
      NDT35=0
      NDT38=0
      NIGNOR=0
C
      DO 101 I=1,5
      IDT02(I)=0
      VAL02(I)=0.0
      IDT29(I)=0
      VAL29(I)=0.0
      IDT35(I)=0
      VAL35(I)=0.0
  101 CONTINUE
      DO 102 I=1,10
      IGNOPT(I)=0
      IGSDAT(I)=0
      IGEDAT(I)=0
  102 CONTINUE
      DO 103 I=1,744
      VM126(I)=0.0
  103 CONTINUE
      DO 105 I=1,MXDT38
      IDT38(I)=0
      VAL38(I)=0.0
  105 CONTINUE
C
      iset=0
      ncount=0
      nloop=0
      do 222 i=1,10
         rcname(1,i)=4H    
         rcname(2,i)=4H    
  222 continue
      ircflg=0
      iqcqp=0
      ibuble=0
c
C     PERFORM MODS BEFORE OPERATIONS TABLE
C
      NUMOP=0
      OPNAME(1)=BLANK
      OPNAME(2)=BLANK
      OPN(1)=OPNAME(1)
      OPN(2)=OPNAME(2)
C   
cav store base uhg 
cc search for uhg change mod( NUMOP = 2 )
       LOCOPN = 0
       CALL FSERCH (2,OPNAME,LOCOPN,P,MP)
cav if UHG found save base uhg       
       if(LOCOPN.GT.0)then 
          idx = idx + 1        
          CALL savebuhg(P(LOCOPN),opname,idx) 
cav else search for uhg in the next index location                
       else
          LOCOPN = 1
  1       CALL FSERCH (2,OPNAME,LOCOPN,P,MP)  
cav  save base uhg               
          if(LOCOPN.GT.0) then
             idx = idx +1
             CALL savebuhg(P(LOCOPN),opname,idx)
             go to 1 
            
             end if
                       
       endif
       
C      IF (NCARDS.GT.0 .and. numop.ne.51) 
Clc    remove NCARDS .GT.0 check to allow  initialization of DHM mod variables
Clc    mods.f already handles case when NCARDS not GT 0
       IF (numop.ne.51)
     1         CALL MODS (NCARDS,MODCRD,MP,P,MC,C,MTS,TS,
     1          MT,T,MD,D,NUMOP,OPN,IHZERO,iuhgd)
     
C
C.......................................
C     CHECK FOR DEBUG OUTPUT.
      MBUG=IFBUG(PRDO)
      IF (IFBUG(JBUG).EQ.1) GO TO 96
   98 IF (IFBUG(KBUG).EQ.1) GO TO 97
      GO TO 99
   96 CALL FDMPA (SP,P,MP)
      CALL FDMPA (SC,C,MC)
      CALL FDMPT(ST,T,MT)
      GO TO 98
   97 CALL FDMPA (SD,D,MD)
C
C.......................................
C
C     INITIALIZE VALUE OF NPRVOP - NUMBER OF LAST OPERATION.
C
   99 NPRVOP=0
C.......................................
c
c     Post the first_plot atom - set to true
      ifirst = 1
      Call post_first_plot_atom(ifirst)
c ......................................
C
C     EXECUTE THE OPERATIONS TABLE.
C
C        FIND NUMBER OF NEXT OPERATION.
  100 NUMOP=T(LOCT)
C
C CHECK TO SEE IF FIRST OPERATION IS BEGASSIM
      IF (NUMOP.EQ.49) GOTO 185
C
C     CHECK FOR CPU TIME CHECK.
      IF (IFBUG(LBUG).EQ.0) GO TO 110
      CALL URTIMR(LAPSE,ICPUT)
      ELAPSE=LAPSE*0.01
      CPUT=ICPUT*0.01
      WRITE(IODBUG,903) ELAPSE,CPUT,NUMOP,IDA
  903 FORMAT (1H0,24HCPU CHECK--ELAPSED TIME=,F10.2,2X,11HTOTAL TIME=,
     1F10.2,2X,21HJUST BEFORE OPERATION,I4,2X,4HIDA=,I6)
C
C     CHECK FOR DEBUG PRINT OF D ARRAY
C     PRINT ONLY IF ('PRDO' SYSTEM DEBUG CODE IS ON) .AND.
C       (DEBUG IS ON FOR PREVIOUS OR NEXT OPERATION)
C     NOTE:  DO NOT PRINT BEFORE FIRST OPERATION IF D() JUST DUMPED ABOV
C
  110 IF (MBUG.EQ.0) GO TO 115
      IF (NPRVOP.EQ.0.AND.IFBUG(KBUG).EQ.1) GO TO 113
      IF (IDBALL.EQ.1) GO TO 112
      IF (NDEBUG.EQ.0) GO TO 113
C
      DO 111 I=1,NDEBUG
      IF (IDEBUG(I).EQ.NPRVOP.OR.IDEBUG(I).EQ.NUMOP) GO TO 112
  111 CONTINUE
      GO TO 113
C
  112 CALL FDMPA (SD,D,MD)
C
  113 NPRVOP=NUMOP
  115 CONTINUE
C
C     CHECK FOR STOP OPERATION.
      IF (NUMOP.EQ.-1) GO TO 195
C
      IF (NUMOP.EQ.4) GO TO 91
C
C     DETERMINE WHERE PARAMETERS ARE IN P ARRAY AND THE NAME
C        ASSIGNED TO THE OPERATION.
C      (SAVE LOCP FOR FFG PROCESSING)
      LPM=T(LOCT+2)
      LOCP=LPM
      LCO=0
      IOPNUM=NUMOP
      OPNAME(1)=P(LPM-5)
      OPNAME(2)=P(LPM-4)
      GO TO 90
C
C     SPECIAL OPERATIONS.
   91 LPM=0
      LCO=0
      IOPNUM=NUMOP
      OPNAME(1)=BLANK
      OPNAME(2)=BLANK
C
C
 90   OPN(1)=OPNAME(1)
      OPN(2)=OPNAME(2)
C
C     CHECK FOR DEBUG OUTPUT
      IF (IFBUG(IBUG).EQ.1) GO TO 95
      GO TO 92
   95 WRITE (IODBUG,902) ISEG,IOPNUM,OPN,LOCT,LPM,IFILLC
  902 FORMAT (1H0,22HDRIVER DEBUG--SEGMENT=,2A4,3X,14HOPERATION NUM=,
     1I3,3X,5HNAME=,2A4,5X,7HLOC.-T=,I5,3X,2HP=,I5,3X,7HIFILLC=,I1)
C.......................................
C     GO TO THE PROPER DRIVE ROUTINE FOR THE OPERATION.
   92 NERROR=NERRS
C
C     PERFORM MODS DURING OPERATIONS TABLE
C
      IWHERE=2
cc      IF (IBTWEN.EQ.1) CALL MODS (NCARDS,MODCRD,MP,P,MC,C,MTS,TS,
 
      

      
      IF (IBTWEN.EQ.1 .and. numop.ne.51)
     1          CALL MODS (NCARDS,MODCRD,MP,P,MC,C,MTS,TS,
cav     1          MT,T,MD,D,NUMOP,OPN,IHZERO,iuhgd)
c set flag for uhgcdate
     1          MT,T,MD,D,NUMOP,OPN,IHZERO,iuhgd)
C
C     CHECK FOR OPERATIONS THAT CAN USE WATER YEAR SCRATCH FILE.
      IF ((NUMOP.GE.16).AND.(NUMOP.LE.18)) GO TO 150
      IF (NUMOP.EQ.40) GO TO 150
      IF (NUMOP.EQ.47) GO TO 150
      IF (NUMOP.GT.19) GO TO 151

ckwz.uhgcdate
ccc NUMOP = 2 - UHG Mod
      if (NUMOP.EQ.2)
     1  CALL CacheUhgMods(P(LPM),MP,NDTUHG,JDTUHG,NVLUHG,UHGVAL,UHGOPN)
      CALL FDRIV1(P,MP,C,MC,T,MT,D,MD,IHZERO,NUMOP,IERR,iuhgd)
cckwz.UHGCDATE enhancement.
cckwz      CALL CacheUhgMods(P(LPM),MP,NDTUHG,JDTUHG,NVLUHG,UHGVAL, UHGOPN)
      GO TO 180
  151 IF (NUMOP.GT.40) GO TO 152
      CALL FDRIV2(P,MP,C,MC,T,MT,D,MD,IHZERO,NUMOP,IERR)
c
c  If 'Rerun' (1), 'Go Upstream' (4), or 'Quit_no_save'(6) was selected in
c   Run_NWSRFS 'Control' menu do not finish operations table - just
c   return to FAZE2. -- gfs, 7/23/91
c
      IF (IFBUG(IBUG).EQ.1) Write(*,473)event_loop_exit_status
 473  Format("in fdrive, after fdriv2, event_loop_exit_status=",i4)
c
      if((event_loop_exit_status .eq. 1) .or.
     1   (event_loop_exit_status .eq. 4) .or.
     2   (event_loop_exit_status .eq. 6)) go to 199
c
c  If 'Next', 'Continue', or 'Quit' was selected, we want
c   to finish processing the segment, including applying
c   any final Mods and writing output time series.
c      
      GO TO 180
  152 IF(NUMOP.EQ.51) THEN
      DO 106 J=1,2
         DO 107 K=1,NROWS
            RRC(K,J)=0.0
107      CONTINUE
106   CONTINUE
      RRC(7,1)=100.1
      RRC(7,2)=100.1
      RRC(1,1)=0.1
      RRC(1,2)=0.1
      RRC(2,1)=0.1
      RRC(2,2)=0.1
     
        CALL MODS (NCARDS,MODCRD,MP,P,MC,C,MTS,TS,
     1          MT,T,MD,D,NUMOP,OPN,IHZERO,iuhgd)

      ENDIF      
      CALL FDRIV3(P,MP,C,MC,T,MT,D,MD,TS,MTS,IHZERO,NUMOP,IERR)
      GO TO 180
  150 CALL FDRVWY(P,MP,C,MC,T,MT,D,MD,IHZERO,NUMOP,IERR)
      if((event_loop_exit_status .eq. 1) .or.
     1   (event_loop_exit_status .eq. 4) .or.
     2   (event_loop_exit_status .eq. 6)) go to 199
  180 IF (IERR.EQ.1) GO TO 190
      IF (NERRS.GT.NERROR) GO TO 195
C.......................................
C  SPECIAL CHECKS FOR A FLASH-FLOOD-GUIDANCE-ONLY RUN
C   IF CURRENT OPERATION IS THE FFG, CHECK TO SEE IF ANY MORE EXIST
C   IN SEGMENT.  IF NOT, KICK OUT OF SEGMENT
C
      IF (IFFG.NE.1 .OR. NUMOP.NE.32) GO TO 650
      CALL FSERCH (32,SNAME,LOCP,P,MP)
      IF (LOCP .EQ. 0) GO TO 195
C.......................................
C     INCREMENT TO THE NEXT OPERATION.
650   LOCT=T(LOCT+1)

C    IF ASSMRUN = 0 THEN SKIP BOTH ASSIMILATOR OPERATIONS
  185 NLOC = T(LOCT)
      IF (((NLOC.EQ.49).OR.(NLOC.EQ.50)).AND.(ASSMRUN.EQ.0))
     1 LOCT = T(LOCT + 1)

      NLOC = T(LOCT)
C    IF ASSMRUN > 0 AND WEVE REACHED BEGASSIM THEN
C    SKIP OVER ALL OPERATIONS UNTIL WE REACH OPERATION ASSIM.
C    SET INASSIM TO SHOW THAT WE ARE NOW IN THE ASSIMILATOR
C    PORTION OF THE OPERATIONS TABLE.
      IF (NLOC.EQ.49) THEN
         DO WHILE (NLOC.NE.50)
                LOCT = T(LOCT + 1)
                NLOC = T(LOCT)
         END DO
         INASSIM = 1
      END IF
C
      IF (LOCT.LE.MT) GO TO 100
      GO TO 195
C.......................................
C     OPERATION IS NOT INCLUDED IN FDRIVE.
  190 IOPNUM=0
      OPNAME(1)=SNAME(1)
      OPNAME(2)=SNAME(2)
      WRITE(IPR,901) NUMOP
  901 FORMAT(1H0,10X,'**FATAL ERROR** THE FDRIVE ROUTINE DOES NOT ',
     1  'CONTAIN A CALL TO OPERATION NUMBER.',I4,1H.)
      CALL KILLPM
C.......................................
C     END OF THE OPERATIONS TABLE.
C
C     PERFORM MODS AFTER OPERATIONS TABLE
C
  195 IWHERE=3
      NUMOP=0
      OPNAME(1)=BLANK
      OPNAME(2)=BLANK
      OPN(1)=OPNAME(1)
      OPN(2)=OPNAME(2)
C
cc      IF (IAFTER.EQ.1) CALL MODS (NCARDS,MODCRD,MP,P,MC,C,MTS,TS,
      IF (IAFTER.EQ.1 .and. numop.ne.51) 
     1          CALL MODS (NCARDS,MODCRD,MP,P,MC,C,MTS,TS,
     1          MT,T,MD,D,NUMOP,OPN,IHZERO,iuhgd)
C
C     CHECK FOR MORE DEBUG OUTPUT
      IF (IFBUG(JBUG).EQ.1) GO TO 196
  198 IF (IFBUG(KBUG).EQ.1) GO TO 197
      GO TO 199
  196 CALL FDMPA (SC,C,MC)
      GO TO 198
  197 CALL FDMPA (SD,D,MD)
C.......................................
  199 CONTINUE
      RETURN
      END

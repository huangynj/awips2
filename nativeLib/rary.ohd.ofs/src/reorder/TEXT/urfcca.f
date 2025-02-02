C MODULE URFCCA
C-----------------------------------------------------------------------
C
      SUBROUTINE URFCCA (MP,P,MT,T,MTS,TS,MC,C,KWOCRY,ISTAT)
C
C  ROUTINE TO COPY A SEGMENT FROM OLD TO NEW FILES.
C
C  THE SEGMENT HAS ALREADY BEEN READ BY ROUTINE FGETSG SO
C  THAT COMMON BLOCK FCSEGN AND THE P, T AND TS ARRAYS ARE DEFINED.
C  COMMON BLOCKS FCSGP2 AND FCCGD2 MUST BE UPDATED WHEN THE SEGMENT
C  IS ADDED TO THE NEW FILES.  ALSO, THE POINTERS IPREC AND IWOCRY
C  IN COMMON BLOCK FCSEGN MUST BE UPDATED TO APPLY TO THE NEW
C  FILES.  NOTE THAT THE OLD CARRYOVER POINTER IS PRESERVED IN
C  COMMON BLOCK URWOCX FOR USE IN ROUTINE URFCCB WHICH UPDATES
C  THE CARRYOVER FILES.
C
      CHARACTER*8 RTNNAM,OPNOLD
C
      DIMENSION P(MP),T(MT),TS(MTS),C(MC)
      DIMENSION INTBUF(5)
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/fccgd2'
      INCLUDE 'common/fcsegn'
      INCLUDE 'common/fcsgp2'
      INCLUDE 'common/fcunit'
      INCLUDE 'urcommon/urunts'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/reorder/RCS/urfcca.f,v $
     . $',                                                             '
     .$Id: urfcca.f,v 1.4 2002/02/11 21:14:51 dws Exp $
     . $' /
C    ===================================================================
C
C
      RTNNAM='FCRDPF'
C
      IF (ITRACE.GT.0) WRITE (IODBUG,*) 'ENTER ',RTNNAM
C
      IOPNUM=0
      CALL FSTWHR (RTNNAM,IOPNUM,OPNOLD,IOLDOP)
C
      IBUG=IFBUG('FCCA')
C
      ISTAT=0     
C
      IF (IBUG.GT.0) WRITE (IODBUG,'(1X,A,2A4)')
     *   'IN URFCCA - IDSEGN=',IDSEGN
C           
C  CHECK FOR ROOM IN FILE FCSEGSTS
      IF (NRSTS2.GT.MRSTS2) THEN
         WRITE (IPR,50)
         CALL SUERRS (IPR,2,-1)
         ISTAT=1
         GO TO 40
         ENDIF
C
C  CHECK FOR ROOM IN FILE FCPARAM
      NADRCP=(NP+NT+NTS+2+NWRP2-1)/NWRP2
      IF (NRP2+NADRCP.GT.MRP2) THEN
         WRITE (IPR,60) 'FCPARAM'
         CALL SUERRS (IPR,2,-1)
         ISTAT=1
         GO TO 40
         ENDIF
C
C  CHECK FOR SPACE ON CARRYOVER FILE
      MWPS=NWR2*NRSLO2
      IF (NWPS2+NC+10.GT.MWPS) THEN
         WRITE (IPR,60) 'FCCARRY'
         CALL SUERRS (IPR,2,-1)
         ISTAT=1
         GO TO 40
         ENDIF
C
C  WRITE TO NEW CARRYOVER GROUP DEFINITION FILE
      IWORD1=NWPS2+1
      NWPS2=NWPS2+NC+10
      IREC=1
      CALL UWRITT (LFCGD,IREC,NSLOT2,IERR)
C
C  CHECK IF SEGMENT HAS ANY OPERATIONS WITH CARRYOVER
      IF (NCOPS.EQ.0) GO TO 30
C
C  SAVE OLD VALUE OF IWOCRY AND CHANGE TO POINT TO NEW FILES
      KWOCRY=IWOCRY
      IWOCRY=IWORD1
      IF (IBUG.GT.0) WRITE (IODBUG,*) 'IN URFCCA - KWOCRY=',KWOCRY
C
C  WRITE TO NEW CARRYOVER FILE
      INTBUF(1)=IDSEGN(1)
      INTBUF(2)=IDSEGN(2)
      INTBUF(3)=0
      INTBUF(4)=0
      INTBUF(5)=NC
      NROFF=(IWORD1+NWR2-1)/NWR2
      IW11=MOD(IWORD1,NWR2)
      IF (IW11.EQ.0)IW11=NWR2
      IW21=IW11+4
      NEED2=0
      IF (IW21.LE.NWR2) GO TO 10
         NEED2=1
         IW21=NWR2
         NBUF2=IW21-IW11+2
         IW12=1
         IW22=5-NBUF2+1
10    DO 20 I=1,NSLOT2
         J=(I-1)*NRSLO2+NROFF
         ITEMP=KFCRY
         KFCRY=LFCRY
         CALL FCWTCF (J,IW11,IW21,INTBUF,0)
         KFCRY=ITEMP
         IF (NEED2.EQ.0) GO TO 20
            J=J+1
            ITEMP=KFCRY
            KFCRY=LFCRY
            CALL FCWTCF (J,IW12,IW22,INTBUF(NBUF2),0)
            KFCRY=ITEMP
20       CONTINUE
C
C  WRITE TO NEW SEGMENT POINTER FILE
30    NS2=NS2+1
      NRSTS2=NRSTS2+1
      NRP2=NRP2+NADRCP
      INTBUF(1)=IDSEGN(1)
      INTBUF(2)=IDSEGN(2)
      INTBUF(3)=NRSTS2
      CALL UWRITT (LFSGPT,NS2+2,INTBUF,IERR)
C 
C  SET RECORD NUMBER FOR PARAMETERS IN NEW PARAMETER FILE     
      IPREC=NRP2-NADRCP+1
C      
C  WRITE TO NEW SEGMENT STATUS FILE
      IRSEG2=NRSTS2
      CALL UWRITT (LFSGST,IRSEG2,IDSEGN,IERR)
C
C  WRITE TO NEW PARAMETER FILE
      ITEMP=KFPARM
      KFPARM=LFPARM
      IPREC=NRP2-NADRCP+1
      CALL FCWTPF (IPREC,IDSEGN,P,NP,T,NT,TS,NTS)
      KFPARM=ITEMP
      IF (IBUG.GT.0) THEN
         WRITE (IODBUG,*)
     *      'DUMP OF P, T AND TS ARRAYS AFTER FCRDPF:'
         CALL FDMPA ('P   ',P,MP)
         CALL FDMPT ('T   ',T,MT)
         CALL FDMPA ('TS  ',TS,MTS)
         ENDIF
C
40    CALL FSTWHR (OPNOLD,IOLDOP,OPNOLD,IOLDOP)
C
      IF (ITRACE.GT.0) WRITE (IODBUG,*) 'EXIT ',RTNNAM
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
50    FORMAT ('0*** ERROR - IN URFCCA - FILE FCSEGSTS IS FULL. ',
     *  'UNABLE TO WRITE SEGMENT.')
60    FORMAT ('0*** ERROR - IN URFCCA - NOT ENOUGH SPACE IN FILE ',
     *   A,' TO HOLD SEGMENT.')
C
      END

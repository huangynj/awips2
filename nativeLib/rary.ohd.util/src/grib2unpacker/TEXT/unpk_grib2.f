      SUBROUTINE UNPK_GRIB2(KFILDO,A,IA,ND2X3,IDAT,NIDAT,RDAT,NRDAT,
     1                      IS0,NS0,IS1,NS1,IS2,NS2,IS3,NS3,IS4,NS4,
     2                      IS5,NS5,IS6,NS6,IS7,NS7,IB,IBITMAP,IPACK,
     3                      ND5,XMISSP,XMISSS,NEW,ICLEAN,L3264B,
     4                      IENDPK,JER,NDJER,KJER)
C
C        
C        MARCH    1999   PEACHEY  ORIGINAL CODING
C        JANUARY  2001   GLAHN    COMMENTS; ELIMINATED  "EXISTS"
C                                 IN MOST CALLING ARGUMENTS;
C                                 ELIMINATED UNUSED ARRAY
C                                 AS2( ) AND VARIABLE "GRIB".
C        FEBRUARY 2001   LAWRENCE GSC/MDL   UPDATED THE PROLOGUE TO
C                                 MAKE IT MORE ACCURATE
C                                 AND INFORMATIVE.
C        NOVEMBER 2001   GLAHN    ADDED TRACE WHEN SECTION FORMAT
C                                 CAN NOT BE RECOGNIZED
C        JANUARY  2002   GLAHN    CHANGED IA(K)=INT(A(K)) TO NINT(A(K))
C        FEBRUARY 2002   GLAHN    MODIFIED RETURN FROM UNPK_SECT2
C
C        PURPOSE
C           THIS UTILITY DECODES A MESSAGE THAT WAS ORIGINALLY ENCODED
C           ACCORDING THE RULES AND STRUCTURE PUT FORTH IN THE GRIB
C           VERSION 2 (GRIB2) DOCUMENTATION.  GRIB2 IS A DATA
C           REPRESENTATION FORM FOR GENERAL REGULARLY DISTRIBUTED
C           INFORMATION IN BINARY.  IT PROVIDES A MEANS OF COMPRESSING
C           DATA SO AS TO MAKE ITS TRANSMISSION MORE EFFICIENT. IT IS 
C           RECOMMENDED THAT THE USER OF THIS ROUTINE REVIEW THE 
C           EXTERNAL DOCUMENTATION THAT EXPLAINS WHAT GRIB2 IS AND
C           HOW TO USE IT.  
C
C           THERE ARE EIGHT MANDATORY AND ONE OPTIONAL SECTIONS
C           CONTAINED WITHIN A GRIB2 MESSAGE.  THESE SECTIONS ARE
C
C              SECTION 0 - THE INDICATOR SECTION
C              SECTION 1 - THE IDENTIFICATION SECTION
C              SECTION 2 - THE LOCAL USE SECTION (OPTIONAL)
C              SECTION 3 - THE GRID DEFINITION SECTION
C              SECTION 4 - THE PRODUCT DEFINITION SECTION
C              SECTION 5 - THE DATA REPRESENTATION SECTION
C              SECTION 6 - THE BIT-MAP SECTION
C              SECTION 7 - THE DATA SECTION
C              SECTION 8 - THE END SECTION
C
C           SECTION 0, THE INDICATOR SECTION, CONTAINS GRIB2
C           DISCIPLINE, EDITION, AND MESSAGE LENGTH INFORMATION. 
C
C           SECTION 1, THE IDENTIFICATION SECTION, CONTAINS DATA 
C           THAT DESCRIBES CHARACTERISTICS THAT APPLY TO ALL OF THE
C           PROCESSED DATA IN THE GRIB2 MESSAGE.
C
C           SECTION 2, THE LOCAL USE SECTION, CONTAINS SUPPLEMENTAL 
C           INFORMATION FOR LOCAL USE BY THE ORIGINATING CENTERS.
C           THIS SECTION IS OPTIONAL; IT DOES NOT NEED TO BE INCLUDED
C           IN THE GRIB2 MESSAGE.
C
C           SECTION 3, THE GRID DEFINITION SECTION, DESCRIBES THE 
C           GEOMETRY OF THE VALUES WITHIN A PLANE DESCRIBED BY 
C           TWO FIXED COORDINATES.
C
C           SECTION 4, THE PRODUCT DEFINITION SECTION, PROVIDES A
C           DESCRIPTION OF THE DATA PACKED WITHIN SECTION 7. 
C
C           SECTION 5, THE DATA REPRESENTATION SECTION, DESCRIBES
C           WHAT METHOD IS USED TO COMPRESS THE DATA IN SECTION 7. 
C     
C           SECTION 6, THE BIT-MAP SECTION, CONTAINS A BIT-MAP WHICH
C           INDICATES THE PRESENCE OR ABSENCE OF DATA AT EACH GRID
C           POINT.  A BIT-MAP IS ONLY APPLICABLE TO THE SIMPLE 
C           AND COMPLEX PACKING METHODS.  A BIT-MAP DOES NOT
C           APPLY TO COMPLEX PACKING WITH SPATIAL DIFFERENCES.
C
C           SECTION 7, THE DATA SECTION, CONTAINS THE PACKED DATA
C           VALUES.
C
C           SECTION 8, THE END SECTION, CONTAINS THE STRING "7777"
C           INDICATING THE END OF THE GRIB2 MESSAGE.
C     
C           SECTIONS 3, 4, 5, AND 7 PROVIDE A VARIETY OF TEMPLATES 
C           THAT DESCRIBE AND DEFINE THE GRIDDED PRODUCT 
C           CONTAINED WITHIN THE GRIB2 MESSAGE.  THIS GRIB2 UNPACKER 
C           DOES NOT SUPPORT ALL OF THE TEMPLATES PROVIDED IN GRIB2.
C           THE MORE COMMONLY USED TEMPLATES ARE SUPPORTED, AND 
C           THIS SOFTWARE CAN BE EASILY EXTENDED IN THE FUTURE TO 
C           ACCOMMODATE ADDITIONAL TEMPLATES AS THE NEED ARISES. 
C
C           THE SECTION 3 GRID DEFINITION TEMPLATES CURRENTLY 
C           RECOGNIZED BY THIS UNPACKER ARE:
C              TEMPLATE 3.0   EQUIDISTANT CYLINDRICAL LATITUDE/
C                             LONGITUDE
C              TEMPLATE 3.10  MERCATOR
C              TEMPLATE 3.20  POLAR STEREOGRAPHIC
C              TEMPLATE 3.30  LAMBERT
C              TEMPLATE 3.90  ORTHOGRAPHIC SPACE VIEW
C              TEMPLATE 3.110 EQUATORIAL AZIMUTHAL EQUIDISTANT
C              TEMPLATE 3.120 AZIMUTH-RANGE (RADAR)
C
C           THE SECTION 4 PRODUCT DEFINITION TEMPLATES CURRENTLY
C           RECOGNIZED BY THIS UNPACKER ARE:
C              TEMPLATE 4.0  ANALYSIS OR FORECAST AT A LEVEL AND POINT
C              TEMPLATE 4.1  INDIVIDUAL ENSEMBLE
C              TEMPLATE 4.2  DERIVED FORECAST BASED ON ENSEMBLES
C              TEMPLATE 4.8  AVERAGE, ACCUMULATION, EXTREMES
C              TEMPLATE 4.20 RADAR
C              TEMPLATE 4.30 SATELLITE
C
C           THE SECTION 5 DATA REPRESENTATION TEMPLATES CURRENTLY 
C           RECOGNIZED BY THIS UNPACKER ARE:
C              TEMPLATE 5.0  SIMPLE PACKING
C              TEMPLATE 5.2  COMPLEX PACKING
C              TEMPLATE 5.3  COMPLEX PACKING AND SPATIAL DIFFERENCING 
C
C           THE SECTION 7 DATA TEMPLATES CURRENTLY RECOGNIZED BY THIS
C           UNPACKER ARE:
C              TEMPLATE 7.0  SIMPLE PACKING
C              TEMPLATE 7.2  COMPLEX PACKING
C              TEMPLATE 7.3  COMPLEX PACKING AND SPATIAL DIFFERENCING
C
C           THE REPRESENTATION OF MISSING VALUES IN THE DATA FIELD
C           PLAYS AN INTEGRAL ROLE IN HOW THE DATA ARE RETURNED TO
C           THE CALLER OF THIS ROUTINE.  THE PROCESSING OF PRIMARY
C           VALUES IS SUPPORTED WHEN DECODING A GRIB2 MESSAGE 
C           CREATED USING THE SIMPLE PACKING METHOD.  THE USER OF
C           THIS ROUTINE IS GIVEN THE OPTION TO HAVE THE DATA
C           FIELD RETURNED TO HIM WITH THE MISSING VALUES EMBEDDED
C           WITHIN IT OR TO HAVE THE DATA FIELD RETURNED TO HIM
C           WITHOUT THE MISSING VALUES IN IT.  IN THE LATTER CASE,
C           THIS ROUTINE WILL GENERATE A BIT-MAP INDICATING THE 
C           LOCATIONS OF THE MISSING VALUES IN THE DATA FIELD WITH
C           RESPECT TO THE VALID DATA POINTS.
C
C           THE EXISTENCE OF PRIMARY AND SECONDARY MISSING VALUES IS
C           PROVIDED FOR WHEN DECODING A GRIB2 MESSAGE CREATED USING
C           THE COMPLEX PACKING METHOD.  AS WITH THE SIMPLE PACKING
C           METHOD, INSTEAD OF RETURNING THE PRIMARY MISSING VALUES
C           EMBEDDED WITHIN THE DATA FIELD, A BIT-MAP MAY BE USED TO
C           INDICATE THE POSITIONS OF THE PRIMARY MISSING VALUES IN
C           RELATION TO THE VALID DATA POINTS.  HOWEVER, THE SECONDARY
C           MISSING VALUES, IF THEY EXIST, ARE ALWAYS RETURNED TO THE 
C           CALLER OF THIS ROUTINE EMBEDDED WITHIN THE DATA FIELD.
C
C           A GRIB2 MESSAGE MAY CONTAIN ONE OR MORE GRIDDED DATA
C           FIELDS.  WHEN UNPACKING MULTIPLE GRIDS FROM A GRIB2 MESSAGE
C           THE FIRST GRID MUST PROVIDE INFORMATION FOR SECTIONS 0 
C           THROUGH 7 (WITH, OF COURSE, SECTION 2 BEING OPTIONAL).
C           SUBSEQUENT GRIDS SHOULD NOT PROVIDE DATA FOR SECTIONS
C           0 AND 1.  THEY NEED ONLY PROVIDE DATA FOR SECTIONS 
C           2, 3, 4, 5, 6, 7, OR 3, 4, 5, 6, 7, OR 4, 5, 6, 7.
C           THE FINAL DATA GRID PACKED INTO THE GRIB2 MESSAGE 
C           MUST BE FOLLOWED BY A SECTION 8 INDICATING THE END
C           OF THE GRIB2 MESSAGE.  THIS ROUTINE MUST BE CALLED
C           ONCE FOR EACH GRID PACKED IN THE GRIB2 MESSAGE. THE
C           NEW AND IENDPK CALLING ARGUMENTS (SEE BELOW) ARE USED
C           WHEN UNPACKING GRIB2 MESSAGES CONTAINING MULTIPLE 
C           DATA GRIDS.
C
C           THE UNPACKED DATA GRID IS RETURNED IN ARRAY A( )
C           IF THE ORIGINAL PACKED FIELD CONSISTED OF FLOATING
C           POINT VALUES OR IN ARRAY IA( ) IF THE ORIGINAL PACKED
C           DATA FIELD CONTAINED INTEGER VALUES.  THE UNPACKED DATA
C           CORRESPONDING TO SECTIONS 0, 1 ,2 , 3, 4, 5, 6, AND 7 OF
C           THE GRIB2 MESSAGE IS RETURNED IN ARRAYS IS0( ), IS1( ),
C           IS2( ), IS3( ), IS4( ), IS5( ), IS6( ), AND IS7( ), 
C           RESPECTIVELY.  IF A BIT-MAP WAS PACKED INTO THE GRIB2
C           MESSAGE, THEN THE BIT-MAP WILL BE UNPACKED RETURNED IN
C           ARRAY IB( ).  EACH ELEMENT OF IB( ) WILL CORRESPOND TO
C           ONE DATA POINT IN THE DATA FIELD.  A VALUE OF "0" IN THE
C           BIT-MAP INDICATES A MISSING VALUE AT THE CORRESPONDING
C           POINT IN THE DATA GRID.  A VALUE OF "1" IN THE BIT-MAP 
C           INDICATES A VALID VALUE AT THE CORRESPONDING POINT IN 
C           THE DATA GRID.  AN IMPORTANT POINT TO REMEMBER IS THAT
C           WHEN A BIT-MAP IS RETURNED FROM THIS ROUTINE THE PRIMARY
C           MISSING VALUES WILL NOT BE INCLUDED IN THE DATA FIELD 
C           (UNLESS THE CALLER HAS SPECIFIED THAT THEY SHOULD BE BY
C           SETTING THE ICLEAN FLAG (SEE BELOW) TO "0".  THE CALLER 
C           OF THIS ROUTINE MUST USE THE BIT-MAP TO DETERMINE THE 
C           LOCATIONS OF MISSING DATA VALUES IN THE DATA FIELD. 
C
C           THIS GRIB2 DECODER CANNOT BE USED TO DECODE A MESSAGE
C           THAT WAS PACKED FOLLOWING THE ORIGINAL GRIB (GRIB 1)
C           FORMAT.  GRIB2 IS NOT BACKWARD COMPATIBLE WITH THE
C           ORIGINAL VERSION OF GRIB.
C
C           THERE ARE A NUMBER OF DIFFERENT ERROR CONDITIONS THAT
C           THAT CAN BE GENERATED WHILE UNPACKING A GRIB2 MESSAGE.
C           ERROR TRACKING IS HANDLED BY THE JER( , ) ARRAY (SEE BELOW).
C           EACH ROW OF THIS ARRAY CAN CONTAIN AN ERROR CODE FOLLOWED
C           BY ITS SEVERITY LEVEL.  THE SEVERITY LEVELS ARE
C           "0" FOR "OK", "1" FOR "WARNING", AND "2" FOR "FATAL". 
C           THE UNPACKER WILL IMMEDIATELY ABORT EXECUTION WHEN 
C           IT ENCOUNTERS A FATAL ERROR.  HOWEVER, EXECUTION IS NOT
C           IMPEDED BY A STATUS CODE OF "OK" OR "WARNING".  SEE THE
C           ARGUMENT LIST BELOW FOR A COMPLETE LIST OF THE ERROR 
C           CODES THAT CAN BE RETURNED BY THIS ROUTINE.
C
C        DATA SET USE
C           KFILDO - UNIT NUMBER FOR OUTPUT (PRINT) FILE.  (OUTPUT)
C
C        VARIABLES
C              KFILDO = UNIT NUMBER OF THE OUTPUT (PRINT) FILE.
C                       (INPUT)
C              A(IXY) = IF FLOATING POINT GRIDDED DATA ARE PACKED IN 
C                       THE GRIB2 MESSAGE, THEN THE UNPACKED DATA ARE
C                       RETURNED IN THIS ARRAY.  TO DETERMINE WHETHER 
C                       A FLOATING POINT DATA FIELD IS BEING RETURNED
C                       BY THIS UNPACKER, THE USER MUST CHECK THE 
C                       VALUE OF IS5(21).  IF IT IS "0", THEN THE
C                       DATA ARE FLOATING POINT.  IF IT IS "1", THEN
C                       THE DATA ARE INTEGER. (OUTPUT)
C             IA(IXY) = IF INTEGER GRIDDED DATA ARE PACKED IN THE
C                       GRIB2 MESSAGE, THEN THE UNPACKED DATA ARE
C                       RETURNED IN THIS ARRAY.  TO DETERMINE WHETHER
C                       AN INTEGER DATA FIELD IS BEING RETURNED
C                       BY THIS UNPACKER, THE USER MUST TEST THE
C                       VALUE CONTAINED WITHIN IS5(21).  IF IT IS
C                       "1", THEN THE DATA ARE INTEGER.  IF IT IS "0",
C                       THEN THE DATA ARE FLOATING POINT.  (OUTPUT)
C               ND2X3 = THE DIMENSION OF A( ), IA( ), AND IB( ). 
C                       (INPUT)
C             IDAT(J) = THE ARRAY CONTAINING THE LOCAL USE GROUPS
C                       CONSISTING OF INTEGER DATA UNPACKED FROM
C                       SECTION 2 (J=1,NIDAT).  (OUTPUT)
C               NIDAT = THE DIMENSION OF THE IDAT( ) ARRAY.  (INPUT)
C             RDAT(J) = THE ARRAY CONTAINING THE LOCAL USE GROUPS
C                       CONSISTING OF FLOATING POINT DATA UNPACKED
C                       FROM SECTION 2 (J=1,NRDAT).  (OUTPUT)
C               NRDAT = THE DIMENSION OF THE RDAT( ) ARRAY.  (INPUT)
C              IS0(L) = HOLDS THE VALUES FOR GRIB2 INDICATOR
C                       SECTION, SECTION 0 (L=1,NS0).  (OUTPUT)
C                 NS0 = SIZE OF IS0( ).  (INPUT)
C              IS1(L) = HOLDS THE VALUES FOR GRIB2 IDENTIFICATION
C                       SECTION, SECTION 1 (L=1,NS1).  (OUTPUT)
C                 NS1 = SIZE OF IS1( ).  (INPUT)
C              IS2(L) = HOLDS THE VALUES FOR GRIB2 LOCAL USE
C                       SECTION, SECTION 2 (L=1,NS2).  (OUTPUT)
C                 NS2 = SIZE OF IS2( ).  (INPUT)
C              IS3(L) = HOLDS THE VALUES FOR GRIB2 GRID DEFINITION
C                       SECTION, SECTION 3 (L=1,NS3).  (OUTPUT)
C                 NS3 = SIZE OF IS3( ).  (INPUT)
C              IS4(L) = HOLDS THE VALUES FOR GRIB2 PRODUCT DEFINITION
C                       SECTION, SECTION 4 (L=1,NS4).  (OUTPUT)
C                 NS4 = SIZE OF IS4( ).  (INPUT)
C              IS5(L) = HOLDS THE VALUES FOR GRIB2 DATA REPRESENTATION
C                       SECTION, SECTION 5 (L=1,NS5).  (OUTPUT)
C                 NS5 = SIZE OF IS5( ).  (INPUT)
C              IS6(L) = HOLDS THE VALUES FOR GRIB2 BIT MAP
C                       SECTION, SECTION 6 (L=1,NS6).  (OUTPUT)
C                 NS6 = SIZE OF IS5( ).  (INPUT)
C              IS7(L) = HOLDS THE VALUES FOR GRIB2 DATA
C                       SECTION, SECTION 7 (L=1,NS7).  (OUTPUT)
C                 NS7 = SIZE OF IS7( ).  (INPUT)
C             IB(IXY) = CAN CONTAIN A BIT-MAP REPRESENTING THE 
C                       LOCATIONS OF MISSING VALUES IN THE 
C                       DATA FIELD AS UNPACKED FROM SECTION
C                       6 OF THE GRIB2 MESSAGE.  A BIT-MAP CAN
C                       ONLY EXIST IN A MESSAGE WHOSE DATA FIELD
C                       WAS PACKED USING THE SIMPLE OR COMPLEX
C                       PACKING METHODS.  A BIT-MAP DOES NOT
C                       APPLY TO COMPLEX PACKING WITH SPATIAL
C                       DIFFERENCES. 
C
C                       UPON RETURNING FROM A CALL TO THIS ROUTINE,
C                       THE EXISTENCE OF A BIT-MAP IN SECTION 6
C                       OF THE GRIB2 MESSAGE IS INDICATED BY
C                       THE CALLING ARGUMENT IBITMAP (SEE BELOW).
C                       (OUTPUT)
C             IBITMAP = A FLAG INDICATING WHETHER OR NOT THERE 
C                       WAS A BIT-MAP IN SECTION 6 OF THE GRIB2
C                       MESSAGE.  A VALUE OF "0" INDICATES THAT
C                       THERE WAS NO BIT-MAP.  A VALUE OF "1" 
C                       INDICATES THAT THERE WAS A BIT-MAP PACKED
C                       IN THIS MESSAGE.  (OUTPUT)
C            IPACK(J) = THE ARRAY HOLDING THE PACKED GRIB2 MESSAGE
C                       (J=1,ND5).  (INPUT)
C                 ND5 = THE DIMENSION OF IPACK( ).  (INPUT)
C              XMISSP = PRIMARY MISSING VALUE INDICATOR.  THE 
C                       CALLER MUST SUPPLY THIS VALUE WHEN 
C                       UNPACKING A MESSAGE THAT WAS COMPRESSED
C                       USING THE SIMPLE PACKING METHOD IF HE 
C                       WANTS MISSING VALUES TO BE EMBEDDED
C                       IN THE RETURNED DATA FIELD.
C
C                       WHEN UNPACKING A MESSAGE THAT WAS 
C                       COMPRESSED USING THE COMPLEX PACKING METHOD
C                       (WITH OR WITHOUT SPATIAL DIFFERENCES), THE 
C                       PRIMARY MISSING VALUE WILL BE RETURNED FROM
C                       THIS ROUTINE THROUGH THIS CALLING ARGUMENT.
C                       THE CALLER OF THIS ROUTINE WILL NEED TO TEST
C                       THE VALUE OF IS5(23) TO DETERMINE THE 
C                       MISSING VALUE MANAGEMENT IN THE UNPACKED 
C                       GRIB2 MESSAGE.  IF IS5(23) HAS A VALUE OF
C                       "0", THEN THERE ARE NO MISSING VALUES
C                       IN THE DATA GRID, AND XMISSP DOES NOT 
C                       REPRESENT A PRIMARY MISSING VALUE.  IF
C                       IS5(23) HAS A VALUE OF "1" OR "2", THEN
C                       THE VALUE IN XMISSP REPRESENTS THE 
C                       PRIMARY MISSING VALUE IN THE DATA FIELD. 
C                       (INPUT/OUTPUT)
C              XMISSS = SECONDARY MISSING VALUE INDICATOR.  THIS
C                       CALLING ARGUMENT DOES NOT APPLY TO DATA 
C                       GRIDS THAT WERE PACKED USING THE SIMPLE 
C                       PACKING METHOD.  WHEN UNPACKING A GRID THAT
C                       WAS PACKED USING THE COMPLEX PACKING METHOD OR
C                       THE COMPLEX WITH SECOND ORDER SPATIAL
C                       DIFFERENCES METHOD, THE CALLER OF THIS ROUTINE
C                       WILL NEED TO TEST IS5(23) TO DETERMINE THE 
C                       MISSING VALUE MANAGEMENT IN THE UNPACKED GRIB2 
C                       DATA GRID.  IF IS5(23) HAS A VALUE OF "0" OR 
C                       "1", THEN THERE ARE NO SECONDARY MISSING 
C                       VALUES IN THE GRIDDED DATA AND XMISSS DOES NOT
C                       REPRESENT A SECONDARY MISSING VALUE.  IF 
C                       IS5(23) HAS A VALUE OF "2", THEN THE VALUE 
C                       CONTAINED WITHIN XMISSS REPRESENTS THE 
C                       SECONDARY MISSING VALUE OF THE DATA FIELD.
C                       (OUTPUT)
C                 NEW = A FLAG THAT INDICATES WHETHER OR NOT TO START
C                       UNPACKING AT THE BEGINNING OF THE GRIB2
C                       MESSAGE.  A VALUE OF "1" INDICATES THAT 
C                       UNPACKING SHOULD START AT THE BEGINNING OF THE
C                       GRIB2 MESSAGE.  A VALUE OF "0" INDICATES THAT
C                       UNPACKING SHOULD RESUME AFTER THE LAST GRID
C                       TO BE UNPACKED FROM THE GRIB2 MESSAGE.
C
C                       THIS FLAG IS USED WHEN UNPACKING GRIB2 MESSAGES
C                       CONTAINING MULTIPLE DATA GRIDS.  WHEN UNPACKING
C                       THE FIRST DATA GRID FROM THE MESSAGE, NEW
C                       SHOULD ALWAYS HAVE A VALUE OF "1".  WHEN
C                       UNPACKING SUBSEQUENT DATA FIELDS FROM THE
C                       MESSAGE, IT SHOULD HAVE A VALUE OF "0".  THIS
C                       ROUTINE MUST BE CALLED ONCE FOR EVERY DATA GRID 
C                       CONTAINED WITHIN THE MESSAGE.  AFTER A DATA
C                       GRID HAD BEEN UNPACKED FROM THE GRIB2 MESSAGE,
C                       THE IENDPK FLAG (SEE BELOW) INDICATES IF THERE
C                       ANY MORE GRIDS TO BE UNPACKED FROM THE
C                       DATA FIELD.  (INPUT)
C              ICLEAN = A FLAG THAT DETERMINES WHETHER OR NOT A DATA
C                       FIELD IS RETURNED WITH PRIMARY MISSING VALUES
C                       IN IT.  THIS FLAG ONLY APPLIES TO THE SIMPLE
C                       AND COMPLEX PACKING METHODS WHEN A BIT-MAP HAS
C                       BEEN PACKED INTO SECTION 6 OF THE GRIB2 
C                       MESSAGE.
C                       1 = THE DATA FIELD IS RETURNED WITHOUT ANY
C                           PRIMARY MISSING VALUES IN IT.  IT IS THE 
C                           RESPONSIBILITY OF THE USER TO USE THE
C                           BIT-MAP TO LOCATE PRIMARY MISSING VALUES.
C                       0 = THE DATA FIELD IS RETURNED WITH THE
C                           PRIMARY MISSING VALUES INSERTED IN IT. 
C                       THIS FLAG DOES NOT APPLY TO COMPLEX PACKING
C                       WITH SPATIAL DIFFERENCING.  ALSO, THIS FLAG
C                       DOES NOT AFFECT SECONDARY MISSING VALUES. 
C                       IF THEY EXIST, THEY ARE ALWAYS RETURNED IN THE
C                       DATA FIELD.  (INPUT)
C              L3264B = INTEGER WORD LENGTH OF MACHINE BEING USED.
C                       VALUES OF 32 AND 64 ARE ACCOMMODATED.  (INPUT)
C              IENDPK = INDICATES TO THE CALLING ROUTINE WHETHER OR NOT
C                       THERE ARE ADDITIONAL GRIDS TO BE PROCESSED
C                       IN THIS GRIB2 MESSAGE.
C                       0 = THIS IS NOT THE END OF THE GRIB2
C                           MESSAGE.  THERE ARE ADDITIONAL
C                           GRIDS TO PROCESS
C                       1 = THERE ARE NO MORE GRIDS TO PROCESS; THIS
C                           IS THE END OF THE GRIB2 MESSAGE.  OR,
C                           THERE HAS BEEN AN ERROR UNPACKING AND
C                           CONTINUING TO UNPACK WOULD BE FRUITLESS.
C                           (OUTPUT)
C            JER(J,K) = RETURN STATUS CODES AND SEVERITY LEVELS
C                       (J=1,NDJER)(K=1,2). VALUES CAN COME FROM
C                       SUBROUTINES; OTHERWISE: 0 = GOOD RETURN.
C                       (OUTPUT)
C               NDJER = THE MAXIMUM NUMBER OF ERROR CODES JER( , )
C                       MAY CONTAIN.  (INPUT)
C                KJER = THE ACTUAL NUMBER OF ERROR MESSAGES CONTAINED
C                       IN JER( , ).  (OUTPUT)
C
C        LOCAL VARIABLES
C               BOUST = .TRUE. IF THE DATA FIELD WAS SCANNED
C                       BOUSTROPHEDONICALLY. .FALSE. OTHERWISE.
C                       (LOGICAL)
C               C7777 = EQUIVALENCED TO I7777 FOR END OF MESSAGE
C                       TESTING.  (CHARACTER*4)
C              EXISTS = A FLAG USED TO INDICATE THE EXISTENCE OF 
C                       OF SECTION 2 AND SECTION 3 IN THE GRIB2
C                       MESSAGE.  (LOGICAL)  
C               I7777 = EQUIVALENCED TO C7777 FOR TESTING END OF
C                       MESSAGE.
C                 IER = ERROR RETURN.
C                        0 -- GOOD RETURN
C                      6-8 -- ERROR CODES RETURNED BY UNPKBG.
C              100,102,199 -- ERROR CODES RETURNED BY UNPK_SECT1.
C                9,202,299 -- ERROR CODES RETURNED BY UNPK_SECT2.
C      300,302,303,307,399 -- ERROR CODES RETURNED BY UNPK_SECT3. 
C                      300 -- THIS IS THE FIRST GRID IN THE MESSAGE
C                             AND THERE IS NO SECTION 3.
C              401,402,499 -- ERROR CODES RETURNED BY UNPK_SECT4.
C      501,502,508,509,599 -- ERROR CODES RETURNED BY UNPK_SECT5.
C      601,602,605,608,699 -- ERROR CODES RETURNED BY UNPK_SECT6. 
C          701,702,708,799 -- ERROR CODES RETURNED BY UNPK_SECT7.
C                      999 -- ERROR CODE RETURNED BY UNPK_TRACE.
C           1002,1010,1011 -- ERROR CODES RETURNED BY UNPK_SECT0.
C                LOCN = THE WORD POSITION FROM WHICH TO UNPACK THE
C                       NEXT VALUE. (INPUT/OUTPUT)
C                IPOS = THE BIT POSITION IN LOCN FROM WHICH TO START
C                       UNPACKING THE NEXT VALUE.  (INPUT/OUTPUT)
C              LBYPWD = BYTES PER WORD FOR EITHER A 32- OR 64-BIT
C                       MACHINE.
C               LOCNS = SAVES THE WORD WHERE A PACKED GRIB2 MESSAGE
C                       SECTION STARTS.
C               IPOSS = SAVES THE BIT POSITION WERE A PACKED GRIB2
C                       MESSAGE STARTS.
C               LSECT = CONTAINS THE LENGTH OF THE SECTION OF THE
C                       GRIB2 MESSAGE LAST UNPACKED.
C                   N = WORKING COPY OF L3264B.
C                  NX = THE NUMBER OF COLUMNS IN THE PRODUCT.
C                  NY = THE NUMBER OF ROWS IN THE PRODUCT.
C                 REF = THE FIELD REFERENCE VALUE AS UNPACKED IN 
C                       SECTION 5.  THIS VALUE IS USED TO UNPACK
C                       THE DATA FIELD IN SECTION 7.
C
C        NON SYSTEM SUBROUTINES CALLED
C           LOCPOS, UNPKBG, UNPK_REFER, UNPK_SECT0, UNPK_SECT1,
C           UNPK_SECT2, UNPK_SECT3, UNPK_SECT4, UNPK_SECT5,
C           UNPK_SECT6, UNPK_SECT7, UNPK_TRACE
C
      CHARACTER*4 C7777
C
      LOGICAL BOUST,EXISTS
C
      DIMENSION A(ND2X3),IA(ND2X3),IB(ND2X3)
      DIMENSION IDAT(NIDAT),RDAT(NRDAT)
C
      DIMENSION IPACK(ND5)
      DIMENSION IS0(NS0),IS1(NS1),IS2(NS2),IS3(NS3),IS4(NS4),IS5(NS5),
     1          IS6(NS6),IS7(NS7)
      DIMENSION JER(NDJER,2)
C
      EQUIVALENCE (C7777,I7777)
C
      DATA C7777/'7777'/
C
      SAVE LOCN,IPOS,NX,NY
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/util/src/grib2unpacker/RCS/unpk_grib2.f,v $
     . $',                                                             '
     .$Id: unpk_grib2.f,v 1.1 2004/09/16 16:51:50 dsa Exp $
     . $' /
C    ===================================================================
C
C
C        SET ERROR RETURN AND INITIALIZE VARIABLES.
      IER=0
C
C        LBYPWD IS THE NUMBER OF BYTES PER WORD.
      LBYPWD=L3264B/8
C
C        THIS ASSIGNMENT IS MADE MAINLY TO KEEP MOST CALLS TO UNPKBG
C        TO ONE LINE.
      N=L3264B
C
C        ZERO OUT THE ERROR-HANDLING ARRAY.
C
      DO K=1,NDJER
         JER(K,1)=0
         JER(K,2)=0
      ENDDO
C
      KJER=0
C
C        ****************************************
C
C        UNPACK SECTION 0, THE INDICATOR SECTION
C
C        ****************************************
C
C        ATTEMPT TO UNPACK SECTIONS 0 AND 1 ONLY IF THIS IS THE FIRST 
C        GRID IN THE GRIB2 MESSAGE.
      IF(NEW.EQ.1)THEN
         LOCN=1
         IPOS=1
C
C           CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C           VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C           A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
         CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,0,0)
         CALL UNPK_SECT0(KFILDO,IPACK,ND5,IS0,NS0,N,LOCN,IPOS,IER,
     1                   ISEVERE,*900)
C
         LSECT=NS0
C
C        *************************************
C
C        UNPACK SECTION 1, IDENTIFICATION.
C
C        *************************************
C
C           SAVE LOCN AND IPOS.
C
         LOCNS=LOCN
         IPOSS=IPOS
C
C           CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C           VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C           A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
         CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,100,0)
         CALL UNPK_SECT1(KFILDO,IPACK,ND5,IS1,NS1,N,LOCN,IPOS,
     1                   IER,ISEVERE,*900)
         LSECT=IS1(1)
C
C           CALCULATE START OF SECTION 2 AND SAVE LOCN AND IPOS.
C           THIS IS DONE IN CASE THERE WAS ACTUALLY MORE DATA
C           IN THE PREVIOUS SECTION THAN WE UNPACKED.
C
         CALL LOCPOS(KFILDO,LOCNS,IPOSS,LSECT,LBYPWD,LOCN,IPOS)
      ENDIF
C
      LOCNS=LOCN
      IPOSS=IPOS
C
C        *************************************
C
C        UNPACK SECTION 2, THE LOCAL USE
C        SECTION, IF IT IS PRESENT.
C
C        *************************************
C
C        CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C        VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C        A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
      CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,200,0)
      CALL UNPK_SECT2(KFILDO,IPACK,ND5,IS2,NS2,RDAT,NRDAT,IDAT,NIDAT,
     1                N,LOCN,IPOS,EXISTS,IER,ISEVERE,*900)
C
      IF(EXISTS)THEN
         LSECT=IS2(1)
C
C           CALCULATE THE START OF THE NEXT SECTION AND SAVE LOCN
C           AND IPOS. THIS IS DONE IN CASE THERE WAS ACTUALLY MORE
C           DATA IN THE PREVIOUS SECTION THAN WE UNPACKED.
         CALL LOCPOS(KFILDO,LOCNS,IPOSS,LSECT,LBYPWD,LOCN,IPOS)
         LOCNS=LOCN
         IPOSS=IPOS
C
         IF(IER.NE.0)THEN
C              SECTION 2 NOT OF RECOGNIZABLE FILE FORMAT.  THIS IS
C              NOT TREATED AS A FATAL ERROR; SECTION 2 IS SKIPPED.
            CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,IER,1)
         ENDIF
C
      ENDIF
C
C        *************************************
C
C        UNPACK SECTION 3, GRID DEFINITION.
C
C        *************************************
C
C        CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C        VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C        A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
      CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,300,0)
      CALL UNPK_SECT3(KFILDO,IPACK,ND5,IS3,NS3,N,LOCN,IPOS,
     1               NX,NY,EXISTS,BOUST,IER,ISEVERE,*900)
C
      IF(.NOT.EXISTS)THEN
         IF(NEW.EQ.1)THEN
C
C              THERE MUST BE A SECTION 3 FOR A NEW PRODUCT.
C              ISEVERE = 2 IS RETURNED FROM UNPK_SECT3 EVEN WITH A
C              NORMAL RETURN.
            IER=300
            GO TO 900
         ENDIF
      ELSE
         LSECT=IS3(1)
C
C           CALCULATE THE START OF THE NEXT SECTION AND SAVE LOCN
C           AND IPOS. THIS IS DONE IN CASE THERE WAS ACTUALLY MORE
C           DATA IN THE PREVIOUS SECTION THAN WE UNPACKED.
         CALL LOCPOS(KFILDO,LOCNS,IPOSS,LSECT,LBYPWD,LOCN,IPOS)
         LOCNS=LOCN
         IPOSS=IPOS
      ENDIF
C
C        *************************************
C
C        UNPACK SECTION 4, PRODUCT DEFINITION.
C
C        *************************************
C
C        CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C        VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C        A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
      CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,400,0)
      CALL UNPK_SECT4(KFILDO,IPACK,ND5,IS4,NS4,N,
     1                LOCN,IPOS,IER,ISEVERE,*900)
      LSECT=IS4(1)
C
C        *************************************
C
C        UNPACK SECTION 5, DATA DEFINITION.
C
C        *************************************
C
C        CALCULATE START OF SECTION 5 AND SAVE LOCN AND IPOS.
C        THIS IS DONE IN CASE THERE WAS ACTUALLY MORE DATA
C        IN THE PREVIOUS SECTION THAN WE UNPACKED.
C
      CALL LOCPOS(KFILDO,LOCNS,IPOSS,LSECT,LBYPWD,LOCN,IPOS)
      LOCNS=LOCN
      IPOSS=IPOS
C
C        CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C        VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C        A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
      CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,500,0)
      CALL UNPK_SECT5(KFILDO,IPACK,ND5,IS5,NS5,N,LOCN,IPOS,
     1                REF,XMISSP,XMISSS,IER,ISEVERE,*900)
      LSECT=IS5(1)
C
C        *************************************************
C
C        UNPACK SECTION 6, BIT MAP.
C
C        ************************************************
C
C        CALCULATE START OF SECTION 6 AND SAVE LOCN AND IPOS.
C        THIS IS DONE IN CASE THERE WAS ACTUALLY MORE DATA
C        IN THE PREVIOUS SECTION THAN WE UNPACKED.
C
      CALL LOCPOS(KFILDO,LOCNS,IPOSS,LSECT,LBYPWD,LOCN,IPOS)
      LOCNS=LOCN
      IPOSS=IPOS
C
C
C        CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C        VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C        A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
      CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,600,0)
      CALL UNPK_SECT6(KFILDO,IPACK,ND5,IS6,NS6,IB,ND2X3,NX,NY,N,
     1                LOCN,IPOS,IBITMAP,IER,ISEVERE,*900)
      LSECT=IS6(1)
C
C        *************************************
C
C        CALL UNPK_REFER TO DETERMINE HOW THE
C        DATA WAS ORIGINALLY PACKED. THIS ROUTINE
C        ALSO DETERMINES WHETHER THE USER WANTS
C        MISSING VALUES IN THE UNPACKED DATA FIELD TO
C        BE REPRESENTED BY A BIT-MAP OR BY ACTUALLY
C        HAVING THE MISSING VALUES EMBEDDED IN THE 
C        DATA FIELD.
C
C        *************************************
C
      CALL UNPK_REFER(IS5,NS5,ICLEAN,IUNPKOPT,IER,ISEVERE,*900)
C
C        *************************************
C
C        UNPACK SECTION 7, BINARY DATA.
C
C        *************************************
C
C        CALCULATE START OF SECTION AND SAVE LOCN AND IPOS.
C        THIS IS DONE IN CASE THERE WAS ACTUALLY MORE DATA
C        IN THE PREVIOUS SECTION THAN WE UNPACKED.
C
      CALL LOCPOS(KFILDO,LOCNS,IPOSS,LSECT,LBYPWD,LOCN,IPOS)
      LOCNS=LOCN
      IPOSS=IPOS
C
C        CALL UNPK_TRACE TO ADD THE SECTION NUMBER AS THE "ERROR"
C        VALUE WITH A SEVERITY OF 0 TO AID IN DIAGNOSING WHERE
C        A FATAL ERROR OCCURRED WITH PROGRAM TERMINATION.
      CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,700,0)
      CALL UNPK_SECT7(KFILDO,A,ND2X3,NX,NY,IUNPKOPT,IPACK,REF,ND5,
     1                IS5,NS5,IS7,NS7,IBITMAP,IB,XMISSP,XMISSS,BOUST,
     2                N,LOCN,IPOS,IER,ISEVERE,*900)
      LSECT=IS7(1)
C
C        *************************************
C
C        UNPACK SECTION 8, END OF RECORD.
C        IT STARTS ON A BYTE.
C
C        *************************************
C
C        CALCULATE START OF SECTION.
C
      CALL LOCPOS(KFILDO,LOCNS,IPOSS,LSECT,LBYPWD,LOCN,IPOS)
      LOCNS=LOCN
      IPOSS=IPOS
      CALL UNPKBG(KFILDO,IPACK,ND5,LOCN,IPOS,NVALUE,32,N,IER,*900)
      IF(L3264B.EQ.64)NVALUE=ISHFT(NVALUE,32)
C        THE ABOVE STATEMENT IS TO ACCOMMODATE THE 64-BIT WORD, BY
C        MOVING THE 4 CHARACTERS TO THE LEFT HALF OF THE WORD FOR 
C        TESTING WITH I7777.
C
      IF(NVALUE.EQ.I7777)THEN
         IENDPK=1
      ELSE
         IENDPK=0
      ENDIF
C
C        THIS RETAINS INTERNALLY FOR THE NEXT ENTRY THE LOCATION
C        OF THE END OF MESSAGE OR THE START OF THE NEXT MESSAGE.
C        IF THE USER WERE TO MISTAKENLY ENTER AGAIN, THE END
C        OF MESSAGE WOULD BE UNEXPECTEDLY FOUND.
      LOCN=LOCN-1
C
C        IS THE USER EXPECTING AN INTEGER DATA FIELD?
      IF(IS5(21).EQ.1)THEN
         DO K=1,NX*NY
            IA(K)=NINT(A(K))
         ENDDO
      ENDIF
C 
      RETURN
C
C        ERROR RETURN SECTION.
C
 900  IENDPK=1
C
      CALL UNPK_TRACE(KFILDO,JER,NDJER,KJER,IER,ISEVERE)
      RETURN
      END

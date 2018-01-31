       IDENTIFICATION DIVISION.
       PROGRAM-ID. MVPRGU.
       AUTHOR. MICHAEL VALDRON.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.
       	
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       	
       COPY 'MVMAP2'.
       COPY DFHBMSCA.
       
       01 WS-STUD-NUM                       PIC X(7).
       
      * Transfer fields 
       01 WS-TRANSFER-FIELD                 PIC XXX.
       01 WS-TRANSFER-LENGTH                PIC S9(4) COMP VALUE 3.
       
       01 WS-SAVEAREA.       
            05 WS-PROGRAM-SWITCH            PIC X.
            05 SAVE-NUM                     PIC X(7).
            05 SAVE-COURSE1                 PIC X(8).
            05 SAVE-COURSE2                 PIC X(8).
            05 SAVE-COURSE3                 PIC X(8).
            05 SAVE-COURSE4                 PIC X(8).
            05 SAVE-COURSE5                 PIC X(8).
            05 SAVE-NAME                    PIC X(20).
            05 SAVE-ADDR-LINE1              PIC X(20).
            05 SAVE-ADDR-LINE2              PIC X(20).
            05 SAVE-ADDR-LINE3              PIC X(20).
            05 SAVE-POSTAL                  PIC X(6).
            05 SAVE-PHONE                   PIC X(10).
            
       01 WS-SAVEAREA-LENGTH                PIC S9(4) COMP VALUE 144.
       
       01 WS-CC-TRANSFER-FIELD.
           05 WS-CC-COURSE-CODE.
               10 WS-CC-COURSE-CODE-PART1   PIC X(4).
               10 WS-CC-COURSE-CODE-PART2   PIC X(4).
           05 WS-CC-COURSE-DESC             PIC X(17).
       01 WS-CC-TRANSFER-LENGTH             PIC S9(4) COMP VALUE 25.
            
       01 STUFILE-LENGTH                    PIC S9(4) COMP VALUE 150.
       
      * Counter for the number for course codes that have been found
      * empty.
       01   WS-EMPTY-CC-COUNT               PIC 99 VALUE 0.
       01   WS-NAME-CHAR-COUNT              PIC 99 VALUE 0.
       
       01  STUFILE-RECORD.
           05  STUFILE-KEY.
               10  STUFILE-PREFIX           PIC XXX VALUE 'MJV'.
               10  STUFILE-STUDENT-NO       PIC X(7).
           05  STUFILE-NAME                 PIC X(20).
           05  STUFILE-COURSES.
               10  STUFILE-COURSE1.    
                   15 STUFILE-COURSE1-PART1 PIC X(4).
                   15 STUFILE-COURSE1-PART2 PIC X(4).
               10  STUFILE-COURSE2. 
                   15 STUFILE-COURSE2-PART1 PIC X(4).
                   15 STUFILE-COURSE2-PART2 PIC X(4).               
               10  STUFILE-COURSE3.        
                   15 STUFILE-COURSE3-PART1 PIC X(4).
                   15 STUFILE-COURSE3-PART2 PIC X(4).
               10  STUFILE-COURSE4.
                   15 STUFILE-COURSE4-PART1 PIC X(4).
                   15 STUFILE-COURSE4-PART2 PIC X(4).               
               10  STUFILE-COURSE5.
                   15 STUFILE-COURSE5-PART1 PIC X(4).
                   15 STUFILE-COURSE5-PART2 PIC X(4).               

           05  STUFILE-ADDR-LINE1           PIC X(20).
           05  STUFILE-ADDR-LINE2           PIC X(20).
           05  STUFILE-ADDR-LINE3           PIC X(20).
           
           05  STUFILE-POSTAL.
               10  STUFILE-POSTAL-1         PIC XXX.
               10  STUFILE-POSTAL-2         PIC XXX.
           
           05  STUFILE-PHONE.
               10  STUFILE-AREA-CODE        PIC XXX.
               10  STUFILE-EXCHANGE         PIC XXX.
               10  STUFILE-PHONE-NUM        PIC XXXX.
           
           05  FILLER                       PIC X(11) VALUE SPACES.
        
       01  COURSES-ARRAY.                    
           05  COURSES-VALUE                OCCURS 5.
               10  COURSES-PART-1           PIC X(4).
               10  COURSES-PART-2           PIC X(4).
           05  COURSES-LENGTH               PIC 9 OCCURS 5.
           05  COURSES-SUB                  PIC 9.
           
       01  COURSES-CHECK-SUB                PIC 9.
       
       01  NAME-SUB                         PIC 99.
       
       01  ERROR-MESSAGE.
           05  MESSAGE-VALUE                PIC X(34).
           05  COURSES-NUMBER               PIC X.
           
      * Constant that holds the error message that displays when a 
      * user makes an error in the postal code.
      * (Made this for my own reason, not a lab requirement)    
       01   WS-POSTAL-CODE-ERROR-CONST      PIC X(38) 
                VALUE 'ENTER A POSTAL CODE (EXAMPLE: L1L 1L1)'.
       01   WS-NOT-FOUND-CONST              PIC X(16) 
                VALUE 'COURSE NOT FOUND'.
                
       LINKAGE SECTION.
       
       01 DFHCOMMAREA.
           05 LK-SAVE                       PIC X(144).
       
       PROCEDURE DIVISION.
       000-START-LOGIC.
            
            EXEC CICS HANDLE AID PF3(750-RETURN)
                                 PF6(960-DELETE-RECORD)
                                 PF9(700-EXIT-PROG)
            
            END-EXEC.
            
       		EXEC CICS HANDLE CONDITION MAPFAIL(100-FIRST-TIME) 
                          NOTFND(999-SEND-ERROR-NO-RECORD-MSG)
            END-EXEC.
            
            IF EIBCALEN = 3
            
                GO TO 100-FIRST-TIME
                
            ELSE IF EIBCALEN = 7
            
                MOVE LK-SAVE(1:7) TO STUFILE-STUDENT-NO
                MOVE STUFILE-STUDENT-NO TO STUNUMO
                GO TO 500-READ-REC
            
            END-IF.

         	EXEC CICS RECEIVE MAP('IAEMAP') MAPSET('MVMAP2') 
            
            END-EXEC.

       		GO TO 200-MAIN-LOGIC.

       100-FIRST-TIME.

       		MOVE LOW-VALUES TO IAEMAPO.
            
            PERFORM 650-MOVE-ATTRIBUTES-I.
            
            MOVE 'F6 - DELETE RECORD' TO UPTILEO.

            MOVE 'ENTER STUDENT NUMBER' TO OUTMSGO.
            
            MOVE 'I' TO WS-PROGRAM-SWITCH.

       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') ERASE 
            
            END-EXEC.

            EXEC CICS RETURN TRANSID('MV04')
                            COMMAREA(WS-SAVEAREA)
                            LENGTH(WS-SAVEAREA-LENGTH)
            END-EXEC.

       200-MAIN-LOGIC.
            
            MOVE LK-SAVE TO WS-SAVEAREA.
            
            IF WS-PROGRAM-SWITCH = 'I'
            
                GO TO 300-INQ-LOGIC
            
            ELSE IF WS-PROGRAM-SWITCH = 'U'
            
                GO TO 900-UPDATE-LOGIC
            
            END-IF.
            
       300-INQ-LOGIC.
       
            IF STUNUML IS < 7
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 650-MOVE-ATTRIBUTES-I
                MOVE 'THE STUDENT NUMBER MUST BE 7 LONG' 
                    TO OUTMSGO
                MOVE -1 TO STUNUML
                MOVE 'I' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                    
            ELSE IF STUNUMI IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 650-MOVE-ATTRIBUTES-I
                MOVE 'THE STUDENT NUMBER IS NOT NUMERIC' 
                    TO OUTMSGO
                MOVE -1 TO STUNUML
                MOVE 'I' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
       		ELSE

       			GO TO 500-READ-REC

       		END-IF.
            
       400-SEND-MAP.
            
       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') CURSOR
            END-EXEC.

       		EXEC CICS RETURN TRANSID('MV04')
                            COMMAREA(WS-SAVEAREA)
                            LENGTH(WS-SAVEAREA-LENGTH)
            END-EXEC.
            
       500-READ-REC.
            
            MOVE STUNUMI TO WS-STUD-NUM.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
       		MOVE WS-STUD-NUM TO STUFILE-STUDENT-NO.
            
            EXEC CICS READ FILE('STUFILE')
                       INTO (STUFILE-RECORD)
                       LENGTH (STUFILE-LENGTH)
                       RIDFLD (STUFILE-KEY)
            END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            MOVE STUFILE-STUDENT-NO TO STUNUMO, SAVE-NUM.
            
            MOVE STUFILE-NAME TO STUNAMO, SAVE-NAME.
            
            MOVE STUFILE-COURSE1-PART1 TO CCOD11O.
            
            MOVE STUFILE-COURSE1-PART2 TO CCOD12O.

            MOVE STUFILE-COURSE1 TO SAVE-COURSE1.
            
            MOVE STUFILE-COURSE2-PART1 TO CCOD21O.
            
            MOVE STUFILE-COURSE2-PART2 TO CCOD22O.
            
            MOVE STUFILE-COURSE2 TO SAVE-COURSE2.
            
            MOVE STUFILE-COURSE3-PART1 TO CCOD31O.
            
            MOVE STUFILE-COURSE3-PART2 TO CCOD32O.
            
            MOVE STUFILE-COURSE3 TO SAVE-COURSE3.
            
            MOVE STUFILE-COURSE4-PART1 TO CCOD41O.
            
            MOVE STUFILE-COURSE4-PART2 TO CCOD42O.
            
            MOVE STUFILE-COURSE4 TO SAVE-COURSE4.
            
            MOVE STUFILE-COURSE5-PART1 TO CCOD51O.
            
            MOVE STUFILE-COURSE5-PART2 TO CCOD52O.
            
            MOVE STUFILE-COURSE5 TO SAVE-COURSE5.
            
            MOVE STUFILE-ADDR-LINE1 TO ADDR01O, SAVE-ADDR-LINE1.
            
            MOVE STUFILE-ADDR-LINE2 TO ADDR02O, SAVE-ADDR-LINE2.
            
            MOVE STUFILE-ADDR-LINE3 TO ADDR03O, SAVE-ADDR-LINE3.
            
            MOVE STUFILE-POSTAL-1 TO POSCO1O.
            
            MOVE STUFILE-POSTAL-2 TO POSCO2O.
            
            MOVE STUFILE-POSTAL TO SAVE-POSTAL.
            
            MOVE STUFILE-AREA-CODE TO AREACOO.
            
            MOVE STUFILE-EXCHANGE TO EXCHCOO.
            
            MOVE STUFILE-PHONE-NUM TO PHONUMO.
            
            MOVE STUFILE-PHONE TO SAVE-PHONE.
            
            MOVE 'STUDENT RECORD FOUND!' TO OUTMSGO.
            
            MOVE DFHBLUE TO OUTMSGC.
            
            PERFORM 600-MOVE-ATTRIBUTES.
            
            MOVE 'U' TO WS-PROGRAM-SWITCH.
            
            MOVE 'F6 - DELETE RECORD' TO UPTILEO.
            
            MOVE -1 TO CCOD11L.
            
            GO TO 400-SEND-MAP.
            
       600-MOVE-ATTRIBUTES.
       
            MOVE ' U P D A T E  S C R E E N ' TO MTITLEO.
            MOVE 'F3' TO FUNKEYO.
            MOVE DFHBLUE TO MTITLEC,
                            UTITLEC.
            MOVE DFHGREEN TO STUNUMC,
                STUNAMC,
                CCOD11C,
                CCOD12C,
                CCOD21C,
                CCOD22C,
                CCOD31C,
                CCOD32C,
                CCOD41C,
                CCOD42C,
                CCOD51C,
                CCOD52C,
                ADDR01C,
                ADDR02C,
                ADDR03C,
                POSCO1C,
                POSCO2C,
                AREACOC,
                EXCHCOC,
                PHONUMC.
            MOVE DFHBMASF TO STUNUMA.
            MOVE DFHBMFSE TO STUNAMA, 
                             CCOD11A, 
                             CCOD12A, 
                             CCOD21A,
                             CCOD22A,
                             CCOD31A,
                             CCOD32A,
                             CCOD41A,
                             CCOD42A,
                             CCOD51A,
                             CCOD52A,
                             ADDR01A,
                             ADDR02A,
                             ADDR03A,
                             POSCO1A,
                             POSCO2A,
                             AREACOA,
                             EXCHCOA,
                             PHONUMA.
                             
       650-MOVE-ATTRIBUTES-I.
       
            MOVE 'F3' TO FUNKEYO.
            MOVE DFHYELLO TO MTITLEC,
                            UTITLEC.
            MOVE DFHGREEN TO STUNUMC,
                STUNAMC,
                CCOD11C,
                CCOD12C,
                CCOD21C,
                CCOD22C,
                CCOD31C,
                CCOD32C,
                CCOD41C,
                CCOD42C,
                CCOD51C,
                CCOD52C,
                ADDR01C,
                ADDR02C,
                ADDR03C,
                POSCO1C,
                POSCO2C,
                AREACOC,
                EXCHCOC,
                PHONUMC.
            
       700-EXIT-PROG.
       
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.

       		EXEC CICS RETURN END-EXEC.
            
       750-RETURN.
       
            MOVE LOW-VALUES TO IAEMAPO.
       
            EXEC CICS XCTL PROGRAM('MVPRGM')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.
       
       800-RUN-CC-PROG.
       
            EXEC CICS LINK PROGRAM('MVPRGCC')
                               COMMAREA(WS-CC-TRANSFER-FIELD)
                               LENGTH(WS-CC-TRANSFER-LENGTH)
            END-EXEC.
       
       900-UPDATE-LOGIC.
       
            MOVE STUNUMI TO STUFILE-STUDENT-NO.
            
            MOVE STUNAMI TO STUFILE-NAME.
            
            MOVE CCOD11I TO STUFILE-COURSE1-PART1.
            
            MOVE CCOD12I TO STUFILE-COURSE1-PART2.
            
            MOVE CCOD21I TO STUFILE-COURSE2-PART1.
            
            MOVE CCOD22I TO STUFILE-COURSE2-PART2.
            
            MOVE CCOD31I TO STUFILE-COURSE3-PART1.
            
            MOVE CCOD32I TO STUFILE-COURSE3-PART2.
            
            MOVE CCOD41I TO STUFILE-COURSE4-PART1.
            
            MOVE CCOD42I TO STUFILE-COURSE4-PART2.
            
            MOVE CCOD51I TO STUFILE-COURSE5-PART1.
            
            MOVE CCOD52I TO STUFILE-COURSE5-PART2.
            
            MOVE ADDR01I TO STUFILE-ADDR-LINE1.
            
            MOVE ADDR02I TO STUFILE-ADDR-LINE2.
            
            MOVE ADDR03I TO STUFILE-ADDR-LINE3.
            
            MOVE POSCO1I TO STUFILE-POSTAL-1.
            
            MOVE POSCO2I TO STUFILE-POSTAL-2.
            
            MOVE AREACOI TO STUFILE-AREA-CODE.
            
            MOVE EXCHCOI TO STUFILE-EXCHANGE.
            
            MOVE PHONUMI TO STUFILE-PHONE-NUM.
       
            IF STUFILE-NAME = SAVE-NAME AND
               STUFILE-COURSE1 = SAVE-COURSE1 AND
               STUFILE-COURSE2 = SAVE-COURSE2 AND
               STUFILE-COURSE3 = SAVE-COURSE3 AND
               STUFILE-COURSE4 = SAVE-COURSE4 AND
               STUFILE-COURSE5 = SAVE-COURSE5 AND
               STUFILE-ADDR-LINE1 = SAVE-ADDR-LINE1 AND
               STUFILE-ADDR-LINE2 = SAVE-ADDR-LINE2 AND
               STUFILE-ADDR-LINE3 = SAVE-ADDR-LINE3 AND
               STUFILE-POSTAL = SAVE-POSTAL AND
               STUFILE-PHONE = SAVE-PHONE THEN
               
                EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC
               
                MOVE LOW-VALUES TO IAEMAPO, WS-SAVEAREA
                
                PERFORM 650-MOVE-ATTRIBUTES-I
                
                MOVE 'NOTHING CHANGED' TO OUTMSGO
                
                MOVE 'I' TO WS-PROGRAM-SWITCH
                
                MOVE DFHBLUE TO OUTMSGC
                
                EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC
                
                EXEC CICS RETURN TRANSID('MV04')
                            COMMAREA(WS-SAVEAREA)
                            LENGTH(WS-SAVEAREA-LENGTH)
                END-EXEC
               
            ELSE
            
                GO TO 950-MAIN-UPDATE-LOGIC
            
            END-IF.
            
       950-MAIN-UPDATE-LOGIC.
       
            MOVE CCOD11I TO COURSES-PART-1(1).
            MOVE CCOD12I TO COURSES-PART-2(1).
            COMPUTE COURSES-LENGTH(1) = CCOD11L + CCOD12L.
            
            MOVE CCOD21I TO COURSES-PART-1(2).
            MOVE CCOD22I TO COURSES-PART-2(2).
            COMPUTE COURSES-LENGTH(2) = CCOD21L + CCOD22L.
            
            MOVE CCOD31I TO COURSES-PART-1(3).
            MOVE CCOD32I TO COURSES-PART-2(3).
            COMPUTE COURSES-LENGTH(3) = CCOD31L + CCOD32L.
            
            MOVE CCOD41I TO COURSES-PART-1(4).
            MOVE CCOD42I TO COURSES-PART-2(4).
            COMPUTE COURSES-LENGTH(4) = CCOD41L + CCOD42L.
            
            MOVE CCOD51I TO COURSES-PART-1(5).
            MOVE CCOD52I TO COURSES-PART-2(5).
            COMPUTE COURSES-LENGTH(5) = CCOD51L + CCOD52L.
            
            PERFORM VARYING COURSES-SUB FROM 1 BY 1
                                UNTIL COURSES-SUB > 5
                PERFORM 980-CC-VALIDATION
                PERFORM 970-CHECK-COURSES 
                   VARYING COURSES-CHECK-SUB FROM 1 BY 1
                                UNTIL COURSES-CHECK-SUB > 5
            END-PERFORM.

            
      * Validation for no course codes entered
            IF WS-EMPTY-CC-COUNT = 5
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'YOU MUST ENTER AT LEAST ONE COURSE' 
                    TO OUTMSGO
                MOVE -1 TO CCOD11L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
            
      * Validation for student name if less than 4 characters      
            ELSE IF STUNAML < 4
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER A NAME WITH 4 CHARACTERS OR MORE' 
                    TO OUTMSGO
                MOVE -1 TO STUNAML
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
            ELSE IF STUNAMI(1:6) = 'DELETE'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'DELETE IS NOT A VALID NAME' 
                    TO OUTMSGO
                MOVE -1 TO STUNAML
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
            
            ELSE IF STUNAMI(1:1) IS < 'A' 
                    OR STUNAMI(1:1) IS > 'Z'
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER A NAME THAT STARTS WITH A LETTER' 
                    TO OUTMSGO
                MOVE -1 TO STUNAML
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
            
            END-IF.

            PERFORM VARYING NAME-SUB FROM 1 BY 1
                                    UNTIL NAME-SUB > 20
                                    
                IF STUNAMI(NAME-SUB:1) IS > 'A' 
                    AND STUNAMI(NAME-SUB:1) IS < 'Z'
                
                    ADD 1 TO WS-NAME-CHAR-COUNT
                    
                END-IF
            
            END-PERFORM.
            
            IF WS-NAME-CHAR-COUNT < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER A NAME WITH FOUR LETTERS' 
                    TO OUTMSGO
                MOVE -1 TO STUNAML
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
            
            END-IF.
            
      * Validation for address part 1 if less than 3 characters         
            IF ADDR01L < 3
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER ADDRESS 1 WITH 3 OR MORE CHAR' 
                    TO OUTMSGO
                MOVE -1 TO ADDR01L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
      * Validation for address part 2 if less than 3 characters
            ELSE IF ADDR02L < 3
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER ADDRESS 2 WITH 3 OR MORE CHAR' 
                    TO OUTMSGO
                MOVE -1 TO ADDR02L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
      * Validation for address part 3 if less than 3 characters      
            ELSE IF ADDR03L < 3
      
      * Address part 3 is optional..     
                IF ADDR03L > 0
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'ENTER ADDRESS 3 WITH 3 OR MORE CHAR' 
                        TO OUTMSGO
                    MOVE -1 TO ADDR03L
                    MOVE 'U' TO WS-PROGRAM-SWITCH
                    MOVE 'F6 - DELETE RECORD' TO UPTILEO
                    MOVE DFHRED TO OUTMSGC
                    GO TO 400-SEND-MAP
                
                END-IF
                
            END-IF.
            
      * Validation for postal code part 1 if less than 3 characters      
            IF POSCO1L < 3
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
        
      * Validation for postal code part 1 starts with a letter 
            ELSE IF POSCO1I (1:1) IS < 'A'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
            ELSE IF POSCO1I (1:1) IS > 'Z'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
        
      * Validation for postal code part 1 has to have a number 
      * in the middle 
            ELSE IF POSCO1I (2:1) IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
      * Validation for postal code part 1 ends with a letter          
            ELSE IF POSCO1I (3:1) IS < 'A'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
            ELSE IF POSCO1I (3:1) IS > 'Z'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
            
      * Validation for postal code part 2 if less than 3 characters       
            ELSE IF POSCO2L < 3
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
       
      * Validation for postal code part 2 starts with a number 
            ELSE IF POSCO2I (1:1) IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
       
      * Validation for postal code part 2 has to have a number 
      * in the middle
            ELSE IF POSCO2I (2:1) IS < 'A'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
            ELSE IF POSCO2I (2:1) IS > 'Z'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
            
      * Validation for postal code part 1 ends with a letter     
            ELSE IF POSCO2I (3:1) IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
            
            END-IF.
            IF AREACOI IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER AN AREA CODE WITH 3 NUMBERS' 
                    TO OUTMSGO
                MOVE -1 TO AREACOL
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
            ELSE
            
                IF AREACOL < 3
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'ENTER AN AREA CODE WITH 3 NUMBERS' 
                        TO OUTMSGO
                    MOVE -1 TO AREACOL
                    MOVE 'U' TO WS-PROGRAM-SWITCH
                    MOVE 'F6 - DELETE RECORD' TO UPTILEO
                    MOVE DFHRED TO OUTMSGC
                    GO TO 400-SEND-MAP
                
                END-IF
            
            END-IF.
            IF AREACOI IS NOT EQUAL TO 905
            
                IF AREACOI IS NOT EQUAL TO 416
                
                    IF AREACOI IS NOT EQUAL TO 705
                    
                        MOVE LOW-VALUES TO IAEMAPO
                        PERFORM 600-MOVE-ATTRIBUTES
                        MOVE 'AREA CODE MUST BE "905", "416" OR "705"' 
                            TO OUTMSGO
                        MOVE -1 TO AREACOL
                        MOVE 'U' TO WS-PROGRAM-SWITCH
                        MOVE 'F6 - DELETE RECORD' TO UPTILEO
                        MOVE DFHRED TO OUTMSGC
                        GO TO 400-SEND-MAP
                        
                    END-IF
                    
                END-IF
                
            END-IF.
            IF EXCHCOI IS NOT NUMERIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER AN EXCHANGE NUMBER WITH 3 NUMBERS' 
                    TO OUTMSGO
                MOVE -1 TO EXCHCOL
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
            ELSE
            
                IF EXCHCOL < 3
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'ENTER AN EXCHANGE NUMBER WITH 3 NUMBERS' 
                        TO OUTMSGO
                    MOVE -1 TO EXCHCOL
                    MOVE 'U' TO WS-PROGRAM-SWITCH
                    MOVE 'F6 - DELETE RECORD' TO UPTILEO
                    MOVE DFHRED TO OUTMSGC
                    GO TO 400-SEND-MAP
                    
                END-IF
                
            END-IF.
            IF PHONUMI IS NOT NUMERIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER AN PHONE NUMBER WITH 4 NUMBERS' 
                    TO OUTMSGO
                MOVE -1 TO PHONUML
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
                GO TO 400-SEND-MAP
                
            ELSE
            
                IF PHONUML < 4
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'ENTER AN EXCHANGE NUMBER WITH 4 NUMBERS' 
                        TO OUTMSGO
                    MOVE -1 TO PHONUML
                    MOVE 'U' TO WS-PROGRAM-SWITCH
                    MOVE 'F6 - DELETE RECORD' TO UPTILEO
                    MOVE DFHRED TO OUTMSGC
                    GO TO 400-SEND-MAP
                    
                END-IF
                
            END-IF.
            
            
            
            EXEC CICS READ FILE('STUFILE')
                 RIDFLD(STUFILE-KEY)
                 LENGTH(STUFILE-LENGTH)
                 INTO(STUFILE-RECORD)
                 UPDATE
            END-EXEC.
            
            MOVE STUNAMI TO STUFILE-NAME.
            
            MOVE CCOD11I TO STUFILE-COURSE1-PART1.
            
            MOVE CCOD12I TO STUFILE-COURSE1-PART2.
            
            MOVE CCOD21I TO STUFILE-COURSE2-PART1.
            
            MOVE CCOD22I TO STUFILE-COURSE2-PART2.
            
            MOVE CCOD31I TO STUFILE-COURSE3-PART1.
            
            MOVE CCOD32I TO STUFILE-COURSE3-PART2.
            
            MOVE CCOD41I TO STUFILE-COURSE4-PART1.
            
            MOVE CCOD42I TO STUFILE-COURSE4-PART2.
            
            MOVE CCOD51I TO STUFILE-COURSE5-PART1.
            
            MOVE CCOD52I TO STUFILE-COURSE5-PART2.
            
            MOVE ADDR01I TO STUFILE-ADDR-LINE1.
            
            MOVE ADDR02I TO STUFILE-ADDR-LINE2.
            
            MOVE ADDR03I TO STUFILE-ADDR-LINE3.
            
            MOVE POSCO1I TO STUFILE-POSTAL-1.
            
            MOVE POSCO2I TO STUFILE-POSTAL-2.
            
            MOVE AREACOI TO STUFILE-AREA-CODE.
            
            MOVE EXCHCOI TO STUFILE-EXCHANGE.
            
            MOVE PHONUMI TO STUFILE-PHONE-NUM.
            
            EXEC CICS REWRITE FILE('STUFILE')
                LENGTH(STUFILE-LENGTH)
                FROM(STUFILE-RECORD)
            END-EXEC.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO, WS-SAVEAREA.
            
            PERFORM 650-MOVE-ATTRIBUTES-I.
            
            MOVE 'RECORD UPDATED!' TO OUTMSGO.
            
            MOVE 'I' TO WS-PROGRAM-SWITCH.
            
            MOVE 'F6 - DELETE RECORD' TO UPTILEO.

            MOVE -1 TO STUNUML.
            
            MOVE DFHBLUE TO OUTMSGC.
            
            GO TO 400-SEND-MAP.
       
       960-DELETE-RECORD.
            
            MOVE LK-SAVE TO WS-SAVEAREA.
            
            EXEC CICS HANDLE CONDITION DUPREC(985-DUP-REC)
            
            END-EXEC.
            
            IF WS-PROGRAM-SWITCH = 'U'
            
                IF STUNAMI(1:6) = 'DELETE'
                
                    MOVE SAVE-NUM TO STUFILE-STUDENT-NO
            
                    MOVE SAVE-NAME TO STUFILE-NAME
                    
                    MOVE SAVE-COURSE1 TO STUFILE-COURSE1
                    
                    MOVE SAVE-COURSE2 TO STUFILE-COURSE2
                    
                    MOVE SAVE-COURSE3 TO STUFILE-COURSE3
                    
                    MOVE SAVE-COURSE4 TO STUFILE-COURSE4
                    
                    MOVE SAVE-COURSE5 TO STUFILE-COURSE5
                    
                    MOVE SAVE-ADDR-LINE1 TO STUFILE-ADDR-LINE1
                    
                    MOVE SAVE-ADDR-LINE2 TO STUFILE-ADDR-LINE2
                    
                    MOVE SAVE-ADDR-LINE3 TO STUFILE-ADDR-LINE3
                    
                    MOVE SAVE-POSTAL TO STUFILE-POSTAL
                    
                    MOVE SAVE-PHONE TO STUFILE-PHONE
                    
                    EXEC CICS WRITE FILE('BKUPFLE') 
                          FROM(STUFILE-RECORD)
                          LENGTH(STUFILE-LENGTH) 
                          RIDFLD(STUFILE-KEY) 
                    END-EXEC
                    
                    EXEC CICS DELETE FILE('STUFILE')
                                  RIDFLD(STUFILE-KEY)
                                  
                    END-EXEC
                    
                    EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC
            
                    MOVE LOW-VALUES TO IAEMAPO, WS-SAVEAREA
                    
                    PERFORM 650-MOVE-ATTRIBUTES-I
                    
                    MOVE 'RECORD DELETED!' TO OUTMSGO
                    
                    MOVE 'I' TO WS-PROGRAM-SWITCH
                    
                    MOVE 'F6 - DELETE RECORD' TO UPTILEO

                    MOVE -1 TO STUNUML
                    
                    MOVE DFHBLUE TO OUTMSGC
                    
                ELSE
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'DELETE MUST BE IN NAME TO BE CONFIRMED' 
                        TO OUTMSGO
                    MOVE -1 TO STUNAML
                    MOVE 'U' TO WS-PROGRAM-SWITCH
                    MOVE 'F6 - DELETE RECORD' TO UPTILEO
                    MOVE DFHRED TO OUTMSGC
                    
                END-IF
                
            ELSE
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 650-MOVE-ATTRIBUTES-I
                MOVE 'DELETE MUST BE DONE IN UPDATE' 
                    TO OUTMSGO
                MOVE -1 TO STUNUML
                MOVE 'I' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                MOVE DFHRED TO OUTMSGC
            
            END-IF.
            
            GO TO 400-SEND-MAP.
            
            
       970-CHECK-COURSES.
          
          IF COURSES-CHECK-SUB NOT EQUAL TO COURSES-SUB
          
              
              IF COURSES-VALUE(COURSES-SUB) NOT EQUAL TO LOW-VALUES 
                    AND COURSES-VALUE(COURSES-SUB) NOT EQUAL TO SPACES

                IF COURSES-VALUE(COURSES-SUB) 
                      = COURSES-VALUE(COURSES-CHECK-SUB) 
                
                    MOVE LOW-VALUES TO IAEMAPO

                    PERFORM 600-MOVE-ATTRIBUTES

                    IF COURSES-SUB = 1
                    
                        MOVE 'COURSE 1 HAS SAME VALUE AS COURSE ' 
                            TO MESSAGE-VALUE
                        MOVE COURSES-CHECK-SUB TO COURSES-NUMBER
                        MOVE ERROR-MESSAGE TO OUTMSGO
                        MOVE 'F6 - DELETE RECORD' TO UPTILEO
                        MOVE -1 TO CCOD11L
                        GO TO 400-SEND-MAP
                        
                    ELSE IF COURSES-SUB = 2

                        MOVE 'COURSE 2 HAS SAME VALUE AS COURSE ' 
                            TO MESSAGE-VALUE
                        MOVE COURSES-CHECK-SUB TO COURSES-NUMBER
                        MOVE ERROR-MESSAGE TO OUTMSGO
                        MOVE 'F6 - DELETE RECORD' TO UPTILEO
                        MOVE -1 TO CCOD21L
                        GO TO 400-SEND-MAP
                    
                    ELSE IF COURSES-SUB = 3

                        MOVE 'COURSE 3 HAS SAME VALUE AS COURSE ' 
                            TO MESSAGE-VALUE
                        MOVE COURSES-CHECK-SUB TO COURSES-NUMBER
                        MOVE ERROR-MESSAGE TO OUTMSGO
                        MOVE 'F6 - DELETE RECORD' TO UPTILEO
                        MOVE -1 TO CCOD31L
                        GO TO 400-SEND-MAP
                    
                    ELSE IF COURSES-SUB = 4

                        MOVE 'COURSE 4 HAS SAME VALUE AS COURSE ' 
                            TO MESSAGE-VALUE
                        MOVE COURSES-CHECK-SUB TO COURSES-NUMBER
                        MOVE ERROR-MESSAGE TO OUTMSGO
                        MOVE 'F6 - DELETE RECORD' TO UPTILEO
                        MOVE -1 TO CCOD41L
                        GO TO 400-SEND-MAP
                    
                    ELSE

                        MOVE 'COURSE 5 HAS SAME VALUE AS COURSE ' 
                            TO MESSAGE-VALUE
                        MOVE COURSES-CHECK-SUB TO COURSES-NUMBER
                        MOVE ERROR-MESSAGE TO OUTMSGO
                        MOVE 'F6 - DELETE RECORD' TO UPTILEO
                        MOVE -1 TO CCOD51L
                        GO TO 400-SEND-MAP
                    
                    END-IF
                    
                  END-IF
          
              END-IF
              
          END-IF.
          
       980-CC-VALIDATION.
       
      * Course code of the first course validation
            IF COURSES-LENGTH(COURSES-SUB) < 1
            
                ADD 1 TO WS-EMPTY-CC-COUNT
                
            ELSE IF COURSES-LENGTH(COURSES-SUB) < 8
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSES MUST HAVE 8 CHARACTERS' 
                    TO OUTMSGO
                PERFORM 990-MOVE-CURSOR
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                GO TO 400-SEND-MAP
            
            ELSE IF COURSES-PART-1(COURSES-SUB) IS NOT ALPHABETIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 1 FIRST PART MUST BE ALPHABETIC' 
                    TO OUTMSGO
                PERFORM 990-MOVE-CURSOR
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                GO TO 400-SEND-MAP
                
            ELSE IF COURSES-PART-2(COURSES-SUB) IS NOT NUMERIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 1 SECOND PART MUST BE NUMERIC' 
                    TO OUTMSGO
                PERFORM 990-MOVE-CURSOR
                MOVE 'U' TO WS-PROGRAM-SWITCH
                MOVE 'F6 - DELETE RECORD' TO UPTILEO
                GO TO 400-SEND-MAP
                
            ELSE
            
                MOVE COURSES-PART-1(COURSES-SUB) 
                    TO WS-CC-COURSE-CODE-PART1
                MOVE COURSES-PART-2(COURSES-SUB) 
                    TO WS-CC-COURSE-CODE-PART2
                PERFORM 800-RUN-CC-PROG
                IF WS-CC-COURSE-DESC EQUAL TO WS-NOT-FOUND-CONST
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'THIS IS NOT A VALID COURSE CODE' TO OUTMSGO
                    PERFORM 990-MOVE-CURSOR
                    MOVE 'U' TO WS-PROGRAM-SWITCH
                    MOVE 'F6 - DELETE RECORD' TO UPTILEO
                    GO TO 400-SEND-MAP
                
                END-IF

            END-IF.
            
       985-DUP-REC.
            
            EXEC CICS DELETE FILE('BKUPFLE')
                                  RIDFLD(STUFILE-KEY)
                                  
            END-EXEC.
       
            EXEC CICS WRITE FILE('BKUPFLE') 
                          FROM(STUFILE-RECORD)
                          LENGTH(STUFILE-LENGTH) 
                          RIDFLD(STUFILE-KEY) 
            END-EXEC.
            
            EXEC CICS DELETE FILE('STUFILE')
                                  RIDFLD(STUFILE-KEY)
                                  
            END-EXEC.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
    
            MOVE LOW-VALUES TO IAEMAPO, WS-SAVEAREA.
            
            PERFORM 650-MOVE-ATTRIBUTES-I.
            
            MOVE 'RECORD DELETED!' TO OUTMSGO.
            
            MOVE 'I' TO WS-PROGRAM-SWITCH.
            
            MOVE 'F6 - DELETE RECORD' TO UPTILEO.

            MOVE -1 TO STUNUML.
            
            MOVE DFHBLUE TO OUTMSGC.
            
            GO TO 400-SEND-MAP.
            
       990-MOVE-CURSOR.
       
            IF COURSES-SUB = 1
            
                MOVE -1 TO CCOD11L
                
            ELSE IF COURSES-SUB = 2

                MOVE -1 TO CCOD21L
            
            ELSE IF COURSES-SUB = 3

                MOVE -1 TO CCOD31L
            
            ELSE IF COURSES-SUB = 4

                MOVE -1 TO CCOD41L
            
            ELSE

                MOVE -1 TO CCOD51L
            
            END-IF.
            
       
       999-SEND-ERROR-NO-RECORD-MSG.
       
            MOVE STUNUMI TO WS-STUD-NUM.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            PERFORM 650-MOVE-ATTRIBUTES-I.
            
            MOVE WS-STUD-NUM TO STUNUMO.

       		MOVE '*ERROR AT INPUT* - NO RECORD FOUND' TO OUTMSGO.
            
            MOVE 'I' TO WS-PROGRAM-SWITCH.
            
            MOVE 'F6 - DELETE RECORD' TO UPTILEO.
            
            MOVE DFHRED TO OUTMSGC.

       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV04')
                            COMMAREA(WS-SAVEAREA)
                            LENGTH(WS-SAVEAREA-LENGTH)
            END-EXEC.

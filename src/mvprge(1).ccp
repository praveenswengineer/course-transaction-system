       IDENTIFICATION DIVISION.
       PROGRAM-ID. MVPRGE.
       AUTHOR. MICHAEL VALDRON.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.
       	
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       	
       COPY 'MVMAP2'.
       COPY DFHBMSCA.

      * Transfer fields 
       01 WS-TRANSFER-FIELD                 PIC XXX.
       01 WS-TRANSFER-LENGTH                PIC S9(4) COMP VALUE 3.
       01 WS-CC-TRANSFER-FIELD.
           05 WS-CC-COURSE-CODE.
               10 WS-CC-COURSE-CODE-PART1   PIC X(4).
               10 WS-CC-COURSE-CODE-PART2   PIC X(4).
           05 WS-CC-COURSE-DESC             PIC X(17).
       01 WS-CC-TRANSFER-LENGTH             PIC S9(4) COMP VALUE 25.
      
      * Counter for the number for course codes that have been found
      * empty.
       01   WS-EMPTY-CC-COUNT               PIC 99 VALUE 0.
      
      * Constant that holds the error message that displays when a 
      * user makes an error in the postal code.
      * (Made this for my own reason, not a lab requirement)
       01   WS-POSTAL-CODE-ERROR-CONST      PIC X(38) 
                VALUE 'ENTER A POSTAL CODE (EXAMPLE: L1L 1L1)'.

       01   WS-NOT-FOUND-CONST              PIC X(16) 
                VALUE 'COURSE NOT FOUND'.
       
      * STUFILE fields that hold the input from the user to be written
      * once it has been valid.
       
       01 STUFILE-LENGTH                    PIC S9(4) COMP VALUE 150.
       
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
           
       LINKAGE SECTION.
       
      * Stores values passed from the last program 
       01 DFHCOMMAREA.
            05 LK-TRANSFER                  PIC XXX.
       
       PROCEDURE DIVISION.
       000-START-LOGIC.
       
      * Assigns F1 key to return to the main menu      
            EXEC CICS HANDLE AID PF1(700-RETURN)
            
            END-EXEC.
       
      * Assigns F9 key to be the exit program key
            EXEC CICS HANDLE AID PF9(500-EXIT-PROG)
            
            END-EXEC.
       
      * Handles the conditions with first entry and duplicate records
       		EXEC CICS HANDLE CONDITION MAPFAIL(100-FIRST-TIME) 
                          DUPREC(999-SEND-ERROR-DUP-RECORD-MSG)
            END-EXEC.
       
      * Handles entry for menu program
            IF EIBCALEN = 3
            
                GO TO 100-FIRST-TIME
            
            END-IF.

      * Receive map 
         	EXEC CICS RECEIVE MAP('IAEMAP') MAPSET('MVMAP2') 
            
            END-EXEC.
            
      * Go to validation..
       		GO TO 200-MAIN-LOGIC.

       100-FIRST-TIME.

       		MOVE LOW-VALUES TO IAEMAPO.
       
      * Move entry program attributes to the 2nd mapset
            PERFORM 600-MOVE-ATTRIBUTES.

      * Output initial message
            MOVE 'FILL OUT THE FIELDS' TO OUTMSGO.
      
      * Send map to screen
       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') ERASE 
            
            END-EXEC.

      * Save the program state and end current processes
            EXEC CICS RETURN TRANSID('MV03') END-EXEC.

       200-MAIN-LOGIC.
            
      * Student number validation     
            IF STUNUML IS < 7
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'THE STUDENT NUMBER MUST BE 7 LONG' 
                    TO OUTMSGO
                MOVE -1 TO STUNUML
                GO TO 400-SEND-MAP
                    
            ELSE IF STUNUMI IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'THE STUDENT NUMBER IS NOT NUMERIC' 
                    TO OUTMSGO
                MOVE -1 TO STUNUML
                GO TO 400-SEND-MAP
            
            END-IF.
            
       
      * Course code of the first course validation
            IF CCOD11L < 1 AND CCOD12L < 1
            
                ADD 1 TO WS-EMPTY-CC-COUNT
                
            ELSE IF CCOD11L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 1 PART 1 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD11L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD12L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 1 PART 2 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD12L
                GO TO 400-SEND-MAP 
            
            ELSE IF CCOD11I IS NOT ALPHABETIC
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'COURSE 1 FIRST PART MUST BE ALPHABETIC' 
                        TO OUTMSGO
                    MOVE -1 TO CCOD11L
                    GO TO 400-SEND-MAP
                
            ELSE IF CCOD12I IS NOT NUMERIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 1 SECOND PART MUST BE NUMERIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD12L
                GO TO 400-SEND-MAP
                
            ELSE
            
                MOVE CCOD11I TO WS-CC-COURSE-CODE-PART1
                MOVE CCOD12I TO WS-CC-COURSE-CODE-PART2
                PERFORM 800-RUN-CC-PROG
                IF WS-CC-COURSE-DESC EQUAL TO WS-NOT-FOUND-CONST
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'THIS IS NOT A VALID COURSE CODE' TO OUTMSGO
                    MOVE -1 TO CCOD11L
                    GO TO 400-SEND-MAP
                
                END-IF

            END-IF.
            
      * Course code of the second course validation
            IF CCOD21L < 1 AND CCOD22L < 1
            
                ADD 1 TO WS-EMPTY-CC-COUNT
            
            ELSE IF CCOD21L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 2 PART 1 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD21L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD22L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 2 PART 2 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD22L
                GO TO 400-SEND-MAP 
            
            ELSE IF CCOD21I IS NOT ALPHABETIC
             
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 2 FIRST PART MUST BE ALPHABETIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD21L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD22I IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 2 SECOND PART MUST BE NUMERIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD22L
                GO TO 400-SEND-MAP
                
            ELSE
            
                MOVE CCOD21I TO WS-CC-COURSE-CODE-PART1
                MOVE CCOD22I TO WS-CC-COURSE-CODE-PART2
                PERFORM 800-RUN-CC-PROG
                IF WS-CC-COURSE-DESC EQUAL TO WS-NOT-FOUND-CONST
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'THIS IS NOT A VALID COURSE CODE' TO OUTMSGO
                    MOVE -1 TO CCOD21L
                    GO TO 400-SEND-MAP
                
                END-IF
            
            END-IF.
            
      * Course code of the third course validation
            IF CCOD31L < 1 AND CCOD32L < 1
            
                ADD 1 TO WS-EMPTY-CC-COUNT
            
            ELSE IF CCOD31L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 3 PART 1 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD31L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD32L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 3 PART 2 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD32L
                GO TO 400-SEND-MAP 
            
            ELSE IF CCOD31I IS NOT ALPHABETIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 3 FIRST PART MUST BE ALPHABETIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD31L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD32I IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 3 SECOND PART MUST BE NUMERIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD32L
                GO TO 400-SEND-MAP
            
            ELSE
            
                MOVE CCOD31I TO WS-CC-COURSE-CODE-PART1
                MOVE CCOD32I TO WS-CC-COURSE-CODE-PART2
                PERFORM 800-RUN-CC-PROG
                IF WS-CC-COURSE-DESC EQUAL TO WS-NOT-FOUND-CONST
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'THIS IS NOT A VALID COURSE CODE' TO OUTMSGO
                    MOVE -1 TO CCOD31L
                    GO TO 400-SEND-MAP
                
                END-IF
            
            END-IF.
            
            
      * Course code of the fourth course validation
            IF CCOD41L < 1 AND CCOD42L < 1
            
                ADD 1 TO WS-EMPTY-CC-COUNT
            
            ELSE IF CCOD41L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 4 PART 1 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD41L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD42L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 4 PART 2 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD42L
                GO TO 400-SEND-MAP 
            
            ELSE IF CCOD41I IS NOT ALPHABETIC
                 
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 4 FIRST PART MUST BE ALPHABETIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD41L
                GO TO 400-SEND-MAP
                
            ELSE IF CCOD42I IS NOT NUMERIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 4 SECOND PART MUST BE NUMERIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD42L
                GO TO 400-SEND-MAP
            
            ELSE
            
                MOVE CCOD41I TO WS-CC-COURSE-CODE-PART1
                MOVE CCOD42I TO WS-CC-COURSE-CODE-PART2
                PERFORM 800-RUN-CC-PROG
                IF WS-CC-COURSE-DESC EQUAL TO WS-NOT-FOUND-CONST
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'THIS IS NOT A VALID COURSE CODE' TO OUTMSGO
                    MOVE -1 TO CCOD41L
                    GO TO 400-SEND-MAP
                
                END-IF
            
            END-IF.
            
      * Course code of the fifth course validation
            IF CCOD51L < 1 AND CCOD52L < 1
            
                ADD 1 TO WS-EMPTY-CC-COUNT
            
            ELSE IF CCOD51L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 5 PART 1 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD51L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD52L < 4
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 5 PART 2 MUST HAVE 4 CHARACTERS' 
                    TO OUTMSGO
                MOVE -1 TO CCOD52L
                GO TO 400-SEND-MAP 
            
            ELSE IF CCOD51I IS NOT ALPHABETIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 5 FIRST PART MUST BE ALPHABETIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD51L
                GO TO 400-SEND-MAP
            
            ELSE IF CCOD52I IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'COURSE 5 SECOND PART MUST BE NUMERIC' 
                    TO OUTMSGO
                MOVE -1 TO CCOD52L
                GO TO 400-SEND-MAP
                
            ELSE
            
                MOVE CCOD51I TO WS-CC-COURSE-CODE-PART1
                MOVE CCOD52I TO WS-CC-COURSE-CODE-PART2
                PERFORM 800-RUN-CC-PROG
                IF WS-CC-COURSE-DESC EQUAL TO WS-NOT-FOUND-CONST
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'THIS IS NOT A VALID COURSE CODE' TO OUTMSGO
                    MOVE -1 TO CCOD51L
                    GO TO 400-SEND-MAP
                
                END-IF
            
            END-IF.
            
      * Validation for no course codes entered
            IF WS-EMPTY-CC-COUNT = 5
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'YOU MUST ENTER AT LEAST ONE COURSE' 
                    TO OUTMSGO
                MOVE -1 TO CCOD11L
                GO TO 400-SEND-MAP
            
      * Validation for student name if less than 4 characters      
            ELSE IF STUNAML < 4
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER A NAME WITH 4 CHARACTERS OR MORE' 
                    TO OUTMSGO
                MOVE -1 TO STUNAML
                GO TO 400-SEND-MAP
                
      * Validation for address part 1 if less than 3 characters         
            ELSE IF ADDR01L < 3
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER ADDRESS 1 WITH 3 OR MORE CHAR' 
                    TO OUTMSGO
                MOVE -1 TO ADDR01L
                GO TO 400-SEND-MAP
                
      * Validation for address part 2 if less than 3 characters
            ELSE IF ADDR02L < 3
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER ADDRESS 2 WITH 3 OR MORE CHAR' 
                    TO OUTMSGO
                MOVE -1 TO ADDR02L
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
                GO TO 400-SEND-MAP
        
      * Validation for postal code part 1 starts with a letter 
            ELSE IF POSCO1I (1:1) IS < 'A'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                GO TO 400-SEND-MAP
                
            ELSE IF POSCO1I (1:1) IS > 'Z'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                GO TO 400-SEND-MAP
        
      * Validation for postal code part 1 has to have a number 
      * in the middle 
            ELSE IF POSCO1I (2:1) IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                GO TO 400-SEND-MAP
                
      * Validation for postal code part 1 ends with a letter          
            ELSE IF POSCO1I (3:1) IS < 'A'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                GO TO 400-SEND-MAP
                
            ELSE IF POSCO1I (3:1) IS > 'Z'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO1L
                GO TO 400-SEND-MAP
            
      * Validation for postal code part 2 if less than 3 characters       
            ELSE IF POSCO2L < 3
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                GO TO 400-SEND-MAP
       
      * Validation for postal code part 2 starts with a number 
            ELSE IF POSCO2I (1:1) IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                GO TO 400-SEND-MAP
       
      * Validation for postal code part 2 has to have a number 
      * in the middle
            ELSE IF POSCO2I (2:1) IS < 'A'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                GO TO 400-SEND-MAP
                
            ELSE IF POSCO2I (2:1) IS > 'Z'
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                GO TO 400-SEND-MAP
            
      * Validation for postal code part 1 ends with a letter     
            ELSE IF POSCO2I (3:1) IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE WS-POSTAL-CODE-ERROR-CONST 
                    TO OUTMSGO
                MOVE -1 TO POSCO2L
                GO TO 400-SEND-MAP
            
            END-IF.
            IF AREACOI IS NOT NUMERIC
            
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER AN AREA CODE WITH 3 NUMBERS' 
                    TO OUTMSGO
                MOVE -1 TO AREACOL
                GO TO 400-SEND-MAP
                
            ELSE
            
                IF AREACOL < 3
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'ENTER AN AREA CODE WITH 3 NUMBERS' 
                        TO OUTMSGO
                    MOVE -1 TO AREACOL
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
                GO TO 400-SEND-MAP
                
            ELSE
            
                IF EXCHCOL < 3
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'ENTER AN EXCHANGE NUMBER WITH 3 NUMBERS' 
                        TO OUTMSGO
                    MOVE -1 TO EXCHCOL
                    GO TO 400-SEND-MAP
                    
                END-IF
                
            END-IF.
            IF PHONUMI IS NOT NUMERIC
                
                MOVE LOW-VALUES TO IAEMAPO
                PERFORM 600-MOVE-ATTRIBUTES
                MOVE 'ENTER AN PHONE NUMBER WITH 4 NUMBERS' 
                    TO OUTMSGO
                MOVE -1 TO PHONUML
                GO TO 400-SEND-MAP
                
            ELSE
            
                IF PHONUML < 4
                
                    MOVE LOW-VALUES TO IAEMAPO
                    PERFORM 600-MOVE-ATTRIBUTES
                    MOVE 'ENTER AN EXCHANGE NUMBER WITH 4 NUMBERS' 
                        TO OUTMSGO
                    MOVE -1 TO PHONUML
                    GO TO 400-SEND-MAP
                    
                END-IF
                
            END-IF.
            
       		GO TO 300-WRITE-REC.

       300-WRITE-REC.
            
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
            
            EXEC CICS WRITE FILE('STUFILE') FROM(STUFILE-RECORD)
            		LENGTH(STUFILE-LENGTH) RIDFLD(STUFILE-KEY) 
            END-EXEC.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.

            MOVE LOW-VALUES TO IAEMAPO.
            
            PERFORM 600-MOVE-ATTRIBUTES.
            
            MOVE DFHGREEN TO OUTMSGC.
            
            MOVE 'STUDENT RECORD ADDED!' TO OUTMSGO.
            
            EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV03') END-EXEC.
            
       400-SEND-MAP.
            
            MOVE DFHRED TO OUTMSGC.
       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') CURSOR 
            
                END-EXEC.

       		EXEC CICS RETURN TRANSID('MV03') END-EXEC.
            
       500-EXIT-PROG.
       
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.

       		EXEC CICS RETURN END-EXEC.
            
       600-MOVE-ATTRIBUTES.
       
            MOVE '  E N T R Y  S C R E E N  ' TO MTITLEO.
            MOVE 'F1' TO FUNKEYO.
            MOVE DFHBLUE TO MTITLEC,
                            UTITLEC,
                            STUNUMC,
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
       
       700-RETURN.
       
            EXEC CICS XCTL PROGRAM('MVPRGM')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.
            
            EXEC CICS RETURN TRANSID('MV01') END-EXEC.
            
       800-RUN-CC-PROG.
       
            EXEC CICS LINK PROGRAM('MVPRGCC')
                               COMMAREA(WS-CC-TRANSFER-FIELD)
                               LENGTH(WS-CC-TRANSFER-LENGTH)
            END-EXEC.
       
       999-SEND-ERROR-DUP-RECORD-MSG.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            PERFORM 600-MOVE-ATTRIBUTES.

       		MOVE 'DUPLICATE RECORD FOUND' TO OUTMSGO.
            
            MOVE -1 TO STUNUML.

       		GO TO 400-SEND-MAP.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. MVPRGB.
       AUTHOR. MICHAEL VALDRON.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.
       	
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       	
       COPY 'MVMAP3'.
       COPY DFHBMSCA.
       
       01 WS-TRANSFER-FIELD                 PIC XXX.
       01 WS-TRANSFER-LENGTH                PIC S9(4) COMP VALUE 3.
       
       01 STUFILE-LENGTH                    PIC S9(4) COMP VALUE 150.
       
       01  STUFILE-RECORD.
           05  STUFILE-KEY.
               10  STUFILE-PREFIX           PIC XXX.
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
       
       01 TS-LENGTH                         PIC S9(4) COMP VALUE 420.
       
       01 TS-RECORD.
           05 TS-PREFIX                     PIC XXX OCCURS 10.
           05 TS-LINE                       OCCURS 10.
               10 TS-LINE-NUM               PIC 99.
               10 TS-STUDENT-NUM            PIC X(7).
               10 TS-STUDENT-NAM            PIC X(20).
               10 TS-STUDENT-AREA-CODE      PIC XXX.
               10 TS-STUDENT-EXCH           PIC XXX.
               10 TS-STUDENT-PHONE          PIC X(4).
           
       
       01 LINE-LENGTH                       PIC S9(4) COMP VALUE 79.
       
       01 RECORD-LINE.
           05 FILLER                        PIC X(12) VALUE SPACES.
           05 RL-LINE                       PIC 99.
           05 FILLER                        PIC XX VALUE SPACES.
           05 RL-NUM                        PIC X(7).
           05 FILLER                        PIC X(7) VALUE SPACES.
           05 RL-NAME                       PIC X(20).
           05 FILLER                        PIC X VALUE '('.
           05 RL-AREA                       PIC XXX.
           05 FILLER                        PIC XX VALUE ') '.
           05 RL-EXCH                       PIC XXX.
           05 FILLER                        PIC X VALUE '-'.
           05 RL-PHONE                      PIC XXXX.
           05 FILLER                        PIC X(15) VALUE SPACES.
           
       01 WS-TRANSFER-SWITCH                PIC X.
       01 WS-SWITCH-LENGTH                  PIC S9(9) COMP VALUE 1.
           
       01 LINE-SUB                          PIC 99 VALUE 0.
       01 CURRENT-SUB                       PIC 99 VALUE 0.
       
       01 TS-NAME.
           05 TS-TERMID                     PIC X(4).
           05 TS-ID                         PIC X(4) VALUE 'MV05'.
       
       LINKAGE SECTION.
       
       01 DFHCOMMAREA.
            05 LK-TRANSFER                  PIC XXX.
       
       
       PROCEDURE DIVISION.
       000-START-LOGIC.
            
            MOVE EIBTRMID TO TS-TERMID.
            
            EXEC CICS HANDLE AID PF2(100-FIRST-TIME)
                                 PF4(700-RETURN)
                                 PF7(800-SCROLL-BACK)
                                 PF8(850-SCROLL-FORWARD)
                                 PF9(600-EXIT-PROG)
            
            END-EXEC.
            
       		EXEC CICS HANDLE CONDITION MAPFAIL(100-FIRST-TIME) 
                          NOTFND(950-NOT-FOUND)
                          ENDFILE(970-END-OF-FILE)
                          QIDERR(990-TS-ERROR)
            END-EXEC.
            
            EXEC CICS IGNORE CONDITION DUPKEY
            
            END-EXEC.
            
            IF EIBCALEN = 3
            
                GO TO 100-FIRST-TIME
            
            END-IF.

         	EXEC CICS RECEIVE MAP('BWSMAP') MAPSET('MVMAP3') 
            
            END-EXEC.

       		GO TO 200-MAIN-LOGIC.

       100-FIRST-TIME.

       		MOVE LOW-VALUES TO BWSMAPO.
            
            EXEC CICS IGNORE CONDITION QIDERR END-EXEC.
            
            EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC.

            MOVE 'ENTER A STUDENT NAME TO BEGIN BROWSE' TO OUTMSGO.
            
            MOVE 'B' TO WS-TRANSFER-SWITCH.
            
            PERFORM 900-MOVE-COLOUR.

       		EXEC CICS SEND MAP('BWSMAP') MAPSET('MVMAP3') ERASE 
            
            END-EXEC.

            EXEC CICS RETURN TRANSID('MV05')
                            COMMAREA(WS-TRANSFER-SWITCH)
                            LENGTH(WS-SWITCH-LENGTH)
            END-EXEC.
            
       110-BROWSE-FWD.

            EXEC CICS READNEXT FILE('STUNAME')
                       INTO(STUFILE-RECORD)
                       RIDFLD(STUFILE-NAME)
                       LENGTH(STUFILE-LENGTH)
            END-EXEC.

            MOVE LINE-SUB TO RL-LINE, TS-LINE-NUM(LINE-SUB).
            MOVE STUFILE-PREFIX TO TS-PREFIX(LINE-SUB).
            MOVE STUFILE-STUDENT-NO 
                TO RL-NUM, TS-STUDENT-NUM(LINE-SUB).
            MOVE STUFILE-NAME TO RL-NAME, TS-STUDENT-NAM(LINE-SUB).
            MOVE STUFILE-AREA-CODE 
                TO RL-AREA, TS-STUDENT-AREA-CODE(LINE-SUB).
            MOVE STUFILE-EXCHANGE 
                TO RL-EXCH, TS-STUDENT-EXCH(LINE-SUB).
            MOVE STUFILE-PHONE-NUM 
                TO RL-PHONE, TS-STUDENT-PHONE(LINE-SUB).
            
            MOVE RECORD-LINE TO RCLINEO(LINE-SUB).
            
       120-READ-PREV.

            EXEC CICS READPREV FILE('STUNAME')
                       INTO(STUFILE-RECORD)
                       RIDFLD(STUFILE-NAME)
                       LENGTH(STUFILE-LENGTH)
            END-EXEC.

            MOVE LINE-SUB TO RL-LINE, TS-LINE-NUM(LINE-SUB).
            MOVE STUFILE-PREFIX TO TS-PREFIX(LINE-SUB).
            MOVE STUFILE-STUDENT-NO 
                TO RL-NUM, TS-STUDENT-NUM(LINE-SUB).
            MOVE STUFILE-NAME TO RL-NAME, TS-STUDENT-NAM(LINE-SUB).
            MOVE STUFILE-AREA-CODE 
                TO RL-AREA, TS-STUDENT-AREA-CODE(LINE-SUB).
            MOVE STUFILE-EXCHANGE 
                TO RL-EXCH, TS-STUDENT-EXCH(LINE-SUB).
            MOVE STUFILE-PHONE-NUM 
                TO RL-PHONE, TS-STUDENT-PHONE(LINE-SUB).
            
            MOVE RECORD-LINE TO RCLINEO(LINE-SUB).
       
       200-MAIN-LOGIC.
       
            MOVE LK-TRANSFER TO WS-TRANSFER-SWITCH.
            
            IF WS-TRANSFER-SWITCH = 'B'
            
                IF STUNAMI IS ALPHABETIC
                    
                    IF STUNAML >= 4
            
                        MOVE STUNAMI TO STUFILE-NAME
                    
                        EXEC CICS STARTBR FILE('STUNAME')
                                      RIDFLD(STUFILE-NAME)
                        END-EXEC

                        MOVE LOW-VALUES TO BWSMAPO
                       
                        PERFORM 110-BROWSE-FWD
                             VARYING LINE-SUB FROM 1 BY 1
                                  UNTIL LINE-SUB > 10

                        EXEC CICS ENDBR FILE('STUNAME') END-EXEC
                        
                        MOVE 'T' TO WS-TRANSFER-SWITCH
                        
                        EXEC CICS WRITEQ TS QUEUE(TS-NAME) 
                                                 FROM(TS-RECORD)
                                                 LENGTH(TS-LENGTH)
                        END-EXEC
                        
                        MOVE 'SEARCH RESULTS' TO OUTMSGO
                        
                        PERFORM 980-TRANSFER-FIELD
                        
                        GO TO 999-SEND-MAP
                    
                    ELSE
                    
                        MOVE LOW-VALUES TO BWSMAPO
                    
                        MOVE DFHRED TO OUTMSGC 
                    
                        MOVE 'MUST BE ALPHABETIC AND 4 LONG AT LEAST' 
                            TO OUTMSGO
                        
                        MOVE -1 TO STUNAML
                        
                        GO TO 999-SEND-MAP
                    
                    END-IF
                
                ELSE
                
                    MOVE LOW-VALUES TO BWSMAPO
                
                    MOVE DFHRED TO OUTMSGC 
                
                    MOVE 'MUST BE ALPHABETIC AND 4 LONG AT LEAST' 
                        TO OUTMSGO
                    
                    MOVE -1 TO STUNAML
                    
                    GO TO 999-SEND-MAP
                
                END-IF
            
            ELSE IF WS-TRANSFER-SWITCH = 'T'
                
                IF RECNUMI IS NUMERIC
                    
                    MOVE RECNUMI TO LINE-SUB
                    
                    GO TO 300-RECORD-LINE-VALIDATION
                
                ELSE IF RECNUMI(1:1) IS NUMERIC AND RECNUML = 1
                                   
                    MOVE RECNUMI(1:1) TO LINE-SUB
                    
                    GO TO 300-RECORD-LINE-VALIDATION
                
                ELSE
                
                    MOVE LOW-VALUES TO BWSMAPO
                
                    MOVE DFHRED TO OUTMSGC 
                
                    MOVE 'ENTER ON A LINE NUMBER' TO OUTMSGO
                    
                    PERFORM 980-TRANSFER-FIELD
                    
                    GO TO 999-SEND-MAP
                
                END-IF
                
            END-IF.
            
       300-RECORD-LINE-VALIDATION.
                    
            IF LINE-SUB <= 10 AND LINE-SUB > 0
                
                EXEC CICS READQ TS QUEUE(TS-NAME) INTO(TS-RECORD)
                                                  LENGTH(TS-LENGTH)
                END-EXEC
                
                EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC
                
                EXEC CICS WRITEQ TS QUEUE(TS-NAME) FROM(TS-RECORD)
                                                   LENGTH(TS-LENGTH)
                END-EXEC
                
                IF RCLINEI(LINE-SUB) = SPACES OR 
                    RCLINEI(LINE-SUB) = LOW-VALUES

                    MOVE DFHRED TO OUTMSGC 
                
                    MOVE 'NO RECORD IN FIELD' TO OUTMSGO
                

                
                    PERFORM 980-TRANSFER-FIELD
                    
                    GO TO 999-SEND-MAP
                
                ELSE IF TS-PREFIX(LINE-SUB) IS NOT EQUAL TO 'MJV'
                
                    MOVE DFHRED TO OUTMSGC 
                
                    MOVE 'PERMISSION TO ACCESS RECORD DENIED' 
                        TO OUTMSGO
                    
                    PERFORM 980-TRANSFER-FIELD
                    
                    GO TO 999-SEND-MAP
                
                ELSE
                
                    EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC
                
                    MOVE RCLINEI(LINE-SUB) TO RECORD-LINE
                    
                    MOVE RL-NUM TO STUFILE-STUDENT-NO
                    
                    MOVE 7 TO WS-TRANSFER-LENGTH
                    
                    EXEC CICS XCTL PROGRAM('MVPRGU')
                               COMMAREA(STUFILE-STUDENT-NO)
                               LENGTH(WS-TRANSFER-LENGTH)
                    END-EXEC
                
                END-IF
            
            ELSE
            
                MOVE DFHRED TO OUTMSGC 
            
                MOVE 'ENTER ON A LINE NUMBER' TO OUTMSGO
                
                PERFORM 980-TRANSFER-FIELD
                
                GO TO 999-SEND-MAP
            
            END-IF.
            
       600-EXIT-PROG.
       
            EXEC CICS IGNORE CONDITION QIDERR END-EXEC.
            
            EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.

            EXEC CICS RETURN END-EXEC.
            
       700-RETURN.
       
            EXEC CICS IGNORE CONDITION QIDERR END-EXEC.
       
            EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC.
            
            EXEC CICS XCTL PROGRAM('MVPRGM')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.
            
       800-SCROLL-BACK.
            
            MOVE LK-TRANSFER TO WS-TRANSFER-SWITCH.
            EXEC CICS HANDLE CONDITION ENDFILE(960-TOP-OF-FILE) 
            
            END-EXEC.
       
            MOVE RCLINEI(1) TO RECORD-LINE.	 
            MOVE RL-NAME TO STUFILE-NAME.
            
            IF RL-NAME(1:1) IS EQUAL TO SPACES
            
                MOVE LOW-VALUES TO BWSMAPO
        
                MOVE DFHRED TO OUTMSGC

                MOVE 'BEGINNING OF RECORDS.' TO OUTMSGO
            
            ELSE
            
                EXEC CICS STARTBR FILE('STUNAME')
                              RIDFLD(STUFILE-NAME)
                END-EXEC
               
                PERFORM 120-READ-PREV
                     VARYING LINE-SUB FROM 10 BY -1
                          UNTIL LINE-SUB < 1

                EXEC CICS ENDBR FILE('STUNAME') END-EXEC
                
                MOVE 'SEARCH RESULTS' TO OUTMSGO
            
            END-IF.
            
            IF WS-TRANSFER-SWITCH = 'T'
                
                EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC
                PERFORM 980-TRANSFER-FIELD
                EXEC CICS WRITEQ TS QUEUE(TS-NAME) FROM(TS-RECORD)
                         LENGTH(TS-LENGTH)
                END-EXEC
                
            ELSE
            
                MOVE -1 TO STUNAML
            
            END-IF.
            
            GO TO 999-SEND-MAP.
            
       850-SCROLL-FORWARD.
            
            MOVE LK-TRANSFER TO WS-TRANSFER-SWITCH.
            MOVE RCLINEI(10) TO RECORD-LINE.	 
            MOVE RL-NAME TO STUFILE-NAME.

		    IF RL-NAME(1:1) IS EQUAL TO SPACES
            
                MOVE LOW-VALUES TO BWSMAPO
        
                MOVE DFHRED TO OUTMSGC

                MOVE 'END OF RECORDS.' TO OUTMSGO
            
            ELSE
            
                EXEC CICS STARTBR FILE('STUNAME')
                              RIDFLD(STUFILE-NAME)
                END-EXEC
               
                PERFORM 110-BROWSE-FWD
                     VARYING LINE-SUB FROM 1 BY 1
                          UNTIL LINE-SUB > 10

                EXEC CICS ENDBR FILE('STUNAME') END-EXEC
                
                MOVE 'SEARCH RESULTS' TO OUTMSGO
            
            END-IF.
            
            IF WS-TRANSFER-SWITCH = 'T'
            
                EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC
                PERFORM 980-TRANSFER-FIELD
                EXEC CICS WRITEQ TS QUEUE(TS-NAME) FROM(TS-RECORD)
                         LENGTH(TS-LENGTH)
                END-EXEC
                
            ELSE
            
                MOVE -1 TO STUNAML
            
            END-IF.
            
            GO TO 999-SEND-MAP.
            
       900-MOVE-COLOUR.
       
             MOVE DFHTURQ TO MTITLEC,
                              UTITLEC,
                              STUNAMC,
                              RECNUMC,
                              RCLINEC(1),
                              RCLINEC(2),
                              RCLINEC(3),
                              RCLINEC(4),
                              RCLINEC(5),
                              RCLINEC(6),
                              RCLINEC(7),
                              RCLINEC(8),
                              RCLINEC(9),
                              RCLINEC(10).
       950-NOT-FOUND.

            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
            MOVE LOW-VALUES TO BWSMAPO.
            
            MOVE LK-TRANSFER TO WS-TRANSFER-SWITCH.
            
            MOVE DFHRED TO OUTMSGC.

            MOVE 'NO RECORD FOUND.' TO OUTMSGO.
            
            IF WS-TRANSFER-SWITCH = 'T'
            
                PERFORM 980-TRANSFER-FIELD
                
            ELSE
            
                MOVE -1 TO STUNAML
            
            END-IF.
            
            GO TO 999-SEND-MAP.
            
       960-TOP-OF-FILE.
            
            MOVE LK-TRANSFER TO WS-TRANSFER-SWITCH.
      
            MOVE SPACES TO RL-NUM.
            MOVE SPACES TO RL-AREA.
            MOVE SPACES TO RL-EXCH.
            MOVE SPACES TO RL-PHONE.            
            MOVE ZERO TO RL-LINE.
       
            MOVE '*BEGINNING OF FILE*' TO RL-NAME.
            
            MOVE RECORD-LINE TO RCLINEO(LINE-SUB).
            MOVE SPACES TO RCLINEO(LINE-SUB)(1:2).
            
            SUBTRACT 1 FROM LINE-SUB.
            
            PERFORM VARYING LINE-SUB FROM LINE-SUB BY -1
                                 UNTIL LINE-SUB < 1
            
                MOVE SPACES TO RCLINEO(LINE-SUB)
                
            END-PERFORM.
            
            IF WS-TRANSFER-SWITCH = 'T'
            
                EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC
                PERFORM 980-TRANSFER-FIELD
                EXEC CICS WRITEQ TS QUEUE(TS-NAME) FROM(TS-RECORD)
                         LENGTH(TS-LENGTH)
                END-EXEC
                
            ELSE
            
                MOVE 'T' TO WS-TRANSFER-SWITCH
                PERFORM 980-TRANSFER-FIELD
                EXEC CICS WRITEQ TS QUEUE(TS-NAME) FROM(TS-RECORD)
                         LENGTH(TS-LENGTH)
                END-EXEC
            
            END-IF.
            
            GO TO 999-SEND-MAP.
            
       970-END-OF-FILE.
            
            MOVE SPACES TO RL-NUM.
            MOVE SPACES TO RL-AREA.
            MOVE SPACES TO RL-EXCH.
            MOVE SPACES TO RL-PHONE.            
            MOVE ZERO TO RL-LINE.
       
            MOVE '***END OF FILE***' TO RL-NAME.
            
            MOVE RECORD-LINE TO RCLINEO(LINE-SUB).
            MOVE SPACES TO RCLINEO(LINE-SUB)(1:2).
            
            ADD 1 TO LINE-SUB.
            
            PERFORM VARYING LINE-SUB FROM LINE-SUB BY 1
                                 UNTIL LINE-SUB > 10
            
                MOVE SPACES TO RCLINEO(LINE-SUB)
                
            END-PERFORM.
            
            IF WS-TRANSFER-SWITCH = 'T'
            
                EXEC CICS DELETEQ TS QUEUE(TS-NAME) END-EXEC
                PERFORM 980-TRANSFER-FIELD
                EXEC CICS WRITEQ TS QUEUE(TS-NAME) FROM(TS-RECORD)
                         LENGTH(TS-LENGTH)
                END-EXEC
                
            ELSE
            
                MOVE 'T' TO WS-TRANSFER-SWITCH
                PERFORM 980-TRANSFER-FIELD
                EXEC CICS WRITEQ TS QUEUE(TS-NAME) FROM(TS-RECORD)
                         LENGTH(TS-LENGTH)
                END-EXEC
            
            END-IF.
            
            GO TO 999-SEND-MAP.
            
       980-TRANSFER-FIELD.
            
            MOVE DFHBMASF TO STUNAMA.
            
            MOVE DFHBMFSE TO RECNUMA.
            
            MOVE -1 TO RECNUML.
            
       990-TS-ERROR.
       
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
            MOVE LOW-VALUES TO BWSMAPO.
            
            MOVE LK-TRANSFER TO WS-TRANSFER-SWITCH.
            
            MOVE DFHRED TO OUTMSGC.

            MOVE 'TRANSFER ERROR.' TO OUTMSGO.
            
            IF WS-TRANSFER-SWITCH = 'T'
            
                PERFORM 980-TRANSFER-FIELD
                
            ELSE
            
                MOVE -1 TO STUNAML
            
            END-IF.
            
            GO TO 999-SEND-MAP.
       
       999-SEND-MAP.
            
            PERFORM 900-MOVE-COLOUR.

            EXEC CICS SEND MAP('BWSMAP') MAPSET('MVMAP3') CURSOR

            END-EXEC.

            EXEC CICS RETURN TRANSID('MV05') 
                                COMMAREA(WS-TRANSFER-SWITCH)
                                LENGTH(WS-SWITCH-LENGTH)
            END-EXEC.

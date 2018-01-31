       IDENTIFICATION DIVISION.
       PROGRAM-ID. MVPRGI.
       AUTHOR. MICHAEL VALDRON.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.
       	
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       	
       COPY 'MVMAP2'.
       COPY DFHBMSCA.
       
       01 WS-TRANSFER-FIELD             PIC XXX.
       01 WS-TRANSFER-LENGTH            PIC S9(4) COMP VALUE 3.
       
       01 WS-STUD-NUM                       PIC X(7).
       
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
       
       01 DFHCOMMAREA.
            05 LK-TRANSFER                  PIC XXX.
       
       
       PROCEDURE DIVISION.
       000-START-LOGIC.
            
            EXEC CICS HANDLE AID PF2(700-RETURN)
                                 PF9(600-EXIT-PROG)
            
            END-EXEC.
            
       		EXEC CICS HANDLE CONDITION MAPFAIL(100-FIRST-TIME) 
                          NOTFND(900-NOT-FOUND)
            END-EXEC.
            
            IF EIBCALEN = 3
            
                GO TO 100-FIRST-TIME
            
            END-IF.

         	EXEC CICS RECEIVE MAP('IAEMAP') MAPSET('MVMAP2') 
            
            END-EXEC.

       		GO TO 200-MAIN-LOGIC.

       100-FIRST-TIME.

       		MOVE LOW-VALUES TO IAEMAPO.

            MOVE 'ENTER STUDENT NUMBER' TO OUTMSGO.
            
            PERFORM 800-MOVE-COLOUR.

       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') ERASE 
            
            END-EXEC.

            EXEC CICS RETURN TRANSID('MV02') END-EXEC.

       200-MAIN-LOGIC.

            IF STUNUML IS < 7
            
                GO TO 500-SEND-ERROR-NOT-VALID-MSG
                
            ELSE IF STUNUMI IS NOT NUMERIC
            
                GO TO 400-SEND-ERROR-NOT-NUMERIC-MSG
                
       		ELSE

       			GO TO 300-READ-REC

       		END-IF.

       300-READ-REC.
            
            MOVE STUNUMI TO WS-STUD-NUM.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
       		MOVE WS-STUD-NUM TO STUFILE-STUDENT-NO.
            
            EXEC CICS READ FILE('STUFILE')
                       INTO (STUFILE-RECORD)
                       LENGTH (STUFILE-LENGTH)
                       RIDFLD (STUFILE-KEY)
            END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            MOVE STUFILE-STUDENT-NO TO STUNUMO.
            
            MOVE STUFILE-NAME TO STUNAMO.
            
            MOVE STUFILE-COURSE1-PART1 TO CCOD11O.
            
            MOVE STUFILE-COURSE1-PART2 TO CCOD12O.
                        
            MOVE STUFILE-COURSE2-PART1 TO CCOD21O.
            
            MOVE STUFILE-COURSE2-PART2 TO CCOD22O.
            
            MOVE STUFILE-COURSE3-PART1 TO CCOD31O.
            
            MOVE STUFILE-COURSE3-PART2 TO CCOD32O.
            
            MOVE STUFILE-COURSE4-PART1 TO CCOD41O.
            
            MOVE STUFILE-COURSE4-PART2 TO CCOD42O.
            
            MOVE STUFILE-COURSE5-PART1 TO CCOD51O.
            
            MOVE STUFILE-COURSE5-PART2 TO CCOD52O.
            
            MOVE STUFILE-ADDR-LINE1 TO ADDR01O.
            
            MOVE STUFILE-ADDR-LINE2 TO ADDR02O.
            
            MOVE STUFILE-ADDR-LINE3 TO ADDR03O.
            
            MOVE STUFILE-POSTAL-1 TO POSCO1O.
            
            MOVE STUFILE-POSTAL-2 TO POSCO2O.
            
            MOVE STUFILE-AREA-CODE TO AREACOO.
            
            MOVE STUFILE-EXCHANGE TO EXCHCOO.
            
            MOVE STUFILE-PHONE-NUM TO PHONUMO.
            
            MOVE DFHGREEN TO OUTMSGC.
            
            MOVE 'STUDENT RECORD FOUND!' TO OUTMSGO.
            
            PERFORM 800-MOVE-COLOUR.
            
            EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV02') END-EXEC.
            
       400-SEND-ERROR-NOT-NUMERIC-MSG.
       
            MOVE STUNUMI TO WS-STUD-NUM.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            MOVE WS-STUD-NUM TO STUNUMO.
            
            MOVE DFHRED TO OUTMSGC.

       		MOVE '*ERROR AT INPUT* - NOT NUMERIC' TO OUTMSGO.
            
            PERFORM 800-MOVE-COLOUR.

       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV02') END-EXEC.
            
       500-SEND-ERROR-NOT-VALID-MSG.
       		
            MOVE STUNUMI TO WS-STUD-NUM.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            MOVE WS-STUD-NUM TO STUNUMO.
            
            MOVE DFHRED TO OUTMSGC.

       		MOVE '*ERROR AT INPUT* - MUST BE 7 LONG' TO OUTMSGO.
            
            PERFORM 800-MOVE-COLOUR.

       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV02') END-EXEC.
            
       600-EXIT-PROG.
       
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.

       		EXEC CICS RETURN END-EXEC.
            
       700-RETURN.
       
            MOVE LOW-VALUES TO IAEMAPO.
       
            EXEC CICS XCTL PROGRAM('MVPRGM')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.
            
       800-MOVE-COLOUR.
       
            MOVE DFHYELLO TO MTITLEC,
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
                             
       900-NOT-FOUND.
       
            EXEC CICS HANDLE CONDITION 
                            NOTFND(999-SEND-ERROR-NO-RECORD-MSG)
            
            END-EXEC.
            
            EXEC CICS READ FILE('BKUPFLE')
                       INTO (STUFILE-RECORD)
                       LENGTH (STUFILE-LENGTH)
                       RIDFLD (STUFILE-KEY)
            END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            MOVE STUFILE-STUDENT-NO TO STUNUMO.
            
            MOVE STUFILE-NAME TO STUNAMO.
            
            MOVE STUFILE-COURSE1-PART1 TO CCOD11O.
            
            MOVE STUFILE-COURSE1-PART2 TO CCOD12O.
                        
            MOVE STUFILE-COURSE2-PART1 TO CCOD21O.
            
            MOVE STUFILE-COURSE2-PART2 TO CCOD22O.
            
            MOVE STUFILE-COURSE3-PART1 TO CCOD31O.
            
            MOVE STUFILE-COURSE3-PART2 TO CCOD32O.
            
            MOVE STUFILE-COURSE4-PART1 TO CCOD41O.
            
            MOVE STUFILE-COURSE4-PART2 TO CCOD42O.
            
            MOVE STUFILE-COURSE5-PART1 TO CCOD51O.
            
            MOVE STUFILE-COURSE5-PART2 TO CCOD52O.
            
            MOVE STUFILE-ADDR-LINE1 TO ADDR01O.
            
            MOVE STUFILE-ADDR-LINE2 TO ADDR02O.
            
            MOVE STUFILE-ADDR-LINE3 TO ADDR03O.
            
            MOVE STUFILE-POSTAL-1 TO POSCO1O.
            
            MOVE STUFILE-POSTAL-2 TO POSCO2O.
            
            MOVE STUFILE-AREA-CODE TO AREACOO.
            
            MOVE STUFILE-EXCHANGE TO EXCHCOO.
            
            MOVE STUFILE-PHONE-NUM TO PHONUMO.
            
            MOVE DFHGREEN TO OUTMSGC.
            
            MOVE 'RECOVERED STUDENT RECORD FOUND!' TO OUTMSGO.
            
            PERFORM 800-MOVE-COLOUR.
            
            EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV02') END-EXEC.
            
       999-SEND-ERROR-NO-RECORD-MSG.
       
            MOVE STUNUMI TO WS-STUD-NUM.
            
            EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
            MOVE LOW-VALUES TO IAEMAPO.
            
            MOVE WS-STUD-NUM TO STUNUMO.
            
            MOVE DFHRED TO OUTMSGC.

            MOVE '*ERROR AT INPUT* - NO RECORD FOUND' TO OUTMSGO.
            
            PERFORM 800-MOVE-COLOUR.

       		EXEC CICS SEND MAP('IAEMAP') MAPSET('MVMAP2') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV02') END-EXEC.

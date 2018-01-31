       IDENTIFICATION DIVISION.
       PROGRAM-ID. MVPRGM.
       AUTHOR. MICHAEL VALDRON.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.
       	
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       	
       COPY 'MVMAP1'.
       
       01 WS-TRANSFER-FIELD             PIC XXX.
       01 WS-TRANSFER-LENGTH            PIC S9(4) COMP VALUE 3.
       
       LINKAGE SECTION.
       
       01 DFHCOMMAREA.
            05 LK-TRANSFER                  PIC XXX.
       
       PROCEDURE DIVISION.
       000-START-LOGIC.

            EXEC CICS HANDLE AID PF1(300-CHOICE-1)
                                 PF2(400-CHOICE-2)
                                 PF3(500-CHOICE-3)
                                 PF4(600-CHOICE-4)
                                 PF9(700-CHOICE-9)
            
            END-EXEC.
       
       		EXEC CICS HANDLE CONDITION MAPFAIL(100-FIRST-TIME) 
            
            END-EXEC.
            
            IF EIBCALEN = 3
            
                GO TO 100-FIRST-TIME
            
            END-IF.

         	EXEC CICS RECEIVE MAP('MNUMAP') MAPSET('MVMAP1') 
            
            END-EXEC.

       		GO TO 200-MAIN-LOGIC.

       100-FIRST-TIME.

       		MOVE LOW-VALUES TO MNUMAPO.      

       		EXEC CICS SEND MAP('MNUMAP') MAPSET('MVMAP1') ERASE 
            
            END-EXEC.

            EXEC CICS RETURN TRANSID('MV01') END-EXEC.

       200-MAIN-LOGIC.

       		IF CHOICEI IS EQUAL TO '1'

       			GO TO 300-CHOICE-1

       		ELSE IF CHOICEI IS EQUAL TO '2'

       			GO TO 400-CHOICE-2

            ELSE IF CHOICEI IS EQUAL TO '3'

       			GO TO 500-CHOICE-3

       		ELSE IF CHOICEI IS EQUAL TO '4'

       			GO TO 600-CHOICE-4

       		ELSE IF CHOICEI IS EQUAL TO '9'

       			GO TO 700-CHOICE-9

       		ELSE

       			GO TO 999-SEND-ERROR-MSG

       		END-IF.

       300-CHOICE-1.

       		MOVE LOW-VALUES TO MNUMAPO.

       		EXEC CICS XCTL PROGRAM('MVPRGE')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.

       		EXEC CICS RETURN TRANSID('MV03') END-EXEC.

       400-CHOICE-2.
            
            MOVE LOW-VALUES TO MNUMAPO.

       		EXEC CICS XCTL PROGRAM('MVPRGI')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.

       		EXEC CICS RETURN TRANSID('MV02') END-EXEC.

       500-CHOICE-3.

            MOVE LOW-VALUES TO MNUMAPO.

       		EXEC CICS XCTL PROGRAM('MVPRGU')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.

       		EXEC CICS RETURN TRANSID('MV04') END-EXEC.

       600-CHOICE-4.

            MOVE LOW-VALUES TO MNUMAPO.

       		EXEC CICS XCTL PROGRAM('MVPRGB')
                           COMMAREA(WS-TRANSFER-FIELD)
                           LENGTH(WS-TRANSFER-LENGTH)
            END-EXEC.

       		EXEC CICS RETURN TRANSID('MV05') END-EXEC.

       700-CHOICE-9.

       		EXEC CICS SEND CONTROL ERASE FREEKB END-EXEC.
            
       		EXEC CICS RETURN END-EXEC.

       999-SEND-ERROR-MSG.

       		MOVE LOW-VALUES TO MNUMAPO.

       		MOVE 'ENTER A CHOICE FROM 1 TO 9' TO OUTMSGO.

       		EXEC CICS SEND MAP('MNUMAP') MAPSET('MVMAP1') END-EXEC.

       		EXEC CICS RETURN TRANSID('MV01') END-EXEC.


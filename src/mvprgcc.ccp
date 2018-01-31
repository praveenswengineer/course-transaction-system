       $SET DB2 (DB=INFOSYS,UDB-VERSION=V8)
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MVPRGCC.
       AUTHOR. MICHAEL VALDRON.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       
       SOURCE-COMPUTER. RS-6000.
       OBJECT-COMPUTER. RS-6000.
       	
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01 WS-SQL-CODE                   PIC 9(9)-.
           
           EXEC SQL INCLUDE SQLCA END-EXEC.
           
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
           
           01 SQL-COURSE-CODE           PIC X(8).
           01 SQL-COURSE-DESC           PIC X(17).
           
           EXEC SQL END DECLARE SECTION END-EXEC.
       
       LINKAGE SECTION.
       
       01 DFHCOMMAREA.
           05 LK-COURSE                 PIC X(8).
           05 LK-DESC                   PIC X(17).
       
       PROCEDURE DIVISION.
       
           EXEC SQL WHENEVER NOT FOUND GO TO 200-COURSE-ERROR END-EXEC.
           EXEC SQL WHENEVER SQLERROR GO TO 999-SQL-ERROR END-EXEC.
           EXEC SQL WHENEVER SQLWARNING CONTINUE END-EXEC.
           
           PERFORM 100-CHECK-COURSE THRU 300-EXIT.
           
           EXEC CICS RETURN END-EXEC.
       
       100-CHECK-COURSE.
       
           MOVE LK-COURSE TO SQL-COURSE-CODE.
           
           EXEC SQL SELECT COURSE_DESC INTO :SQL-COURSE-DESC
                      FROM BILLM.COURSE_CODES
                      WHERE COURSE_CODE = :SQL-COURSE-CODE
           END-EXEC.
           
           MOVE SQL-COURSE-DESC TO LK-DESC.
           
           GO TO 300-EXIT.
       
       200-COURSE-ERROR.
       
           MOVE 'COURSE NOT FOUND' TO LK-DESC.
           
       300-EXIT.
       
           EXIT.
       
       999-SQL-ERROR.
       
           MOVE SQLCODE TO WS-SQL-CODE.
           MOVE WS-SQL-CODE TO LK-DESC.
           EXEC CICS RETURN END-EXEC.
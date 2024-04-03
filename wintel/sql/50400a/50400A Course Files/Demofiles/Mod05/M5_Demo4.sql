/* Create audit entries to the Windows application log, log the failed logon, and enable server auditing */

USE master ;
GO
CREATE SERVER AUDIT Test_SQL_Server_Audit TO APPLICATION_LOG WITH ( QUEUE_DELAY = 1000,  ON_FAILURE = CONTINUE);
GO
CREATE SERVER AUDIT SPECIFICATION Test_Server_Audit_Specification FOR SERVER AUDIT Test_SQL_Server_Audit ADD (FAILED_LOGIN_GROUP); 
--Enable the audit
ALTER SERVER AUDIT Test_SQL_Server_Audit WITH (STATE = ON);
GO 

--------------------------------------------------------------------------------------------------------------------------------------------

/* Add audit entries to the Windows application log, log INSERT operations, and enable server auditing */

USE master ;
GO
CREATE SERVER AUDIT Security_Audit
    TO APPLICATION_LOG WITH ( QUEUE_DELAY = 1000,  ON_FAILURE = CONTINUE);

ALTER SERVER AUDIT Security_Audit 
WITH (STATE = ON) ;
GO
USE QuantamCorp ;
GO
CREATE DATABASE AUDIT SPECIFICATION Audit_Pay_Tables
FOR SERVER AUDIT Security_Audit
ADD (SELECT , INSERT
     ON HumanResources.EmployeePayHistory BY dbo )
WITH (STATE = ON) ;
GO
INSERT INTO HumanResources.EmployeePayHistory (BusinessEntityID,RateChangeDate,Rate,PayFrequency,ModifiedDate) VALUES (1,GETDATE(),100,1,GETDATE())

--------------------------------------------------------------------------------------------------------------------------------------------
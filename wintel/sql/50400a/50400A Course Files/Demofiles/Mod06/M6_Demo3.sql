/* Create a test table MsgLog */

USE QuantamCorp
GO
CREATE TABLE MsgLog (log_date datetime, message xml)
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Enable service broker */

ALTER DATABASE QuantamCorp SET ENABLE_BROKER
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a service broker queue */

CREATE QUEUE NotifyQueue 
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a stored procedure to log information from event notifications */

CREATE PROCEDURE usp_RecordMessage
AS 

            SET NOCOUNT ON;
            DECLARE @Handle UNIQUEIDENTIFIER;
            DECLARE @MessageType SYSNAME;
            DECLARE @Message XML;

      

            WAITFOR (RECEIVE 
                  @Handle = conversation_handle,
                  @MessageType = message_type_name, 
                  @Message = message_body
            FROM [NotifyQueue]),TIMEOUT 2000;            
                
            IF(@Handle IS NOT NULL AND @Message IS NOT NULL)
            BEGIN

                  INSERT INTO MsgLog (log_date ,[Message])
                  VALUES(GETDATE(),@Message);
            END

GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Modify the queue object to support automatic activation */

ALTER QUEUE NotifyQueue WITH ACTIVATION (
      STATUS = ON,
      MAX_QUEUE_READERS = 1,
      PROCEDURE_NAME = usp_RecordMessage,
      EXECUTE AS OWNER

);;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a service between the queue and the event notification messages */

CREATE SERVICE NotifyService
ON QUEUE NotifyQueue
([http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]);
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Route messages to the service */

CREATE ROUTE NotifyRoute
WITH SERVICE_NAME = 'NotifyService',
ADDRESS = 'LOCAL';
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create an event notification */

CREATE EVENT NOTIFICATION log_ddl1 
ON DATABASE 
FOR CREATE_TABLE 
TO SERVICE 'NotifyService',
    'current database' ;

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create the table1 table */

USE QuantamCorp
GO
CREATE TABLE table1 (id int)

--------------------------------------------------------------------------------------------------------------------------------------------

/* Check if any information is listed in the MsgLog table */

Use QuantamCorp
GO
SELECT * FROM MsgLog

--------------------------------------------------------------------------------------------------------------------------------------------

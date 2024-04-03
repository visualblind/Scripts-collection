/* Create a table DDL_Log, a trigger Triggerlog, and then log the event information to the DDL_Log table */

USE QuantamCorp
GO
CREATE TABLE DDL_Log 
(
PostTime datetime, 
DB_User nvarchar (100), 
Event nvarchar (100), 
TSQL nvarchar (2000)
)
GO
CREATE TRIGGER Triggerlog 
ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS 
AS
DECLARE @data XML
SET @data = EVENTDATA()
INSERT ddl_log 
   (PostTime, DB_User, Event, TSQL) 
   VALUES 
   (GETDATE(), 
   CONVERT(nvarchar(100), CURRENT_USER), 
   @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
   @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)') ) ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create and drop the TestTable table */

CREATE TABLE TestTable (col_key int)
DROP TABLE TestTable ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Retrieve data stored in the ddl_log table */

SELECT * FROM ddl_log 

--------------------------------------------------------------------------------------------------------------------------------------------
CREATE TRIGGER log 
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

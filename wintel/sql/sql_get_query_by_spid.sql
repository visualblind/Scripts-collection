--Get your session id
SELECT @@SPID
GO

--Get query of spid in our input buffer
DBCC INPUTBUFFER(61)
GO


--There are several ways to find out what is the latest run query from system table sys.sysprocesses.

DECLARE @sqltext VARBINARY(128)
SELECT @sqltext = sql_handle
FROM sys.sysprocesses
WHERE spid = 61
SELECT TEXT
FROM sys.dm_exec_sql_text(@sqltext)
GO


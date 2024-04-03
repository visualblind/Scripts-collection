SELECT name, physical_name
FROM sys.master_files
WHERE database_id = DB_ID('tempdb');

USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, FILENAME = 'g:\tempdb.mdf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME = templog, FILENAME = 'g:\templog.ldf');
GO
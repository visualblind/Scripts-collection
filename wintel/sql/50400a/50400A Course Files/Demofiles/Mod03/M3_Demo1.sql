/* check the database structure */

USE QuantamCorp;
GO
DBCC CHECKFILEGROUP;
GO
DBCC CHECKTABLE ("HumanResources.Employee");
GO
DBCC CHECKALLOC
GO
--------------------------------------------------------------------------------------------------------------------------------------------

/* shrink a file and a database */

USE QuantamCorp;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE QuantamCorp
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (QuantamCorp_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE QuantamCorp
SET RECOVERY FULL;
GO
USE QuantamCorp;
GO
SELECT file_id, name
FROM sys.database_files;
GO
DBCC SHRINKFILE (1, TRUNCATEONLY);
GO 
DBCC SHRINKDATABASE (QuantamCorp, TRUNCATEONLY);  

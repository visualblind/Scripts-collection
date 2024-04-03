/* Set recovery mode of the database to FULL */

USE master;
GO
ALTER DATABASE Mod11 
SET RECOVERY FULL;
GO

/* Backup the database and the log file */

BACKUP DATABASE Mod11 
    TO DISK = 'D:\Data\Mod11.bak' 
    WITH FORMAT
GO
BACKUP LOG Mod11 
    TO DISK = 'D:\Data\Mod11_log.bak' 
GO

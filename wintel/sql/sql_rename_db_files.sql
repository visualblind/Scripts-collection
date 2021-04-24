ALTER DATABASE HCM_CHCC SET OFFLINE
GO
ALTER DATABASE HCM_CHCC SET ONLINE
GO


ALTER
DATABASE HCM_CHUC
SET
SINGLE_USER With
ROLLBACK IMMEDIATE

USE [master]
ALTER
DATABASE HCM_CHUC
SET MULTI_USER;


ALTER DATABASE HCM_CHCC MODIFY FILE (NAME =HCM_CHUC_Log, FILENAME = 'E:\Logs\HCM_CHCC.ldf')
GO

--if changing log file name
ALTER DATABASE  databaseNAme MODIFY FILE (NAME = db_log, FILENAME =
'C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\Data\db.ldf')
GO

ALTER DATABASE databaseName SET ONLINE
GO










SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'SI_TCIP');

ALTER DATABASE SI_TCIP SET OFFLINE WITH ROLLBACK IMMEDIATE

ALTER DATABASE SI_TCIP MODIFY FILE(name=SI_TCIP, filename=N'D:\Data\SI_TCIP.mdf')
ALTER DATABASE SI_TCIP MODIFY FILE(name=SI_TCIP_log, filename=N'e:\Logs\SI_TCIP_log.LDF')

SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'SI_TCIP');

ALTER DATABASE SI_TCIP SET ONLINE
USE [master];
GO
--Disconnect all existing session.
ALTER DATABASE VeeamBackup SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
--Change database in to OFFLINE mode.
ALTER DATABASE VeeamBackup SET OFFLINE

--Rename the physical database files in the OS
--After physical rename proceed with the Alter Database Modify File
ALTER DATABASE VeeamBackup MODIFY FILE (Name='VeeamBackup', FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL11.VEEAMSQL2012\MSSQL\DATA\VeeamBackup.mdf')
GO
ALTER DATABASE VeeamBackup MODIFY FILE (Name='VeeamBackup_log', FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL11.VEEAMSQL2012\MSSQL\DATA\VeeamBackup_log.ldf')
GO

ALTER DATABASE VeeamBackup SET ONLINE
Go
ALTER DATABASE VeeamBackup SET MULTI_USER
Go
Restore database logshiptest from disk = 'C:\logshiptest\first_backup.bak' with NORECOVERY,
MOVE 'logshiptest' to 'C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\Data\logshiptest.mdf',
MOVE 'logshiptest_log' to 'C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\Data\logshiptest_log.ldf'





#Restore database to recovery mode without restoring db or log files
Restore database DBName with Recovery



USE master
GO
-- First determine the number and names of the files in the backup.
-- AdventureWorks2008R2_Backup is the name of the backup device.
RESTORE FILELISTONLY
   FROM AdventureWorks2008R2_Backup
-- Restore the files for MyAdvWorks.
RESTORE DATABASE MyAdvWorks
   FROM AdventureWorks2008R2_Backup
   WITH RECOVERY,
   MOVE 'AdventureWorks2008R2_Data' TO 'D:\MyData\MyAdvWorks_Data.mdf', 
   MOVE 'AdventureWorks2008R2_Log' TO 'F:\MyLog\MyAdvWorks_Log.ldf'
GO
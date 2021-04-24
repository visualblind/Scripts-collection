ps_10180



USE master;
GO
CREATE DATABASE MyAdventureWorks 
    ON (FILENAME = 'C:\MySQLServer\AdventureWorks2008R2_Data.mdf'),
    (FILENAME = 'C:\MySQLServer\AdventureWorks2008R2_Log.ldf')
    FOR ATTACH;
GO



------------------------------------------------------------------

EXEC sp_attach_db @dbname = 'PS_LAVI', 
     @filename1 = 'D:\Data\PS_LAVI.mdf', 
     @filename2 = 'E:\Logs\PS_LAVI_log.LDF'
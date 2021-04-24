USE Master; 
GO  
SET NOCOUNT ON 

-- 1 - Variable declaration 
DECLARE @dbName sysname 
DECLARE @backupPath NVARCHAR(500) 
DECLARE @cmd NVARCHAR(500) 
DECLARE @fileList TABLE (backupFile NVARCHAR(255)) 
DECLARE @lastFullBackup NVARCHAR(500) 
DECLARE @lastDiffBackup NVARCHAR(500) 
DECLARE @backupFile NVARCHAR(500) 

-- 2 - Initialize variables 
SET @dbName = 'Millennium' 
SET @backupPath = 'E:\logship\' 

-- 3 - get list of files 
SET @cmd = 'DIR /b ' + @backupPath 

INSERT INTO @fileList(backupFile) 
EXEC master.sys.xp_cmdshell @cmd 

-- 5 - check for log backups 
DECLARE backupFiles CURSOR FOR  
   SELECT backupFile  
   FROM @fileList 
   WHERE backupFile LIKE '%.TRN'  
   AND backupFile LIKE @dbName + '%' 
   AND backupFile > @lastFullBackup 

OPEN backupFiles  

-- Loop through all the files for the database  
FETCH NEXT FROM backupFiles INTO @backupFile  

WHILE @@FETCH_STATUS = 0  
BEGIN  
   SET @cmd = 'RESTORE LOG ' + @dbName + ' FROM DISK = '''  
       + @backupPath + @backupFile + ''' WITH NORECOVERY' 
   PRINT @cmd 
   FETCH NEXT FROM backupFiles INTO @backupFile  
END 

CLOSE backupFiles  
DEALLOCATE backupFiles
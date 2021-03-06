/* Iterate through db's and replace string */
DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL=COALESCE(@SQL+';','')+'UPDATE '+QUOTENAME(Name)+'.dbo.SPath
SET PATH = REPLACE(path,''OldServer'',''NewServer'')'
FROM sys.databases
WHERE Name LIKE 'PS_%' OR Name LIKE 'SI_%'
EXEC sp_executesql @SQL

--
USE DB1
SELECT path FROM DB1.dbo.SPath WHERE path LIKE '%StringToSearch%'
  
USE DatabaseName
UPDATE SPath
SET path = REPLACE(path,'OldServer','NewServer')

DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL=COALESCE(@SQL+';','')+'DELETE FROM '+QUOTENAME(Name)+'.dbo.dbFlags WHERE label = ''SkipUsrSec''
DELETE FROM '+QUOTENAME(Name)+'.dbo.dbFlags WHERE label = ''SkipCoSec''
INSERT INTO '+QUOTENAME(Name)+'.dbo.dbFlags (label,i1) VALUES (''SkipUsrSec'',1)
INSERT INTO '+QUOTENAME(Name)+'.dbo.dbFlags (label,i1) VALUES (''SkipCoSec'',1)'
FROM sys.databases
WHERE Name LIKE 'PS_%' OR Name LIKE 'SI_%'
EXEC sp_executesql @SQL

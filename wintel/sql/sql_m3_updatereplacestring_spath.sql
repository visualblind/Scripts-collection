/* replace string */
Use PS_Imp
select path from PS_Imp.dbo.SPath where path LIKE '%OldSvrName%'
update SPath
set path = REPLACE(path,'OldSvrName','NewSvrName')


/* Iterate through db's and replace string */
DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL=COALESCE(@SQL+';','')+'UPDATE '+QUOTENAME(Name)+'.dbo.SPath
SET PATH = REPLACE(path,''OldSvrName'',''NewSvrName'')'
FROM sys.databases
WHERE Name LIKE 'PS_%' OR Name LIKE 'SI_%'
EXEC sp_executesql @SQL
select outputDirSpecific from Application-Name.dbo.Rproperty WHERE outputDirSpecific IS NOT NULL AND outputDirSpecific != '' ORDER BY outputDirSpecific

select outputDirSpecific from Application-Name.dbo.Rproperty WHERE outputDirSpecific LIKE '%Server-Name1%' ORDER BY outputDirSpecific
select outputDirSpecific from Application-Name.dbo.Rproperty WHERE outputDirSpecific LIKE '%Server-Name2%' ORDER BY outputDirSpecific
select outputDirSpecific, outputFilenameSpecific from Application-Name.dbo.Rproperty WHERE outputDirSpecific LIKE '%Domain.org%' ORDER BY outputDirSpecific


\\Domain.org\DFS\Clients

/** Start audited changes **/

/** Reports **/
UPDATE Application-Name.dbo.Rproperty SET outputDirSpecific = REPLACE(outputDirSpecific,'\\Server-Name11\clients','\\Domain.org\DFS\Clients')
UPDATE Application-Name.dbo.Rproperty SET outputDirSpecific = REPLACE(outputDirSpecific,'\\Server-Name11\shared','\\Domain.org\DFS\Shared')
UPDATE Application-Name.dbo.Rproperty SET outputDirSpecific = REPLACE(outputDirSpecific,'\\Server-Name11\Money','\\Domain.org\DFS\Money')
UPDATE Application-Name.dbo.Rproperty SET outputDirSpecific = REPLACE(outputDirSpecific,'\\Server-Name2\clients','\\Domain.org\DFS\Clients')
UPDATE Application-Name.dbo.Rproperty SET outputDirSpecific = REPLACE(outputDirSpecific,'\\Server-Name2\shared','\\Domain.org\DFS\Shared')

/** Time Import **/
UPDATE Application-Name.dbo.CService 
SET options = CAST(REPLACE(CAST(options as NVarchar(MAX)),'\\Server-Name11\clients','\\Domain.org\DFS\Clients') AS NText)
WHERE options LIKE '%Server-Name11%' 

UPDATE Application-Name.dbo.CService 
SET options = CAST(REPLACE(CAST(options as NVarchar(MAX)),'\\Server-Name11\shared','\\Domain.org\DFS\Shared') AS NText)
WHERE options LIKE '%Server-Name11%' 

/** Signatures **/
ALTER TABLE Table1 DISABLE TRIGGER Table1_Auto_Delete
ALTER TABLE Table1 DISABLE TRIGGER Table1_Auto_Insert
ALTER TABLE Table1 DISABLE TRIGGER Table1_Auto_Update
GO
UPDATE Table1 SET Column1 = REPLACE(Column1,'\\Server-Name11\shared','\\Domain.org\DFS\Shared')
ALTER TABLE Table1 ENABLE TRIGGER Table1_Auto_Delete
ALTER TABLE Table1 ENABLE TRIGGER Table1_Auto_Insert
ALTER TABLE Table1 ENABLE TRIGGER Table1_Auto_Update
GO

/** Logos **/
ALTER TABLE Table1 DISABLE TRIGGER Table1_Auto_Delete
ALTER TABLE Table1 DISABLE TRIGGER Table1_Auto_Insert
ALTER TABLE Table1 DISABLE TRIGGER Table1_Auto_Update
GO
UPDATE Table1 SET logoImageFile = REPLACE(logoImageFile,'\\Server-Name11\shared','\\Domain.org\DFS\Shared')
ALTER TABLE Table1 ENABLE TRIGGER Table1_Auto_Delete
ALTER TABLE Table1 ENABLE TRIGGER Table1_Auto_Insert
ALTER TABLE Table1 ENABLE TRIGGER Table1_Auto_Update
GO
/** End audited changes **/

Select * from CService where service = 'Import' AND options LIKE '%Domain.org%'
Select * from Application-Name.dbo.CService where service = 'Import' and options LIKE '%Server-Name11%'

select Column1 from Table1 WHERE Column1 IS NOT NULL AND Column1 != '' ORDER BY Column1
select Column1, logoImageFile from Table1 WHERE Column1 IS NOT NULL AND Column1 != '' ORDER BY Column1
select logoImageFile from Table1 WHERE logoImageFile IS NOT NULL AND logoImageFile != ''

select * from Table1
Select Column1, logoImageFile from SBankAccountDetail WHERE Column1 IS NOT NULL AND Column1 != ''
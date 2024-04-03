/* Create a full-text catalog, a full-text stoplist, a full-text index, and configure full-text indexing for stoplists */

USE QuantamCorp;
GO
CREATE FULLTEXT CATALOG Mod03_Demo2;
CREATE FULLTEXT STOPLIST DemoStopList FROM SYSTEM STOPLIST;
GO
CREATE FULLTEXT INDEX ON HumanResources.Employee(JobTitle)
KEY INDEX PK_Employee_BusinessEntityID
WITH STOPLIST = DemoStopList; 
GO
SELECT fulltextcatalogproperty('Mod03_Demo2', 'ItemCount'); 
GO
--------------------------------------------------------------------------------------------------------------------------------------------

/* Configure full-text indexing for thesaurus */

EXEC sys.sp_fulltext_load_thesaurus_file 1033;
GO
USE QuantamCorp;
GO
SELECT fulltextcatalogproperty('Mod03_Demo2', 'ItemCount'); 
GO
USE QuantamCorp;
GO
SELECT LoginID
FROM HumanResources.Employee
WHERE CONTAINS(JobTitle, ' "Officer" '); 
GO
SELECT LoginID
FROM HumanResources.Employee
WHERE FREETEXT(JobTitle, ' "Officer" ')
GO

--------------------------------------------------------------------------------------------------------------------------------------------



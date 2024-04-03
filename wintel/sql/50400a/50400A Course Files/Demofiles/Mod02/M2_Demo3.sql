/* Modify the collation of the HumanResources.Department table to Danish_Norwegian_CS_AS */

USE QuantamCorp
SELECT * FROM HumanResources.Department ORDER BY GroupName
GO
ALTER TABLE HumanResources.Department ALTER COLUMN GroupName nvarchar(50) COLLATE Danish_Norwegian_CS_AS
GO
--------------------------------------------------------------------------------------------------------------------------------------------

/* Modify the collation of the HumanResources.Department table to Latin1_General_CI_AS */

SELECT * FROM HumanResources.Department ORDER BY GroupName
GO
ALTER TABLE HumanResources.Department ALTER COLUMN GroupName nvarchar(50) COLLATE Latin1_General_CI_AS
GO
SELECT * FROM HumanResources.Department ORDER BY GroupName
GO

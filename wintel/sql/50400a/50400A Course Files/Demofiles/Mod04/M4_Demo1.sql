/* Set the statistics xml option on and retrieve records from the HumanResources.Department table */

USE QuantamCorp;
GO
SET STATISTICS XML ON;
GO
SELECT Name 
FROM HumanResources.Department
WHERE DepartmentID = '1';
GO
SELECT Name, GroupName 
FROM HumanResources.Department
WHERE GroupName LIKE 'Sales%';
GO
SET STATISTICS XML OFF;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Disable auto update statistics */

ALTER DATABASE QuantamCorp SET AUTO_UPDATE_STATISTICS OFF
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create manual statistics */

CREATE STATISTICS HRDepartment
    ON HumanResources.Department (DepartmentID,Name,GroupName)
    WITH FULLSCAN, NORECOMPUTE;

--------------------------------------------------------------------------------------------------------------------------------------------

/* Compare the result obtained by running the SET STATISTICS command with the HRDepartment statistics */

DBCC SHOW_STATISTICS ('HumanResources.Department', HRDepartment)

--------------------------------------------------------------------------------------------------------------------------------------------

/* Insert data into the HumanResources.Department table */

USE QuantamCorp
GO
DBCC CHECKIDENT ('HumanResources.Department', RESEED, 3000);
GO

DECLARE @i int

SET @i=1

WHILE @i<1000
BEGIN

 INSERT INTO HumanResources.Department VALUES
 ('Name '+CAST(@i AS varchar(20)), 'GroupName '+CAST(@i AS varchar(20)),GETDATE())
SET @i=@i+1
END 

------------------------------------------------------------------------------------------------------------------------------------------


/* Enable auto update statistics, auto create statistics, and auto update statistics async */

ALTER DATABASE QuantamCorp SET AUTO_UPDATE_STATISTICS ON, AUTO_CREATE_STATISTICS ON, AUTO_UPDATE_STATISTICS_ASYNC ON

--------------------------------------------------------------------------------------------------------------------------------------------
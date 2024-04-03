/* Create a distributed transaction */

USE QuantamCorp;
GO
EXEC sp_addlinkedserver   
   @server='RemoteServer', 
   @srvproduct='',
   @provider='SQLNCLI', 
   @datasrc='NYC-SQL1\DEVELOPMENT'
GO
SET XACT_ABORT ON
BEGIN DISTRIBUTED TRANSACTION;
-- Insert sample data into a table.
INSERT INTO QuantamCorp.HumanResources.Department (Name,GroupName, ModifiedDate) VALUES ('test','test',GETDATE())
INSERT INTO RemoteServer.QuantamCorp.HumanResources.Department (Name,GroupName, ModifiedDate) VALUES ('test','test',GETDATE())
-- Delete candidate from local instance.
DELETE QuantamCorp.HumanResources.Department WHERE DepartmentID = (SELECT MAX(DepartmentID) FROM QuantamCorp.HumanResources.Department);
-- Delete candidate from remote instance.
DELETE RemoteServer.QuantamCorp.HumanResources.Department WHERE DepartmentID = (SELECT MAX(DepartmentID) FROM RemoteServer.QuantamCorp.HumanResources.Department);
COMMIT TRANSACTION; 
GO	

----------------------------------------------------------------------------------------------------------------------------------------------

/* Retrieve database records from the local server */

SELECT * FROM QuantamCorp.HumanResources.Department

-------------------------------------------------------------------------------------------------------------------------------------------

/* Retrieve database records from the remote server */

SELECT * FROM RemoteServer.QuantamCorp.HumanResources.Department 
GO


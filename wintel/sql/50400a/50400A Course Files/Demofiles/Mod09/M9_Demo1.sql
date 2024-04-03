/* Add an instance of SQL Server as a linked server */

USE master;
GO
EXEC sp_addlinkedserver   
   @server='VAN-SQL', 
-- NYC-SQL1 represents the remote server.
   @srvproduct='',
   @provider='SQLNCLI', 
   @datasrc='NYC-SQL1' 
-- NYC-SQL1 represents the host server.

----------------------------------------------------------------------------------------------------------------------------------------------

/* Enable linked server for self mapping of credentials */

EXEC sp_addlinkedsrvlogin 'NYC-SQL1', 'true'
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Verify if the linked table is working */

SELECT * FROM [NYC-SQL1].QuantamCorp.sys.tables

----------------------------------------------------------------------------------------------------------------------------------------------

/* Add and link a linked server record to an excel file and retrieve the information of the excel file */

EXEC sp_addlinkedserver @server = N'ExcelDataSource', 
@srvproduct=N'ACE 12.0', @provider=N'Microsoft.ACE.OLEDB.12.0', 
@datasrc=N'D:\Demofiles\Person.xlsx',
@provstr='Excel 12.0' ;
------------------------------------------------------------------------------------------------------------------------------------------------------
/*retrieve the information of the excel file */

SELECT * FROM ExcelDataSource...[Person$]

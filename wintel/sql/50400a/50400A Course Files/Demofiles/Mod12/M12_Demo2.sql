/* Add a file and a filegroup to the database and set the filegroup with default settings */

USE [master]
GO
ALTER DATABASE [QuantamCorp] ADD FILEGROUP [Data]
GO
ALTER DATABASE [QuantamCorp] ADD FILE ( NAME = N'ConData', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\ConData.ndf' , SIZE = 2048KB , FILEGROWTH = 1024KB ) TO FILEGROUP [Data]
GO
ALTER DATABASE [QuantamCorp] MODIFY FILEGROUP [Data] DEFAULT
GO
CREATE TABLE Table1(id int)
GO

----------------------------------------------------------------------------------------------------------------------------------------------


/* Create a backup of the Primary and the Data filegroups of the database */

BACKUP DATABASE QuantamCorp FILEGROUP='Primary'	
 TO DISK = 'D:\Demofiles\QuantamCorpPri.bak'
   GO
BACKUP DATABASE QuantamCorp FILEGROUP='Data'	
 TO DISK = 'D:\Demofiles\QuantamCorpData.bak'
   WITH FORMAT;
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Create a transaction log backup with the FORMAT option */

BACKUP LOG QuantamCorp 
 TO DISK = 'D:\Demofiles\QuantamCorpLog.bak'
   WITH FORMAT;
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Modify the database content */

Use QuantamCorp
UPDATE Production.Product
   SET ListPrice = ListPrice * 1.10
   WHERE ProductNumber LIKE 'BK-%';
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Create a tail log backup with the NORECOVERY and the NO_TRUNCATE options */

Use master;
BACKUP LOG QuantamCorp TO DISK = 'D:\Demofiles\QuantamCorpTailLog.bak'  WITH NORECOVERY, NO_TRUNCATE
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore a primary filegroup of a database with the FILEGROUP, the PARTIAL and the NORECOVERY options */

RESTORE DATABASE QuantamCorp FILEGROUP='Primary' FROM DISK = 'D:\Demofiles\QuantamCorpPri.bak'   WITH PARTIAL, NORECOVERY
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore the transaction log file with the NORECOVERY option */

RESTORE LOG QuantamCorp FROM DISK='D:\Demofiles\QuantamCorpLog.bak'  WITH NORECOVERY
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore the tail log file with the RECOVERY option */

RESTORE LOG QuantamCorp FROM DISK='D:\Demofiles\QuantamCorpTailLog.bak'  WITH RECOVERY
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Retrieve records from a system table and a user-defined table */

SELECT * FROM sys.tables
GO
Use QuantamCorp
SELECT * FROM Production.Product
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore a file and the transaction log file with the NORECOVERY option */

use master
RESTORE DATABASE QuantamCorp FILE='ConData' FROM DISK = 'D:\Demofiles\QuantamCorpData.bak'   WITH  NORECOVERY
GO
Use master
RESTORE LOG QuantamCorp FROM DISK= 'D:\Demofiles\QuantamCorpLog.bak'  WITH NORECOVERY
GO
Use master
RESTORE LOG QuantamCorp FROM DISK='D:\Demofiles\QuantamCorpTailLog.bak'  WITH RECOVERY
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore the tail log backup with the RECOVERY option */

Use QuantamCorp
SELECT * FROM Production.Product
GO


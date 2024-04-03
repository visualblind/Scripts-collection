/* Set the database recovery model to FULL and create a backup of a database */

Use master;
ALTER DATABASE QuantamCorp SET RECOVERY FULL;
GO
BACKUP DATABASE QuantamCorp
 TO DISK = 'D:\Demofiles\QuantamCorp.bak'
   WITH FORMAT;
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Create a backup of the transaction log */

BACKUP LOG QuantamCorp
 TO DISK = 'D:\Demofiles\QuantamCorpLog.bak'
   WITH FORMAT, NORECOVERY;
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore the database backup with the NORECOVERY option */

RESTORE DATABASE QuantamCorp
   FROM DISK = 'D:\Demofiles\QuantamCorp.bak'
   WITH NORECOVERY;
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore the transaction log backup */

RESTORE LOG QuantamCorp
   FROM DISK = 'D:\Demofiles\QuantamCorpLog.bak'
   WITH STOPAT = '<YYYY-MM-DD>';
GO

----------------------------------------------------------------------------------------------------------------------------------------------

/* Restore the database backup with the RECOVERY option */

RESTORE DATABASE QuantamCorp WITH RECOVERY;

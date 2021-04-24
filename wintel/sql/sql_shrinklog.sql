DBCC SHRINKFILE(<filename>,<desired_shrink_size>)
DBCC SHRINKFILE('PS_10150_log',8000)


-------

USE DatabaseName
GO
DBCC SHRINKFILE(<TransactionLogName>, 1)
BACKUP LOG <DatabaseName> WITH TRUNCATE_ONLY
DBCC SHRINKFILE(<TransactionLogName>, 1)
GO
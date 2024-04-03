/* Check the disk consumption with different compression */

EXEC sp_estimate_data_compression_savings 'Production', 'WorkOrderRouting', NULL, NULL, 'ROW' ;
GO 
EXEC sp_estimate_data_compression_savings 'Production', 'WorkOrderRouting', NULL, NULL, 'PAGE' ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Enable row compression on the Production.WorkOrderRouting table */

ALTER TABLE Production.WorkOrderRouting REBUILD WITH (DATA_COMPRESSION=ROW)
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Enable page compression on the Production.WorkOrderRouting table */

ALTER TABLE Production.WorkOrderRouting REBUILD WITH (DATA_COMPRESSION=PAGE)
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Check the status of the compressed table and index */

SELECT * FROM sys.dm_db_index_operational_stats(DB_ID(N'QuantamCorp'), OBJECT_ID(N'QuantamCorp.Production.WorkOrderRouting'), NULL, NULL);

--------------------------------------------------------------------------------------------------------------------------------------------
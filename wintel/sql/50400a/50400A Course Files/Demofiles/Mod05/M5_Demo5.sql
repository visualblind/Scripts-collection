/* Create TestTable and enable change data capture on it */

USE QuantamCorp
GO
CREATE TABLE TestTable 
 (
id int,
content varchar(200),
create_date datetime
)

GO
EXEC sys.sp_cdc_enable_db
GO
EXEC sys.sp_cdc_enable_table N'dbo', N'TestTable',DEFAULT,DEFAULT, 1
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Make changes to the TestTable */

INSERT INTO TestTable (id,content,create_date) VALUES (1,'Test',GETDATE())
INSERT INTO TestTable (id,content,create_date) VALUES (2,'Test',GETDATE())
GO
UPDATE TestTable SET create_date=GETDATE(), content='test2' WHERE id=1
GO
DELETE TestTable WHERE id=2

--------------------------------------------------------------------------------------------------------------------------------------------

/* Get all changes captured in cdc.fn_cdc_get_all_changes_dbo_TestTable */

SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_TestTable
(sys.fn_cdc_get_min_lsn('dbo_TestTable'), sys.fn_cdc_get_max_lsn(),N'all')

--------------------------------------------------------------------------------------------------------------------------------------------
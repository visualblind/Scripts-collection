/*Clear all data from the CallDetails table and insert new records in the table*/

USE Mod08
GO
TRUNCATE TABLE CallDetails
GO
DECLARE @d datetime,@ds int,@s int
SET @d = '2004-01-01'
SET @ds = 3  

WHILE (@d <= '20091231') 
BEGIN

SET @s = CAST ( RAND() * 100000 as INT )

PRINT @d
INSERT INTO CallDetails (call_date,caller,duration,additional_info) VALUES
(@d,'Peter',30,'Call to ' +CAST(@s AS varchar(10)))

SET @d = DATEADD(D,@ds,@d)
END 


/*Generate a table schema to test the deadlock*/

USE Mod08 
CREATE TABLE dbo.DLTable (col1 INT)
INSERT dbo.DLTable SELECT 1
CREATE TABLE dbo.DLLock (col1 INT)
INSERT dbo.DLLOCK SELECT 1

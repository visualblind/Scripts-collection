DECLARE @d datetime,@ds int,@s int
SET @d = '2004-01-01'
SET @ds = 7  -- date_key increment step
	
WHILE (@d <= '20091231') 
BEGIN

SET @s = CAST ( RAND() * 100000 as INT )

PRINT @d
INSERT INTO CallDetails (call_date,caller,duration,additional_info) VALUES
(@d,'Peter',30,'Call to ' +CAST(@s AS varchar(10)))

SET @d = DATEADD(D,@ds,@d)
END 

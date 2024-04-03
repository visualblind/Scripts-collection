\*Verify the replication setup in NYC-SQL1*\

DECLARE @d datetime,@ds int, @p int, @cs int
SET @d = '2004-01-01'
SET @ds = 3  
	
WHILE (@d <= '20091231') 
BEGIN

SET @p = CAST ( RAND() * 3 as INT )
SET @cs = CAST ( RAND() * 5 as INT )


PRINT @d
INSERT INTO CallDetails (call_date,caller,duration,product,cs_rep) VALUES
(@d,'Peter',30,@p,@cs)


SET @d = DATEADD(D,@ds,@d)
END


\*Verify the replication setup in NYC-SQL1\DEVELOPMENT*\

DECLARE @d datetime,@ds int, @p int, @cs int
SET @d = '2000-01-01'
SET @ds = 3  
	
WHILE (@d <= '20031231') 
BEGIN

SET @p = CAST ( RAND() * 3 as INT )
SET @cs = CAST ( RAND() * 5 as INT )


PRINT @d
INSERT INTO CallDetails (call_date,caller,duration,product,cs_rep) VALUES
(@d,'Peter',30,@p,@cs)


SET @d = DATEADD(D,@ds,@d)
END

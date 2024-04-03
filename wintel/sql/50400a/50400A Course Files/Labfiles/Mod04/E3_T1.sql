/*Create a test table*/

CREATE TABLE [dbo].[CallDetailsHistory]
(
	[call_date] [datetime] NOT NULL,
	[caller] [varchar] (20) NOT NULL,
	[dest] varchar (20) NOT NULL,
	source_countrycode int NOT NULL,
	dest_countrycode int NOT NULL,
	[duration] [int] NULL,
	[additional_info] xml NULL,
)

/*Insert records in the test table*/

DECLARE @d datetime,@ds int,@s int,@t int,@sc int, @dc int
SET @d = '2000-01-01'
SET @ds = 7  

WHILE (@d <= '20091231') 
BEGIN
SET @t=CAST(RAND()*60 AS int)
SET @s = CAST(RAND() * 100000 as INT )
SET @sc=CAST(RAND()*800 AS int)
SET @dc=CAST(RAND()*800 AS int)

PRINT @d
INSERT INTO CallDetailsHistory (call_date,caller,duration,dest,source_countrycode,dest_countrycode,additional_info) VALUES (@d,'Peter',@t,'Michael',@sc,@dc,'<call_info to="'+CAST(@s AS varchar(10))+'"><source> '+CAST(@sc AS varchar(10))+'</source><dest>' +CAST(@dc AS varchar(10))+'</dest></call_info>')

SET @d = DATEADD(D,@ds,@d)
END

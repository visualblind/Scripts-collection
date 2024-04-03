/*Create a test table*/

CREATE TABLE [dbo].[CallDetails]
(
	[call_date] [datetime] NOT NULL,
	[caller] [varchar] (20) NOT NULL,
	[duration] [int] NULL,
	[additional_info] [nchar] (4000) NULL,
 CONSTRAINT [PK_CallDetails] PRIMARY KEY CLUSTERED 
(
	[call_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
) 
) 

/*Insert records in the test table*/

DECLARE @d datetime,@ds int,@s int
SET @d = '1999-01-01'
SET @ds = 7  

WHILE (@d <= '20041231') 
BEGIN

SET @s = CAST ( RAND() * 100000 as INT )

PRINT @d
INSERT INTO CallDetails (call_date,caller,duration,additional_info) VALUES
(@d,'Peter',30,'Call to ' +CAST(@s AS varchar(10)))

SET @d = DATEADD(D,@ds,@d)
END

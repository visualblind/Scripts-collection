/*Create a test table*/

CREATE TABLE [CallDetails_FT]
(
	[id] [uniqueidentifier] NOT NULL,
	[call_date] [datetime] NULL,
	[caller] [varchar](20) NULL,
	[duration] [int] NULL,
	[additional_info] [nchar](4000) NULL,
 CONSTRAINT [PK_CallDetails_FT] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
) 
) 

/*Add records to the test table */

DECLARE @d datetime,@ds int,@s int
SET @d = '2004-01-01'
SET @ds = 7  -- date_key increment step
	
WHILE (@d <= '20091231') 
BEGIN

SET @s = CAST ( RAND() * 100000 as INT )

PRINT @d
INSERT INTO CallDetails_FT (id,call_date,caller,duration,additional_info) VALUES
(NEWID(), @d,'Peter',30,'Call to ' +CAST(@s AS varchar(10)))

SET @d = DATEADD(D,@ds,@d)
END 

CREATE DATABASE Mod10
ON PRIMARY ( NAME = Primary_Data,
    FILENAME = 'D:\data\Mod10_Primary.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
    LOG ON ( NAME = Primary_Log,
    FILENAME = 'D:\data\Mod10_Log.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
GO
USE Mod10
GO
CREATE TABLE [dbo].[CallDetails]
(
	[call_date] [datetime] NOT NULL,
	[caller] [varchar](20) NOT NULL,
	[duration] [int] NULL,
	[product] [int] NOT NULL,
	[cs_rep] [int] NOT NULL,
	[additional_info] [nchar](4000) NULL
)
GO
DECLARE @d datetime,@ds int,@s int, @p int, @cs int
SET @d = '2004-01-01'
SET @ds = 3  

WHILE (@d <= '20091231') 
BEGIN

SET @s = CAST ( RAND() * 100000 as INT )
SET @p = CAST ( RAND() * 3 as INT )
SET @cs = CAST ( RAND() * 5 as INT )


PRINT @d
INSERT INTO CallDetails (call_date,caller,duration,product,cs_rep,additional_info) VALUES
(@d,'Peter',30,@p,@cs,'Call to ' +CAST(@s AS varchar(10)))


SET @d = DATEADD(D,@ds,@d)
END

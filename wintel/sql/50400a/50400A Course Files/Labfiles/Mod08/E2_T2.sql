CREATE DATABASE Mod08
ON PRIMARY ( NAME = Primary_Data,
    FILENAME = 'D:\data\Mod08_Primary.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
    LOG ON ( NAME = Primary_Log,
    FILENAME = 'D:\data\Mod08_Log.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
GO
USE Mod08
GO
CREATE TABLE [dbo].[CallDetails]
(
	[call_date] [datetime] NOT NULL,
	[caller] [varchar](20) NOT NULL,
	[duration] [int] NULL,
	[additional_info] [nchar](4000) NULL
)
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

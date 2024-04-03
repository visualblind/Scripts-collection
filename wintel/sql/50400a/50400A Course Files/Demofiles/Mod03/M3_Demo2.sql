/* Add database files and filegroups for partitioning */

USE QuantamCorp
GO
ALTER DATABASE QuantamCorp
ADD FILEGROUP test1fg
GO
ALTER DATABASE QuantamCorp
ADD FILEGROUP test2fg
GO
ALTER DATABASE QuantamCorp
ADD FILEGROUP test3fg
GO
ALTER DATABASE QuantamCorp
ADD FILEGROUP test4fg 
GO   
ALTER DATABASE QuantamCorp
ADD FILE ( NAME = Test_Data01,
    FILENAME = 'D:\Demofiles\Mod03_Data01.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP test1fg
GO
ALTER DATABASE QuantamCorp
ADD FILE ( NAME = Test_Data02,
    FILENAME = 'D:\Demofiles\Mod03_Data02.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP test2fg
GO
ALTER DATABASE QuantamCorp
ADD FILE ( NAME = Test_Data03,
    FILENAME = 'D:\Demofiles\Mod03_Data03.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP test3fg
GO
ALTER DATABASE QuantamCorp
ADD FILE ( NAME = Test_Data04,
    FILENAME = 'D:\Demofiles\Mod03_Data04.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP test4fg
GO
--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a partition function */
USE QuantamCorp
GO
CREATE PARTITION FUNCTION myRangePF1 (int)
AS RANGE LEFT FOR VALUES (1, 100, 1000) ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a partition scheme */

USE QuantamCorp
GO
CREATE PARTITION SCHEME myRangePS1
AS PARTITION myRangePF1 TO (test1fg, test2fg, test3fg, test4fg) ;
GO
--------------------------------------------------------------------------------------------------------------------------------------------

/* Apply the partition scheme to the table */

USE QuantamCorp
GO
CREATE TABLE PartitionTable (col1 int, col2 char(10))ON myRangePS1 (col1) ;
GO 



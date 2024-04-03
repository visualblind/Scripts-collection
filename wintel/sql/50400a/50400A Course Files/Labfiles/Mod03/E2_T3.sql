/*Add two files to the TableData filegroup*/

ALTER DATABASE Mod03	
ADD FILE ( NAME = Table_Data01,
    FILENAME = 'D:\Data\Mod03_Data01.ndf',	
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP TableData
GO
ALTER DATABASE Mod03
ADD FILE ( NAME = Table_Data02,
    FILENAME = 'D:\Data\Mod03_Data02.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP TableData
GO

/*Add two files to the HistoryData filegroup*/

ALTER DATABASE Mod03
ADD FILE ( NAME = History_Data01,
    FILENAME = 'D:\Data\Mod03_History01.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP HistorialData
GO	
ALTER DATABASE Mod03
ADD FILE ( NAME = History_Data02,
    FILENAME = 'D:\Data\Mod03_History02.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP HistorialData
GO

/*Add two files to the PresentData filegroup*/

ALTER DATABASE Mod03
ADD FILE ( NAME = Present_Data01,
    FILENAME = 'D:\Data\Mod03_Present01.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP PresentData
GO
ALTER DATABASE Mod03
ADD FILE ( NAME = Present_Data02,
    FILENAME = 'D:\Data\Mod03_Present02.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP PresentData
GO

/* Modify File Group */

ALTER DATABASE Mod03
MODIFY FILEGROUP TABLEDATA DEFAULT
GO


/*Add a log file to the database*/

ALTER DATABASE Mod03
ADD LOG FILE ( NAME = Mod03_Log02,
    FILENAME = 'D:\Data\Mod03_Log02.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )

ALTER DATABASE Mod04
ADD FILE ( NAME = FullText_Data01,
    FILENAME = 'D:\Data\Mod04_FullText01.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP FullTextData
GO

CREATE DATABASE FILESTREAM_Test 
ON
PRIMARY ( NAME = Data1,
    FILENAME = 'D:\Data\archdat1.mdf'),
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM( NAME = Arch3,
    FILENAME = 'D:\data\filestream1')
LOG ON  ( NAME = Log1,
    FILENAME = 'D:\Data\archlog1.ldf')
GO

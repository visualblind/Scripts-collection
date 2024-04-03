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
CREATE TABLE dbo.DLTable (col1 INT)
INSERT dbo.DLTable SELECT 1
CREATE TABLE dbo.DLLock (col1 INT)
INSERT dbo.DLLOCK SELECT 1

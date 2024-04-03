/*Create a database*/

CREATE DATABASE Mod12
ON PRIMARY ( NAME = Primary_Data,
    FILENAME = 'd:\data\Mod12_Primary.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
    LOG ON ( NAME = Primary_Log,
    FILENAME = 'd:\data\Mod12_Log.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
GO

/*Add three filegroups*/
ALTER DATABASE Mod12
ADD FILEGROUP HistorialData
GO
ALTER DATABASE Mod12
ADD FILEGROUP PresentData
GO
ALTER DATABASE Mod12
ADD FILEGROUP TableData
GO

/*Add files to the filegroups*/

ALTER DATABASE Mod12
ADD FILE ( NAME = Table_Data01,
    FILENAME = 'D:\data\Mod12_Data01.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP TableData
GO
ALTER DATABASE Mod12
ADD FILE ( NAME = Table_Data02,
    FILENAME = 'D:\data\Mod12_Data02.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP TableData
GO
ALTER DATABASE Mod12
MODIFY FILEGROUP TableData DEFAULT
GO

ALTER DATABASE Mod12
ADD FILE ( NAME = History_Data01,
    FILENAME = 'D:\data\Mod12_History01.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP HistorialData
GO
ALTER DATABASE Mod12
ADD FILE ( NAME = History_Data02,
    FILENAME = 'D:\data\Mod12_History02.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP HistorialData
GO

ALTER DATABASE Mod12
ADD FILE ( NAME = Present_Data01,
    FILENAME = 'D:\data\Mod12_Present01.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP PresentData
GO
ALTER DATABASE Mod12
ADD FILE ( NAME = Present_Data02,
    FILENAME = 'D:\data\Mod12_Present02.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
TO FILEGROUP PresentData
GO

/*Add a secondary log file to the database*/

ALTER DATABASE Mod12
ADD LOG FILE ( NAME = Mod12_Log02,
    FILENAME = 'D:\data\Mod12_Log02.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
GO

/*Create a table and add a constraint on the table*/

Use Mod12
GO
CREATE TABLE [dbo].[CallDetails]
(
	[call_date] [datetime] NOT NULL,
	[caller] [varchar](20) NOT NULL,
	[duration] [int] NULL,
	[additional_info] [nchar](4000) NULL,
CONSTRAINT [PK_CallDetails] PRIMARY KEY CLUSTERED 
(
	[call_date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
) ON TableData)



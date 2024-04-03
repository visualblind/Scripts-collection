CREATE DATABASE Mod09_2
ON PRIMARY ( NAME = Primary_Data,
    FILENAME = 'D:\data\Mod09_2_Primary.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
    LOG ON ( NAME = Primary_Log,
    FILENAME = 'D:\data\Mod09_2_Log.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
GO
USE Mod09_2
GO
CREATE TABLE [dbo].[Employee]
(
	[employee_id] [int] NOT NULL,
	[name] [varchar](20) NOT NULL
)
GO
INSERT INTO Employee (employee_id,name) VALUES (1,'Peter')
INSERT INTO Employee (employee_id,name) VALUES (2,'Michael')
INSERT INTO Employee (employee_id,name) VALUES (3,'John')

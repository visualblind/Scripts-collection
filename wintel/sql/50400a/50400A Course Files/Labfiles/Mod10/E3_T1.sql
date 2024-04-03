USE master
GO
CREATE DATABASE Mod10_P2P
ON PRIMARY ( NAME = Primary_Data,
    FILENAME = 'D:\data\Mod10_P2P_Primary.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
    LOG ON ( NAME = Primary_Log,
    FILENAME = 'D:\data\Mod10_P2P_Log.ldf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
GO
USE Mod10_P2P
GO

CREATE TABLE [dbo].[CallDetails](
	[id] [uniqueidentifier] NOT NULL,
	[call_date] [datetime] NOT NULL,
	[caller] [varchar](20) NOT NULL,
	[duration] [int] NULL,
	[product] [int] NOT NULL,
	[cs_rep] [int] NOT NULL,
CONSTRAINT [PK_CallDetails] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CallDetails] ADD  CONSTRAINT [DF_CallDetails_id]  DEFAULT (newid()) FOR [id]
GO

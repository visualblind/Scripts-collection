USE Mod06
GO			
CREATE QUEUE [dbo].[Notify-Queue] 
WITH STATUS = ON , RETENTION = OFF 
ON [PRIMARY] 
GO

CREATE SERVICE [//Fabcorp.com/Notify-Service] 
AUTHORIZATION [dbo] 
ON QUEUE [dbo].[Notify-Queue] ([http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]);
GO

CREATE ROUTE [Notify-Route] 
AUTHORIZATION [dbo] 
WITH SERVICE_NAME = N'//Fabcorp.com/Notify-Service', ADDRESS = N'LOCAL';
GO

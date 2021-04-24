declare @cmd1 varchar(3000),
@cmd2 varchar(3000)
SET @cmd1 =
'IF ''?'' LIKE (''SI_%'') OR ''?'' LIKE (''PS_%'')
BEGIN
USE ?
IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_InternalA'')
BEGIN
CREATE USER [SENTRIC\BackOffice_InternalA] FOR LOGIN [SENTRIC\BackOffice_InternalA]
END

IF IS_ROLEMEMBER (''db_datareader'', ''SENTRIC\BackOffice_InternalA'') = 0
BEGIN
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_InternalA]
END

IF IS_ROLEMEMBER (''db_datawriter'', ''SENTRIC\BackOffice_InternalA'') = 0
BEGIN
ALTER ROLE [db_datawriter] ADD MEMBER [SENTRIC\BackOffice_InternalA]
END

IF IS_ROLEMEMBER (''db_ddladmin'', ''SENTRIC\BackOffice_InternalA'') = 0
BEGIN
ALTER ROLE [db_ddladmin] ADD MEMBER [SENTRIC\BackOffice_InternalA]
END


IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_JobServer'')
BEGIN
CREATE USER [SENTRIC\BackOffice_JobServer] FOR LOGIN [SENTRIC\BackOffice_JobServer]
END

IF IS_ROLEMEMBER (''db_datareader'', ''SENTRIC\BackOffice_JobServer'') = 0
BEGIN
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_JobServer]
END

IF IS_ROLEMEMBER (''db_datawriter'', ''SENTRIC\BackOffice_JobServer'') = 0
BEGIN
ALTER ROLE [db_datawriter] ADD MEMBER [SENTRIC\BackOffice_JobServer]
END

IF IS_ROLEMEMBER (''db_ddladmin'', ''SENTRIC\BackOffice_JobServer'') = 0
BEGIN
ALTER ROLE [db_ddladmin] ADD MEMBER [SENTRIC\BackOffice_JobServer]
END

;END'

SET @cmd2 =
'IF ''?'' LIKE (''PR_%'') OR ''?'' LIKE (''HCM_%'')
BEGIN
USE ?
IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_InternalA'')
BEGIN
CREATE USER [SENTRIC\BackOffice_InternalA] FOR LOGIN [SENTRIC\BackOffice_InternalA]
END

IF IS_ROLEMEMBER (''db_datareader'', ''SENTRIC\BackOffice_InternalA'') = 0
BEGIN
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_InternalA]
END

IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_JobServer'')
BEGIN
CREATE USER [SENTRIC\BackOffice_JobServer] FOR LOGIN [SENTRIC\BackOffice_JobServer]
END

IF IS_ROLEMEMBER (''db_datareader'', ''SENTRIC\BackOffice_JobServer'') = 0
BEGIN
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_JobServer]
END

;END'

EXEC sp_MSforeachdb @command1 = @cmd1, @command2 = @cmd2
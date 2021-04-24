declare @cmd1 varchar(2000),
@cmd2 varchar(2000)
SET @cmd1 =
'IF ''?'' LIKE (''SI_%'') OR ''?'' LIKE (''PS_%'')
BEGIN
USE ?
IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_InternalA'')
CREATE USER [SENTRIC\BackOffice_InternalA] FOR LOGIN [SENTRIC\BackOffice_InternalA]
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_InternalA]
ALTER ROLE [db_datawriter] ADD MEMBER [SENTRIC\BackOffice_InternalA]

IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_JobServer'')
CREATE USER [SENTRIC\BackOffice_JobServer] FOR LOGIN [SENTRIC\BackOffice_JobServer]
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_JobServer]
ALTER ROLE [db_datawriter] ADD MEMBER [SENTRIC\BackOffice_JobServer]
;
END'

SET @cmd2 =
'IF ''?'' LIKE (''PR_%'') OR ''?'' LIKE (''HCM_%'')
BEGIN
USE ?
IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_InternalA'')
CREATE USER [SENTRIC\BackOffice_InternalA] FOR LOGIN [SENTRIC\BackOffice_InternalA]
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_InternalA]

IF NOT exists (select name from sys.database_principals where name = ''SENTRIC\BackOffice_JobServer'')
CREATE USER [SENTRIC\BackOffice_JobServer] FOR LOGIN [SENTRIC\BackOffice_JobServer]
ALTER ROLE [db_datareader] ADD MEMBER [SENTRIC\BackOffice_JobServer]
;
END'

EXEC sp_MSforeachdb @command1 = @cmd1, @command2 = @cmd2